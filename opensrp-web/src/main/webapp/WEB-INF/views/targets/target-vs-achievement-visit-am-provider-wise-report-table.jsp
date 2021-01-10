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

<% Object targets = request.getAttribute("jsonReportData");
	int sl = 0;
%>

<div class="row">
	<div class="col-sm-offset-9 col-sm-3">
		<select class="custom-select form-control" id="visitCategory" style="width: 95%" onclick="reloadSkChart()">
			<option value="avg_visit">Average Visit</option>
			<option value="hhVisitAchievementInPercentage">Household Visit</option>
			<option value="elcoVisitAchievementInPercentage">ELCO Visit</option>
			<option value="methodsUsersVisitAchievementInPercentage">Methods Users</option>
			<option value="adolescentMethodsUsersVisitAchievementInPercentage">Adolescent Methods Users</option>
			<option value="pregnancydentifiedVisitAchievementInPercentage">Pregnancy Identified</option>
			<option value="deliveryVisitAchievementInPercentage">Delivery</option>
			<option value="institutionalizedDeliveryVisitAchievementInPercentage">Institutionalized Delivery</option>
			<option value="Child06VisitAchievementInPercentage">Child Visit(0-6 months)</option>
			<option value="Child724VisitAchievementInPercentage">Child Visit(7-24 months)</option>
			<option value="Child1836VisitAchievementInPercentage">Child Visit(18-36 months)</option>
			<option value="immunizationVisitAchievementInPercentage">Immunization(0-59 months)</option>
			<option value="pregnantVisitAchievementInPercentage">Pregnant Visit</option>
		</select>
	</div>
</div>
<div id="column-chart"></div>

<table class="stripe display table table-bordered table-striped" id="reportDataTable"
	   style="width: 100%;">
	<thead>

	<tr>
		<th rowspan="2">Sl</th>
		<th rowspan="2">SK name</th>
		<th rowspan="2">Branch name</th>

		<th rowspan="2">Mobile</th>
		<th colspan="3">Household Visit</th>
		<th colspan="3">ELCO Visit</th>
		<th colspan="3">Methods Users</th>
		<th colspan="3">Adolescent Methods Users</th>
		<th colspan="3">Pregnancy Identified</th>
		<th colspan="3">Delivery</th>

		<th colspan="3">Institutionalized Delivery</th>
		<th colspan="3">Child Visit(0-6 months)</th>
		<th colspan="3">Child Visit(7-24 months)</th>

		<th colspan="3">Child Visit(18-36 months)</th>
		<th colspan="3">Immunization(0-59 months)</th>
		<th colspan="3">Pregnant Visit</th>


	</tr>
	<tr>
		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>

		<th>Target</th>
		<th>Achievement</th>
		<th>TvA(%)</th>



	</tr>

	</thead>

	<tbody id="t-body">
	<c:forEach items="${reportDatas}" var="reportData">
		<tr>
			<td> <%= ++sl %> </td>
			<td> ${reportData.getFullName() }</td>
			<td> ${reportData.getBranchName() }</td>

			<td> ${reportData.getMobile() }</td>
			<td> ${reportData.getHhVisitTarget() }</td>
			<td> ${reportData.getHhVisitAchievement()}</td>
			<td> ${reportData.getHhVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getElcoVisitTarget() }</td>
			<td> ${reportData.getElcoVisitAchievement() }</td>
			<td> ${reportData.getElcoVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getMethodsUsersVisitTarget() }</td>
			<td> ${reportData.getMethodsUsersVisitAchievement() }</td>
			<td> ${reportData.getMethodsUsersVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getAdolescentMethodsUsersVisitTarget() }</td>
			<td> ${reportData.getAdolescentMethodsUsersVisitAchievement() } </td>
			<td> ${reportData.getAdolescentMethodsUsersVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getPregnancydentifiedVisitTarget() }</td>
			<td> ${reportData.getPregnancydentifiedVisitAchievement() }</td>
			<td> ${reportData.getPregnancydentifiedVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getDeliveryVisitTarget() }</td>
			<td> ${reportData.getDeliveryVisitAchievement() }</td>
			<td> ${reportData.getDeliveryVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getInstitutionalizedDeliveryVisitTarget() }</td>
			<td> ${reportData.getInstitutionalizedDeliveryVisitAchievement() }</td>
			<td> ${reportData.getInstitutionalizedDeliveryVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getChild06VisitTarget() }</td>
			<td> ${reportData.getChild06VisitAchievement() }</td>
			<td> ${reportData.getChild06VisitAchievementInPercentage() }</td>

			<td> ${reportData.getChild724VisitTarget() }</td>
			<td> ${reportData.getChild724VisitAchievement() }</td>
			<td> ${reportData.getChild724VisitAchievementInPercentage() } %</td>

			<td> ${reportData.getChild1836VisitTarget() }</td>
			<td> ${reportData.getChild1836VisitAchievement() }</td>
			<td> ${reportData.getChild1836VisitAchievementInPercentage() } %</td>

			<td> ${reportData.getImmunizationVisitTarget() }</td>
			<td> ${reportData.getImmunizationVisitAchievement() }</td>
			<td> ${reportData.getImmunizationVisitAchievementInPercentage() } %</td>

			<td> ${reportData.getPregnantVisitTarget() }</td>
			<td> ${reportData.getPregnantVisitAchievement() }</td>
			<td> ${reportData.getPregnantVisitAchievementInPercentage() } %</td>
		</tr>

	</c:forEach>
	</tbody>
</table>

<script>

	function reloadChart(visitCategory, reportData) {

		console.log("visit category", visitCategory);
		var skList = [];
		var percentages = [];
		for (var i = 0; i < reportData.length; i++) {
			skList.push(reportData[i].firstName + ' ' + reportData[i].lastName);
			percentages.push(reportData[i][visitCategory]);
		}
		loadChart(skList, percentages);
		$('#totalSK').html(reportData.length);
	}

	function loadAvgVisitChart(reportData) {
		var skList = [];
		var percentages = [], cnt = 0, sum = 0, result, totalSum = 0, totalCount = 0 ;
		var avgFields = ['hhVisitAchievementInPercentage','elcoVisitAchievementInPercentage','methodsUsersVisitAchievementInPercentage','adolescentMethodsUsersVisitAchievementInPercentage','pregnancydentifiedVisitAchievementInPercentage','deliveryVisitAchievementInPercentage','institutionalizedDeliveryVisitAchievementInPercentage','Child06VisitAchievementInPercentage','Child724VisitAchievementInPercentage','Child1836VisitAchievementInPercentage','immunizationVisitAchievementInPercentage','pregnantVisitAchievementInPercentage'];
		for (var i = 0; i < reportData.length; i++) {
			skList.push(reportData[i].firstName + ' ' + reportData[i].lastName);

			cnt=0;
			sum = 0;
			for(var j=0; j< avgFields.length; j++) {
				if(reportData[i][avgFields[i]] > 0) cnt++;
				sum += reportData[i][avgFields[i]];
			}
			totalSum+=sum;
			totalCount+=cnt;
			result = cnt === 0 ? 0 : parseFloat((sum / cnt).toFixed(2));
			percentages.push(result);
		}
		loadChart(skList, percentages);
		$('#totalSK').html(reportData.length);
		$('#skAvgTva').html(totalCount === 0 ? 0 : parseFloat((totalSum / totalCount).toFixed(2)));
	}

	function loadChart(skList,  percentages){
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
				categories: skList,
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
			series: [{name: '', data: percentages}],
		});
	}


	function reloadSkChart() {

		var reportData = <%= targets%>;
		console.log(reportData);
		var category = $('#visitCategory').val();
		if(category === 'avg_visit') {
			loadAvgVisitChart(reportData);
			return;
		}
		reloadChart(category, reportData);
	}

	loadAvgVisitChart(<%= targets%>);

	var achvColumn = [7,10,13,16,19,22, 25, 28, 31, 34, 37, 40, 43];
	for(var i=0; i<achvColumn.length; i++) {
		$('#t-body tr td:nth-child('+achvColumn[i]+')').each(function ()
		{
			if(parseInt($(this).text()) < 80) {
				$(this).css('color', 'red');
			}
			if(parseInt($(this).text()) >= 80 && parseInt($(this).text()) < 100) {
				$(this).css('color', 'yellow');
			}
			if(parseInt($(this).text()) >= 100){
				$(this).css('color', 'green');
			}
		});
	}

</script>
</body>