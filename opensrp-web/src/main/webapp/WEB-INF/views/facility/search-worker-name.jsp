<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>


<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="org.opensrp.core.entity.FacilityWorker" %>
<%@page import="java.util.List"%>


<% 
List<String> workers = (List<String>)session.getAttribute("searchedWorkers");	
	if(workers!=null){
		String name ="";
		for (String workerName : workers) {	
			name = workerName;
		%>
			 <option value="<%=name%>"><%=name%></option>
		<%}
	}
%>
