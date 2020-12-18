<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url var="all_branch_url" value="/all-branch-list-options" />
<c:url var="branch_url" value="/branch-list-options-by-user-ids" />
<c:url var="user_list_url" value="/user-list-options-by-parent-user-ids" />
<c:choose>
	<c:when test="${roleName=='Admin' }">
<div class="col-lg-3 form-group">
	<label for="cars">Divisional manager </label> <select
		onclick="getAm(this.value,'AM')" name="divM" class="form-control"
		id="divM">
		<option value="0">Please select</option>
		<c:forEach items="${divms}" var="divm">
			<option value="${divm.getId()}">${divm.getFullName()}</option>
		</c:forEach>
	</select>
</div>

<div class="col-lg-3 form-group">
	<label for="cars">Area manager </label> <select
		onclick="getBranchListByUserId(this.value,'branchList')" name="AM"
		id="AM" class="form-control">
		<option value="0">Please select</option>
		<c:forEach items="${users}" var="user">
			<option value="${user.getId()}">${user.getFullName()}</option>
		</c:forEach>
	</select>
</div>
</c:when>
<c:when test="${roleName=='DivM' }">
<div class="col-lg-3 form-group">
	<label for="cars">Area manager </label> <select
		onclick="getBranchListByUserId(this.value,'branchList')" name="AM"
		id="AM" class="form-control">
		<option value="0">Please select</option>
		<c:forEach items="${users}" var="user">
			<option value="${user.getId()}">${user.getFullName()}</option>
		</c:forEach>
	</select>
</div>
</c:when>
<c:otherwise></c:otherwise>
</c:choose>

<div class="col-lg-3 form-group">
	<label for="cars"><spring:message code="lbl.branch"></spring:message></label>
	<select name="branchList" class="form-control" id="branchList">

		<c:forEach items="${branches}" var="branch">

			<option value="${branch.id}">${branch.name}</option>

		</c:forEach>
	</select>
</div>



<script>
	function getAm(userId, divId) {

		let
		url = '${user_list_url}';
		if (userId != 0) {
			getBranchListByUserId(userId, 'branchList');
			$.ajax({
				type : "GET",
				contentType : "application/json",
				url : url + "?id=" + userId + "&roleId=32",
				dataType : 'html',
				timeout : 300000,
				beforeSend : function() {
				},
				success : function(data) {
					$("#" + divId).html(data);
				},
				error : function(e) {
					console.log("ERROR: ", e);
					display(e);
				},
				done : function(e) {
					console.log("DONE");
				}
			});
		} else {
			getAllBranch();
			$("#AM").html('<option value="0">Please select </option>');
		}

	}
	function getBranchListByUserId(userId, divId) {
		if (userId != 0) {
			getBranchByuserIds(userId);
		} else {
			userId = $("#divM option:selected").val();
			if (userId != 0) {
				getBranchByuserIds(userId);
			} else {
				getAllBranch();
			}
		}
	}

	function getAllBranch() {
		let
		url = '${all_branch_url}';
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : url,
			dataType : 'html',
			timeout : 300000,
			beforeSend : function() {
			},
			success : function(data) {
				$("#branchList").html(data);
				$("#branchList > option").prop("selected", "selected");
				$("#branchList").trigger("change");
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

	function getBranchByuserIds(userId) {
		let
		url = '${branch_url}';
		$.ajax({
			type : "GET",
			contentType : "application/json",
			url : url + "?id=" + userId,

			dataType : 'html',
			timeout : 300000,
			beforeSend : function() {
			},
			success : function(data) {
				$("#branchList").html(data);
				$("#branchList > option").prop("selected", "selected");
				$("#branchList").trigger("change");
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