<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:url var="location_url" value="/child-location-options" />
<c:url var="branch_url" value="/branch-list-options" />
	<div class="row">
			<div class="col-lg-3 form-group">
			    <label for="cars"><spring:message code="lbl.division"></spring:message> <span class="text-danger"> </span> </label> 
			    <select	onclick="getChildLocation(this.value,'districtList')" name="division" class="form-control" id="divisionList" required>
					<option value="0">Please select</option>
					<c:forEach items="${divisions}" var="division">
					 <c:choose>
					 	 <c:when test="${division.id ==webNotification.getDivision()}">
							<option value="${division.id}" selected="selected">${division.name}</option>
						</c:when>
						 <c:otherwise>
						 	<option value="${division.id}">${division.name}</option>
						 </c:otherwise>
					</c:choose>
					</c:forEach>
				</select>
			</div>
			<div class="col-lg-3 form-group">
			    <label for="cars"><spring:message code="lbl.district"></spring:message> </label> 
			    
			    <select	name="districtList" onclick="getChildLocation(this.value,'upazilaList')" id="districtList" class="form-control" >
					<option value="0">Please select </option>
					<c:forEach items="${districts}" var="location">
						<c:choose>
						 	 <c:when test="${location.id ==webNotification.getDistrict()}">
								<option value="${location.id}" selected="selected">${location.name}</option>
							</c:when>
							 <c:otherwise>
							 	<option value="${location.id}">${location.name}</option>
							 </c:otherwise>
						</c:choose>
					</c:forEach>
					
				</select>
			</div>
			<div class="col-lg-3 form-group">
			    <label for="cars"><spring:message code="lbl.upazila"></spring:message> </label> 
			    <select	name="upazilaList"  id="upazilaList" class="form-control">
					<option value="0">Please select </option>
					<c:forEach items="${Upazilas}" var="location">
						<c:choose>
						 	 <c:when test="${location.id ==webNotification.getUpazila()}">
								<option value="${location.id}" selected="selected">${location.name}</option>
							</c:when>
							 <c:otherwise>
							 	<option value="${location.id}">${location.name}</option>
							 </c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</div>
			<div class="col-lg-3 form-group">
			    <label for="cars"><spring:message code="lbl.branch"></spring:message></label> 
			    <select	name="branchList" class="form-control" id="branchList">
					<option value="0">please select</option>
					<c:forEach items="${branches}" var="branch">
						<c:choose>
						 	 <c:when test="${branch.id == webNotification.getBranch()}">
								<option value="${branch.id}" selected="selected">${branch.name}</option>
							</c:when>
							 <c:otherwise>
							 	<option value="${branch.id}">${branch.name}</option>
							 </c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
			</div>
								
	</div>
<script>
function getChildLocation(locationId,divId) {
	$("#"+divId).html("");	
	if(divId=='districtList'){
		$("#districtList").html('<option value="0">Please select </option>');
		$("#upazilaList").html('<option value="0">Please select </option>');
		/* $("#branchList").html('<option value="0">Please select </option>'); */
	}else if(divId=='upazilaList'){
		$("#upazilaList").html('<option value="0">Please select </option>');
		//$("#branchList").html('<option value="0">Please select </option>');
	}
	let url = '${location_url}';	
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url+"?id="+locationId,
		dataType : 'html',
		timeout : 100000,
		beforeSend: function() {},
		success : function(data) {
			$("#"+divId).html(data);
		},
		error : function(e) {
			console.log("ERROR: ", e);
			display(e);
		},
		done : function(e) {
			console.log("DONE");			
		}
	});

}


function getBranchList(locationId,divId) {
	$("#"+divId).html("");
	let url = '${branch_url}';
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url+"?id="+locationId,

		dataType : 'html',
		timeout : 100000,
		beforeSend: function() {},
		success : function(data) {
			$("#"+divId).html(data);
		},
		error : function(e) {
			console.log("ERROR: ", e);
			display(e);
		},
		done : function(e) {
			console.log("DONE");
			//enableSearchButton(true);
		}
	});

}


</script>