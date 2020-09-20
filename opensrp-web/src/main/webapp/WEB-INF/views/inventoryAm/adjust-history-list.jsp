<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Adjust History</title>
	
	

<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />


<div class="page-content-wrapper">
		<div class="page-content">
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							Stock Adjust History
						</div>


					</div>
		
					<div class="portlet-body">
					<div class="row">
					<div class="col-lg-3 form-group">
								    <label for="from"><spring:message code="lbl.from"></spring:message><span class="text-danger">*</span> :</label>
									<input type="date" class="form-control" id="from">
									<span class="text-danger" id="startDateValidation"></span>
								</div> 
								<div class="col-lg-3 form-group">
									<label for="to"><spring:message code="lbl.to"></spring:message><span class="text-danger">*</span> :</label>
									<input type="date" class="form-control" id="to">
									<span class="text-danger" id="endDateValidation"></span>
								</div>
								<div class="col-lg-3 form-group">
								<label for="to"><spring:message code="lbl.branch"></spring:message> :</label>
								<select id=branchSelect class="form-control" name="branchSelect" required>
									<option value="0"><spring:message
											code="lbl.pleaseSelect" /></option>
									<c:forEach items="${branches}" var="branch">
										<option value="${branch.id}">${branch.name}</option>
									</c:forEach>
								</select>
								<p>
									<span class="text-danger" id="branchSelectionValidation"></span>
								</p>
							</div>
					</div>
					
						<table class="table table-striped table-bordered" id="adjustHistoryList">
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
		$('#adjustHistoryList').DataTable();
		$('#branchSelect').select2({dropdownAutoWidth : true});
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



















