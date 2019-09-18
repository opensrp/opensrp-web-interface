<%@page import="java.util.List"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>
<%@ page import="org.opensrp.common.dto.ReportDTO" %>
<%@ page import="org.opensrp.web.util.SearchUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>

<%
	String householdCount = (String) session.getAttribute("totalHousehold");
	String populationCount = (String) session.getAttribute("totalPopulation");
	String malePercentage = (String) session.getAttribute("totalMale");
	String femalePercentage = (String) session.getAttribute("totalFemale");
%>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<meta http-equiv="refresh"
		  content="<%=session.getMaxInactiveInterval()%>;url=/login" />

	<title>Form Wise Report Status</title>

	<jsp:include page="/WEB-INF/views/css.jsp" />

	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
</head>


<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
	<div class="container-fluid">

		<jsp:include page="/WEB-INF/views/report-search-panel.jsp" />

		<div class="card mb-3">
			<div class="card-header">
				<i class="fa fa-table"></i>
				<%if (AuthenticationManagerUtil.isUHFPO()){%>
				<spring:message code="lbl.ccWiseReportStatus"/>
				<%} else {%>
				<spring:message code="lbl.mhvWiseReportStatus"/>
				<%}%>
			</div>
			<div class="card-body">
				<!-- Icon Cards-->
				<div class="row">
					<div class="col-xl-3 col-sm-6 mb-4">
						<div class="card text-white o-hidden h-100 bg-primary">
							<div class="card-body">
								<div class="card-body-icon">
									<!-- <i class="fa fa-fw fa-female"></i>  -->
								</div>
								<div class="mr-5">
									<h3><%=householdCount%></h3>
									<h5>Total Registered Household</h5>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-sm-6 mb-4">
						<div class="card text-white o-hidden h-100 bg-primary">
							<div class="card-body">
								<div class="card-body-icon">
									<!-- <i class="fa fa-fw fa-female"></i>  -->
								</div>
								<div class="mr-5">
									<h3><%=populationCount%></h3>
									<h5>Total Population</h5>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-sm-6 mb-4">
						<div class="card text-white o-hidden h-100 bg-primary">
							<div class="card-body">
								<div class="card-body-icon">
									<!-- <i class="fa fa-fw fa-female"></i>  -->
								</div>
								<div class="mr-5">
									<h3><%=femalePercentage%></h3>
									<h5>Total Female Percentage</h5>
								</div>
							</div>
						</div>
					</div>
					<div class="col-xl-3 col-sm-6 mb-4">
						<div class="card text-white o-hidden h-100 bg-primary">
							<div class="card-body">
								<div class="card-body-icon">
									<!-- <i class="fa fa-fw fa-female"></i>  -->
								</div>
								<div class="mr-5">
									<h3><%=malePercentage%></h3>
									<h5>Total Male Percentage</h5>
								</div>
							</div>
						</div>
					</div>
					<!-- <div class="col-xl-4 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">  -->
					<!-- <i class="fa fa-fw fa-female"></i>  -->
					<!-- </div>
                    <div class="mr-5">
                        <h5>Other Percentage</h5>
                    </div>
                </div>
            </div>
        </div>  -->
				</div>

				<div class="row">
					<div class="col-sm-12" id="content">
						<table class="display" id="formWiseAggregatedListTable"
							   style="width: 100%;">
							<thead>
							<tr>
								<th><spring:message code="lbl.provider"/></th>
								<th><spring:message code="lbl.householdCount"/></th>
								<th><spring:message code="lbl.population"/></th>
								<th><spring:message code="lbl.female"/></th>
								<th><spring:message code="lbl.male"/></th>
							</tr>
							</thead>
							<tbody>
							<%
								List<ReportDTO> reports = (List<ReportDTO>) session.getAttribute("formWiseAggregatedList");
								for (ReportDTO report: reports) {
									int population = SearchUtil.randomBetween(600, 20);
									int male = SearchUtil.randomBetween(population, 20);
							%>
							<tr>
								<td>
									<a href="<c:url value="/report/individual-mhv-works.html">
											<c:param name="mhvUsername" value="<%=report.getMhv()%>"/></c:url>">
										<%=report.getMhv()%>
									</a>
								</td>
								<td><%=SearchUtil.randomBetween(100, 20)%></td>
								<td><%=population%></td>
								<td><%=population-male%></td>
								<td><%=male%></td>
							</tr>
							<%}%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="card-footer small text-muted"></div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/datepicker.js' />"></script>
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
		$('#formWiseAggregatedListTable').DataTable({
			bFilter: true,
			bInfo: true,
			dom: 'Bfrtip',
			destroy: true,
			buttons: [
				'pageLength', 'csv', 'excel', 'pdf'
			],
			lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
		});
	});

	$(document).ready(function() {
		$('#ccListTable').DataTable({
			bFilter: true,
			bInfo: true,
			dom: 'Bfrtip',
			destroy: true,
			buttons: [
				'pageLength', 'csv', 'excel', 'pdf'
			],
			lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
		});
	});
</script>
</body>
</html>