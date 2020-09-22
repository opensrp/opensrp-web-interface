<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>


<title>Adjust History Details</title>
	
	
<jsp:include page="/WEB-INF/views/header.jsp" />
<link type="text/css" href="<c:url value="/resources/css/jquery.simple-dtpicker.css"/>" rel="stylesheet">



<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Stock Adjust Details - ${stockAdjustObj.getBranchName() }</div>


			</div>
			
			<div class="portlet-body">
				<div class="form-group row">
						<label for="trainingTitle" class="col-sm-2 col-form-label">Adjustment Date:</label>
						<div class="col-sm-3">
						<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getAdjustDate()}</label>
							
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingTitle" class="col-sm-2 col-form-label">Product Name:</label>
						<div class="col-sm-6">
						<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getProductName()}</label>
							
						</div>
					</div> 
					<div class="form-group row">
						<label for="trainingStartDate" class="col-sm-2 col-form-label">Product Id :</label>
						<div class="col-sm-6">
							<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getProductId()}</label>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingStartDate" class="col-sm-2 col-form-label">Branch Name :</label>
						<div class="col-sm-6">
							<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getBranchName()}</label>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingDuration" class="col-sm-2 col-form-label">Previous Stock :</label>
						<div class="col-sm-6">
							<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getCurrentStock()}</label>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingDuration" class="col-sm-2 col-form-label">Adjustment :</label>
						<div class="col-sm-6">
							<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getChangedStock()}</label>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingDuration" class="col-sm-2 col-form-label">After adjustment :</label>
						<div class="col-sm-6">
							<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getCurrentStock()-stockAdjustObj.getChangedStock()}</label>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingDuration" class="col-sm-2 col-form-label">Reason</label>
						<div class="col-sm-6">
							<label for="trainingTitle" class=" col-form-label">${stockAdjustObj.getAdjustReason()} </label>
						</div>
					</div>
					
					
			</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<%-- <jsp:include page="/WEB-INF/views/dataTablejs.jsp" />
 --%>
<script src="<c:url value='/resources/js/jquery.simple-dtpicker.js' />"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
  
});

</script>




















