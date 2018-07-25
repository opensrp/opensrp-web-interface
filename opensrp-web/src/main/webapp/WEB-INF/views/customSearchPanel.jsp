<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	List<Object[]> divisions = (List<Object[]>) session
			.getAttribute("divisions");
%>


<div class="card mb-3">
	<div class="card-header">
		<i class="fa fa-table"></i> ${title.toString()} Search
	</div>
	<div class="card-body">
		
			<div class="row">
			</div>
			<form id="search-form">
			<div class="row">
				
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="division"
						name="division">
						<option value="">Please Select Division</option>
						<%
							for (Object[] objects : divisions) {%>
								<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
						<%
										
						}
						%>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="district"
						name="district">
						<option value=""></option>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="upazila"
						name="upazila">
						<option value=""></option>
						
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="union"
						name="union">
						<option value=""></option>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="ward"
						name="ward">
						<option value=""></option>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="subunit"
						name="subunit">
						<option value=""></option>
					</select>
				</div>
				<div class="col-3">
					<select class="custom-select custom-select-lg mb-3" id="mauzapara"
						name="mauzapara">
						<option value=""></option>
					</select>
				</div>
			</div>

			<div class="row">
				
				<div class="col-6">
					<button name="search" type="submit" id="bth-search"
						class="btn btn-primary" value="search">Search</button>
				</div>
			</div>
			
		</form>
	</div>
	<div class="card-footer small text-muted"></div>
</div>