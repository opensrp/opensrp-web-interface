<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<div class="form-group">
	<ol class="breadcrumb">		
<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY")){ %>			
		<li class="breadcrumb-item">
		<a  href="<c:url value="/facility/add.html?lang=${locale}"/>" > <strong><spring:message code="lbl.registration"/></strong> </a>  
		</li> 
<%} %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY_LIST")){ %>						
	<li class="breadcrumb-item">
	<a  href="<c:url value="/cbhc-dashboard?lang=${locale}"/>"> <strong><spring:message code="lbl.comunityClinic"/></strong> </a>  
	</li> 
<%} %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV")){ %>	
		<li class="breadcrumb-item">
		 <a  href="<c:url value="/facility/upload_csv.html?lang=${locale}"/>"> <strong><spring:message code="lbl.facilityUpload"/></strong> </a>
		 </li> 	
<%} %>		
<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_HEALTH_ID")){ %>	
		<li class="breadcrumb-item">
		 <a  href="<c:url value="/healthId/upload_csv.html?lang=${locale}"/>"> <strong><spring:message code="lbl.healthIdUpload"/></strong> </a>
		 </li> 	
<%} %>	
