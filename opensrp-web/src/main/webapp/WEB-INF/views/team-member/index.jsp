<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
	
<%@page import="org.opensrp.core.entity.TeamMember"%>
<%@page import="org.opensrp.core.entity.Location"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>

<title><spring:message code="lbl.teamMemberList"/></title>

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
			
			<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_TEAM_MEMBER")){ %>
			<a  href="<c:url value="/team/teammember/add.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addNew"/></strong>	</a> <%} %>
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
									class="btn btn-primary" value="search"><spring:message code="lbl.search"/></button>
							</div>
						</div>			
					</form>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
			<div class="card mb-3">
				<div class="card-header">
					 <spring:message code="lbl.teamMemberList"/>
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th><spring:message code="lbl.name"/></th>
									<th><spring:message code="lbl.identifier"/></th>									
									<th><spring:message code="lbl.location"/></th>
									<th><spring:message code="lbl.team"/></th>
									<th><spring:message code="lbl.action"/></th>										
								</tr>
							</thead>
							
							<tbody>
							
							<%
								List<TeamMember> teamMembers = (List<TeamMember>) session
														.getAttribute("dataList");
								
								String team = "";
							
								for (TeamMember teamMember : teamMembers) 
									{
									pageContext.setAttribute("id", teamMember.getId());
									
									Set<Location> locations = teamMember.getLocations();
									String locationNames = "";
									if(locations.size()!=0){
										for (Location location : locations) {
											locationNames +=location.getName()+" <br /> ";
										}
										
									}
									if(teamMember.getTeam()!= null){
										team = teamMember.getTeam().getName();
									}
							%>
								
									<tr>
										<td><%=teamMember.getPerson().getUsername() %></td>
										<td><%=teamMember.getIdentifier() %></td>
										<td><%=locationNames%></td>
										<td><%=team%></td>
										<td>
										<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_TEAM_MEMBER")){ %>
											<a href="<c:url value="/team/teammember/${id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a>
										<%} %>	
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

