<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
	
<%@page import="org.opensrp.acl.entity.User"%>
<%@page import="org.opensrp.acl.entity.Role"%>
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
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>User List</title>

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/role/add" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
		
			<div class="form-group">				
					   <a  href="<c:url value="/user.html"/>"> <strong> Manage User</strong> 
						</a>  |   <a  href="<c:url value="/role.html"/>"> <strong>Manage Role</strong>
						</a>			
			</div>
			
			<div class="form-group">
				<h5>User Management</h5>
				<a  href="<c:url value="/user/add.html"/>"> <strong>Add User</strong>
						</a>
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
									class="btn btn-primary" value="search">Search</button>
							</div>
						</div>			
					</form>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
			<!-- Example DataTables Card-->
			<div class="card mb-3">
				<div class="card-header">
					 User List
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th>FullName</th>
									<th>User Name</th>
									<th>Email</th>
									<th>Role</th>
									<th>Actions</th>
								</tr>
							</thead>
							<tfoot>
								<tr>
									<th>FullName</th>
									<th>User Name</th>
									<th>Email</th>
									<th>Role</th>
									<th>Actions</th>
								</tr>
							</tfoot>
							<tbody>
							<%
								List<User> users = (List<User>) session
														.getAttribute("dataList");
								
								String creator = "";
								for (User user : users) 
									{
									pageContext.setAttribute("id", user.getId());
									
									if(user.getCreator()!= null){
										creator = user.getCreator().getUsername();
									}
							%>
								
									<tr>
										<td><a href="<c:url value="/user/${id}/edit.html"/>"><%=user.getFullName() %></a></td>
										<td><%=user.getUsername()%></td>
										<td><%=user.getEmail()%></td>
										<td>
										<% 
										for (Role role : user.getRoles()){  %>
										<b> <%=role.getName()%> </b>
										<% } %> 
										</td>
										<td><a href="<c:url value="/user/${id}/edit.html"/>">Edit</a>
											| <a href="<c:url value="/user/${id}/password.html"/>">Reset
												Pasword</a></td>

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