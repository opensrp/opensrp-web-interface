<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>
<a  href="<c:url value="/user.html"/>"> <strong> Manage User</strong> </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>
<a  href="<c:url value="/role.html"/>"> <strong>Manage Role</strong></a> <% } %>
    


