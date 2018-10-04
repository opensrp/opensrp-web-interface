<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.loactionTagList"/></title>

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/role/add" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<!-- Example DataTables Card-->
			<div class="form-group">
			<jsp:include page="/WEB-INF/views/location/location-tag-link.jsp" />
				
			</div>
			<div class="form-group">
			<h5><spring:message code="lbl.loactionTagList"/></h5>
			<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_LOCATION_TAG")){ %>			
			<a  href="<c:url value="/location/tag/add.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addNew"/></strong> </a>
			<%} %>
			</div>
			<div class="card mb-3">
				<div class="card-header">
					<spring:message code="lbl.loactionTagList"/>
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th><spring:message code="lbl.name"/></th>
									<th><spring:message code="lbl.description"/></th>
									<th><spring:message code="lbl.createdDate"/></th>
									<th><spring:message code="lbl.action"/></th>
								</tr>
							</thead>
							
							<tbody>
								<c:forEach var="locationTag" items="${locationTags}" varStatus="loop">
									<tr>
										<td>${locationTag.getName()}</td>
										<td>${locationTag.getDescription()}</td>
										<td>${locationTag.getCreated()}</td>
										<td>
										<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_LOCATION_TAG")){ %>
											<a href="<c:url value="/location/tag/${locationTag.id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a>
										<%} %>
										</td>

									</tr>
								</c:forEach>
							</tbody>
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