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
int sl =0;
%>

<div class="row">
	<div class=" form-group  col-sm-6">
		<select  class="form-control" class="custom-select" id="visitCategory" style="width: 95%" onclick="reloadSkChart()">
			<option value="0">Please select</option>
			<option value="presbyopiaTargetVsAchievement">Marked as presbyopia</option>
			<option value="presbyopiaCorrectionTargetVsAchievement">Presbyopia correction</option>
			<option value="diabetesTargetVsAchievement">Estimate diabetes</option>
			<option value="hbpTargetVsAchievement">Estimate HBP</option>
			<option value="cataractSurgeryTargetVsAchievement">Cataract surgery refer</option>
			<option value="cataractTargetVsAchievement">Cataract surgery</option>
			
		</select>
	</div>
</div>
<div id="column-chart"></div>

<table class="stripe display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>
    
		    <tr>
				<th rowspan="2"> Sl </th>
		     	<th rowspan="2">SK name</th>
		        <th rowspan="2">Branch name</th>		        
		       
		        <th rowspan="2">Mobile</th>
		        <th colspan="3">Marked as presbyopia</th>
		        <th colspan="3">Presbyopia correction</th>
		        <th colspan="3">Estimate diabetes</th>
		        <th colspan="3">Estimate HBP</th>
		        <th colspan="3">Cataract surgery refer</th>
		        <th colspan="3">Cataract surgery</th>
		        
		        
		        
		        
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
		        
		       
		        
		        
		        
		    </tr>
	 	
    </thead>
   
    <tbody id="t-body">
    	
   		<c:forEach items="${reportDatas}" var="reportData"> 
   			<tr>
					<td> <%= ++sl %> </td>
   					<td> ${reportData.getFullName() }</td>
		   			<td> ${reportData.getBranchName() }</td>		   			
		   			
		   			<td> ${reportData.getMobile() }</td>
		   			<td> ${reportData.getPresbyopiaTarget() }</td>
		   			<td> ${reportData.getPresbyopiaAchievement() }</td>
		   			<td>
		   			<c:choose>
		   				<c:when test="${reportData.getPresbyopiaTarget()==0}">		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getPresbyopiaAchievement()*100/reportData.getPresbyopiaTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getPresbyopiaCorrectionTarget() }</td>
		   			<td> ${reportData.getPresbyopiaCorrectionAchievement() }</td>
		   			<td>
		   			<c:choose>
		   				<c:when test="${reportData.getPresbyopiaCorrectionTarget()==0}">		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getPresbyopiaCorrectionAchievement()*100/reportData.getPresbyopiaCorrectionTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getDiabetesTarget() }</td>
		   			<td> ${reportData.getDiabetesAchievement() }</td>
		   			<td>
		   			<c:choose>
		   				<c:when test="${reportData.getDiabetesTarget()==0}">		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getDiabetesAchievement()*100/reportData.getDiabetesTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getHbpTarget() }</td>
		   			<td> ${reportData.getHbpAchievement() }</td>
		   			<td>
		   			<c:choose>
		   				<c:when test="${reportData.getHbpTarget()==0}">		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getHbpAchievement()*100/reportData.getHbpTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getCataractSurgeryTarget() }</td>
		   			<td> ${reportData.getCataractSurgeryAchievement() }</td>
		   			<td>
		   			<c:choose>
		   				<c:when test="${reportData.getCataractSurgeryTarget()==0}">		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getCataractSurgeryAchievement()*100/reportData.getCataractSurgeryTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getCataractTarget() }</td>
		   			<td> ${reportData.getCataractAchievement() }</td>
		   			<td>
		   			<c:choose>
		   				<c:when test="${reportData.getCataractTarget()==0}">		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getCataractAchievement()*100/reportData.getCataractTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			
	   			
	   			
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
		var avgFields = ['presbyopiaTargetVsAchievement','presbyopiaCorrectionTargetVsAchievement','diabetesTargetVsAchievement','hbpTargetVsAchievement','cataractTargetVsAchievement','cataractSurgeryTargetVsAchievement'];
		
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
		//console.log(reportData);
		var category = $('#visitCategory').val();
		if(category === 0) {
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