<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Training title list</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Training title</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					/ Training / <b> Training title list</b>  
				</li>
				
				
			
			</ul>
		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Training title list</div>


			</div>

			<div class="portlet-body">
				<div class="col-lg-12 form-group requisition-add">
					<a class="btn btn-primary pull-right" id="addRequisition"
						href="<c:url value="/training/add-training-title.html?lang=${locale}"/>">
						<strong> Add training title </strong>
					</a>
				</div>
					<table class="table table-striped table-bordered" id="productListDm">
						<thead>
							<tr>								
								<th>Training title</th>								
								<th>Action</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="title" items="${ titles }">
									<tr>
										<td>${ title.getTitle() }</td>
										
										<td><a href="<c:url value="/training/${title.id}/edit-training-title.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a></td>
									</tr>
								</c:forEach>
						</tbody>
					</table>
			</div>
		</div>
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		$('#productListDm').DataTable({
			  "pageLength": 25
		});
});
</script>



















