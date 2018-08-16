<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
	
<%@page import="org.opensrp.acl.entity.Location"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<title>Location List</title>

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
				   <a  href="<c:url value="/location/tag/list.html"/>"> <strong> Manage Tags</strong> 
					</a>  |  <a  href="<c:url value="/location/location.html"/>"> <strong>Manage Locations</strong>
					</a>|  <a  href="<c:url value="/location/hierarchy.html"/>"> <strong>View Hierarchy</strong>
					</a>		
		</div>
		<div class="form-group">
			<h1>Location Management</h1>
			<a  href="<c:url value="/location/add.html"/>"> <strong>Add New Location</strong>
					</a>
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
					<i class="fa fa-table"></i> Location List
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th>Name</th>
									<th>Description</th>									
									<th> Tag</th>									
									<th> Creator</th>
								</tr>
							</thead>
							<tfoot>
								<tr>
									<th>Name</th>
									<th>Description</th>									
									<th> Tag</th>
									
									<th> Creator</th>
								</tr>
							</tfoot>
							<tbody>
							
							<%
								List<Location> locations = (List<Location>) session
														.getAttribute("dataList");
								String tagName = "";
								String creator = "";
								for (Location location : locations) 
									{
									pageContext.setAttribute("id", location.getId());
									
									if(location.getLocationTag() != null){
										tagName = location.getLocationTag().getName();
									}
									
									if(location.getCreator()!= null){
										creator = location.getCreator().getUsername();
									}
							%>
								
									<tr>
										<td><a href="<c:url value="/location/${id}/edit.html"/>"><%=location.getName() %></a></td>
										
										<td><%=location.getDescription() %></td>
										<td><%=tagName%></td>
										
										<td><%=creator %></td>

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

