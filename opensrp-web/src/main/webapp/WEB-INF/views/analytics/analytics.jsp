<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%
	List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");

	Integer[] ancRate = (Integer[]) session.getAttribute("ancRate");
	Integer[] pncRate = (Integer[]) session.getAttribute("pncRate");
	Integer[] ancReferred = (Integer[]) session.getAttribute("ancReferred");
	Integer[] pncReferred = (Integer[]) session.getAttribute("pncReferred");
	Integer[] serviceRate = (Integer[]) session.getAttribute("serviceRate");
	Integer[] ancCCAccess = (Integer[]) session.getAttribute("ancCCAccess");
	Integer[] pncCCAccess = (Integer[]) session.getAttribute("pncCCAccess");
	Integer[] serviceAccess = (Integer[]) session.getAttribute("serviceAccess");
%>

<!DOCTYPE html>
<html lang="en">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title><spring:message code="lbl.viewRefresh"/></title>
		<style>
			td.large-font {
				font-size: 18px;
				font-weight: bolder;
				color: maroon;
			}
			td, th {
				text-align: center !important;
			}
		</style>
		<link type="text/css"
			  href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>" rel="stylesheet">
		<jsp:include page="/WEB-INF/views/header.jsp" />
		<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
		<script src="<c:url value='/resources/chart/data.js'/>"></script>
		<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
		<script src="<c:url value='/resources/chart/series-label.js'/>"></script>

	<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

			<form id="search-form" autocomplete="off">
				<div class="row">
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="division"
								name="division">
							<option value=""><spring:message code="lbl.selectDivision"/>
							</option>
							<%
								for (Object[] objects : divisions) {
							%>
							<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
							<%

								}
							%>
						</select>
					</div>

					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="district"
								name="district">
							<option value="0?"><spring:message code="lbl.selectDistrict"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="upazila"
								name="upazila">
							<option value="0?"><spring:message code="lbl.selectUpazila"/></option>
							<option value=""></option>

						</select>
					</div>
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="union"
								name="union">
							<option value="0?"><spring:message code="lbl.selectUnion"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-1">
						<select class="custom-select custom-select-lg mb-3" id="ward"
								name="ward">
							<option value="0?"><spring:message code="lbl.selectWard"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="cc"
								name="cc">
							<option value="0?"><spring:message code="lbl.selectCC"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-1">
						<button name="search" type="submit" id="bth-search"
								class="btn btn-primary btn-sm" value="search"><spring:message code="lbl.search"/></button>
					</div>
				</div>
			</form>

			<br>
			<div class="bs-example">
				<ul class="nav nav-tabs">
					<li class="nav-item">
						<a href="#home" class="nav-link active" data-toggle="tab">
							<spring:message code="lbl.ancUtilization"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#profile" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.pncUtilization"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#messages" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.serviceUtilization"/>
						</a>
					</li>
				</ul>
				<br>
				<div class="tab-content">

					<div class="tab-pane fade show active" id="home">
						<h3 style="color: darkblue; text-align: center;">ANC Utilization Rate from Community Clinic</h3>
						<table class="display" style="width: 100%;">
							<thead>
								<tr>
									<th><b>Access to CC (%)</b></th>
									<th><b>Received HealthCare (%)</b></th>
									<th><b>Received HealthEducation (%)</b></th>
									<th><b>Referred (%)</b></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="large-font"><%=ancRate[0]%>%</td>
									<td class="large-font"><%=ancRate[1]%>%</td>
									<td class="large-font"><%=ancRate[2]%>%</td>
									<td class="large-font"><%=ancReferred[0]%>%</td>
								</tr>
							</tbody>
						</table>
						<br>
						<h5 style="color: darkblue; text-align: center;">Different ANC Service Utilization Rate</h5>
						<table class="display" id="statusTable1" style="width: 100%;">
							<thead>
								<tr>
									<th>Service Type</th>
									<th>Service Access to CC</th>
									<th>Access to CC (%)</th>
									<th>Received HealthCare (%)</th>
									<th>Received HealthEducation (%)</th>
									<th>Referred (%)</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>ANC-1</td>
									<td><%=ancCCAccess[0]%></td>
									<td><%=ancRate[3]%></td>
									<td><%=ancRate[4]%></td>
									<td><%=ancRate[5]%></td>
									<td><%=ancReferred[1]%></td>
								</tr>
								<tr>
									<td>ANC-2</td>
									<td><%=ancCCAccess[1]%></td>
									<td><%=ancRate[6]%></td>
									<td><%=ancRate[7]%></td>
									<td><%=ancRate[8]%></td>
									<td><%=ancReferred[2]%></td>
								</tr>
								<tr>
									<td>ANC-3</td>
									<td><%=ancCCAccess[2]%></td>
									<td><%=ancRate[9]%></td>
									<td><%=ancRate[10]%></td>
									<td><%=ancRate[11]%></td>
									<td><%=ancReferred[3]%></td>
								</tr>
								<tr>
									<td>ANC-4</td>
									<td><%=ancCCAccess[3]%></td>
									<td><%=ancRate[12]%></td>
									<td><%=ancRate[13]%></td>
									<td><%=ancRate[14]%></td>
									<td><%=ancReferred[5]%></td>
								</tr>
							</tbody>
						</table>

						<br>

						<h5 style="color: darkblue; text-align: center;">ANC Utilization Trend</h5>

						<table>
							<thead>
								<th>Access to CC (%)</th>
								<th>Received HealthCare (%)</th>
								<th>Received HealthEducation (%)</th>
								<th>Referred (%)</th>
							</thead>
							<tbody>
								<tr>
									<td>
										<div id = "container1" style = "width: 300px; height: 300px; margin: 0 auto"></div>
									</td>
									<td>
										<div id = "container2" style = "width: 300px; height: 300px; margin: 0 auto"></div>
									</td>
									<td>
										<div id = "container3" style = "width: 300px; height: 300px; margin: 0 auto"></div>
									</td>
									<td>
										<div id = "container4" style = "width: 300px; height: 300px; margin: 0 auto"></div>
									</td>
								</tr>
							</tbody>
						</table>
						<script>
							Highcharts.chart('container1', {
								title: {
									text: ''
								},
								colors: ['#0868cf'],
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Access to CC: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['January 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['February 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['March 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['April 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['May 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['June 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
						<script>
							Highcharts.chart('container2', {
								title: {
									text: ''
								},
								colors: ['#ed5f13'],
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Received HealthCare: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['January 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['February 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['March 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['April 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['May 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['June 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
						<script>
							Highcharts.chart('container3', {
								colors: ['#0db829'],
								title: {
									text: ''
								},
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Received HealthEducation: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['January 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['February 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['March 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['April 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['May 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['June 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
						<script>
							Highcharts.chart('container4', {
								title: {
									text: ''
								},
								colors: ['#c71a1a'],
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Referred: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['January 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['February 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['March 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['April 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['May 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['June 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>

					</div>

					<div class="tab-pane fade show" id="profile">
						<h3 style="color: darkblue; text-align: center;">PNC Utilization Rate from Community Clinic</h3>
						<table class="display" style="width: 100%;">
							<thead>
							<tr>
								<th><b>Access to CC (%)</b></th>
								<th><b>Received HealthCare (%)</b></th>
								<th><b>Received HealthEducation (%)</b></th>
								<th><b>Referred (%)</b></th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td class="large-font"><%=pncRate[0]%>%</td>
								<td class="large-font"><%=pncRate[1]%>%</td>
								<td class="large-font"><%=pncRate[2]%>%</td>
								<td class="large-font"><%=pncReferred[0]%>%</td>
							</tr>
							</tbody>
						</table>
						<br>
						<h5 style="text-align: center;">Different PNC Service Utilization Rate</h5>
						<table class="display" id="statusTable2" style="width: 100%;">
							<thead>
							<tr>
								<th>Service Type</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Received HealthCare (%)</th>
								<th>Received HealthEducation (%)</th>
								<th>Referred (%)</th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td>PNC-1</td>
								<td><%=pncCCAccess[0]%></td>
								<td><%=pncRate[3]%></td>
								<td><%=pncRate[4]%></td>
								<td><%=pncRate[5]%></td>
								<td><%=pncReferred[1]%></td>
							</tr>
							<tr>
								<td>PNC-2</td>
								<td><%=pncCCAccess[1]%></td>
								<td><%=pncRate[6]%></td>
								<td><%=pncRate[7]%></td>
								<td><%=pncRate[8]%></td>
								<td><%=pncReferred[2]%></td>
							</tr>
							<tr>
								<td>PNC-3</td>
								<td><%=pncCCAccess[2]%></td>
								<td><%=pncRate[9]%></td>
								<td><%=pncRate[10]%></td>
								<td><%=pncRate[11]%></td>
								<td><%=pncReferred[3]%></td>
							</tr>
							</tbody>
						</table>

						<br>

						<h5 style="color: darkblue; text-align: center;">PNC Utilization Trend</h5>

						<table>
							<thead>
							<th>Access to CC (%)</th>
							<th>Received HealthCare (%)</th>
							<th>Received HealthEducation (%)</th>
							<th>Referred (%)</th>
							</thead>
							<tbody>
							<tr>
								<td>
									<div id = "container5" style = "width: 300px; height: 300px; margin: 0 auto"></div>
								</td>
								<td>
									<div id = "container6" style = "width: 300px; height: 300px; margin: 0 auto"></div>
								</td>
								<td>
									<div id = "container7" style = "width: 300px; height: 300px; margin: 0 auto"></div>
								</td>
								<td>
									<div id = "container8" style = "width: 300px; height: 300px; margin: 0 auto"></div>
								</td>
							</tr>
							</tbody>
						</table>
						<script>
							Highcharts.chart('container5', {
								title: {
									text: ''
								},
								colors: ['#0868cf'],
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Access to CC: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['January 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['February 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['March 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['April 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['May 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['June 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
						<script>
							Highcharts.chart('container6', {
								title: {
									text: ''
								},
								colors: ['#ed5f13'],
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Received HealthCare: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['January 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['February 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['March 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['April 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['May 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['June 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
						<script>
							Highcharts.chart('container7', {
								colors: ['#0db829'],
								title: {
									text: ''
								},
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Received HealthEducation: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['January 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['February 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['March 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['April 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['May 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
										['June 2019', Math.floor(Math.random() * (90 - 55 + 1)) + 55],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
						<script>
							Highcharts.chart('container8', {
								title: {
									text: ''
								},
								colors: ['#c71a1a'],
								chart: {
									type: 'column'
								},
								xAxis: {
									type: 'category',
									labels: {
										rotation: -90,
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								},
								yAxis: {
									min: 0,
									title: {
										text: 'Value'
									}
								},
								legend: {
									enabled: false
								},
								tooltip: {
									pointFormat: 'Referred: <b>{point.y:.1f} %</b>'
								},
								series: [{
									name: 'Population',
									data: [
										['December 2018', Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['January 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['February 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['March 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['April 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['May 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
										['June 2019',  Math.floor(Math.random() * (30 - 15 + 1)) + 15],
									],
									dataLabels: {
										enabled: true,
										rotation: -90,
										color: '#FFFFFF',
										align: 'right',
										format: '{point.y:.1f}', // one decimal
										y: 10, // 10 pixels down from the top
										style: {
											fontSize: '13px',
											fontFamily: 'Verdana, sans-serif'
										}
									}
								}]
							});
						</script>
					</div>

					<div class="tab-pane fade show" id="messages">
						<h3 style="color: darkblue; text-align: center;">Service Utilization from CC</h3>
						<table class="display" style="width: 100%;">
							<thead>
							<tr>
								<th><b>Age-U5</b></th>
								<th><b>Age(15-19)</b></th>
								<th><b>Age(20-30)</b></th>
								<th><b>Age30+</b></th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<td class="large-font"><%=serviceRate[0]%>%</td>
								<td class="large-font"><%=serviceRate[1]%>%</td>
								<td class="large-font"><%=serviceRate[2]%>%</td>
								<td class="large-font"><%=serviceRate[3]%>%</td>
							</tr>
							</tbody>
						</table>
						<br>
						<h5 style="text-align: center;">Service Utilization (Gender)</h5>
						<table class="display" style="width: 100%;">
							<thead>
							<tr>
								<th colspan="9">Age Range</th>
							</tr>
							<tr>
								<th rowspan="2">Gender</th>
								<th colspan="2">Age-U5</th>
								<th colspan="2">Age(15-19)</th>
								<th colspan="2">Age(20-30)</th>
								<th colspan="2">Age 30+</th>
							</tr>
							<tr>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
							</tr>
							</thead>
							<tbody>
								<tr>
									<th>Female</th>
									<td><%=serviceAccess[0]%></td>
									<td><%=serviceRate[4]%>%</td>
									<td><%=serviceAccess[1]%></td>
									<td><%=serviceRate[5]%>%</td>
									<td><%=serviceAccess[2]%></td>
									<td><%=serviceRate[6]%>%</td>
									<td><%=serviceAccess[3]%></td>
									<td><%=serviceRate[7]%>%</td>
								</tr>
								<tr>
									<th>Male</th>
									<td><%=serviceAccess[4]%></td>
									<td><%=serviceRate[8]%>%</td>
									<td><%=serviceAccess[5]%></td>
									<td><%=serviceRate[9]%>%</td>
									<td><%=serviceAccess[6]%></td>
									<td><%=serviceRate[10]%>%</td>
									<td><%=serviceAccess[7]%></td>
									<td><%=serviceRate[11]%>%</td>
								</tr>
							</tbody>
						</table>
						<br>
						<h5 style="text-align: center;">Service Utilization (Socio Economic Background)</h5>
						<table class="display" style="width: 100%;">
							<thead>
							<tr>
								<th colspan="9">Age Range</th>
							</tr>
							<tr>
								<th rowspan="2">Socio Economic Status</th>
								<th colspan="2">Age-U5</th>
								<th colspan="2">Age(15-19)</th>
								<th colspan="2">Age(20-30)</th>
								<th colspan="2">Age 30+</th>
							</tr>
							<tr>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
								<th>Service Access to CC</th>
								<th>Access to CC (%)</th>
							</tr>
							</thead>
							<tbody>
							<tr>
								<th>Ultra Poor</th>
								<td><%=serviceAccess[8]%></td>
								<td><%=serviceRate[12]%>%</td>
								<td><%=serviceAccess[9]%></td>
								<td><%=serviceRate[13]%>%</td>
								<td><%=serviceAccess[10]%></td>
								<td><%=serviceRate[14]%>%</td>
								<td><%=serviceAccess[11]%></td>
								<td><%=serviceRate[15]%>%</td>
							</tr>
							<tr>
								<th>Poor</th>
								<td><%=serviceAccess[12]%></td>
								<td><%=serviceRate[16]%>%</td>
								<td><%=serviceAccess[13]%></td>
								<td><%=serviceRate[17]%>%</td>
								<td><%=serviceAccess[14]%></td>
								<td><%=serviceRate[18]%>%</td>
								<td><%=serviceAccess[15]%></td>
								<td><%=serviceRate[19]%>%</td>
							</tr>
							<tr>
								<th>Middle Class</th>
								<td><%=serviceAccess[16]%></td>
								<td><%=serviceRate[20]%>%</td>
								<td><%=serviceAccess[17]%></td>
								<td><%=serviceRate[21]%>%</td>
								<td><%=serviceAccess[18]%></td>
								<td><%=serviceRate[22]%>%</td>
								<td><%=serviceAccess[19]%></td>
								<td><%=serviceRate[23]%>%</td>
							</tr>
							<tr>
								<th>Solvent</th>
								<td><%=serviceAccess[20]%></td>
								<td><%=serviceRate[24]%>%</td>
								<td><%=serviceAccess[21]%></td>
								<td><%=serviceRate[25]%>%</td>
								<td><%=serviceAccess[22]%></td>
								<td><%=serviceRate[26]%>%</td>
								<td><%=serviceAccess[23]%></td>
								<td><%=serviceRate[27]%>%</td>
							</tr>
							<tr>
								<th>Rich</th>
								<td><%=serviceAccess[24]%></td>
								<td><%=serviceRate[28]%>%</td>
								<td><%=serviceAccess[25]%></td>
								<td><%=serviceRate[29]%>%</td>
								<td><%=serviceAccess[26]%></td>
								<td><%=ancRate[29]%>%</td>
								<td><%=serviceAccess[27]%></td>
								<td><%=ancRate[28]%>%</td>
							</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	</body>

</html>