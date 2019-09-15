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
	<h5 style="text-align: center;">Utilization of neonatal services from CC</h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th rowspan="2">Disease</th>
				<th colspan="2">Access</th>
				<th colspan="2">Care (drug, physical examination)</th>
				<th colspan="2">Health education</th>
				<th colspan="2">Referred</th>
			</tr>
			<tr>
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Very severe disease </th>
				<td><%=serviceAccess[0]%></td>
				<td><%=serviceRate[0]%>%</td>
				<td><%=serviceAccess[1]%></td>
				<td><%=serviceRate[1]%>%</td>
				<td><%=serviceAccess[2]%></td>
				<td><%=serviceRate[2]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
			</tr>
			<tr>
				<th>Infection</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[4]%>%</td>
				<td><%=serviceAccess[5]%></td>
				<td><%=serviceRate[5]%>%</td>
				<td><%=serviceAccess[6]%></td>
				<td><%=serviceRate[6]%>%</td>
				<td><%=serviceAccess[7]%></td>
				<td><%=serviceRate[7]%>%</td>
			</tr>
			<tr>
				<th>Jaundice</th>
				<td><%=serviceAccess[8]%></td>
				<td><%=serviceRate[8]%>%</td>
				<td><%=serviceAccess[9]%></td>
				<td><%=serviceRate[9]%>%</td>
				<td><%=serviceAccess[10]%></td>
				<td><%=serviceRate[10]%>%</td>
				<td><%=serviceAccess[11]%></td>
				<td><%=serviceRate[11]%>%</td>
			</tr>
			<tr>
				<th>Dehydration/Diarrhoea</th>
				<td><%=serviceAccess[13]%></td>
				<td><%=serviceRate[13]%>%</td>
				<td><%=serviceAccess[14]%></td>
				<td><%=serviceRate[14]%>%</td>
				<td><%=serviceAccess[15]%></td>
				<td><%=serviceRate[15]%>%</td>
				<td><%=serviceAccess[16]%></td>
				<td><%=serviceRate[16]%>%</td>
			</tr>
			<tr>
				<th>Total</th>
				<td><%=serviceAccess[17]%></td>
				<td><%=serviceRate[17]%>%</td>
				<td><%=serviceAccess[18]%></td>
				<td><%=serviceRate[18]%>%</td>
				<td><%=serviceAccess[19]%></td>
				<td><%=serviceRate[19]%>%</td>
				<td><%=serviceAccess[20]%></td>
				<td><%=serviceRate[21]%>%</td>
			</tr>
		</tbody>
	</table>
</div>