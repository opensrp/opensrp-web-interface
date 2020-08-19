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


<title><spring:message code="lbl.branchTitle"/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
<style>
	td {
		font-size: 13px;
		font-weight: bold;
	}
	.dataTables_wrapper .dataTables_paginate .paginate_button {
		padding: 0px;
	}
	.pagination>li>a:focus, .pagination>li>a:hover, .pagination>li>span:focus, .pagination>li>span:hover  {
		margin: 0px;
	}
</style>
<jsp:include page="/WEB-INF/views/css.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<c:url var="saveUrl" value="/rest/api/v1/branch/save" />

<div class="page-content-wrapper">
	<div class="page-content">
		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="caption">
					<i class="fa fa-list"></i><spring:message code="lbl.searchArea"/>
				</div>
			</div>
			<div class="portlet-body">
				<div class="table-responsive">
						<table class=" table table-striped table-bordered" id="branchList">
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
				<div>
					<a href="<c:url value="/branch/add.html?lang=${locale}"/>"
					   class="btn btn-primary btn-sm">
						<b>Create Branch +</b>
					</a>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>

</div>
<!-- /.container-fluid-->
<!-- /.content-wrapper-->
</div>

<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />
<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>
<script>
	jQuery(document).ready(function() {
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		//TableAdvanced.init();
	});
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
				searchPlaceholder: "Name / Code"
			}
		});
	});
</script>
</html>
