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
<%@page import="org.opensrp.core.entity.Role"%>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>Change Password</title>

	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/${id}/password.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
	<div class="container-fluid">
		<div class="card mb-3">
			<div class="card-header">

				Reset Password
			</div>
			<div class="card-body">
				<form:form method="POST" action="${saveUrl}"
						   modelAttribute="account" class="form-inline">
					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="inputPassword6">Password</label>
							<input type="password" placeholder="Enter password" class="form-control mx-sm-3" id="password" name="password"  title="" required />
							<small id="passwordHelpInline" class="text-muted text-para">
								Password should be 8 characters long and should have both upper and lower case characters ,
								at least one digit , at least one non digit.
							</small>
						</div>
					</div>

					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width"  for="inputPassword6">Confirm password</label>
							<form:password path="retypePassword"
										   placeholder="Confirm password" class="form-control mx-sm-3"
										   required="required" />
							<small id="passwordHelpInline" class="text-muted text-para">
								<span class="text-red" id="passwordNotmatchedMessage"></span> Retype the password (for accuracy).
							</small>
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
					<form:hidden path="chcp"/>
					<div class="row col-12 tag-height">
						<div class="form-group">
							<input type="submit" onclick="return Validate()"  value="Save" 	class="btn btn-primary btn-block btn-center" />
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

	<script type="text/javascript">
		function Validate() {

			var password = document.getElementById("password").value;
			var confirmPassword = document.getElementById("retypePassword").value;
			if (password != confirmPassword) {
				$("#passwordNotmatchedMessage").html("Your password is not similar with confirm password. Please enter same password in both");

				return false;
			}

			$("#passwordNotmatchedMessage").html("");

			return true;
		}

	</script>
</div>
</body>
</html>
