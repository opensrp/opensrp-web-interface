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
	Integer[] pncRate = (Integer[]) session.getAttribute("pncRate");
	Integer[] pncReferred = (Integer[]) session.getAttribute("pncReferred");
	Integer[] pncCCAccess = (Integer[]) session.getAttribute("pncCCAccess");
%>

<div>
	<h3 style="color: darkblue; text-align: center;">PNC Utilization
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
				<td class="large-font"><%=pncRate[0]%>%</td>
				<td class="large-font"><%=pncRate[1]%>%</td>
				<td class="large-font"><%=pncRate[2]%>%</td>
				<td class="large-font"><%=pncReferred[0]%>%</td>
			</tr>
		</tbody>
	</table>
	<br>
	<h5 style="text-align: center;">Different PNC Service Utilization
		Rate</h5>
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

	<h5 style="color: darkblue; text-align: center;">PNC Utilization
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
					<div id="container5"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
				<td>
					<div id="container6"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
				<td>
					<div id="container7"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
				<td>
					<div id="container8"
						style="width: 300px; height: 300px; margin: 0 auto"></div>
				</td>
			</tr>
		</tbody>
	</table>
	<script>
		Highcharts.chart('container5',
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
						'container6',
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
						'container7',
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
		Highcharts.chart('container8',
				{
					title : {
						text : ''
					},
					colors : [ '#c71a1a' ],
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
						pointFormat : 'Referred: <b>{point.y:.1f} %</b>'
					},
					series : [ {
						name : 'Population',
						data : [
								[
										'December 2018',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ],
								[
										'January 2019',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ],
								[
										'February 2019',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ],
								[
										'March 2019',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ],
								[
										'April 2019',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ],
								[
										'May 2019',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ],
								[
										'June 2019',
										Math.floor(Math.random()
												* (30 - 15 + 1)) + 15 ], ],
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
</div>