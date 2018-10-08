<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<div class="form-group">		
<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY")){ %>			
				   <a  href="<c:url value="/facility/add.html"/>" > <strong>Registration</strong> </a>  | 
<%} %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>						
					 <a  href="<c:url value="/cbhc-dashboard"/>"> <strong>Community Clinic</strong> </a>  | 
<%} %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV")){ %>	
					 <a  href="<c:url value="/facility/upload_csv.html"/>"> <strong>Upload Facility</strong> </a>	
<%} %>		
		</div>