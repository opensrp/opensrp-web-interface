<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Member details</title>



<c:url var="get_url" value="/rest/api/v1/people/household/list" />



<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<c:url var="get_member_url" value="/rest/api/v1/people/member/list" />

       
<jsp:include page="/WEB-INF/views/modal_content.jsp" />

<div class="page-content-wrapper">
	<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
			<li><a href="<c:url value="/"/>">Home</a> <i
				class="fa fa-circle"></i></li>
			<li><a href="<c:url value="/people/members.html"/>">Back</a>

			</li>

		</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Member details
						</div>
					</div>
					<div class="portlet-body">
						
						
						<div class="tabbable tabbable-custom tabbable-noborder">
						
						<div class="col-md-12 form-group">
							<div class="row">
								<h4><strong>Member ID</strong>: ${rawData.getString("member_id")}, <strong>Name:</strong> ${rawData.getString("first_name")},
								 <strong>Age</strong>: ${rawData.getString("member_age")},<strong>Gender</strong>: ${rawData.getString("gender")} </h4>
								
							</div>
							
						</div>
							<ul class="nav nav-tabs">

								<li data-target="#member_info" role="tab" data-toggle="tab"
									class="active btn btn-success btn-sm">Member information</li>

								<li data-target="#reg_visit" role="tab" data-toggle="tab"
									class="btn btn-success btn-sm">Service information</li>
							</ul>
							<div class="tab-content">
								<div class="tab-pane active" id="member_info">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">
													<jsp:include page="/WEB-INF/views/dynamic_content.jsp" />

												</div>
											</div>
										</div>
									</div>
								</div>


								<div class="tab-pane" id="reg_visit">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">

													<jsp:include page="/WEB-INF/views/service_list.jsp" />
												</div>
											</div>
										</div>
									</div>
								</div>







							</div>
						</div>

					</div>

				</div>

			</div>
		</div>
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</div>
<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script
	src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		
});




</script>


