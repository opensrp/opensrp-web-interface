<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>My Inventory</title>
	
	

<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<style>

    /*for computers*/
    @media screen and (min-width: 992px) {
        .modal-margin {
            margin-top: 5%;
        }
    }
    /*for mobile devices*/
    @media screen and (max-width: 992px) {
        .modal-margin {
            margin-top: 40%;
        }
    }
</style>	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							${branchInfo[0][1]} - ${branchInfo[0][2]}
						</div>


					</div>
		
					<div class="portlet-body">
						<table class="table table-striped table-bordered" id="productStockListOfAm">
							<thead>
								<tr>
									<th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<th><spring:message code="lbl.currentStock"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="product" items="${ productList }">
									<tr>
										<td>${ product.id }</td>
										<td>${ product.name }</td>
										<td>${ product.stock }</td>
										<td><a class="btn btn-primary col-sm-5 form-group sm" href="javascript:;" onclick="openAdjustStockModal(${ product.id },${ product.stock },'${ product.name }')">Adjust Stock</a></td>
									</tr>
								</c:forEach>
							</tbody>
				</table>
					</div>
					</div>
					<div class="modal modal-margin" id="adjustStockModal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 55%;">

						<div class="row">
									<div class="modal-header" style="border-bottom: none;">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Adjust Stock</Strong>
										</h4>
									</div>
									<div style="display: none;" class="alert alert-success" id="serverResponseMessage" role="alert"></div>
								<div class="card-body">
									<div id="loading"
										style="display: none; position: absolute; z-index: 1000; margin-left: 40%">
										<img width="50px" height="50px"
											src="<c:url value="/resources/images/ajax-loading.gif"/>">
									</div>

								</div>
								<div class="modal-body">
									<div class="form-group row">
										<label for="trainingId" class="col-sm-4 col-form-label">Product Name :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="productName" name ="productName" readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingId" class="col-sm-4 col-form-label">Product ID :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="productId" name ="productId" readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingStartDate" class="col-sm-4 col-form-label"><spring:message code="lbl.date"></spring:message> :</label>
										<div class="col-sm-6">
											<input type="date" class="form-control" id="date" name = "date" required>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingId" class="col-sm-4 col-form-label">Current Stock :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="currentStock" name ="currentStock" readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingId" class="col-sm-4 col-form-label">Changed Stock :</label>
										<div class="col-sm-6">
											<input type="number" min="1" oninput="this.value = Math.abs(this.value)"  class="form-control" id="changedStock" name ="changedStock" >
											<span class="text-danger" id="numberValidation"></span>
										</div>
									</div>
									<div class="form-group row">
										<label for="diference" class="col-sm-4 col-form-label">Difference<span class="text-danger"> *</span> :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="diference" name ="diference" readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingDuration" class="col-sm-4 col-form-label">Reason<span class="text-danger"> *</span> :</label>
										<div class="col-sm-6">
											<select id="reason" class="form-control" name="reason" required >
												<option value=""><spring:message code="lbl.pleaseSelect" /></option>
												<option value="">Date Expired</option>
												<option value="">Order By Mistake</option>
											</select>
										</div>
									</div>
									<br>
										<div class="text-right">
											
											<button type="button" onclick="sellManyTOSSSubmit()" class="btn btn-primary"
												value="confirm">Confirm</button>
										</div>
									</div>
							<div class="footer text-right">
							<a href="#close-modal" class="btn btn-default" rel="modal:close" class="close-modal ">Close</a>
									</div>
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
		$('#productStockListOfAm').DataTable({
			  "pageLength": 25
		});
});

$('.modal-body').delegate('#changedStock', 'input propertychange', function (event) {
	var thisStock = +$(this).val();
	var currntStock = +$("#currentStock").val();
	if(thisStock > currntStock) {
		$("#numberValidation").html("Changed stock can not be grater than current stock");
		$("#diference").val('');
		return;
	}
	$("#numberValidation").html("");
	var Difference = currntStock - thisStock;
	$("#diference").val(Difference);
	
});

function openAdjustStockModal(id,currentStock,productName) {
	
	$("#productName").val(productName);
	$("#productId").val(id);
	$("#currentStock").val(currentStock);


	$('#adjustStockModal').modal({
        escapeClose: false,
        clickClose: false,
        closeExisting: false,
        showClose: false,        // Shows a (X) icon/link in the top-right corner
        show: true
	});
}



</script>



















