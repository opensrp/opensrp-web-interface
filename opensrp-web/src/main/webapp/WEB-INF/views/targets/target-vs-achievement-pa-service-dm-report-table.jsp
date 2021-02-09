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
            width: 50px;
        }
    </style>
</head>
<body>
<% Object targets = request.getAttribute("jsonReportData"); %>
<div class="row">
	<div class="col-sm-offset-9 col-sm-3">
		<select class="custom-select form-control" id="visitCategory" style="width: 95%" onclick="reloadSkChart()">
			<option value="initial">Please Select </option>
			 <option value="NCDService">NCD Package</option>
            <option value="glass">Glass sales</option>
		</select>
	</div>
</div>

<div id="column-chart"></div>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>

		<tr>
			<th rowspan="2">Am name</th>
			<th rowspan="2">Number of branch</th>
			<th rowspan="2">Number of PA</th>
			<th colspan="3">Adult service</th>
			<th colspan="3">Glass Sales</th>
		</tr>
		<tr>
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
		   			<td> ${reportData.getFullName() }</td>
		   			<td> ${reportData.getNumberOfBranch() }</td>
		   			<td> ${reportData.getNumberOfPA() }</td>
		   			<td> ${reportData.getNCDServiceTarget() }</td>
		   			<td> ${reportData.getNCDServiceSell() }</td>

		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getNCDServiceTarget()==0}">
		   				
		   				0.0%
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getNCDServiceSell()*100/reportData.getNCDServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getGlassTarget() }</td>
		   			<td> ${reportData.getGlassSell() } </td>

		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getGlassTarget()==0}">
		   				
		   				0.0%
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getGlassSell()*100/reportData.getGlassTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
	 		</tr>
		</c:forEach>
    </tbody>
	<tfoot>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
		<td></td>
	</tfoot>
</table>

<script>
	var totalSk = 0;
	initialLoad();

	function initialLoad() {
		var reportData = <%= targets%>;
		console.log(reportData);
		var managers = [];
		var percentages = [];
		var totalTarget = 0, totalSell = 0, result = 0, allProviderTarget = 0, allProviderSell = 0;
		for(var i=0; i < reportData.length; i++) {
			totalSk+=reportData[i].numberOfPA;
			managers.push(reportData[i].firstName + ' '+ reportData[i].lastName);
			totalTarget =reportData[i].NCDServiceTarget                
            + reportData[i].glassTarget;

        	totalSell = reportData[i].NCDServiceSell               
            + reportData[i].glassSell;

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

	$('#reportDataTable').DataTable({
		scrollY:        "300px",
		scrollX:        true,
		scrollCollapse: true,
		fixedColumns:   {
			leftColumns: 1
		},
		"footerCallback": function ( row, data, start, end, display ) {
			var api = this.api(), data, total=0;

			// Remove the formatting to get integer data for summation
			var intVal = function ( i ) {
				return typeof i === 'string' ?
						i.replace(/[\%,]/g, '')*1 :
						typeof i === 'number' ?
								i : 0;
			};

			// Total over all pages
			$('.DTFC_LeftFootWrapper').css('margin-top', '-5px');
			$(api.column(0).footer()).html('Total');
			console.log("i am getting called in service");
			for(var i=1; i<9; i++) {
				total = api
						.column(i)
						.data()
						.reduce(function (a, b) {
							return intVal(a) + intVal(b);
						}, 0);


				$(api.column(i).footer()).html(total);
			}
		}
	});
</script>

</body>