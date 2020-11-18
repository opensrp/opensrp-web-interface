<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AggregatedBiometricDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<head>
    <style>
        th, td {
            text-align: center;
        }
        .elco-number {
            width: 30px;
        }
    </style>
</head>
<body>

<% Object targets = request.getAttribute("jsonReportData"); %>

<div id="column-chart"></div>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>
    
	 		 <tr>
				<th>Branch name</th>
				<th>Number of  SK</th>
				<th>SK target vs achievement</th>
		    </tr>
	 	
    </thead>
   
    <tbody>
    
   		<c:forEach items="${reportDatas}" var="reportData">
	   		<tr>
			   	<td> ${reportData.getBranchName() }</td>
			   	<td> ${reportData.getNumberOfSK() }</td>
			   	<td> <fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getAchievementInPercentage() }" /> %</td>
		   			
		 	</tr>
		</c:forEach>
    </tbody>
</table>

<script>

	var reportData = <%= targets%>;
	console.log(reportData);
	var branches = [];
	var percentages = []
	for(var i=0; i < reportData.length; i++) {
		branches.push(reportData[i].branchName );
		percentages.push(reportData[i].achievementInPercentage);
	}

	Highcharts.chart('column-chart', {
		chart: {
			type: 'column'
		},
		title: {
			text: 'Target vs Achievement'
		},
		subtitle: {
			text: ''
		},
		xAxis: {
			categories: branches,
			crosshair: true
		},
		yAxis: {
			min: 0,
			title: {
				text: 'Average Achievement'
			}
		},
		tooltip: {
			headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
			pointFormat: '<tr><td style="color:{series.color};padding:0"> </td>' +
					'<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
			footerFormat: '</table>',
			shared: true,
			useHTML: true
		},
		plotOptions: {
			column: {
				pointPadding: 0.2,
				borderWidth: 0
			}
		},
		series: [{name:'', data: percentages}],
	});

</script>
</body>