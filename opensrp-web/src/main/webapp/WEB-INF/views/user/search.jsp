<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page import="org.opensrp.core.entity.Role" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<%
	List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
	List<Branch> branches = (List<Branch>) session.getAttribute("branches");
	List<Role> roles = (List<Role>) session.getAttribute("roles");
%>
<div class="card mb-3">
	<div class="card-header">
		<i class="fa fa-table"></i> ${title.toString()} <spring:message code="lbl.searchArea"/>
	</div>
	<div class="card-body">

		<div class="row">
		</div>
		<form id="search-form" autocomplete="off">
			<!-- location info -->
			<div class="row">
				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="division"
							name="division">
						<option value=""><spring:message code="lbl.selectDivision"/>
						</option>
						<%
							for (Object[] objects : divisions) {
						%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="district"
							name="district">
						<option value="0?"><spring:message code="lbl.selectDistrict"/></option>
						<option value=""></option>
					</select>
				</div>

				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="upazila"
							name="upazila">
						<option value="0?"><spring:message code="lbl.selectUpazila"/></option>
						<option value=""></option>

					</select>
				</div>

				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="pourasabha"
							name="pourasabha">
						<option value="0?"><spring:message code="lbl.selectPourasabha"/></option>
						<option value=""></option>

					</select>
				</div>

				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="union"
							name="union">
						<option value="0?"><spring:message code="lbl.selectUnion"/></option>
						<option value=""></option>

					</select>
				</div>

				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="village"
							name="village">
						<option value="0?"><spring:message code="lbl.selectVillage"/></option>
						<option value=""></option>

					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3" id="role"
							name="role">
						<option value=""><spring:message code="lbl.selectRole"/></option>
						<%
							for(Role role: roles) {

						%>
						<option value="<%=role.getId()%>"><%=role.getName()%></option>
						<%
							}
						%>
					</select>
				</div>

				<div class="col-2">
					<select class="custom-select custom-select-lg mb-3 js-example-basic-multiple" id="branch" name="branch">
						<option value=""><spring:message code="lbl.selectBranch"/></option>
						<%
							for(Branch branch: branches) {

						%>
						<option value="<%=branch.getId()%>"><%=branch.getName()%></option>
						<%
							}
						%>
					</select>
				</div>
				
				<div class="col-2">
					<div class="form-group">
						<input name="name" style="font-size:12px" type="search" class="form-control"
							 placeholder="User name">
					</div>
				</div>
			</div>
			<!-- end: location info -->

			<div class="row">

				<div class="col-6">
					<button type="submit" id="bth-search"
							class="btn btn-primary" value="search"><spring:message code="lbl.search"/></button>
				</div>
			</div>
		</form>
	</div>
	<div class="card-footer small text-muted"></div>
</div>

<script>

</script>
