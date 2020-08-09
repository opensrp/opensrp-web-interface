<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>New Invoice</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							<spring:message code="lbl.branch"/> - ${id}
						</div>


					</div>

				<div class="portlet-body">
				<div class="row">
					<div class="col-lg-3 form-group">
						<label for="invoiceNo">Invoice Number:</label> <input type="text"
							class="form-control" id="invoiceNo" readonly>
					</div>
					<div class="col-lg-3 form-group">
						<label for="receiveDate">Receive Date:</label> <input type="date"
							class="form-control" id="receiveDate">
					</div>
				</div>
				<div class="col-lg-12 form-group requisition-add">
					<a class="btn btn-primary" id="newInvoice"
						data-toggle="modal" data-target="#addProductToStock">
						<strong>Add Product </strong>
					</a>
				</div>
				<table class="table table-striped table-bordered" id="addProductTemporaryList">
							<thead>
								<tr>
									<th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<th><spring:message code="lbl.quantityInUnit"></spring:message></th>
									<th><spring:message code="lbl.expiryDate"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>

						</table>
						<div class="modal fade" id="addProductToStock" role="dialog">
							<div class="modal-dialog">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title"><strong>Add Product</strong></h4>
									</div>
									<div class="modal-body">
								<div class="form-group row">
									<label for="cars" class="col-sm-3 col-form-label">Select Product:</label>
									<div class="col-sm-6">
										<select class="form-control" name="cars" id="cars">
												<option value="volvo">Volvo</option>
												<option value="saab">Saab</option>
												<option value="mercedes">Mercedes</option>
												<option value="audi">Audi</option>
											</select>
									</div>
								</div>
								<div class="form-group row">
									<label for="currentStock" class="col-sm-3 col-form-label">Current Stock:</label>
									<div class="col-sm-6">
										<input type="text" class="form-control" id="currentStock"
											readonly>
									</div>
								</div>
								<div class="form-group row">
									<label for="quantityIn" class="col-sm-3 col-form-label">Quantity In(unit):</label>
									<div class="col-sm-6">
										<input type="number" class="form-control" id="quantityIn">
									</div>
								</div>
								<div class="form-group row">
									<label for="expiryDate" class="col-sm-3 col-form-label">Expiry Date:</label>
									<div class="col-sm-6">
										<input type="number" class="form-control" id="expiryDate">
									</div>
								</div>
									<div class="text-right">
										<button  type="submit" class="btn btn-primary" data-toggle="modal" data-target="#sellToManyProductSelectModal"
											>Confirm</button></div>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button>
									</div>
								</div>

							</div>
						</div>
					</div>
							</div>
				<div class="col-lg-12 form-group text-right">
	                <button type="submit" onclick="" class="btn btn-primary" value="confirm">Confirm All</button>
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
		$('#sample_1').DataTable();
});
</script>



















