<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="_csrf" content="${_csrf.token}"/>
	<!-- default header name is X-CSRF-TOKEN -->
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title><spring:message code="lbl.editBranchTitle"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<%--<c:url var="saveUrl" value="/role/${id}/edit.html" />--%>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
	<div class="container-fluid">
		<div class="form-group">
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
		</div>
		<div class="card mb-3">
			<div class="card-header">
				<i class="fa fa-table"></i> <spring:message code="lbl.editBranchTitle"/>
			</div>
			<div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
				<img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
			</div>
			<div id="errorMessage" style="color: red; font-size: small; display: none; margin-left: 20px; margin-top: 5px;"></div>
			<div class="card-body">
				<form:form modelAttribute="branch" id="BranchInfo" class="form-inline">
					<form:input type="hidden" path="id" value="${branchDTO.id}"/>
					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="name"> <spring:message code="lbl.branchName"/> </label>
							<form:input value="${branchDTO.name}" path="name" class="form-control mx-sm-3"
										required="required" />
						</div>
					</div>
					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="code"> <spring:message code="lbl.branchCode"/> </label>
							<form:input value="${branchDTO.code}" path="code" class="form-control mx-sm-3"
										required="required" />
						</div>
					</div>
					<div class="row col-12 tag-height">
						<div class="form-group">
							<input type="submit" value="<spring:message code="lbl.saveChanges"/>" class="btn btn-primary btn-block btn-center" />
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	<!-- /.container-fluid-->
	<!-- /.content-wrapper-->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script>
	$("#BranchInfo").submit(function (event) {
		$("#loading").show();
		var url = "/opensrp-dashboard/rest/api/v1/branch/save";
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		var formData = {
			'id': $('input[name=id]').val(),
			'name': $('input[name=name]').val(),
			'code': $('input[name=code]').val()
		};

		event.preventDefault();
		console.log(formData);
		console.log("Header: ", header);
		console.log("Token: ", token);
		$.ajax({
			contentType : "application/json",
			type: "POST",
			url: url,
			data: JSON.stringify(formData),
			dataType : 'json',

			timeout : 100000,
			beforeSend: function(xhr) {
				xhr.setRequestHeader(header, token);
			},
			success : function(data) {
				if (data == "") {
					$('#loading').hide();
					window.location.replace("/opensrp-dashboard/branch-list.html");
				} else {
					$('#errorMessage').html(data);
					$('#errorMessage').show();
					$('#loading').hide();
				}
			},
			error : function(e) {
				$('#loading').hide();
				$('#errorMessage').html(data);
				$('#errorMessage').show();
			},
			complete : function(e) {
				$("#loading").hide();
				console.log("DONE");
			}
		});
	});
</script>
</body>
</html>