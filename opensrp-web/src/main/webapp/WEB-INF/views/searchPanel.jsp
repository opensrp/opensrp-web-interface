<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	Map<String, String> paginationAtributes = (Map<String, String>) session
			.getAttribute("paginationAtributes");
	String division = "";
	int divId = 0;
	if (paginationAtributes.containsKey("divId")) {
		divId = Integer.parseInt(paginationAtributes.get("divId"));
	}

	int distId = 0;
	if (paginationAtributes.containsKey("distId")) {
		distId = Integer.parseInt(paginationAtributes.get("distId"));
	}

	int upzilaId = 0;
	if (paginationAtributes.containsKey("upzilaId")) {
		upzilaId = Integer
				.parseInt(paginationAtributes.get("upzilaId"));
	}
	String union = "";
	int unionId = 0;
	if (paginationAtributes.containsKey("unionId")) {
		unionId = Integer.parseInt(paginationAtributes.get("unionId"));
	}

	int wardId = 0;
	if (paginationAtributes.containsKey("wardId")) {
		wardId = Integer.parseInt(paginationAtributes.get("wardId"));
	}

	int subunitId = 0;
	if (paginationAtributes.containsKey("subunitId")) {
		subunitId = Integer.parseInt(paginationAtributes
				.get("subunitId"));
	}

	int mauzaparaId = 0;
	if (paginationAtributes.containsKey("mauzaparaId")) {
		mauzaparaId = Integer.parseInt(paginationAtributes
				.get("mauzaparaId"));
	}

	String name = "";
	if (paginationAtributes.containsKey("name")) {
		name = paginationAtributes.get("name");
	}

	List<Object[]> divisions = (List<Object[]>) session
			.getAttribute("divisions");
	List<Object[]> districts = (List<Object[]>) session
			.getAttribute("districtListByParent");
	List<Object[]> upazilas = (List<Object[]>) session
			.getAttribute("upazilasListByParent");
	List<Object[]> unions = (List<Object[]>) session
			.getAttribute("unionsListByParent");
	List<Object[]> wards = (List<Object[]>) session
			.getAttribute("wardsListByParent");
	List<Object[]> subuits = (List<Object[]>) session
			.getAttribute("subunitListByParent");
	List<Object[]> mauzaparas = (List<Object[]>) session
			.getAttribute("mauzaparaListByParent");
%>


<div class="card mb-3">
	<div class="card-header">
		<i class="fa fa-table"></i> ${title.toString()} Search
	</div>
	<div class="card-body">
		<form id="search-form">
			<div class="row">
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="division"
						name="division">
						<option value="0?">Please Select Division</option>
						<%
										for (Object[] objects : divisions) {
											if (divId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
										}
									%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="district"
						name="district">
						<option value="0?">Please Select District</option>
						<%
										if (districts != null) {
											for (Object[] objects : districts) {
												if (distId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
											}
										}
									%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="upazila"
						name="upazila">
						<option value="0?">Please Select Upazilla</option>
						<%
										if (upazilas != null) {
											for (Object[] objects : upazilas) {
												if (upzilaId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
											}
										}
									%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="union"
						name="union">
						<option value="0?">Please Select Union</option>
						<%
										if (unions != null) {
											for (Object[] objects : unions) {
												if (unionId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
											}
										}
									%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="ward"
						name="ward">
						<option value="0?">Please Select Ward</option>
						<%
										if (wards != null) {
											for (Object[] objects : wards) {
												if (wardId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
											}
										}
									%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="subunit"
						name="subunit">
						<option value="0?">Please Select Subunit</option>
						<%
										if (subuits != null) {
											for (Object[] objects : subuits) {
												if (subunitId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
											}
										}
									%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="mauzapara"
						name="mauzapara">
						<option value="0?">Please Select Mauzapara</option>
						<%
										if (mauzaparas != null) {
											for (Object[] objects : mauzaparas) {
												if (mauzaparaId == ((Integer) objects[1]).intValue()) {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
						<%
										} else {
									%>
						<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										}
											}
										}
									%>
					</select>
				</div>
			</div>


			<div class="row">
				<div class="col-6">
					<div class="form-group">
						<input name="name" type="search" class="form-control"
							value="<%=name%>" placeholder="">
					</div>
				</div>
				<div class="col-6">
					<button name="search" type="submit" id="bth-search"
						class="btn btn-primary" value="search">Search</button>
				</div>
			</div>
		</form>
	</div>
	<div class="card-footer small text-muted"></div>
</div>