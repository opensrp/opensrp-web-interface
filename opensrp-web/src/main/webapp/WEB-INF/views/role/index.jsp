<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Role list</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
			<!-- BEGIN SAMPLE PORTLET CONFIGURATION MODAL FORM-->
			<div class="modal fade" id="portlet-config" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
							<h4 class="modal-title">Modal title</h4>
						</div>
						<div class="modal-body">
							 Widget settings form goes here
						</div>
						<div class="modal-footer">
							<button type="button" class="btn blue">Save changes</button>
							<button type="button" class="btn default" data-dismiss="modal">Close</button>
						</div>
					</div>
					<!-- /.modal-content -->
				</div>
				<!-- /.modal-dialog -->
			</div>
			
			<ul class="page-breadcrumb breadcrumb text-right">
				<li>
					<%-- <a href="<c:url value="/user.html"/>">Home</a> --%>
					
				</li>
				<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_ROLE")){ %>
				<span id="actions" style="float: right;margin-bottom: 6px;">					
					<a class="btn btn-default" id="add" href="<c:url value="/role/add.html?lang=${locale}"/>">Add
					a new Role</a> 
					
				<%} %>
			</ul>
			<!-- END PAGE BREADCRUMB -->
			<!-- END PAGE HEADER-->
			<!-- BEGIN PAGE CONTENT-->
			
	
			<div class="row">
				<div class="col-md-12">
					
					<!-- BEGIN EXAMPLE TABLE PORTLET-->
					<div class="portlet box blue-madison">
						<div class="portlet-title">
							<div class="caption">
								<i class="fa fa-list"></i>Role list
							</div>
							
							
						</div>
						
						<div class="portlet-body">
							<table class="table table-striped table-bordered " id="sample_1">
							<!-- <table class="display" id="roleList" style="width:100%"> -->
									<thead>
										<tr>
											<th><spring:message code="lbl.name"/></th>
											<th><spring:message code="lbl.permissions"/></th>										
											<th><spring:message code="lbl.action"/></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="role" items="${roles}" varStatus="loop">
											<tr>
												<td>${role.getName()}</td>
												<td><c:forEach var="permission"
											   items="${role.getPermissions()}" varStatus="loop">
													<b> ${permission.getName()} , </b>
												</c:forEach></td>											
												<td>
													<% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_ROLE")){ %>
													<a href="<c:url value="/role/${role.id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> <%} %>
												</td>
				
											</tr>
										</c:forEach>
									</tbody>

								</table>
						</div>
					</div>
					
					
					
				</div>
			</div>
			<!-- END PAGE CONTENT-->
			<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
</div>
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		$('#sample_1').DataTable();
});
</script>



















