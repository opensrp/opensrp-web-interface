<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>59-1"%>

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
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="_csrf" content="${_csrf.token}"/>
	<!-- default header name is X-CSRF-TOKEN -->
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<title><spring:message code="lbl.addBranchTitle"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
	<div class="container-fluid">
		<div class="form-group">
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
		</div>
		<div class="card mb-3">
			<div class="card-header">
				<i class="fa fa-table"></i> <spring:message code="lbl.addBranchTitle"/>
			</div>
			<div class="card-body">
				<form:form modelAttribute="branch" id="BranchInfo" class="form-inline" autocomplete="false">
					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="name"> <spring:message code="lbl.branchName"/> </label>
							<form:input path="name" class="form-control mx-sm-3"
										required="required" />
						</div>
					</div>
					<div class="row col-12 tag-height">
						<div class="form-group required">
							<label class="label-width" for="code"> <spring:message code="lbl.branchCode"/> </label>
							<form:input path="code" class="form-control mx-sm-3"
										required="required" />
						</div>
					</div>
					<div class="row col-12 tag-height">
						<div class="form-group">
							<input type="submit" value="<spring:message code="lbl.save"/>" class="btn btn-primary btn-block btn-center" />
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
				console.log(data);
				console.log("success!!!")
				window.location.replace("/opensrp-dashboard/branch-list.html");
			},
			error : function(e) {
				console.log(e);
			},
			done : function(e) {
				$("#loading").hide();
				console.log("DONE");
			}
		});
	});
</script>
</body>
</html>
