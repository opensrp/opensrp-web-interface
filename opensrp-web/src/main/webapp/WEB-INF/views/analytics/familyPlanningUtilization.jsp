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
	<h5 style="text-align: center;">Utilization of family planning services from CC</h5>
	<table class="display" style="width: 100%;">
		<thead>
			<tr>
				<th>Family planning services</th>
				<th>Number</th>
				<th>percentage(%)</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>Oral pill</th>
				<td><%=serviceAccess[0]%></td>
				<td><%=serviceRate[0]%>%</td>
			</tr>
			<tr>
				<th>Condom</th>
				<td><%=serviceAccess[1]%></td>
				<td><%=serviceRate[1]%>%</td>
			</tr>
			<tr>
				<th>Injectables</th>
				<td><%=serviceAccess[2]%></td>
				<td><%=serviceRate[2]%>%</td>
			</tr>
			<tr>
				<th>Counceling</th>
				<td><%=serviceAccess[3]%></td>
				<td><%=serviceRate[3]%>%</td>
			</tr>
			<tr>
				<th>Referred</th>
				<td><%=serviceAccess[4]%></td>
				<td><%=serviceRate[4]%>%</td>
			</tr>
			<tr>
				<th>Total</th>
				<td><%=serviceAccess[6]%></td>
				<td><%=serviceRate[6]%>%</td>
			</tr>
		</tbody>
	</table>
</div>