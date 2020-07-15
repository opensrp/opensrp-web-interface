<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="org.opensrp.core.entity.Permission"%>
<title>Edit role</title>
<jsp:include page="/WEB-INF/views/header.jsp" />

    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    

<c:url var="cancelUrl" value="/role.html" />
<c:url var="saveUrl" value="/role/${id}/edit.html" />








<div class="page-content-wrapper">
		<div class="page-content">
			
			
			<ul class="page-breadcrumb breadcrumb">
				<li>
					<a href="<c:url value="/"/>">Home</a>
					<i class="fa fa-circle"></i>
				</li>
				<li>
					<a href="<c:url value="/role.html"/>">Role list</a>
					<i class="fa fa-circle"></i>
				</li>
			
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
								<i class="fa fa-edit"></i>Update Role
							</div>
							
							
						</div>
						
						<div class="portlet-body">
							<form:form method="POST" action="${saveUrl}" modelAttribute="role">
								<div class="form-group">
									<div class="row">
										<div class="col-lg-6 form-group">
											<label class="control-label"><spring:message code="lbl.name"/><span class="required">* </span>	</label>
											<form:input path="name" readonly="true" id="roleName" class="form-control"
												required="required" />
										</div>
									</div>
								</div>
								<div class="form-group">
									<div class="form-check">
										<div class="row">
											<%
											List<Permission> permissions = (List<Permission>) session
											.getAttribute("permissions");
									int[] selectedPermissions = (int[]) session
											.getAttribute("selectedPermissions");
									for (Permission permission : permissions) {
											%>
											<div class="col-lg-3 form-group">
												<form:checkbox class="checkBoxClass form-check-input"
											path="permissions" value="<%=permission.getId()%>"
											checked="<%=CheckboxHelperUtil.checkCheckedBox(
							selectedPermissions, permission.getId())%>" />
												<label class="form-check-label" for="defaultCheck1"> <%=permission.getName()%>
												</label>
											</div>
											<%
												}
											%>
										</div>
										<form:hidden path="id" />
									</div>
									<%-- <div class="row">
										<div class="col-lg-3 form-group">
											<label class="form-check-label"> <spring:message code="lbl.checkAll"/> <input
												type="checkbox" id="ckbCheckAll" /></label>
											<p>${errorPermission}</p>
										</div>
									</div> --%>
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
<jsp:include page="/WEB-INF/views/footer.jsp" />


<script type="text/javascript">
jQuery(document).ready(function($) {
    $("#ckbCheckAll").click(function () {    	
        $(".checkBoxClass").prop('checked', $(this).prop('checked'));
    });
});
</script>
