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

<title>Edit user information</title>

<link type="text/css"
	href="<c:url value="/resources/css/bootstrap.min.css"/>"
	rel="stylesheet">
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/${id}/edit.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
		<div class="form-group">				
				   <a  href="<c:url value="/user.html"/>"> <strong> Manage User</strong> 
					</a>  |   <a  href="<c:url value="/role.html"/>"> <strong>Manage Role</strong>
					</a>			
		</div>
			<div class="card mb-3">
				<div class="card-header">					
					Edit Account
				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}"
						modelAttribute="account">
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<label for="exampleInputName">User Name</label>
									<form:input path="username" class="form-control"
										readonly="true" required="required"
										aria-describedby="nameHelp" placeholder="Enter first name" />
									${unique}
								</div>
								<div class="col-3">
									<label for="exampleInputLastName">Email</label>
									<form:input path="email" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Enter last name" />
								</div>
							</div>

						</div>
						
						<form:hidden path="uuid" />
						<form:hidden path="personUUid" />
						<form:hidden path="provider" />
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<label for="exampleInputName">First name</label>
									<form:input path="firstName" class="form-control"
										required="required" aria-describedby="nameHelp" placeholder="Enter first name" />
								</div>
								<div class="col-3">
									<label for="exampleInputLastName">Last name</label>
									<form:input path="lastName" class="form-control"
										required="required" aria-describedby="nameHelp" placeholder="Enter last name" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="form-row">
								<div class="col-3">
									<label>Mobile Number</label>
									<form:input path="mobile" class="form-control"
										placeholder="Enter mobile number" />
								</div>
								<div class="col-3">
									<label>Identifier</label>
									<form:input path="idetifier" class="form-control"
										placeholder="Enter identifier" />
								</div>
							</div>
						</div>
						<form:hidden path="id" />
						<form:hidden path="password" />
						<div class="form-group">
							<div class="form-check">
								<div class="row">
									<%
										List<Role> roles = (List<Role>) session.getAttribute("roles");
											int[] selectedRoles = (int[]) session
													.getAttribute("selectedRoles");
											for (Role role : roles) {
									%>
									<div class="col-5">
										<form:checkbox class="checkBoxClass form-check-input"
											path="roles" value="<%=role.getId()%>"
											checked="<%=CheckboxHelperUtil.checkCheckedBox(selectedRoles,
							role.getId())%>" />
										<label class="form-check-label" for="defaultCheck1"> <%=role.getName()%>
										</label>
									</div>
									<%
										}
									%>
								</div>
							</div>
						</div>
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