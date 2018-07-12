<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<%@page import="java.util.List"%>
<%@page import="org.opensrp.acl.entity.Role"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Change Password</title>

<link type="text/css"
	href="<c:url value="/resources/css/bootstrap.min.css"/>"
	rel="stylesheet">

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/${id}/password.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i><a href="/user.html"> User List</a> /
					Reset Password
				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}"
						modelAttribute="account">
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<label>New Password</label>
									<form:password path="password" required="required" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<label>Re-type Password</label>
									<form:password path="retypePassword" required="required" />
									${passwordNotMatch}
								</div>
							</div>
						</div>

						<form:hidden path="username" />
						<form:hidden path="id" />
						<form:hidden path="firstName" />
						<form:hidden path="lastName" />
						<form:hidden path="email" />
						<form:hidden path="uuid" />
						<form:hidden path="mobile" />
						<form:hidden path="idetifier" />
						<form:hidden path="personUUid" />
						<form:hidden path="provider" />
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
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>
</html>