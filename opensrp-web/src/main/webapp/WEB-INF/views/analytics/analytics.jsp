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

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><spring:message code="lbl.viewRefresh"/></title>
<link type="text/css"
	href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>" rel="stylesheet">
<jsp:include page="/WEB-INF/views/header.jsp" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">
				   <jsp:include page="/WEB-INF/views/report/report-link.jsp" />

			</div>
		    <div class="card mb-3">
		    	<center>
				<form id="search-form">
					<button name="search" type="submit" id="bth-search"
							class="btn btn-primary" value="search"><spring:message code="lbl.viewRefresh"/></button>
				</form>
				</center>
			</div>

			<div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
							<img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>"></div>

			</div>
			<div id="message"> </div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />

		<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>


		<script src="<c:url value='/resources/js/datepicker.js'/>"></script>

		<script type="text/javascript">


		$("#search-form").submit(function(event) {
			$("#loading").show();

			 $("#message").html("");
			event.preventDefault();
			$.ajax({
				type : "GET",
				contentType : "application/json",
				url : "/opensrp-dashboard/analytics/analytics-ajax.html",
				dataType : 'html',
				timeout : 100000,
				beforeSend: function() {


				},
				success : function(data) {
					$("#loading").hide();
				   $("#message").html(data);
				},
				error : function(e) {
				    console.log("ERROR: ", e);
				    display(e);
				},
				done : function(e) {
				    console.log("DONE");
				}
			});
		});

		</script>
	</div>
</body>
</html>