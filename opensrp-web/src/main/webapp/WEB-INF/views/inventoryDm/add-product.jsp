<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Add Product</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Add a Product</div>


			</div>

			<div class="portlet-body">
				<form>
					<div class="form-group row">
						<label for="productName" class="col-sm-3 col-form-label"><spring:message code="lbl.productName"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="productName"
								placeholder="Product Name" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="description" class="col-sm-3 col-form-label"><spring:message code="lbl.description"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="description"
								placeholder="Description">
						</div>
					</div>
					<div class="form-group row">
						<label for="purchasePrice" class="col-sm-3 col-form-label"><spring:message code="lbl.purchasePrice"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="purchasePrice"
								placeholder="Purchase Price">
						</div>
					</div>
					<div class="form-group row">
						<label for="sellingPrice" class="col-sm-3 col-form-label"><spring:message code="lbl.sellingPrice"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="sellingPrice"
								placeholder="Selling Price" required>
						</div>
					</div>
					<div class="form-group row">
						<label  class="col-sm-3 col-form-label"><spring:message code="lbl.seller"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" value="SK" id="skcheckbox1">
								<label class="form-check-label" for="skcheckbox1">
									SK </label>
									
							</div>
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="pkcheckbox1">
								<label class="form-check-label" for="pkcheckbox1">
									PK </label>
									
							</div>
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="pacheckbox1">
								<label class="form-check-label" for="pacheckbox1">
									PA </label>
									
							</div>
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="sscheckbox1">
								<label class="form-check-label" for="sscheckbox1">
									SS </label>
									
							</div>
						</div>
					</div>
					<div class="form-group row"></div>
					<div class="form-group row">
						<div class="col-sm-3"></div>
						<div class="col-sm-2">
							<a class="btn btn-danger" id="cancelProduct"
								href="<c:url value="/inventorydm/products-list.html?lang=${locale}"/>">
								<strong>Cancel</strong>
							</a>
						</div>
						<div class="col-sm-2">
							<button type="submit" class="btn btn-primary">Confirm</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		
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
		$('#sample_1').DataTable();
});
</script>



















