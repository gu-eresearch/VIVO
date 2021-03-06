/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vivo.auth.policy;

import java.util.List;

import edu.cornell.mannlib.vitro.webapp.auth.policy.ifaces.PolicyDecision;
import edu.cornell.mannlib.vitro.webapp.auth.policy.specialrelationships.RelationshipChecker;
import edu.cornell.mannlib.vitro.webapp.auth.requestedAction.propstmt.AbstractPropertyStatementAction;

/**
 * Does the requested action involve a change to a Course that the self-editor
 * is authorized to modify?
 */
public class CourseChecker extends RelationshipChecker {
	private static final String NS_CORE = "http://vivoweb.org/ontology/core#";
	private static final String URI_COURSE_TYPE = NS_CORE + "Course";
	private static final String URI_RELATED_ROLE_PROPERTY = NS_CORE
			+ "relatedRole";
	private static final String URI_TEACHER_ROLE_OF_PROPERTY = NS_CORE
			+ "teacherRoleOf";

	private final String[] resourceUris;

	public CourseChecker(AbstractPropertyStatementAction action) {
		super(action.getOntModel());
		this.resourceUris = action.getResourceUris();
	}

	/**
	 * A self-editor is authorized to add, edit, or delete a statement if the
	 * subject or object refers to a Course, and if the self-editor:
	 * 
	 * 1) is a Teacher of that Course
	 */
	public PolicyDecision isAuthorized(List<String> userUris) {
		for (String resourceUri : resourceUris) {
			if (isCourse(resourceUri)) {
				if (anyUrisInCommon(userUris, getUrisOfTeachers(resourceUri))) {
					return authorizedTeacher(resourceUri);
				}
			}
		}
		return null;
	}

	private boolean isCourse(String resourceUri) {
		return isResourceOfType(resourceUri, URI_COURSE_TYPE);
	}

	private List<String> getUrisOfTeachers(String resourceUri) {
		return getObjectsOfLinkedProperty(resourceUri,
				URI_RELATED_ROLE_PROPERTY, URI_TEACHER_ROLE_OF_PROPERTY);
	}

	private PolicyDecision authorizedTeacher(String resourceUri) {
		return authorizedDecision("User is a Teacher of " + resourceUri);
	}

}
