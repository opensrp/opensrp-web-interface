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
<%@page import="org.opensrp.core.service.UserService"%>
<title><spring:message code="lbl.userList"/></title>
<%
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
%>

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />

<link type="text/css" href="<c:url value="/resources/css/jquery.toast.css"/>" rel="stylesheet">

<div class="page-content-wrapper">
	<div class="page-content">


		<ul class="page-breadcrumb breadcrumb text-right">
			<li>
				<%-- <a href="<c:url value="/user.html"/>">Home</a> --%>



				<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
				<a class="btn btn-default" id="add" href="<c:url value="/user/add-ajax.html?lang=${locale}"/>">
					<strong>
					<spring:message code="lbl.addNew"/>
					<spring:message code="lbl.user"/>
				</strong></a>
				<%} %>
			</li>
		</ul>
		<!-- END PAGE BREADCRUMB -->
		<!-- END PAGE HEADER-->
		<!-- BEGIN PAGE CONTENT-->


		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i><spring:message code="lbl.userList"/>
						</div>


					</div>
					
					<div class="portlet-body">
						<jsp:include page="/WEB-INF/views/user/search-ajax.jsp" />
						<hr />
						<table class="table table-striped table-bordered " id="userList">
							<thead>
								<tr>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.username"></spring:message></th>
									<th><spring:message code="lbl.role"></spring:message></th>
									<th><spring:message code="lbl.phoneNumber"></spring:message></th>
									<th><spring:message code="lbl.branch"></spring:message></th>
									<th><spring:message code="lbl.action"></spring:message></th>
								</tr>
							</thead>

						</table>
					</div>
					
				</div>
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i><spring:message code="lbl.usersWithoutCatchmentArea"/>
						</div>


					</div>
					<div class="portlet-body">
						<table class="table table-striped table-bordered" id="userListWithoutCatchmentArea">
							<thead>
								<tr>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.username"></spring:message></th>
									<th><spring:message code="lbl.role"></spring:message></th>
									<th><spring:message code="lbl.phoneNumber"></spring:message></th>
									<th><spring:message code="lbl.branch"></spring:message></th>
									<th><spring:message code="lbl.action"></spring:message></th>
								</tr>
							</thead>

						</table>
					</div>
				</div>


			</div>
		</div>
		<!-- END PAGE CONTENT-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</div>
<!-- END CONTENT -->
</div>


<script>
	jQuery(document).ready(function() {
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		//TableAdvanced.init();
	});
</script>
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />
<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
	let userListWithoutCatchmentArea, userList;
	var userCount = 0, userCountWithoutCatchmentArea = 0;
	$(document).ready(function() {
		clearRegionSelection();
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

		userList = $('#userList').DataTable({
			bFilter: true,
			serverSide: true,
			processing: true,
			columnDefs: [
				{ targets: [5], orderable: false },
				{ width: "12%", targets: 0 },
				{ width: "13%", targets: 1 },
				{ width: "7%", targets: 2 },
				{ width: "13%", targets: 3 },
				{ width: "30%", targets: 4 },
				{ width: "25%", targets: 5 }
			],
			ajax: {
				url: "/opensrp-dashboard/rest/api/v1/user/user-with-catchment-area",
				data: function(data){
					data.division = $('#division').val();
					data.district = $('#district').val();
					data.upazila = $('#upazila').val();
					data.pourasabha = $('#pourasabha').val();
					data.union = $('#union').val();
					data.village = $('#village').val();
					data.role = $('#role').val();
					data.branch = $('#branch').val();
					data.userCount = userCount;
				},
				dataSrc: function(json){
					if(json.data){
						userCount = json.recordsTotal;
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
				searchPlaceholder: "Username"
			}
		});

		userListWithoutCatchmentArea = $('#userListWithoutCatchmentArea').DataTable({
			bFilter: true,
			serverSide: true,
			processing: true,
			columnDefs: [
				{ targets: [5], orderable: false },
				{ width: "12%", targets: 0 },
				{ width: "13%", targets: 1 },
				{ width: "7%", targets: 2 },
				{ width: "13%", targets: 3 },
				{ width: "30%", targets: 4 },
				{ width: "25%", targets: 5 }
			],
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
					data.userCountWithoutCatchmentArea = userCountWithoutCatchmentArea;
				},
				dataSrc: function(json){
					if(json.data){
						userCountWithoutCatchmentArea = json.recordsTotal;
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
				searchPlaceholder: "Username"
			}
		});
	});
	function drawDataTables() {
		userList.ajax.reload();
		userListWithoutCatchmentArea.ajax.reload();
	}
	function clearRegionSelection() {
		$("#division").val("");
		$("#district").html("<option value='0?'>Select District</option>");
		$("#upazila").html("<option value='0?'>Select Upazila/City Corporation</option>");
		$("#pourasabha").html("<option value='0?'>Select Pourasabha</option>");
		$("#union").html("<option value='0?'>Select Union/Ward</option>");
		$("#village").html("<option value='0?'>Select Village</option>");
	}
</script>
