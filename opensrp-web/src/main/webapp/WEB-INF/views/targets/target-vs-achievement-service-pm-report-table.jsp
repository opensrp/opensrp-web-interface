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

<div class="row">
	<div class="col-sm-offset-10 col-sm-2">
		<select class="custom-select" id="visitCategory" style="width: 95%" onclick="reloadSkChart()">
			<option value="initial">Please Select </option>
			<option value="ANCService">ANC Package</option>
			<option value="PNCService">PNC Package</option>
			<option value="NCDService">NCD Package</option>
			<option value="IYCFService">IYCF Package</option>
			<option value="WOMENService">Women Package</option>
			<option value="AdolescentService">Adolescent Package</option>
		</select>
	</div>
</div>

<div id="column-chart"></div>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>
    <c:choose>
		<c:when test="${type =='managerWise'}">
		    <tr>
		        <th rowspan="2">DM name</th>
		        <th rowspan="2">Number of AM</th>
				<th rowspan="2">Number of SK</th>
		        <th colspan="2">ANC package</th>
		        <th colspan="2">PNC package</th>
		        <th colspan="2">NCD package</th>
		        <th colspan="2">IYCF package</th>
		        <th colspan="2">Women package</th>
		        <th colspan="2">Adolescent package</th>
		    </tr>
		    <tr>
		        <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		          <th>TvA (#)</th>
		        <th>TvA(%)</th>
		    </tr>
	 	</c:when>
	 	<c:otherwise>
	 		 <tr>
		        <th rowspan="2">Location name</th>
		        <th rowspan="2">Number of AM</th>
				 <th rowspan="2">Number of SK</th>
		        <th colspan="2">ANC package</th>
		        <th colspan="2">PNC package</th>
		        <th colspan="2">NCD package</th>
		        <th colspan="2">IYCF package</th>
		        <th colspan="2">Women package</th>
		        <th colspan="2">Adolescent package</th>
		    </tr>
		    <tr>
		        <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		          <th>TvA (#)</th>
		        <th>TvA(%)</th>
		    </tr>
	 	</c:otherwise>
	 
	 </c:choose>
    </thead>
   
    <tbody id="t-body">
    	
   		<c:forEach items="${reportDatas}" var="reportData"> 
   			<tr>
   			<c:choose>
				<c:when test="${type =='managerWise'}">
		   			<td> ${reportData.getFullName() }</td>
		   			<td> ${reportData.getNumberOfAm() }</td>
					<td> ${reportData.getNumberOfSK() }</td>
		   			<td> ${reportData.getANCServiceTarget() }/${reportData.getANCServiceSell() }</td>
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getANCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getANCServiceSell()*100/reportData.getANCServiceTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getPNCServiceTarget() }/${reportData.getPNCServiceSell() }</td>
		   			
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getPNCServiceSell()*100/reportData.getPNCServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			</td>
		   			
		   			<td> ${reportData.getNCDServiceTarget() }/${reportData.getNCDServiceSell() }</td>
		   			
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getNCDServiceSell()*100/reportData.getNCDServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getIYCFServiceTarget() }/${reportData.getIYCFServiceSell() }</td>
		   			
		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getIYCFServiceSell()*100/reportData.getIYCFServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			
		   			
		   			<td> ${reportData.getWomenServiceTarget() }/${reportData.getWomenServiceSell() }</td>
		   			
		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getWomenServiceSell()*100/reportData.getWomenServiceTarget() }" /> 
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getAdolescentServiceTarget() }/${reportData.getAdolescentServiceSell() }</td>
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getAdolescentServiceSell()*100/reportData.getAdolescentServiceTarget() }" /> 
		   				 
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			
	   			</c:when>
	 
	 		
	 		<c:otherwise>
	 				<td> ${reportData.getLocationName() }</td>		   			
		   			<td> ${reportData.getNumberOfAm() }</td>
					<td> ${reportData.getNumberOfSK() }</td>
		   			<td> ${reportData.getANCServiceTarget() }/${reportData.getANCServiceSell() }</td>
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getANCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getANCServiceSell()*100/reportData.getANCServiceTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getPNCServiceTarget() }/${reportData.getPNCServiceSell() }</td>
		   			
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getPNCServiceSell()*100/reportData.getPNCServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			</td>
		   			
		   			<td> ${reportData.getNCDServiceTarget() }/${reportData.getNCDServiceSell() }</td>
		   			
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getNCDServiceSell()*100/reportData.getNCDServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getIYCFServiceTarget() }/${reportData.getIYCFServiceSell() }</td>
		   			
		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getIYCFServiceSell()*100/reportData.getIYCFServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			
		   			
		   			<td> ${reportData.getWomenServiceTarget() }/${reportData.getWomenServiceSell() }</td>
		   			
		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getWomenServiceSell()*100/reportData.getWomenServiceTarget() }" /> 
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getAdolescentServiceTarget() }/${reportData.getAdolescentServiceSell() }</td>
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getAdolescentServiceSell()*100/reportData.getAdolescentServiceTarget() }" /> 
		   				 
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
	 		</c:otherwise>
	 		</c:choose>
	 		</tr>
		</c:forEach>
    </tbody>
</table>

<script>

	initialLoad();
	var totalSk = 0;

	function initialLoad() {
		var reportData = <%= targets%>;
		console.log(reportData);
		var managers = [];
		var percentages = [];
		var totalTarget = 0, totalSell = 0, result = 0, allProviderTarget = 0, allProviderSell = 0;
		totalSk=0;
		for(var i=0; i < reportData.length; i++) {
			managers.push(reportData[i].firstName + ' '+ reportData[i].lastName);
			totalSk+=reportData[i].numberOfSK;
			totalTarget = reportData[i].ANCServiceTarget
					+ reportData[i].AdolescentServiceTarget
					+ reportData[i].IYCFServiceTarget
					+ reportData[i].NCDServiceTarget
					+ reportData[i].PNCServiceTarget
					+ reportData[i].WomenServiceTarget;

			totalSell = reportData[i].ANCServiceSell
					+ reportData[i].AdolescentServiceSell
					+ reportData[i].IYCFServiceSell
					+ reportData[i].NCDServiceSell
					+ reportData[i].PNCServiceSell
					+ reportData[i].WomenServiceSell;

			result = totalTarget === 0 ? 0 : (totalSell * 100) / totalTarget;

			allProviderTarget+=totalTarget;
			allProviderSell+=totalSell;
			percentages.push(result);

		}
		$('#totalSK').html(totalSk);
		$('#skAvgTva').html((allProviderTarget === 0 ? 0 : (allProviderSell * 100) / allProviderTarget).toFixed(2));
		reloadChart(managers, percentages);
	}


	function reloadChart(managers, percentages) {
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
				categories: managers,
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

	}

	function reloadSkChart() {
		var category =  $('#visitCategory').val();
		var reportData = <%= targets %>;
		var managers = [];
		var percentages = [], result = 0;

		if(category === 'initial') {
			initialLoad();
			return;
		}

		for(var i=0; i < reportData.length; i++) {
			managers.push(reportData[i].firstName + ' '+ reportData[i].lastName);
			result = reportData[i][category+'Target'] === 0 ? 0 : (reportData[i][category+'Sell'] * 100) / reportData[i][category+'Target'];
			console.log(reportData[category+'Sell'], '-----',reportData[category+'Target'] );
			percentages.push(parseFloat(result.toFixed(2)));
		}
		console.log("percentages", percentages, " managers", managers);
		reloadChart(managers, percentages);
	}
</script>

</body>