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

<%
	List<Object[]> users = (List<Object[]>) session.getAttribute("users");
	List<Object[]> usersWithoutCatchmentArea = (List<Object[]>) session.getAttribute("usersWithoutCatchmentArea");
%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><spring:message code="lbl.userList"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
	<link type="text/css" href="<c:url value="/resources/css/jquery.toast.css"/>" rel="stylesheet">
	<link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
	<style>
		th, td {
			text-align: center;
		}
		.select2-container--default .select2-results__option { font-size: 18px!important; }
		.select2-container--default .select2-selection--single .select2-selection__arrow { left: 88% !important; }
		.select2-container--default .select2-selection--single { width: 100% !important; }
		.select2-container--open .select2-dropdown--below {width: 80% !important;}
	</style>
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
	<div class="container-fluid">

		<div class="form-group">
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
		</div>

		<div class="form-group">
			<h5><spring:message code="lbl.userList"/></h5>
			<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
			<a  href="<c:url value="/user/add.html?lang=${locale}"/>">
				<strong>
					<spring:message code="lbl.addNew"/>
					<spring:message code="lbl.user"/>
				</strong> </a> <%} %>
		</div>
		<jsp:include page="/WEB-INF/views/user/search-ajax.jsp" />

		<!-- Example DataTables Card-->
		<div class="card mb-3">
			<div class="card-header">
				<spring:message code="lbl.userList"/>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="display" id="userList">
						<thead>
							<tr>
								<th><spring:message code="lbl.name"></spring:message></th>
								<th><spring:message code="lbl.userName"></spring:message></th>
								<th><spring:message code="lbl.role"></spring:message></th>
								<th><spring:message code="lbl.phoneNumber"></spring:message></th>
								<th><spring:message code="lbl.branch"></spring:message></th>
								<th><spring:message code="lbl.action"></spring:message></th>
							</tr>
						</thead>
						<tbody>
							<%
								if (users != null){
									for (Object[] user: users) {
										String stringId = user[5].toString();
										String fullName = String.valueOf(user[1]).replaceAll("\\.$", "");
										Integer id = Integer.parseInt(stringId);
										session.setAttribute("id", id);
							%>
							<tr>
								<td><%=fullName%></td>
								<td><%=user[0]%></td>
								<td><%=user[3]%></td>
								<td><%=user[2]%></td>
								<td><%=user[4]%></td>
                                <td>
                                    <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
                                    <a href="<c:url value="/user/${id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> |  <%} %>
                                    <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                    <a href="<c:url value="/user/${id}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>
                                   <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
								 | <a href="<c:url value="/user/${id}/change-password.html?lang=${locale}"/>"><spring:message code="lbl.changePassword"/></a> <%} %>
                                </td>
							</tr>
							<%
									}
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
			<div class="card-footer small text-muted"></div>
		</div>

		<!-- Example DataTables Card-->
		<div class="card mb-3">
			<div class="card-header">
				<spring:message code="lbl.usersWithoutCatchmentArea"/>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="display" id="userListWithoutCatchmentArea">
						<thead>
						<tr>
							<th><spring:message code="lbl.name"></spring:message></th>
							<th><spring:message code="lbl.userName"></spring:message></th>
							<th><spring:message code="lbl.role"></spring:message></th>
							<th><spring:message code="lbl.phoneNumber"></spring:message></th>
							<th><spring:message code="lbl.branch"></spring:message></th>
							<th><spring:message code="lbl.action"></spring:message></th>
						</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="card-footer small text-muted"></div>
		</div>
	</div>
</div>
	<!-- /.container-fluid-->
	<!-- /.content-wrapper-->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<%--<script src="<c:url value='/resources/js/datepicker.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/jspdf.debug.js' />"></script>--%>
<script src="<c:url value='/resources/js/jquery.toast.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>
<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>
<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<%--<script src="<c:url value='/resources/js/jszip.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/pdfmake.js' />"></script>--%>
<%--<script src="<c:url value='/resources/js/vfs_fonts.js' />"></script>--%>
<script>
	var userListWithoutCatchmentArea;
	$(document).ready(function() {
		$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
		var heading = "<%=(String) session.getAttribute("heading")%>";
		var toastMessage = "<%=(String) session.getAttribute("toastMessage")%>";
		var icon = "<%=(String) session.getAttribute("icon")%>";
		console.log("heading: "+ toastMessage);
		if (heading != null && heading != "" && heading != 'null') {
			$.toast({
				heading: heading,
				text: toastMessage,
				icon: icon,
				position: 'top-right',
				loader: false
			});
		}
		<%
            session.setAttribute("heading", "");
            session.setAttribute("toastMessage", "");
            session.setAttribute("icon", "");
        %>

		$('#userList').DataTable({
			bFilter: false,
			bInfo: true,
			dom: 'Bfrtip',
			destroy: true,
			buttons: [
				'pageLength'
			],
			lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
			language: {
				searchPlaceholder: "Username / Mobile"
			}
		});

		userListWithoutCatchmentArea = $('#userListWithoutCatchmentArea').DataTable({
			bFilter: true,
			serverSide: true,
			processing: true,
			ajax: {
				url: "/opensrp-dashboard/rest/api/v1/user/user-without-catchment-area",
				data: function(data){
					data.division = $('#division').val();
					data.district = $('#district').val();
					data.upazila = $('#upazila').val();
					data.pourasabha = $('#pourasabha').val();
					data.union = $('#union').val();
					data.village = $('#village').val();
					data.role = $('#role').val();
					data.branch = $('#branch').val();
				},
				dataSrc: function(json){
					if(json.data){
						return json.data;
					}
					else {
						return [];
					}
				},
				complete: function() {
				},
				type: 'GET'
			},
			bInfo: true,
			destroy: true,
			language: {
				searchPlaceholder: "Username / Mobile"
			}
		});
	});
	function drawDataTables() {
		userListWithoutCatchmentArea.ajax.reload();
	}
</script>
</body>
</html>
