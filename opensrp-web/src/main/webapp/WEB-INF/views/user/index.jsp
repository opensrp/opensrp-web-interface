<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="org.opensrp.core.entity.User"%>
<%@page import="org.opensrp.core.entity.Role"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>

<%

%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><spring:message code="lbl.userList"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
	<div class="container-fluid">

		<div class="form-group">
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
		</div>

		<div class="form-group">
			<h5><spring:message code="lbl.userList"/></h5>
			<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
			<a  href="<c:url value="/user/add.html?lang=${locale}"/>">
				<strong>
					<spring:message code="lbl.addNew"/>
					<spring:message code="lbl.user"/>
				</strong> </a> <%} %>
		</div>
		<jsp:include page="/WEB-INF/views/user/search.jsp" />

		<!-- Example DataTables Card-->
		<div class="card mb-3">
			<div class="card-header">
				<spring:message code="lbl.userList"/>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="display" id="userList">

					</table>
				</div>
			</div>
			<div class="card-footer small text-muted"></div>
		</div>
	</div>
	<!-- /.container-fluid-->
	<!-- /.content-wrapper-->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>
