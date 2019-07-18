<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

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
					<i class="fa fa-table"></i> MHV Wise Report Status
				</div>
				<div class="card-body">

					<!-- Icon Cards-->
					<div class="row">
					    <%
							if(session.getAttribute("formWiseAggregatedList") != null){
							List<Object> formWiseAggregatedList = (List<Object>) session.getAttribute("formWiseAggregatedList");
							Iterator formWiseAggregatedListIterator = formWiseAggregatedList.iterator();
							while (formWiseAggregatedListIterator.hasNext()) {
								Object[] formWiseObject = (Object[]) formWiseAggregatedListIterator.next();
								String providerName = String.valueOf(formWiseObject[0]);
								String householdCount = "";
								String population = "";
								String femalePercentage = "";
								String malePercentage = "";

								if (providerName.equalsIgnoreCase("Total")) {
									householdCount = String.valueOf(formWiseObject[1]);
									population = String.valueOf(formWiseObject[2]);
									femalePercentage = String.valueOf(formWiseObject[3]);
									malePercentage = String.valueOf(formWiseObject[4]);
								} else {
									continue;
								}
						%>
						<div class="col-xl-4 col-sm-6 mb-4">
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
						<div class="col-xl-4 col-sm-6 mb-4">
							<div class="card text-white o-hidden h-100 bg-primary">
								<div class="card-body">
									<div class="card-body-icon">
										<!-- <i class="fa fa-fw fa-female"></i>  -->
									</div>
									<div class="mr-5">
										<h3><%=population%></h3>
										<h5>Total Population</h5>
									</div>
								</div>
							</div>
						</div>
						<div class="col-xl-4 col-sm-6 mb-4">
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
						<div class="col-xl-4 col-sm-6 mb-4">
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
						<%
							}
						}
						%>
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
										if(session.getAttribute("formWiseAggregatedList") != null){
										List<Object> formWiseAggregatedList = (List<Object>) session.getAttribute("formWiseAggregatedList");
										Iterator formWiseAggregatedListIterator = formWiseAggregatedList.iterator();
										while (formWiseAggregatedListIterator.hasNext()) {
											Object[] formWiseObject = (Object[]) formWiseAggregatedListIterator.next();
											String providerName = String.valueOf(formWiseObject[0]);
											if (providerName.equalsIgnoreCase("Total")) {
												continue;
											}
											String householdCount = String.valueOf(formWiseObject[1]);
											String population = String.valueOf(formWiseObject[2]);
											String femalePercentage = String.valueOf(formWiseObject[3]);
											String malePercentage = String.valueOf(formWiseObject[4]);
									%>
									<tr>
										<td>
											<a href="<c:url value="/report/individual-mhv-works.html">
											<c:param name="mhvUsername" value="<%=providerName%>"/></c:url>">
												<%=providerName%>
											</a>
										</td>
										<td><%=householdCount%></td>
										<td><%=population%></td>
										<td><%=femalePercentage%></td>
										<td><%=malePercentage%></td>
									</tr>
									<%
										}
									}
									%>
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

	$("#exportcsv").click(function() {
		$("table").tableToCSV();
	});

	$("#exportpdf").click(function() {
		$("table").tableToPDF();
	});
</script>
</html>