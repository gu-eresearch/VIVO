package au.edu.gu.vivo.servlet.filter;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import edu.cornell.mannlib.vedit.beans.LoginStatusBean;
import java.util.UUID;

public class CachingHeaderFilter implements Filter {

    private static final Log log = LogFactory.getLog(CachingHeaderFilter.class);
    
    //private FilterConfig filterConfig;

    @Override
    public void destroy() {
        
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest)request;
        HttpServletResponse resp = (HttpServletResponse)response;
        
        if (log.isDebugEnabled()) {
            log.debug("Incoming Request:");
            Enumeration<String> headernames = req.getHeaderNames();
            while (headernames.hasMoreElements()) {
                String headername = headernames.nextElement();
                Enumeration<String> headers = req.getHeaders(headername);
                while (headers.hasMoreElements()) {
                    log.debug("    " + headername + " : " + headers.nextElement());
                }
            }
        }
        Cookie[] cookies = req.getCookies();
        Cookie hubcookie = null;
        if (cookies != null) {
            for (Cookie cookie: cookies) {
                if ("research-hub".equals(cookie.getName())) {
                    if (log.isDebugEnabled()) {
                        log.debug("RHHUB cookie found.");
                        log.debug("       value : " + cookie.getValue());
                        log.debug("       path : " + (cookie.getPath() == null ? "null" : cookie.getPath()));
                        log.debug("       maxage : " + cookie.getMaxAge());
                    }
                    hubcookie = cookie;
                    break;
                }
            }
        }

        LoginStatusBean lsb = LoginStatusBean.getBean(req);
        if (log.isDebugEnabled()) {
            log.debug("Do Cookie checks before passing requset on.");
            log.debug("          User is " + (lsb.isLoggedIn() ? "" : "not ") + "logged in.");
        }
        if (lsb.isLoggedIn() && hubcookie == null) {
            // add cookie if not there
            addCookie(req, resp);
            log.debug("          RHHUB Cookie set.");
        } else if (!lsb.isLoggedIn() && hubcookie != null) {
            //hubcookie = new Cookie("research-hub", lsb.getUserURI());
            // remove cookie if there
            removeCookie(req, resp);
            log.debug("          RHHUB Cookie reset.");
        }
        // add RHHUB and PUBTKT headers as Cache-keys
        resp.addHeader("VARY", "RHHUB");
        
        // add cache control headers fol js and css files:
        //if (req.getRequestURI().endsWith(".js") || 
        //        req.getRequestURI().endsWith(".css")) {
        //    resp.addHeader("Cache-Control", "public, max-age=86400"); // one day
                              // 31536000 ... 1 year
                             // 604800 ... 1 week
        //}

        // FIXME: it would be much better to set/unset cookies after the request has been processed,
        //        but it is most likely that something in the filter chain already commits the response
        //        which renders it immutable.
        chain.doFilter(request, response);

        if (log.isDebugEnabled()) {
            log.debug("Outgoing Response:");
            log.debug("        content-type: " + resp.getContentType());
            log.debug("        vary: " + (resp.containsHeader("vary") ? "true" : "false"));
            log.debug("        committed: " + (resp.isCommitted() ? "true" : "false"));
        }
        // do another check here whether to set the cookie
        if (!resp.isCommitted()) {
            if (log.isDebugEnabled()) {
                log.debug("Response not committed, do cookie checks again");
                log.debug("          User is " + (lsb.isLoggedIn() ? "" : "not ") + "logged in.");
            }
            if (lsb.isLoggedIn() && hubcookie == null) {
                // add cookie if not there
                addCookie(req, resp);
                log.debug("          RHHUB Cookie set.");
            } else if (!lsb.isLoggedIn() && hubcookie != null) {
                //hubcookie = new Cookie("research-hub", lsb.getUserURI());
                // remove cookie if there
                removeCookie(req, resp);
                log.debug("          RHHUB Cookie reset.");
            }
        }
    }

    @Override
    public void init(FilterConfig fc) throws ServletException {
        //this.filterConfig = fc;
    }
    
    public static void addCookie(HttpServletRequest request, HttpServletResponse response) {
        LoginStatusBean lsb = LoginStatusBean.getBean(request);
        String uri = lsb.getUserURI();
        if (uri == null || uri.isEmpty()) {
            uri = UUID.randomUUID().toString();
        }
        //log.debug("User uri used for cookie: " + uri);
        Cookie hubcookie = new Cookie("research-hub", DigestUtils.md5Hex(uri));
        hubcookie.setMaxAge(-1);
        hubcookie.setPath("/");
        
        try {
        String host = request.getHeader("host");
        if (host == null) {
        	host = "";
        }
        hubcookie.setDomain(host);
        response.addCookie(hubcookie);
        } catch (RuntimeException e){
            log.error("Could not set login status cookie");
        }
        // don't cache set/unset cookie responses
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache,no-store,max-age=0");
        response.setDateHeader("Expires", 1);
    }
    
    public static void removeCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie hubcookie = new Cookie("research-hub", "");
        hubcookie.setMaxAge(0);
        hubcookie.setPath("/");
        hubcookie.setDomain(request.getHeader("host"));
        response.addCookie(hubcookie);
        // don't cache set/unset cookie responses
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache,no-store,max-age=0");
        response.setDateHeader("Expires", 1);
    }

}
