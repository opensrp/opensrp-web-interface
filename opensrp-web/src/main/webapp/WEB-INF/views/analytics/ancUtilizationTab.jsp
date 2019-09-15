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
	Integer[] ancReferred = (Integer[]) session.getAttribute("ancReferred");
	Integer[] ancCCAccess = (Integer[]) session.getAttribute("ancCCAccess");
%>
<div>
	<h3 style="color: darkblue; text-align: center;">ANC Utilization
		Rate from Community Clinic</h3>
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
	<h5 style="color: darkblue; text-align: center;">Different ANC
		Service Utilization Rate</h5>
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

	<h5 style="color: darkblue; text-align: center;">ANC Utilization
		Trend</h5>

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
					<div id="container1"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
				<td>
					<div id="container2"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
				<td>
					<div id="container3"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
				<td>
					<div id="container4"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
			</tr>
		</tbody>
	</table>
	<script>
		Highcharts.chart('container1',
				{
					title : {
						text : ''
					},
					colors : [ '#0868cf' ],
					chart : {
						type : 'column'
					},
					xAxis : {
						type : 'category',
						labels : {
							rotation : -90,
							style : {
								fontSize : '13px',
								fontFamily : 'Verdana, sans-serif'
							}
						}
					},
					yAxis : {
						min : 0,
						title : {
							text : 'Value'
						}
					},
					legend : {
						enabled : false
					},
					tooltip : {
						pointFormat : 'Access to CC: <b>{point.y:.1f} %</b>'
					},
					series : [ {
						name : 'Population',
						data : [
								[
										'December 2018',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ],
								[
										'January 2019',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ],
								[
										'February 2019',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ],
								[
										'March 2019',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ],
								[
										'April 2019',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ],
								[
										'May 2019',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ],
								[
										'June 2019',
										Math.floor(Math.random()
												* (90 - 55 + 1)) + 55 ], ],
						dataLabels : {
							enabled : true,
							rotation : -90,
							color : '#FFFFFF',
							align : 'right',
							format : '{point.y:.1f}', // one decimal
							y : 10, // 10 pixels down from the top
							style : {
								fontSize : '13px',
								fontFamily : 'Verdana, sans-serif'
							}
						}
					} ]
				});
	</script>
	<script>
		Highcharts
				.chart(
						'container2',
						{
							title : {
								text : ''
							},
							colors : [ '#ed5f13' ],
							chart : {
								type : 'column'
							},
							xAxis : {
								type : 'category',
								labels : {
									rotation : -90,
									style : {
										fontSize : '13px',
										fontFamily : 'Verdana, sans-serif'
									}
								}
							},
							yAxis : {
								min : 0,
								title : {
									text : 'Value'
								}
							},
							legend : {
								enabled : false
							},
							tooltip : {
								pointFormat : 'Received HealthCare: <b>{point.y:.1f} %</b>'
							},
							series : [ {
								name : 'Population',
								data : [
										[
												'December 2018',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'January 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'February 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'March 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'April 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'May 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'June 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ], ],
								dataLabels : {
									enabled : true,
									rotation : -90,
									color : '#FFFFFF',
									align : 'right',
									format : '{point.y:.1f}', // one decimal
									y : 10, // 10 pixels down from the top
									style : {
										fontSize : '13px',
										fontFamily : 'Verdana, sans-serif'
									}
								}
							} ]
						});
	</script>
	<script>
		Highcharts
				.chart(
						'container3',
						{
							colors : [ '#0db829' ],
							title : {
								text : ''
							},
							chart : {
								type : 'column'
							},
							xAxis : {
								type : 'category',
								labels : {
									rotation : -90,
									style : {
										fontSize : '13px',
										fontFamily : 'Verdana, sans-serif'
									}
								}
							},
							yAxis : {
								min : 0,
								title : {
									text : 'Value'
								}
							},
							legend : {
								enabled : false
							},
							tooltip : {
								pointFormat : 'Received HealthEducation: <b>{point.y:.1f} %</b>'
							},
							series : [ {
								name : 'Population',
								data : [
										[
												'December 2018',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'January 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'February 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'March 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'April 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'May 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ],
										[
												'June 2019',
												Math.floor(Math.random()
														* (90 - 55 + 1)) + 55 ], ],
								dataLabels : {
									enabled : true,
									rotation : -90,
									color : '#FFFFFF',
									align : 'right',
									format : '{point.y:.1f}', // one decimal
									y : 10, // 10 pixels down from the top
									style : {
										fontSize : '13px',
										fontFamily : 'Verdana, sans-serif'
									}
								}
							} ]
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