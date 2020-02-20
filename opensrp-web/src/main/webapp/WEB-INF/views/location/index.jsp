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
	<title><spring:message code="lbl.locationTitle"/></title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
	<div class="container-fluid">
		<!-- Example DataTables Card-->
		<div class="form-group">
			<jsp:include page="/WEB-INF/views/location/location-tag-link.jsp" />
		</div>
		<div class="form-group">
			<h5><spring:message code="lbl.locationTitle"/></h5>
			<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_LOCATION")){ %>
			<a  href="<c:url value="/location/add-ajax.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addNew"/></strong></a>
			<% } %>
		</div>
		<div class="card mb-3">
			<div class="card-header">
				<spring:message code="lbl.locationTitle"/>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="display" id="locationListWithPagination" style="width: 100%;">
						<thead>
							<tr>
								<th><spring:message code="lbl.name"></spring:message></th>
								<th><spring:message code="lbl.description"></spring:message></th>
								<th><spring:message code="lbl.code"></spring:message></th>
								<th><spring:message code="lbl.locationTag"></spring:message></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="card-footer small text-muted"></div>
		</div>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</div>
<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>
<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>
<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>
<script>
	let locations;
	$(document).ready(function() {
		locations = $('#locationListWithPagination').DataTable({
			bFilter: true,
			serverSide: true,
			processing: true,
			columnDefs: [
				{ targets: [3], orderable: false },
				{ width: "28%", targets: 0 },
				{ width: "27%", targets: 1 },
				{ width: "20%", targets: 2 },
				{ width: "25%", targets: 2 }
			],
			ajax: {
				url: "/opensrp-dashboard/rest/api/v1/location/list-ajax",
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
				searchPlaceholder: "Name"
			}
		});
	});
</script>
</body>
</html>

