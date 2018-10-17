<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<% 
boolean PERM_UPLOAD_FACILITY_CSV = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV");
%>
<div class="form-group">	

<% if(PERM_UPLOAD_FACILITY_CSV){ %>	
					  <a  href="<c:url value="/form/uploadForm.html?lang=${locale}"/>"> <strong><spring:message code="lbl.uploadForm"/> </strong> </a>	
<%} %>	
<% if(PERM_UPLOAD_FACILITY_CSV){ %>	
					| <a  href="<c:url value="/form/downloadForm.html?lang=${locale}"/>"> <strong><spring:message code="lbl.downloadForm"/> </strong> </a>	
<%} %>

</div>