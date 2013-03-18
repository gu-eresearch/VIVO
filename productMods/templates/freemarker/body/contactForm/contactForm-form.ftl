<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Contact form -->
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.tools.validator.js"></script>

<style>



</style>

<div class="staticPageBackground feedbackForm">

	<h2>Research Hub Service Request and Feedback Form</h2>
	
	<div class="contactText">
		<p>The Griffith Research Hub is the product of a project that is due to complete in March 2013. Changes will be made to the Hub as the project progresses and the team is interested in hearing your feedback. </p>
		<p>For general information about the Research Hub, the <a href="/help" title="Research Hub Help" target="_blank">Help page</a> contains answers to Frequently Asked Questions. If you are having difficulty using your profile, the <a href="/quick-start" title="Research Hub Quick Start Guide" target="_blank">Quick Start Guide</a> may be able to assist you.</p>
		<p>Otherwise, please fill out the form on this page to contact us if you require assistance or you would like to provide feedback to the project team. </p>
		<p style="font-weight: bold; margin-top: 1em">Thank you!</p>
	</div>
	
	<div id="form-wrapper">

		<form name="contact_form" id="contact_form" action="${formAction}" method="post">
			
			<h3>Contact Form</h3>
			
			<label for="message_subject">Please select what best describes your query from the choices below :</label>

			<select name="message_subject">
				<option value="informationInProfile">Information in my Profile</option>
				<option value="enabledisable">Enable/Disable My Profile</option>
				<option value="updatePublicationsOrProjects">Updating my Publications or Projects</option>
				<option value="training">Register for Training</option>
				<option value="login">Logging in</option>
				<option value="editing">Editing My Profile</option>
				<option value="feedback">Give Feedback</option> 
				<option value="other">Other</option>
			</select>
		
		
			<input type="hidden" name="RequiredFields" value="webusername,webuseremail,s34gfd88p9x1"/>
			<input type="hidden" name="RequiredFieldsNames" value="Name,Email address,Comments"/>
			<input type="hidden" name="EmailFields" value="webuseremail"/>
			<input type="hidden" name="EmailFieldsNames" value="emailaddress"/>
			<input type="hidden" name="DeliveryType" value="contact"/>
			
			
			<label for="webusername">Full name</label>
			<input type="text" name="webusername" maxlength="255" required="required"/>
			
			<label for="webuseremail">Email address</label>
			<input type="email" name="webuseremail" maxlength="255" required="required"/>
			
			<label for="s34gfd88p9x1">Comments, questions, or suggestions</label>
			<textarea name="s34gfd88p9x1" rows="9" cols="70" required="required"></textarea>
			
			<input id="submit" type="submit" class="buttons" value="Send My Message"/>
			
			<script type="text/javascript">
				jQuery(document).ready(function() {
					 //jQuery("#contact_form").validator({offset:[-5,10]});
					 // adds an effect called "relativeError" to the validator
					jQuery.tools.validator.addEffect("relativeError", function(errors, event) {
							$('.error').remove();
							$.each(errors, function(index, error) {
								$(error.input).after('<span class="error"><p style="display: inline;">'+error.messages+'</p></span>');
							});
							//event.preventDefault();
					}, function(inputs)  {
						// the effect does nothing when all inputs are valid
					});
				
					$("#contact_form").validator({
						   effect: 'relativeError', 
						   offset:[-5,10]
						   // do not validate inputs when they are edited
						   //errorInputEvent: null
						   
						// custom form submission logic  
						}).submit(function(e)  { 
						   // when data is valid 
						   if (!e.isDefaultPrevented()) {
							  // prevent the form data being submitted to the server
							  //e.preventDefault();
						   } 
						   
						});
				
					
				}); //end document.ready
			
			</script>
			
		</form>    
	</div>
</div>

