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
<%@page import="org.opensrp.core.entity.Location" %>
<%@page import="java.util.List"%>


<% 
List<Location> locatationTreeData = (List<Location>)session.getAttribute("searchedLocation");	
	if(locatationTreeData!=null){
		for (Location location : locatationTreeData) {
			String parentLocationName = "";
			if(location.getParentLocation() !=null){
				parentLocationName = location.getParentLocation().getName() + " -> ";
			}
			String tagNme= "";
			if(location.getLocationTag()!=null){
				tagNme = "  ("+ location.getLocationTag().getName() + ")";
			}
			String name = parentLocationName +location.getName() + tagNme;
		%>
			 <option value="<%=location.getId()%>"><%=name%></option>
		<%}
	}
%>
