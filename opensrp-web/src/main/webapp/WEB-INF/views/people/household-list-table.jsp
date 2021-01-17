<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AggregatedBiometricDTO"%>
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




	<table class="display table table-bordered table-striped"
		id="dataTable" style="width: 100%;">
		<thead>

			<tr>
				<th> SI</th>
				<th>HH ID</th>
				<th>HH head name</th>
				<th>#Members</th>
				<th>Registration date</th>
				<th>Last visit date</th>
				<th>Village</th>
				<th>Branch(code)</th>
				<th>Contact</th>
				<th>Action</th>
			</tr>


		</thead>

		<tbody id="t-body">

			<c:forEach items="${households}" var="household">
				<tr>
					<%-- <c:forEach items='${households.get("exampleMap ").entrySet()}' var="category">
								      <a:dropdownOption value="${category.key}">${category.key} </a:dropdownOption>
								</c:forEach> --%>
					<td>0</td>
					<td>${household.getHouseholdId() }</td>
					<td>${household.getHouseholdHead() }</td>
					<td>${household.getNumberOfMember() }</td>
					<td>${household.getRegistrationDate() }</td>
					<td>${household.getLastVisitDate() }</td>
					<td>${household.getVillage() }</td>
					<td>${household.getBranchName() }(${ household.getBranchCode()})</td>
					<td>${household.getContact() }</td>
					<td><a
						href="<c:url value="/people/household-details/${household.getBaseEntityId()}/${household.getId() }.html?lang=${locale}"/>">Details</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>



</body>