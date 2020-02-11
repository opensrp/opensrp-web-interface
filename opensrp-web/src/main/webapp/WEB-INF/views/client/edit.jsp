<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
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

<c:url var="saveUrl" value="/client/mother/${baseEntityId}/edit.html?lang=${locale}" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
		
		<div class="form-group">				
			 <jsp:include page="/WEB-INF/views/client/client-link.jsp" /> 		
			</div>
			
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.editMother"/>
				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}"
						modelAttribute="clientEntity">
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<%
										if (session.getAttribute("editData") != null) {
											List<Object> dataList = (List<Object>) session.getAttribute("editData");
											Iterator dataListIterator = dataList.iterator();
											while (dataListIterator.hasNext()) {
												Object[] clientObject = (Object[]) dataListIterator.next();
												String firstName = String.valueOf(clientObject[9]);
												String householdCode = String.valueOf(clientObject[12]);
												String lastName = String.valueOf(clientObject[13]);
												String nid = String.valueOf(clientObject[15]);
												String phoneNumber = String.valueOf(clientObject[17]);
												String spouseName = String.valueOf(clientObject[19]);
												String motherNumber = String.valueOf(clientObject[32]);
												String fatherName = String.valueOf(clientObject[33]);

												if(firstName.equalsIgnoreCase("null")) {
													firstName = "";
												}
												if(householdCode.equalsIgnoreCase("null")) {
													householdCode = "";
												}
												if(lastName.equalsIgnoreCase("null")) {
													lastName = "";
												}
												if(nid.equalsIgnoreCase("null")) {
													nid = "";
												}
												if(phoneNumber.equalsIgnoreCase("null")) {
													phoneNumber = "";
												}
												if(spouseName.equalsIgnoreCase("null")) {
													spouseName = "";
												}
												if(motherNumber.equalsIgnoreCase("null")) {
													motherNumber = "";
												}
												if(fatherName.equalsIgnoreCase("null")) {
													fatherName = "";
												}
									%>
									<label for="First Name"><spring:message code="lbl.firstName"/></label>
									<form:input path="firstName" class="form-control"
										placeholder="First Name" value="<%=firstName%>" />
										
									<label for="Last Name"><spring:message code="lbl.lastName"/></label>
									<form:input path="lastName" class="form-control"
										placeholder="Last Name" value="<%=lastName%>" />

                                    <label for="Household ID"><spring:message code="lbl.household"/></label>
									<form:input path="householdCode" class="form-control"
									    placeholder="Household ID" value="<%=householdCode%>" />

                                    <label for="Phone Number"><spring:message code="lbl.phoneNumber"/></label>
									<form:input path="phoneNumber" class="form-control"
										placeholder="Phone Number" value="<%=phoneNumber%>" />

									<label for="NID"><spring:message code="lbl.nId"/></label>
									<form:input path="nid" class="form-control"
									    placeholder="NID" value="<%=nid%>" />

									<label for="Spouse Name"><spring:message code="lbl.husbandName"/></label>
									<form:input path="spouseName" class="form-control"
										placeholder="Spouse Name" value="<%=spouseName%>" />

									<label for="Mother Name"><spring:message code="lbl.motherName"/></label>
									<form:input path="motherName" class="form-control"
										placeholder="Mother Name" value="<%=motherNumber%>" />

                                    <label for="Father Name"><spring:message code="lbl.fatherName"/></label>
									<form:input path="fatherName" class="form-control"
										placeholder="Father Name" value="<%=fatherName%>" />

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
									<input type="submit" value="<spring:message code="lbl.save"/>"
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