<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.LocationTag"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<title>Upload location</title>
<jsp:include page="/WEB-INF/views/header.jsp" />

    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    
<c:url var="saveUrl" value="/location/upload_csv.html" />
<c:url var="cancelUrl" value="/location/location.html" />


<div class="page-content-wrapper">
		<div class="page-content">
			
			
			<%-- <ul class="page-breadcrumb breadcrumb">
				<li>
					<a href="<c:url value="/"/>">Home</a>
					
				</li>
			
			</ul> --%>
			<!-- END PAGE BREADCRUMB -->
			<!-- END PAGE HEADER-->
			<!-- BEGIN PAGE CONTENT-->
			
	
			<div class="row">
				<div class="col-md-12">
					
					<!-- BEGIN EXAMPLE TABLE PORTLET-->
					<div class="portlet box blue-madison">
						<div class="portlet-title">
							<div class="caption">
								<i class="fa fa-edit"></i>Upload location
							</div>
							
							
						</div>
						
						<div class="portlet-body">
							<form:form method="POST" action="${saveUrl}?${_csrf.parameterName}=${_csrf.token}" modelAttribute="location" enctype="multipart/form-data">
								<div class="form-group">
									<div class="row">
										<div class="col-lg-6 form-group">
											<label class="control-label">File<span class="required">* </span>	</label>
											<input id="file" type="file" name="file" />
										</div>
									</div>
									<span class="text-red">${msg}</span>
								</div>
								
								<hr class="dotted">  
								<div class="form-group text-right">
					                <button type="submit" id="submit-form"  class="btn btn-primary" name="signup" value="Validate">Submit</button>                
					                <a class="btn btn-info" href="${cancelUrl}">Cancel</a>
					            </div>
							</form:form>
							
							
							
							
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
<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
});
</script>



