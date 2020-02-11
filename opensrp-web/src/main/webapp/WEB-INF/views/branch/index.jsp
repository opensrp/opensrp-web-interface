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

	<title><spring:message code="lbl.branchTitle"/></title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">

	<style>
		td {
			font-size: 13px;
			font-weight: bold;
		}
	</style>
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/rest/api/v1/branch/save" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
	<div class="container-fluid">
		<div class="form-group">
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
		</div>
		<div class="card-footer small text-muted">
			<div class="row">
				<div class="card-body">
					<div class="table-responsive">
						<table class="display" id="branchList">
							<thead>
							<tr>
								<th><spring:message code="lbl.branchName"/></th>
								<th><spring:message code="lbl.branchCode"/></th>
								<th><spring:message code="lbl.action"/></th>
							</tr>
							</thead>

							<tbody>
							<c:forEach var="branch" items="${branches}" varStatus="loop">
								<tr>
									<td>${branch.getName()}</td>
									<td>${branch.getCode()}</td>
									<td>
										<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_BRANCH_LIST")){ %>
										<a href="<c:url value="/branch/edit.html?lang=${locale}">
															 <c:param name="id" value="${branch.id}"/>
														 </c:url>">
											<spring:message code="lbl.edit"/>
										</a>
										<%} %>
									</td>

								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="row">
				<a href="<c:url value="/branch/add.html?lang=${locale}"/>"
				   class="btn btn-primary btn-sm">
					<b>Create Branch +</b>
				</a>
			</div>
		</div>
	</div>
</div>
<!-- /.container-fluid-->
<!-- /.content-wrapper-->
<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>

<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/jspdf.debug.js' />"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>
<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>
<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>
<script src="<c:url value='/resources/js/jszip.js' />"></script>
<script src="<c:url value='/resources/js/pdfmake.js' />"></script>
<script src="<c:url value='/resources/js/vfs_fonts.js' />"></script>
<script>
	$(document).ready(function() {
		$('#branchList').DataTable({
			bFilter: true,
			bInfo: true,
			dom: 'Bfrtip',
			destroy: true,
			buttons: [
				'pageLength'
			],
			lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
			language: {
				searchPlaceholder: "Branch Name / Code"
			}
		});
	});
</script>
</body>
</html>
