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
	Map<String, String> paginationAtributes = (Map<String, String>) session
			.getAttribute("paginationAtributes");
	String name = "";
	if (paginationAtributes.containsKey("name")) {
		name = paginationAtributes.get("name");
	}
%>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><spring:message code="lbl.userList"/></title>
	<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/role/add" />

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
		<div class="card mb-3">

			<div class="card-body">
				<form id="search-form">
					<div class="row">
						<div class="col-3">
							<input name="userName" type="search" class="form-control"
								   value="<%=name%>" placeholder="">
						</div>
						<div class="col-6">
							<button name="search" type="submit" id="bth-search"
									class="btn btn-primary" value="search"><spring:message code="lbl.search"/></button>
						</div>
					</div>
				</form>
			</div>
			<div class="card-footer small text-muted"></div>
		</div>
		<!-- Example DataTables Card-->
		<div class="card mb-3">
			<div class="card-header">
				<spring:message code="lbl.userList"/>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="table table-bordered" id="dataTable">
						<thead>
						<tr>
							<th><spring:message code="lbl.slNo"/></th>
							<th><spring:message code="lbl.fullName"/></th>
							<th><spring:message code="lbl.userName"/></th>
							<th><spring:message code="lbl.phoneNumber"/></th>
							<th><spring:message code="lbl.email"/></th>
							<th><spring:message code="lbl.role"/></th>
							<th><spring:message code="lbl.action"/></th>
						</tr>
						</thead>

						<tbody>
						<%
							List<User> users = (List<User>) session.getAttribute("dataList");

							int serialNumber =0;
							for (User user : users) {
								pageContext.setAttribute("id", user.getId());
						%>

						<tr>

							<td><%= ++serialNumber %></td>
							<td><%=user.getFullName() %></td>
							<td><%=user.getUsername()%></td>
							<td>
								<%if(user.getMobile()!=null && !user.getMobile().isEmpty()){ %>
								<%=user.getMobile() %>
								<%} %>
							</td>
							<td><%=user.getEmail()%></td>
							<td>
								<%
									for (Role role : user.getRoles()){  %>
								<b> <%=role.getName()%> </b>
								<% } %>
							</td>
							<td>
								<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
								<a href="<c:url value="/user/${id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> |  <%} %>
<%--								<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>--%>
<%--								<a href="<c:url value="/user/${id}/password.html?lang=${locale}"/>"><spring:message code="lbl.resetPassword"/></a> | <%} %>--%>
								<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
								<a href="<c:url value="/user/${id}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>
							</td>

						</tr>
						<%}%>
						</tbody>
					</table>
				</div>
			</div>
			<jsp:include page="/WEB-INF/views/pager.jsp" />
			<div class="card-footer small text-muted"></div>
		</div>
	</div>
	<!-- /.container-fluid-->
	<!-- /.content-wrapper-->
	<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>