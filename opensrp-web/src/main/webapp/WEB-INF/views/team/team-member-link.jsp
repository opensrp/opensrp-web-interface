<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST")){ %>
<a  href="<c:url value="/team/list.html?lang=${locale}"/>"> <strong> Manage Team</strong> 	</a>  | <% } %> 
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST")){ %>
<a  href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>Manage Team Member</strong> </a> <% } %>
    


