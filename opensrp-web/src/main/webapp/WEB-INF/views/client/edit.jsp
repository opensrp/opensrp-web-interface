<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.common.util.NumberToDigit"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name='viewport'
	content='initial-scale=1,maximum-scale=1,user-scalable=no' />

<title>Edit</title>

<script
	src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.js'></script>

<jsp:include page="/WEB-INF/views/css.jsp" />

<link href="https://fonts.googleapis.com/css?family=Open+Sans"
	rel="stylesheet">
<link type="text/css" href="<c:url value="/resources/css/style.css"/>"
	rel="stylesheet">
</head>

<c:url var="saveUrl" value="/client/mother/${id}/edit.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Edit Mother
				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}" modelAttribute="clientEntity">
					   <div class="form-group">
							<div class="row">
								<div class="col-3">
									<%
										if (session.getAttribute("eventList") != null) {
											List<Object> dataList = (List<Object>) session.getAttribute("eventList");
											Iterator dataListIterator = dataList.iterator();
											while (dataListIterator.hasNext()) {
												Object[] clientObject = (Object[]) dataListIterator.next();
												String firstName = String.valueOf(clientObject[9]);
												String phoneNumber = String.valueOf(clientObject[17]);
									%>
									<label for="Name">Name</label>
									<form:input path="firstName" class="form-control"
									placeholder="Name" value="<%=firstName%>"/>
										
									<label for="Phone">Phone</label>
									<form:input path="lastName" class="form-control"
									placeholder="Phone" value="<%=phoneNumber%>"/>
							
									<%
											}
										}
									%>
								</div>
							</div>
						</div>
		
		                <form:hidden path="id" />
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="Save"
										class="btn btn-primary btn-block" />
								</div>
							</div>
						</div>					
					</form:form>

				</div>
				<div class="card-footer small text-muted"></div>
			</div>
			<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
		</div>
</body>
</html>