<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<ol class="breadcrumb">
	<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/user.html?lang=${locale}"/>"> <strong> <spring:message code="lbl.manageUuser"/></strong> </a>    <% } %>
	</li>
	<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_ROLE_LIST")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/role.html?lang=${locale}"/>"> <strong><spring:message code="lbl.manageRole"/></strong></a>   <% } %>
	</li>
	<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_BRANCH_LIST")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/branch-list.html?lang=${locale}"/>"> <strong><spring:message code="lbl.manageBranch"/></strong></a>   <% } %>
	</li>
	<% if(AuthenticationManagerUtil.isPermitted("PERM_USER_HIERARCHY")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/user/hierarchy.html?lang=${locale}"/>"> <strong><spring:message code="lbl.userHiearchy"/></strong></a> <% } %>
	</li>
	<% if(AuthenticationManagerUtil.isPermitted("PERM_USER_UPLOAD")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/user/upload.html?lang=${locale}"/>"> <strong><spring:message code="lbl.userUpload"/></strong></a> <% } %>
	</li>
	<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_IMEI")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/user/upload-imei.html?lang=${locale}"/>"> <strong><spring:message code="lbl.uploadImei"/></strong></a> <% } %>
	</li>
</ol>

