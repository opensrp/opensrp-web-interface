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
	
<c:url var="backUrl" value="/inventoryam/myinventory.html" />
	

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
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<a  href="<c:url value="/"/>">Home</a>
					<i class="fa fa-arrow-right"></i>
				</li>
				<li>
					<a  href="${backUrl }">Back</a>
				</li>
		</ul>
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
										<td><div class="col-sm-12 form-group"><a class="text-primary" href="javascript:;" onclick="openAdjustStockModal(${ product.id },${ product.stock },'${ product.name }')"><strong>Adjust Stock</strong></a></div></td>
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
									<div id="loading" style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
										<img width="50px" height="50px"
											src="<c:url value="/resources/images/ajax-loading.gif"/>">
									</div>
									<div>
									<div style="display: none;" class="alert alert-success" id="serverResponseMessage" role="alert"></div>
								</div>
								<form id = "adjustStock">
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
											<input type="date" class="form-control" id="date" name = "date" required readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingId" class="col-sm-4 col-form-label">Current Stock :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="currentStock" name ="currentStock" readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingId" class="col-sm-4 col-form-label">Adjustment<span class="text-danger"> *</span> :</label>
										<div class="col-sm-6">
											<input type="number" min="1" oninput="this.value = Math.abs(this.value)"  class="form-control" id="changedStock" name ="changedStock" required>
											<span class="text-danger" id="numberValidation"></span>
										</div>
									</div>
									<div class="form-group row">
										<label for="diference" class="col-sm-4 col-form-label">Stock after Adjustment :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="diference" name ="diference" readonly>
										</div>
									</div>
									<div class="form-group row">
										<label for="trainingDuration" class="col-sm-4 col-form-label">Reason<span class="text-danger"> *</span> :</label>
										<div class="col-sm-6">
											<select id="reason" class="form-control" name="reason" required >
												<option value=""><spring:message code="lbl.pleaseSelect" /></option>
												<option value="Date Expired">Date Expired</option>
												<option value="Product Damaged">Product Damaged</option>
												<option value="Lost">Lost</option>
												<option value="Others">Others</option>
											</select>
										</div>
									</div>
									<div class="form-group row" id="othersDiv" style="display:none;">
										<label for="others" class="col-sm-4 col-form-label">Please Specify<span class="text-danger"> *</span> :</label>
										<div class="col-sm-6">
											<input type="text" class="form-control" id="others" name ="others">
											<span id="othervalidation" class="text-danger"></span>
										</div>
									</div>
									<br>
										<div class="text-right">
											<button type="submit" onclick="return Validate()" class="btn btn-primary">Confirm</button>
										</div>
										</form>
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
<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>
<script>
jQuery(document).ready(function() {       
	 	Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   		//TableAdvanced.init();
		//var todayDate = new Date(), y = todayDate.getFullYear(), m = todayDate.getMonth();
		var todayDate = $.datepicker.formatDate('yy-mm-dd', new Date());
		var table = $('#productStockListOfAm').DataTable({
			  "pageLength": 10,
			  scrollY:        "300px",
              scrollX:        true,
              scrollCollapse: true,
              fixedColumns:   {
                  leftColumns: 2/* ,
               rightColumns: 1 */
              }
			  
		});
		
		table.on( 'order.dt search.dt', function () {
	        table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
		$('#date').val(todayDate);
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
	$("#changedStock").val('');
	$('#diference').val('');
	$('#adjustStockModal').modal({
        escapeClose: false,
        clickClose: false,
        closeExisting: false,
        showClose: false,        // Shows a (X) icon/link in the top-right corner
        show: true
	});
}


$("#reason").change(function (event) {
	let reasonValue = $('#reason').val();
	if(reasonValue == "Others") {
		$('#othersDiv').show();
	}
	else {
		$('#othersDiv').hide();
	}

});


$("#adjustStock").submit(function(event) { 
	$("#loading").show();
	var url = "/opensrp-dashboard/rest/api/v1/stock/stock-adjust-save-update";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var todayDate = new Date();
	let reasonValue = "";
	if($('#reason').val() == "Others") {
		reasonValue = $('#others').val();
	}
	else {
		reasonValue = $('#reason').val();
	}
	var formData;
	
		formData = {
	            'productId': +$('input[name=productId]').val(),
	            'branchId': parseInt('${id}'),
	            'id': 0,
	            'adjustDate': $('input[name=date]').val(),
	            'currentStock': +$('input[name=currentStock]').val(),
	            'changedStock': +$('input[name=changedStock]').val(),
	            'adjustReason': reasonValue,
	            'month': todayDate.getMonth()+1,
	            'year': todayDate.getFullYear()
	        };
	console.log(formData)
	event.preventDefault();
	$.ajax({
		contentType : "application/json",
		type: "POST",
        url: url,
        data: JSON.stringify(formData), 
        dataType : 'json',
        
        timeout : 300000,
		beforeSend: function(xhr) {				    
			 xhr.setRequestHeader(header, token);
		},
		success : function(data) {
		   var response = JSON.parse(data);
		   $("#loading").hide();
		   $("#serverResponseMessage").show();
		   $("#serverResponseMessage").html(response.msg);

		   if(response.status == "SUCCESS"){
           	setTimeout(function(){
           			window.location.replace("/opensrp-dashboard/inventoryam/myinventory-list/${id}.html?lang=en");
                }, 1000);
		   }
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
});	

function Validate() {
	if($('#reason').val() == "Others") {
		var reasonValue = $('#others').val();
		if(reasonValue == "") {
		   	 $("#othervalidation").html("<strong>Please fill out this field</strong>");
		     return false;
		}
	}
	var currentStock = +$("#currentStock").val();
	var changedStock = +$("#changedStock").val();
	if(changedStock > currentStock) {
		$("#numberValidation").html("Changed stock can not be grater than current stock");
		return false;
	}
	$("#othervalidation").html("");
	$("#numberValidation").html("");
}

</script>



















