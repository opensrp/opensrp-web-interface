<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><spring:message code="lbl.roleTitle"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>">
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
	<div class="app-header header-shadow">
		<jsp:include page="/WEB-INF/views/navbar.jsp" />
		<div style="margin: auto;" id="loaderImage">
			<img src="<c:url value="/resources/images/loader.svg"/> " height="64" width="64">
		</div>
		<div class="app-main__outer" style="display: none;" id="contents">
			<div class="app-main__inner">

				<div class="form-group">
					<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
				</div>

				<div class="form-group">
					<h5><spring:message code="lbl.roleManagement"/></h5>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_ROLE")){ %>
					<a  href="<c:url value="/role/add.html?lang=${locale}"/>">
						<strong>
							<spring:message code="lbl.addNew"/>
							<spring:message code="lbl.role"/>
						</strong>
					</a> <%} %>
				</div>
				<!-- Example DataTables Card-->
				<div class="card mb-3">
					<div class="card-header">
						<spring:message code="lbl.roleTitle"/>
					</div>
					<div class="card-body">
						<div class="table-responsive">
							<table class="table display" id="roleList">
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
											<a class="badge badge-info" href="<c:url value="/role/${role.id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> <%} %>
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
			<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
</div>

<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>
<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>
<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>
<script>
	$(document).ready(function() {
		$('#roleList').DataTable({
			bFilter: true,
			bInfo: true,
			dom: 'Bfrtip',
			destroy: true,
			buttons: [
				'pageLength'
			],
			lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
			language: {
				searchPlaceholder: "Role Name / Permissions"
			}
		});
	});

	$(function () {
		$("#loaderImage").hide();
		$("#contents").show();
	});
</script>
</body>
</html>


<%--<%@ page language="java" contentType="text/html; charset=UTF-8"--%>
<%--		 pageEncoding="ISO-8859-1"%>--%>

<%--<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>--%>
<%--<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>--%>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>--%>
<%--<%@ taglib prefix="security"--%>
<%--		   uri="http://www.springframework.org/security/tags"%>--%>
<%--<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>--%>

<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>

<%--<head>--%>
<%--	<meta charset="utf-8">--%>
<%--	<meta http-equiv="content-type" content="text/html; charset=UTF-8">--%>
<%--	<meta http-equiv="X-UA-Compatible" content="IE=edge">--%>
<%--	<meta name="viewport" content="width=device-width, initial-scale=1">--%>

<%--	<title><spring:message code="lbl.roleTitle"/></title>--%>
<%--	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">--%>
<%--	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">--%>
<%--	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">--%>
<%--	<style>td {font-size: 13px;}</style>--%>
<%--</head>--%>

<%--<body class="fixed-nav sticky-footer bg-dark" id="page-top">--%>
<%--<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">--%>
<%--	<div class="app-header header-shadow">--%>
<%--		<jsp:include page="/WEB-INF/views/navbar.jsp" />--%>
<%--		<div style="margin: auto;" id="loaderImage">--%>
<%--			<img src="<c:url value="/resources/images/loader.svg"/> " height="64" width="64">--%>
<%--		</div>--%>
<%--		<div class="app-main__outer" style="display: none;" id="contents">--%>
<%--			<div class="app-main__inner">--%>
<%--				<div class="form-group">--%>
<%--					<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />--%>
<%--				</div>--%>

<%--				<div class="form-group">--%>
<%--					<h5><spring:message code="lbl.roleManagement"/></h5>--%>
<%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_ROLE")){ %>--%>
<%--					<a  href="<c:url value="/role/add.html?lang=${locale}"/>">--%>
<%--						<strong>--%>
<%--							<spring:message code="lbl.addNew"/>--%>
<%--							<spring:message code="lbl.role"/>--%>
<%--						</strong>--%>
<%--					</a> <%} %>--%>
<%--				</div>--%>
<%--				<!-- Example DataTables Card-->--%>
<%--				<div class="card mb-3">--%>
<%--					<div class="card-header">--%>
<%--						<spring:message code="lbl.roleTitle"/>--%>
<%--					</div>--%>
<%--					<div class="card-body">--%>
<%--						<div class="table-responsive">--%>
<%--							<table class="table display" id="roleList">--%>
<%--								<thead>--%>
<%--								<tr>--%>
<%--									<th><spring:message code="lbl.name"/></th>--%>
<%--									<th><spring:message code="lbl.permissions"/></th>--%>
<%--									<th><spring:message code="lbl.action"/></th>--%>
<%--								</tr>--%>
<%--								</thead>--%>

<%--								<tbody>--%>
<%--								<c:forEach var="role" items="${roles}" varStatus="loop">--%>
<%--									<tr>--%>
<%--										<td>${role.getName()}</td>--%>
<%--										<td><c:forEach var="permission"--%>
<%--													   items="${role.getPermissions()}" varStatus="loop">--%>
<%--											<b> ${permission.getName()} , </b>--%>
<%--										</c:forEach></td>--%>
<%--										<td>--%>
<%--											<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_ROLE")){ %>--%>
<%--											<a href="<c:url value="/role/${role.id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> <%} %>--%>
<%--										</td>--%>
<%--									</tr>--%>
<%--								</c:forEach>--%>
<%--								</tbody>--%>
<%--							</table>--%>
<%--						</div>--%>
<%--					</div>--%>
<%--					<div class="card-footer small text-muted"></div>--%>
<%--				</div>--%>

<%--			</div>--%>
<%--			<jsp:include page="/WEB-INF/views/footer.jsp" />--%>
<%--		</div>--%>
<%--	</div>--%>
<%--</div>--%>

<%--<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>--%>
<%--<script>--%>
<%--	$(document).ready(function() {--%>
<%--		$('#roleList').DataTable({--%>
<%--			bFilter: true,--%>
<%--			bInfo: true,--%>
<%--			dom: 'Bfrtip',--%>
<%--			destroy: true,--%>
<%--			buttons: [--%>
<%--				'pageLength', 'csv', 'excel', 'pdf'--%>
<%--			],--%>
<%--			lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],--%>
<%--			language: {--%>
<%--				searchPlaceholder: "Role Name / Permissions"--%>
<%--			}--%>
<%--		});--%>
<%--	});--%>
<%--	$(function () {--%>
<%--		$("#loaderImage").hide();--%>
<%--		$("#contents").show();--%>
<%--	});--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>
