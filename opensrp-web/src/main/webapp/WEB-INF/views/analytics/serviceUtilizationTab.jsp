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
<div>
	<h3 style="color: darkblue; text-align: center;">Service
		Utilization from CC</h3>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th><b>Age-U5</b></th>
				<th><b>Age(15-19)</b></th>
				<th><b>Age(20-30)</b></th>
				<th><b>Age30+</b></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="large-font"><%=serviceRate[0]%>%</td>
				<td class="large-font"><%=serviceRate[1]%>%</td>
				<td class="large-font"><%=serviceRate[2]%>%</td>
				<td class="large-font"><%=serviceRate[3]%>%</td>
			</tr>
		</tbody>
	</table>
	<br>
	<h5 style="text-align: center;">Service Utilization (Gender)</h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th colspan="9">Age Range</th>
			</tr>
			<tr>
				<th rowspan="2">Gender</th>
				<th colspan="2">Age-U5</th>
				<th colspan="2">Age(15-19)</th>
				<th colspan="2">Age(20-30)</th>
				<th colspan="2">Age 30+</th>
			</tr>
			<tr>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Female</th>
				<td><%=serviceAccess[0]%></td>
				<td><%=serviceRate[4]%>%</td>
				<td><%=serviceAccess[1]%></td>
				<td><%=serviceRate[5]%>%</td>
				<td><%=serviceAccess[2]%></td>
				<td><%=serviceRate[6]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[7]%>%</td>
			</tr>
			<tr>
				<th>Male</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[8]%>%</td>
				<td><%=serviceAccess[5]%></td>
				<td><%=serviceRate[9]%>%</td>
				<td><%=serviceAccess[6]%></td>
				<td><%=serviceRate[10]%>%</td>
				<td><%=serviceAccess[7]%></td>
				<td><%=serviceRate[11]%>%</td>
			</tr>
		</tbody>
	</table>
	<br>
	<h5 style="text-align: center;">Service Utilization (Socio
		Economic Background)</h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th colspan="9">Age Range</th>
			</tr>
			<tr>
				<th rowspan="2">Socio Economic Status</th>
				<th colspan="2">Age-U5</th>
				<th colspan="2">Age(15-19)</th>
				<th colspan="2">Age(20-30)</th>
				<th colspan="2">Age 30+</th>
			</tr>
			<tr>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
				<th>Service Access to CC</th>
				<th>Access to CC (%)</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Ultra Poor</th>
				<td><%=serviceAccess[8]%></td>
				<td><%=serviceRate[12]%>%</td>
				<td><%=serviceAccess[9]%></td>
				<td><%=serviceRate[13]%>%</td>
				<td><%=serviceAccess[10]%></td>
				<td><%=serviceRate[14]%>%</td>
				<td><%=serviceAccess[11]%></td>
				<td><%=serviceRate[15]%>%</td>
			</tr>
			<tr>
				<th>Poor</th>
				<td><%=serviceAccess[12]%></td>
				<td><%=serviceRate[16]%>%</td>
				<td><%=serviceAccess[13]%></td>
				<td><%=serviceRate[17]%>%</td>
				<td><%=serviceAccess[14]%></td>
				<td><%=serviceRate[18]%>%</td>
				<td><%=serviceAccess[15]%></td>
				<td><%=serviceRate[19]%>%</td>
			</tr>
			<tr>
				<th>Middle Class</th>
				<td><%=serviceAccess[16]%></td>
				<td><%=serviceRate[20]%>%</td>
				<td><%=serviceAccess[17]%></td>
				<td><%=serviceRate[21]%>%</td>
				<td><%=serviceAccess[18]%></td>
				<td><%=serviceRate[22]%>%</td>
				<td><%=serviceAccess[19]%></td>
				<td><%=serviceRate[23]%>%</td>
			</tr>
			<tr>
				<th>Solvent</th>
				<td><%=serviceAccess[20]%></td>
				<td><%=serviceRate[24]%>%</td>
				<td><%=serviceAccess[21]%></td>
				<td><%=serviceRate[25]%>%</td>
				<td><%=serviceAccess[22]%></td>
				<td><%=serviceRate[26]%>%</td>
				<td><%=serviceAccess[23]%></td>
				<td><%=serviceRate[27]%>%</td>
			</tr>
			<tr>
				<th>Rich</th>
				<td><%=serviceAccess[24]%></td>
				<td><%=serviceRate[28]%>%</td>
				<td><%=serviceAccess[25]%></td>
				<td><%=serviceRate[29]%>%</td>
				<td><%=serviceAccess[26]%></td>
				<td><%=ancRate[29]%>%</td>
				<td><%=serviceAccess[27]%></td>
				<td><%=ancRate[28]%>%</td>
			</tr>
		</tbody>
	</table>
</div>