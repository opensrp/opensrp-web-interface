<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.common.visualization.HighChart"%>
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

<title>mCare2 Dashboard Home</title>

<jsp:include page="/WEB-INF/views/css.jsp" />

</head>
<c:url var="saveUrl" value="/role/add" />
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />


	<div class="content-wrapper">
		<div class="container-fluid">
		
			
			<div class="row">
				<div class="col-lg-6 col-xs-6">
				    <div id="barChartDirlled" style="width: 100%; height: 250px; margin: 0 auto"></div>
				</div>
				<div class="col-lg-6 col-xs-6">	
					<div id="barChartDirlled2" style="width: 100%; height: 250px; margin: 0 auto"></div>
				</div>
			</div> <!-- row -->
			
			<div class="row">
				<!-- <div id="pieDrilled" style="width: 100%; height: 250px; margin: 0 auto"></div> -->
				<div id="container"></div>

				<hr>
				<div class="chart">
				<div class="donut-chart" data-percent="0.14" data-title=""></div>
				</div>
			</div> <!-- row -->
			<hr />
			
				
		</div>
		<% 
		JSONArray monthWiseSeriesData = (JSONArray)session.getAttribute("monthWiseSeriesData");		
		//JSONArray dayWiseData = (JSONArray)session.getAttribute("dayWiseData");
		JSONArray lineChartData = (JSONArray)session.getAttribute("lineChartData");
		JSONArray lineChartCategory = (JSONArray)session.getAttribute("lineChartCategory");
		String chartTitle = (String)session.getAttribute("chatTitle");
		
		
		%>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
	<script src="<c:url value='/resources/chart/data.js'/>"></script>
	<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
	<script src="<c:url value='/resources/chart/pretty-doughtnut.js'/>"></script>
	<script src="<c:url value='//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js'/>"></script>
	<script src="<c:url value='http://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.1/Chart.min.js'/>"></script>
	
	<script src="<c:url value='//code.jquery.com/jquery-2.1.3.min.js'/>"></script>
	<script src="<c:url value='/resources/chart/jquery.chart.js'/>"></script>
	
	<script type="text/javascript">
	Highcharts.chart('lineChart', {
	    chart: {
	        type: 'line'
	    },
	    title: {
	        text: 'Line Chart'
	    },
	    subtitle: {
	        text: ''
	    },
	    credits: {
	        enabled: false
	    },
	    xAxis: {
	        categories: <%=lineChartCategory%>
	    },
	    yAxis: {
	        title: {
	            text: 'Data Quantity'
	        }
	    },
	    plotOptions: {
	        line: {
	            dataLabels: {
	                enabled: true
	            },
	            enableMouseTracking: false
	        }
	    },
	    series: <%=lineChartData%>
	});
	
	</script>
	<script type="text/javascript">
	
	// Create the chart
	Highcharts.chart('pieDrilled', {
	    chart: {
	        type: 'pie'
	    },
	    title: {
	        text: ''
	    },
	    subtitle: {
	        text: ''
	    },
	    credits: {
	        enabled: false
	    },
	    tooltip: {
            pointFormat: '<b>{point.percentage} </b>',
            percentageDecimals: 0
        },
        plotOptions: {
            series: {
                dataLabels: {
                    enabled: true,
                    format: '{point.name}: {point.y:.0f}'
                }
            }
        },

	    tooltip: {
	        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
	        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.0f}</b> of total<br/>'
	    },

	    "series": [
	        {
	            "name": "mCare2 Data Visualization",
	            "colorByPoint": true,
	            "data": <%=monthWiseSeriesData%>
	        }
	    ]
	});
	</script>
	<script type="text/javascript">
	// Create the chart
	
	Highcharts.chart('barChartDirlled', {
	    chart: {
	        type: 'column'
	    },
	    title: {
	        text: '<%=chartTitle%>'
	    },
	    subtitle: {
	        text: ''
	    },
	    xAxis: {
	        type: 'category'
	    },
	    yAxis: {
	        title: {
	            text: ''
	        }

	    },
	    credits: {
	        enabled: false
	    },
	    legend: {
	        enabled: false
	    },
	    plotOptions: {
	        series: {
	            borderWidth: 0,
	            dataLabels: {
	                enabled: true,
	                format: '{point.y:.0f}'
	            }
	        }
	    },

	    tooltip: {
	        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
	        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.0f} <br/>'
	    },

	    "series": [
	        {
	            "name": "mCare2 Data Visualization",
	            "colorByPoint": true,
	            "data": <%=monthWiseSeriesData%>
	        }
	    ]
	});
	
	</script>
	
	<script type="text/javascript">
	// Create the chart
	
	Highcharts.chart('barChartDirlled2', {
	    chart: {
	        type: 'column'
	    },
	    title: {
	        text: '<%=chartTitle%>'
	    },
	    subtitle: {
	        text: ''
	    },
	    xAxis: {
	        type: 'category'
	    },
	    yAxis: {
	        title: {
	            text: ''
	        }

	    },
	    credits: {
	        enabled: false
	    },
	    legend: {
	        enabled: false
	    },
	    plotOptions: {
	        series: {
	            borderWidth: 0,
	            dataLabels: {
	                enabled: true,
	                format: '{point.y:.0f}'
	            }
	        }
	    },

	    tooltip: {
	        headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
	        pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.0f} <br/>'
	    },

	    "series": [
	        {
	            "name": "mCare2 Data Visualization",
	            "colorByPoint": true,
	            "data": <%=monthWiseSeriesData%>
	        }
	    ]
	});
	
	</script>
	
	<script type="text/javascript">
	$(window).load(function() {
		  doughnutWidget.options = {
		    container: $('#container'),
		    width: 100,
		    height: 100,
		    class: 'myClass',
		    cutout: 50
		  };

		  doughnutWidget.render(data());

		  //setInterval(init, 2000);
		});

		function init() {
		  doughnutWidget.render(data());
		}

		function data() {
		  var data = {
		  pending: {
		    //val: Math.round(Math.random() * 100),
		    val: 40,
		    color: '#57B4F2',
		    click: function(e) {
		    console.log('hi');
		    }
		  }
		  /*,
		  delivered: {
		    val: Math.round(Math.random() * 100),
		    color: '#6DED5C'
		  },
		  delayed: {
		    val: Math.round(Math.random() * 100),
		    color: '#E63329',
		    link: 'http://www.google.com'
		  }*/
		  };

		  return data;
		}
	
	</script>
	
	<script type="text/javascript">
	$(function() {
        $('.donut-chart').cssCharts({type:"donut"}).trigger('show-donut-chart');
    });
	
	</script>
	
</body>
</html>