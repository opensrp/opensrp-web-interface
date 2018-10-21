<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<% 
boolean PERM_DOWNLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_DOWNLOAD_FORM");
boolean PERM_UPLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FORM");
%>
<div class="form-group">	

<% if(PERM_UPLOAD_FORM){ %>	
					  <a  href="<c:url value="/form/uploadForm.html?lang=${locale}"/>"> <strong><spring:message code="lbl.uploadForm"/> </strong> </a>	
<%} %>	
<% if(PERM_DOWNLOAD_FORM){ %>	
					| <a  href="<c:url value="/form/downloadForm.html?lang=${locale}"/>"> <strong><spring:message code="lbl.downloadForm"/> </strong> </a>	
<%} %>

</div>