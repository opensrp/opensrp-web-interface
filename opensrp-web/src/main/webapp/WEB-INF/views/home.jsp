<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.common.util.NumberToDigit"%>
<%@page import="org.opensrp.web.visualization.HighChart"%>
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

<title>OPENSRP Dashboard Home</title>

<meta name='viewport'
	content='initial-scale=1,maximum-scale=1,user-scalable=no' />
<link href="https://fonts.googleapis.com/css?family=Open+Sans"
	rel="stylesheet">
<script
	src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.js'></script>
<link
	href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.css'
	rel='stylesheet' />
<style>
body {
	margin: 0;
	padding: 0;
}

#map {
	position: absolute;
	top: 0;
	bottom: 0;
	width: 100%;
}

.marker {
	background-image: url('/resources/images/mapbox-icon.png');
	background-size: cover;
	width: 50px;
	height: 50px;
	border-radius: 50%;
	cursor: pointer;
}

.mapboxgl-popup {
	max-width: 200px;
}

.mapboxgl-popup-content {
	text-align: center;
	font-family: 'Open Sans', sans-serif;
}
</style>

<jsp:include page="/WEB-INF/views/css.jsp" />
<link type="text/css" href="<c:url value="/resources/css/style.css"/>"
	rel="stylesheet">
</head>
<c:url var="saveUrl" value="/role/add" />
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />


	<div class="content-wrapper">
		<div class="container-fluid">
			<!-- Breadcrumbs-->
			<ol class="breadcrumb">
				<li class="breadcrumb-item"><a href="#">Dashboard</a></li>
				<!-- <li class="breadcrumb-item active">My Dashboard</li> -->
			</ol>
			<!-- Icon Cards-->
			<div class="row">
				<div class="col-xl-4 col-sm-6 mb-4">
					<div class="card text-white bg-primary o-hidden h-100">
						<div class="card-body">
							<div class="card-body-icon">
								<i class="fa fa-fw fa-comments"></i>
							</div>
							<div class="mr-5">
								<% 
		                         Integer totalChildCount = (Integer) session.getAttribute("totalChildCount");
		                        %>
								<h3><%=totalChildCount%></h3>
								Total Child Registered
							</div>
						</div>
						<a class="card-footer text-white clearfix small z-1" href="#">
							<span class="float-left">View Details</span> <span
							class="float-right"> <i class="fa fa-angle-right"></i>
						</span>
						</a>
					</div>
				</div>
				<div class="col-xl-4 col-sm-6 mb-4">
					<div class="card text-white bg-warning o-hidden h-100">
						<div class="card-body">
							<div class="card-body-icon">
								<i class="fa fa-fw fa-list"></i>
							</div>
							<div class="mr-5">
								<h3>90%</h3>
								% of the Children are reaching
							</div>
						</div>
						<a class="card-footer text-white clearfix small z-1" href="#">
							<span class="float-left">View Details</span> <span
							class="float-right"> <i class="fa fa-angle-right"></i>
						</span>
						</a>
					</div>
				</div>
				<div class="col-xl-4 col-sm-6 mb-4">
					<div class="card text-white bg-success o-hidden h-100">
						<div class="card-body">
							<div class="card-body-icon">
								<i class="fa fa-fw fa-shopping-cart"></i>
							</div>
							<div class="mr-5">
								<% 
		                         String childGrowthFalteringPercentage = (String) session.getAttribute("childGrowthFalteringPercentage");
		                        %>
								<h3><%=childGrowthFalteringPercentage%>%
								</h3>
								% Children who are growth faltering
							</div>
						</div>
						<a class="card-footer text-white clearfix small z-1" href="#">
							<span class="float-left">View Details</span> <span
							class="float-right"> <i class="fa fa-angle-right"></i>
						</span>
						</a>
					</div>
				</div>
				<div class="col-xl-4 col-sm-6 mb-4">
					<div class="card text-white bg-danger o-hidden h-100">
						<div class="card-body">
							<div class="card-body-icon">
								<i class="fa fa-fw fa-support"></i>
							</div>
							<div class="mr-5">
								<% 
		                         Integer totalPregnantCount = (Integer) session.getAttribute("totalPregnantCount");
		                        %>
								<h3><%=totalPregnantCount%></h3>
								Total Pregnant Women Registered
							</div>
						</div>
						<a class="card-footer text-white clearfix small z-1" href="#">
							<span class="float-left">View Details</span> <span
							class="float-right"> <i class="fa fa-angle-right"></i>
						</span>
						</a>
					</div>
				</div>
				<div class="col-xl-4 col-sm-6 mb-4">
					<div class="card text-white bg-success o-hidden h-100">
						<div class="card-body">
							<div class="card-body-icon">
								<i class="fa fa-fw fa-support"></i>
							</div>
							<div class="mr-5">
								<h3>70%</h3>
								% of the Woman are Reaching
							</div>
						</div>
						<a class="card-footer text-white clearfix small z-1" href="#">
							<span class="float-left">View Details</span> <span
							class="float-right"> <i class="fa fa-angle-right"></i>
						</span>
						</a>
					</div>
				</div>
				<div class="col-xl-4 col-sm-6 mb-4">
					<div class="card text-white bg-danger o-hidden h-100">
						<div class="card-body">
							<div class="card-body-icon">
								<i class="fa fa-fw fa-support"></i>
							</div>
							<div class="mr-5">
								<h3>30%</h3>
								% of the Woman are followed Counseling
							</div>
						</div>
						<a class="card-footer text-white clearfix small z-1" href="#">
							<span class="float-left">View Details</span> <span
							class="float-right"> <i class="fa fa-angle-right"></i>
						</span>
						</a>
					</div>
				</div>
			</div>

			<!-- Area Chart Example-->
			<div class="card-header">
					<i class="fa fa-area-chart"></i> Growth Faltering Status
				</div>
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-area-chart"></i> Growth Faltering Status
				</div>
				<div class="card-body">
					<div id='map'></div>
					 <canvas width="100%" height="450"></canvas>
				</div>
			</div>

			<!-- Area Chart Example-->
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-area-chart"></i> % Children who are growth
					faltering over time
				</div>
				<div id="lineChart" class="card-body">
					<canvas id="myAreaChart" width="100%" height="30"></canvas>
				</div>
			</div>





		</div>
		<!-- /.container-fluid-->


		<% 
		//JSONArray monthWiseSeriesData = (JSONArray)session.getAttribute("monthWiseSeriesData");		
		//JSONArray dayWiseData = (JSONArray)session.getAttribute("dayWiseData");
		JSONArray lineChartData = (JSONArray)session.getAttribute("lineChartData");
		JSONArray lineChartCategory = (JSONArray)session.getAttribute("lineChartCategory");
		//String chartTitle = (String)session.getAttribute("chatTitle");
		
		%>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>


	<script>

    mapboxgl.accessToken = 'pk.eyJ1IjoibnVyc2F0aiIsImEiOiJjamp6ZDU5ZmswOG9zM3JwNTJvN3FzYWNyIn0.PLU3v5A_kNUrfkZLQq4E8w';

    var map = new mapboxgl.Map({
       container: 'map',
       style: 'mapbox://styles/mapbox/streets-v9',
       center: [90.399452, 23.777176],
       zoom: 12
    });

    // code from the next step will go here!
    var geojson = {
        type: 'FeatureCollection',
        features: [{
            type: 'Feature',
            geometry: {
            type: 'Point',
            coordinates: [90.4043, 23.7940]
            },
            properties: {
            title: 'Mapbox',
            description: 'Banani'
            }
         },
        {
            type: 'Feature',
            geometry: {
            type: 'Point',
            coordinates: [90.3442, 23.7837]
            },
            properties: {
            title: 'Mapbox',
            description: 'Gabtoli'
            }
        }]
    };

    
    
    // add markers to map
    geojson.features.forEach(function(marker) {

      // create a HTML element for each feature
      var el = document.createElement('div');
      el.className = 'marker';

      // make a marker for each feature and add to the map
      new mapboxgl.Marker(el)
      .setLngLat(marker.geometry.coordinates)
      .setPopup(new mapboxgl.Popup({ offset: 25 }) // add popups
      .setHTML('<h3>' + marker.properties.title + '</h3><p>' + marker.properties.description + '</p>'))
      .addTo(map);
    });
    </script>


	<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
	<script src="<c:url value='/resources/chart/data.js'/>"></script>
	<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
	<script type="text/javascript">
	Highcharts.chart('lineChart', {
	    chart: {
	        type: 'line'
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

</body>
</html>