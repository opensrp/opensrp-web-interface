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
<%@page import="org.opensrp.acl.entity.User" %>
<%@page import="java.util.List"%>


<% 
List<User> users = (List<User>)session.getAttribute("searchedUsers");	
	if(users!=null){
		String name ="";
		for (User user : users) {	
			name = user.getUsername()+ " ("+user.getFullName()+")";
		%>
			 <option value="<%=user.getId()%>"><%=name%></option>
		<%}
	}
%>
