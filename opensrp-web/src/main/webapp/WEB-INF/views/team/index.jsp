<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
	
<%@page import="org.opensrp.acl.entity.Team"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<title>Team List</title>

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<%
Map<String, String> paginationAtributes = (Map<String, String>) session
.getAttribute("paginationAtributes");
String name = "";
if (paginationAtributes.containsKey("name")) {
	name = paginationAtributes.get("name");
}
%>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<!-- Example DataTables Card-->
		<div class="form-group">				
			<jsp:include page="/WEB-INF/views/team/team-member-link.jsp" />		
		</div>
		<div class="form-group">
			<h5>Team Management</h5>
			<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_TEAM")){ %>			
			<a  href="<c:url value="/team/add.html"/>"> <strong>Add New Team</strong></a> <%} %>
		</div>
		<div class="card mb-3">
				
				<div class="card-body">
					<form id="search-form">
						<div class="row">
							<div class="col-3">					
							<input name="name" type="search" class="form-control"
							value="<%=name%>" placeholder="">					
							</div>
							<div class="col-6">
								<button name="search" type="submit" id="bth-search"
									class="btn btn-primary" value="search">Search</button>
							</div>
						</div>			
					</form>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
			<div class="card mb-3">
				<div class="card-header">
					 Team List
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th>Name</th>
									<th>Identifier</th>									
									<th>Location</th>
									<th>Current Supervisor</th>
									<th>Actions</th>
								</tr>
							</thead>
							
							<tbody>
							
							<%
								List<Team> teams = (List<Team>) session
														.getAttribute("dataList");
								String location = "";
								String superVisor = "";
							
								for (Team team : teams) 
									{
									pageContext.setAttribute("id", team.getId());
									
									
									if(team.getLocation() != null){
										location = team.getLocation().getName();
									}
									if(team.getSuperVisor()!= null){
										superVisor = team.getSuperVisor().getUsername();
									}
							%>
								
									<tr>
										<td><%=team.getName() %></td>										
										<td><%=team.getIdentifier() %></td>
										<td><%=location%></td>
										<td><%=superVisor%></td>
										<td>
										<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_TEAM")){ %>	
											<a href="<c:url value="/team/${id}/edit.html"/>">Edit</a> <%} %>
										</td>

									</tr>
									<%
									}
									%>
								
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

