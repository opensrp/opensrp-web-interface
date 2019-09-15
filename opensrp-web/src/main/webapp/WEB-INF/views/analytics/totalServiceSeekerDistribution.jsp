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
	<h5 style="text-align: center;">Distribution of total service seeker of community clinic </h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th rowspan="2" colspan="2">Traits</th>
				<th colspan="2">U5</th>
				<th colspan="2">5-9</th>
				<th colspan="2">10-14</th>
				<th colspan="2">15-19</th>
				<th colspan="2">20-24</th>
				<th colspan="2">25-29</th>
				<th colspan="2">30+</th>
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
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
				<th>Number</th>
				<th>Percentage(%)</th>
			</tr>
			<tr>
				<th rowspan="2" >Gender</th>
				<th>Male</th>
				<td><%=serviceAccess[0]%></td>
				<td><%=serviceRate[0]%>%</td>
				<td><%=serviceAccess[1]%></td>
				<td><%=serviceRate[1]%>%</td>
				<td><%=serviceAccess[2]%></td>
				<td><%=serviceRate[2]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
			</tr>
			<tr>
				<th>Female</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[4]%>%</td>
				<td><%=serviceAccess[5]%></td>
				<td><%=serviceRate[5]%>%</td>
				<td><%=serviceAccess[6]%></td>
				<td><%=serviceRate[6]%>%</td>
				<td><%=serviceAccess[7]%></td>
				<td><%=serviceRate[7]%>%</td>
				<td><%=serviceAccess[8]%></td>
				<td><%=serviceRate[8]%>%</td>
				<td><%=serviceAccess[9]%></td>
				<td><%=serviceRate[9]%>%</td>
				<td><%=serviceAccess[10]%></td>
				<td><%=serviceRate[10]%>%</td>
				
			</tr>
		</thead>
		<tbody>
			<tr>
				<th rowspan="4" >Socio-economic status </th>
				<th>Ultra Poor</th>
				<td><%=serviceAccess[11]%></td>
				<td><%=serviceRate[11]%>%</td>
				<td><%=serviceAccess[12]%></td>
				<td><%=serviceRate[12]%>%</td>
				<td><%=serviceAccess[13]%></td>
				<td><%=serviceRate[13]%>%</td>
				<td><%=serviceAccess[14]%></td>
				<td><%=serviceRate[14]%>%</td>
				<td><%=serviceAccess[15]%></td>
				<td><%=serviceRate[15]%>%</td>
				<td><%=serviceAccess[16]%></td>
				<td><%=serviceRate[16]%>%</td>
				<td><%=serviceAccess[17]%></td>
				<td><%=serviceRate[18]%>%</td>
			</tr>
			<tr>
				<th>Poor</th>
				<td><%=serviceAccess[19]%></td>
				<td><%=serviceRate[19]%>%</td>
				<td><%=serviceAccess[20]%></td>
				<td><%=serviceRate[20]%>%</td>
				<td><%=serviceAccess[21]%></td>
				<td><%=serviceRate[21]%>%</td>
				<td><%=serviceAccess[22]%></td>
				<td><%=serviceRate[22]%>%</td>
				<td><%=serviceAccess[23]%></td>
				<td><%=serviceRate[23]%>%</td>
				<td><%=serviceAccess[24]%></td>
				<td><%=serviceRate[24]%>%</td>
				<td><%=serviceAccess[25]%></td>
				<td><%=serviceRate[25]%>%</td>
			</tr>
			<tr>
				<th>Lower middle class</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[4]%>%</td>
				<td><%=serviceAccess[5]%></td>
				<td><%=serviceRate[5]%>%</td>
				<td><%=serviceAccess[6]%></td>
				<td><%=serviceRate[6]%>%</td>
				<td><%=serviceAccess[7]%></td>
				<td><%=serviceRate[7]%>%</td>
				<td><%=serviceAccess[8]%></td>
				<td><%=serviceRate[8]%>%</td>
				<td><%=serviceAccess[9]%></td>
				<td><%=serviceRate[9]%>%</td>
				<td><%=serviceAccess[10]%></td>
				<td><%=serviceRate[10]%>%</td>
			</tr>
			<tr>
				<th>Middle class/affluent</th>
				<td><%=serviceAccess[11]%></td>
				<td><%=serviceRate[11]%>%</td>
				<td><%=serviceAccess[12]%></td>
				<td><%=serviceRate[12]%>%</td>
				<td><%=serviceAccess[13]%></td>
				<td><%=serviceRate[13]%>%</td>
				<td><%=serviceAccess[14]%></td>
				<td><%=serviceRate[14]%>%</td>
				<td><%=serviceAccess[15]%></td>
				<td><%=serviceRate[15]%>%</td>
				<td><%=serviceAccess[16]%></td>
				<td><%=serviceRate[16]%>%</td>
				<td><%=serviceAccess[17]%></td>
				<td><%=serviceRate[18]%>%</td>
			</tr>
			<tr>
				<th>Geo-graphical local</th>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>

			</tr>
		</tbody>
	</table>
</div>