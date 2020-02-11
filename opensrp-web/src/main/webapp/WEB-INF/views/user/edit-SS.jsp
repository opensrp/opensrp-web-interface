<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@ taglib prefix="sec"
		   uri="http://www.springframework.org/security/tags"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page import="java.util.Set" %>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title><spring:message code="lbl.editUserTitle"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/${id}/edit-SS.html" />
<c:url var="cancelUrl" value="/user/${skId}/${skUsername}/my-ss.html?lang=en" />

<%
	String selectedParentUser = (String)session.getAttribute("parentUserName");
%>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
	<div class="container-fluid">
		
		<div class="card mb-3">
			<div class="card-header">
				Edit SS			</div>
			<div class="card-body">
				<form:form method="POST" action="${saveUrl}"
						   modelAttribute="account" class="form-inline">


					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="inputPassword6"> <spring:message code="lbl.firstName"/> </label>
							<form:input path="firstName" class="form-control mx-sm-3"
										required="required"/>
						</div>
					</div>

					<div class="row col-12 tag-height">
						<div class="form-group">
							<label class="label-width" for="inputPassword6"><spring:message code="lbl.lastName"/> </label>
							<form:input path="lastName" class="form-control mx-sm-3"/>
						</div>
					</div>

					<div class="row col-12 tag-height">
						<div class="form-group">
							<label class="label-width"  for="inputPassword6"> <spring:message code="lbl.email"/> </label>
							<input type="email" class="form-control mx-sm-3" name="email" value="${account.getEmail()}">
						</div>
					</div>

					<div class="row col-12 tag-height">
						<div class="form-group">
							<label class="label-width" for="inputPassword6"><spring:message code="lbl.mobile"/></label>
							<form:input path="mobile" class="form-control mx-sm-3" />
						</div>
					</div>

					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="inputPassword6"><spring:message code="lbl.username"/></label>
							<form:input path="username" class="form-control mx-sm-3"
										readonly="true"	required="required"/>
							
						</div>
					</div>

					<form:hidden path="uuid" />
					<form:hidden path="personUUid" />
					<form:hidden path="provider" />
					<form:hidden path="ssNo" />
					<input type="hidden" type="text" value="${skId}" name="skId">
					<input type="hidden" type="text" value="${skUsername}" name="skUsername">
					<form:hidden path="password" />

					<div class="row col-12 tag-height">
						<div class="form-group">
							<input type="submit" value="<spring:message code="lbl.saveChanges"/>"
								   class="btn btn-primary btn-block btn-sm" />
						</div>
						<div class="form-group">
	                    	<a href="${cancelUrl}" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Cancel</a>
	                    </div>
					</div>
				</form:form>

			</div>
			<div class="card-footer small text-muted"></div>
		</div>
	</div>
	<!-- /.container-fluid-->
	<!-- /.content-wrapper-->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>

<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
</html>
