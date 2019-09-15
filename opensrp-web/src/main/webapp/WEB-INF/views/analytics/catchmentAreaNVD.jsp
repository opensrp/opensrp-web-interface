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
	Integer[] ancRate = (Integer[]) session.getAttribute("ancRate");
	Integer[] serviceRate = (Integer[]) session.getAttribute("serviceRate");
	Integer[] serviceAccess = (Integer[]) session.getAttribute("serviceAccess");
%>
<h5 style="text-align: center;">Percentage of NVD conducted in CC having facilities of NVD</h5>
<div id="container_catchment_area_nvd" ></div>

	<script>
	Highcharts.chart('container_catchment_area_nvd', {
	    chart: {
	        plotBackgroundColor: null,
	        plotBorderWidth: null,
	        plotShadow: false,
	        type: 'pie'
	    },
	    title: {
	        text: ''
	    },
	    tooltip: {
	        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
	    },
	    plotOptions: {
	        pie: {
	            allowPointSelect: true,
	            cursor: 'pointer',
	            dataLabels: {
	                enabled: true,
	                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
	            }
	        }
	    },
	    series: [{
	        name: 'Brands',
	        colorByPoint: true,
	        data: [{
	            name: 'Others',
	            y: 25,
	            sliced: false,
	            selected: true
	        },  {
	            name: '% of NVD conducted in CC having facilities of NVD',
	            y: 75
	        }]
	    }]
	});
	</script>

	<h5 style="text-align: center;">Distribution of place of delivery in catchment area (during last 6 month)</h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th rowspan="3">Place of delivery</th>
				<th colspan="2">Access</th>
				<th colspan="6">Mode of delivery </th>

			</tr>
			<tr>
				<th rowspan="2">Number</th>
				<th rowspan="2">Percentage(%)</th>
				<th colspan="2">NVD</th>
				<th colspan="2">CS</th>
				<th colspan="2">Others (Instrumental)</th>
			</tr>
			<tr>
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
			<tr>
		</thead>
		<tbody>
			<tr>
				<th>Home </th>
				<td><%=serviceAccess[0]%></td>
				<td><%=serviceRate[0]%>%</td>
				<td><%=serviceAccess[1]%></td>
				<td><%=serviceRate[1]%>%</td>
				<td><%=serviceAccess[2]%></td>
				<td><%=serviceRate[2]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
			</tr>
			<tr>
				<th>Community clinic</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[4]%>%</td>
				<td><%=serviceAccess[5]%></td>
				<td><%=serviceRate[5]%>%</td>
				<td><%=serviceAccess[6]%></td>
				<td><%=serviceRate[6]%>%</td>
				<td><%=serviceAccess[7]%></td>
				<td><%=serviceRate[7]%>%</td>
			</tr>
			<tr>
				<th>UHC</th>
				<td><%=serviceAccess[8]%></td>
				<td><%=serviceRate[8]%>%</td>
				<td><%=serviceAccess[9]%></td>
				<td><%=serviceRate[9]%>%</td>
				<td><%=serviceAccess[10]%></td>
				<td><%=serviceRate[10]%>%</td>
				<td><%=serviceAccess[11]%></td>
				<td><%=serviceRate[11]%>%</td>
			</tr>
			<tr>
				<th>Govt. Hospital</th>
				<td><%=serviceAccess[12]%></td>
				<td><%=serviceRate[12]%>%</td>
				<td><%=serviceAccess[13]%></td>
				<td><%=serviceRate[13]%>%</td>
				<td><%=serviceAccess[14]%></td>
				<td><%=serviceRate[14]%>%</td>
				<td><%=serviceAccess[15]%></td>
				<td><%=serviceRate[15]%>%</td>
			</tr>
			<tr>
				<th>Private hospital</th>
				<td><%=serviceAccess[16]%></td>
				<td><%=serviceRate[16]%>%</td>
				<td><%=serviceAccess[17]%></td>
				<td><%=serviceRate[17]%>%</td>
				<td><%=serviceAccess[18]%></td>
				<td><%=serviceRate[18]%>%</td>
				<td><%=serviceAccess[19]%></td>
				<td><%=serviceRate[19]%>%</td>
			</tr>
			<tr>
				<th>NGO</th>
				<td><%=serviceAccess[20]%></td>
				<td><%=serviceRate[10]%>%</td>
				<td><%=serviceAccess[21]%></td>
				<td><%=serviceRate[21]%>%</td>
				<td><%=serviceAccess[22]%></td>
				<td><%=serviceRate[22]%>%</td>
				<td><%=serviceAccess[23]%></td>
				<td><%=serviceRate[23]%>%</td>
			</tr>
			<tr>
				<th>Total</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
		</tbody>
	</table>
<br>

	<h5 style="text-align: center;">Pregnancy Outcomes of delivery in Catchment area ( last 6 month)</h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th>Outcome</th>
				<th>Number</th>
				<th>Percentage</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Live birth </th>
				<td><%=serviceAccess[0]%></td>
				<td><%=serviceRate[0]%>%</td>

			</tr>
			<tr>
				<th>Still birth</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[4]%>%</td>

			</tr>
			<tr>
				<th>Spontaneous abortion</th>
				<td><%=serviceAccess[8]%></td>
				<td><%=serviceRate[8]%>%</td>

			</tr>
			<tr>
				<th>Induced abortion</th>
				<td><%=serviceAccess[12]%></td>
				<td><%=serviceRate[12]%>%</td>
			</tr>
			
		</tbody>
	</table>
