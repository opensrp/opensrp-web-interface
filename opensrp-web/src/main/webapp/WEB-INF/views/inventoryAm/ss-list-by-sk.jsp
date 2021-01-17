<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<table class="table table-striped table-bordered record_table"
	id="sellToManySSList">
	<thead>
		<tr>
			<th>
				<!-- <input type="checkbox"  name="select_all" value="1" id="select-all"> -->
			</th>
			<th><spring:message code="lbl.name"></spring:message></th>
			<th><spring:message code="lbl.designation"></spring:message></th>
			<th><spring:message code="lbl.skname"></spring:message></th>
			<th>SK mobile</th>
			<th><spring:message code="lbl.branchNameCode"></spring:message></th>

		</tr>
	</thead>

	<tbody>
		<c:forEach items="${ssLists}" var="ssList">
			<tr>
				<td><input type="checkbox" name="manuf[]" class="sub_chk"
					id="ss${ssList.getId() }" value="${ssList.getId()}"></td>
					<td>${ssList.getFullName() }</td>
					<td>SS</td>
				
				<td>${ssList.getSKName() }</td>
				<td>${ssList.getUsername() }</td>
				<td>${ssList.getBranchName() } ${ssList.getBranchCode() }</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

















