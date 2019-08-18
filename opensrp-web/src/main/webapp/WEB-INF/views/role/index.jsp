<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.roleTitle"/></title>

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<%--<c:url var="saveUrl" value="/role/add" />--%>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
				<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />			
			</div>
			
			<div class="form-group">
				<h5><spring:message code="lbl.roleManagement"/></h5>
				<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_ROLE")){ %>
				<a  href="<c:url value="/role/add.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addNew"/></strong></a> <%} %>
			</div>
			<!-- Example DataTables Card-->
			<div class="card mb-3">
				<div class="card-header">
					 <spring:message code="lbl.roleTitle"/>
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th><spring:message code="lbl.name"/></th>
									<th><spring:message code="lbl.permissions"/></th>
									<th><spring:message code="lbl.action"/></th>
								</tr>
							</thead>
							
							<tbody>
								<c:forEach var="role" items="${roles}" varStatus="loop">
									<tr>
										<td>${role.getName()}</td>
										<td><c:forEach var="permission"
												items="${role.getPermissions()}" varStatus="loop">
												<b> ${permission.getName()} , </b>
											</c:forEach></td>
										<td>
										<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_ROLE")){ %>
											<a href="<c:url value="/role/${role.id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> <%} %>
										</td>

									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
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