<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<ol class="breadcrumb">
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/user.html?lang=${locale}"/>"> <strong> <spring:message code="lbl.manageUuser"/></strong> </a>    <% } %>
	</li>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/role.html?lang=${locale}"/>"> <strong><spring:message code="lbl.manageRole"/></strong></a>   <% } %>
	</li>
<% if(AuthenticationManagerUtil.isPermitted("PERM_USER_HIERARCHY")){ %>
	<li class="breadcrumb-item">
 		<a  href="<c:url value="/user/hierarchy.html?lang=${locale}"/>"> <strong><spring:message code="lbl.userHiearchy"/></strong></a> <% } %>
 	</li>
</ol>

