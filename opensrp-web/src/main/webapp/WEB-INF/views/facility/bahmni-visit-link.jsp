<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="org.opensrp.core.util.FacilityHelperUtil"%>
<%@page import="org.springframework.beans.factory.annotation.Value"%>
	
<%	String bahmniVisitURL = (String)session.getAttribute("bahmniVisitURL");
	if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
				<li class="breadcrumb-item">
					<a  href="<%=bahmniVisitURL %>" target="_blank"> 
					<strong><spring:message code="lbl.visit"/></strong> </a>
				</li>		
<%} %>
