<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="org.opensrp.common.dto.ReportDTO" %>
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
<link type="text/css"
	href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>"
	rel="stylesheet">
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
				<%if (!AuthenticationManagerUtil.isUHFPO()){%>
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
									<th><spring:message code="lbl.femalePercentage"/></th>
									<th><spring:message code="lbl.malePercentage"/></th>
								</tr>
								</thead>
								<tbody>
								<%
									List<ReportDTO> reports = (List<ReportDTO>) session.getAttribute("formWiseAggregatedList");
									for (ReportDTO report: reports) {
								%>
								<tr>
									<td>
										<a href="<c:url value="/report/individual-mhv-works.html">
											<c:param name="mhvUsername" value="<%=report.getMhv()%>"/></c:url>">
											<%=report.getMhv()%>
										</a>
									</td>
									<td><%=report.getHousehold()%></td>
									<td><%=report.getPopulation()%></td>
									<td><%=report.getFemalePercentage()%></td>
									<td><%=report.getMalePercentage()%></td>
								</tr>
								<%}%>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<%} else {%>
				<div class="row" style="margin-top: 30px;">
					<div class="col-sm-12" style="padding: 30px;">
						<table class="display" id="ccListTable"
							   style="width: 100%;">
							<thead>
							<tr>
								<th><spring:message code="lbl.cc"/></th>
								<th><spring:message code="lbl.householdCount"/></th>
								<th><spring:message code="lbl.population"/></th>
								<th><spring:message code="lbl.female"/></th>
								<th><spring:message code="lbl.male"/></th>
							</tr>
							</thead>
							<tbody>
							<%
								List<Object[]> ccList = (List<Object[]>) session.getAttribute("ccList");
								for (int i = 0; i < ccList.size(); i++) {
							%>
							<tr>
								<td><%=ccList.get(i)[0]%></td>
								<td><%=ccList.get(i)[1]%></td>
								<td><%=ccList.get(i)[2]%></td>
								<td><%=ccList.get(i)[3]%></td>
								<td><%=ccList.get(i)[4]%></td>
							</tr>
							<%}%>
							</tbody>
						</table>
					</div>
				</div>
				<%}%>
				<button id="exportcsv" class="btn btn-sm btn-primary">Export CSV</button>
1
				<div class="card-footer small text-muted"></div>
			</div>
		</div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>
<script src="<c:url value='/resources/js/jquery-1.12.4.js' />"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.min.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/datepicker.js' />"></script>
<script src="<c:url value='/resources/js/jspdf.debug.js' />"></script>
<script src="<c:url value='/resources/js/jquery.tabletoCSV.js' />"></script>
<script src="<c:url value='/resources/js/jquery.tabletoPDF.js' />"></script>
<script>
	$(document).ready(function() {
		$('#formWiseAggregatedListTable').DataTable({
			"paginate" : true
		});
	});

	$(document).ready(function() {
		$('#ccListTable').DataTable({
			"paginate" : true
		});
	});

	$("#exportcsv").click(function() {
		$("table").tableToCSV();
	});

	$("#exportpdf").click(function() {
		$("table").tableToPDF();
	});
</script>
</html>