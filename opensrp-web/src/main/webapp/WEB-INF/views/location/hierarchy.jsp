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
<link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
<title><spring:message code="lbl.viewLocationsHierarchy"/> </title>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<% 
JSONArray locatationTreeData = (JSONArray)session.getAttribute("locatationTreeData");	
%>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<!-- Example DataTables Card-->
		<div class="form-group">				
			<jsp:include page="/WEB-INF/views/location/location-tag-link.jsp" />
		</div>
		
			<div class="card mb-3">
				<div class="card-header">
					<spring:message code="lbl.viewLocationsHierarchy"/> 
				</div>
				<div class="card-body">
					<div id="locationTreee">
  
					</div>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
 	<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
    
</body>

<script type="text/javascript">
$(document).ready(function () {

$('#locationTreee').jstree({ 'core' : {
    'data' : <%=locatationTreeData %>
} });

});
</script>
</html>

