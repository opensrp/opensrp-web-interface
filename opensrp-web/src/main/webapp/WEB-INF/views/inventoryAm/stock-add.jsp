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
	
	
<c:url var="backUrl" value="/inventoryam/stock-list/${branchInfo[0][0]}.html" />
<c:url var="saveURL" value="/rest/api/v1/stock/save-update" />
<c:url var="productByIdURL" value="/inventoryam/product-by-id" />
<c:url var="redirectURL" value="/inventoryam/stock-list" />

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Stock In</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					/ Inventory  / Stock In list / <b>Add Stock In</b> / 
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
						<c:url var="branchIdHidden" value="${branchInfo[0][0]}" />
						<c:url var="branchCode" value="${branchInfo[0][2]}" />
					</div>

				<div class="portlet-body">
				<div style="display: none;" class="alert alert-success" id="serverResponseMessage" role="alert"></div>
					<p><span class="text-danger"> * Required Fields</span></p>
				<div class="row">
					<div class="col-lg-3 form-group">
						<label for="invoiceNo">Invoice Number:</label><span class="text-danger"> *</span> <input type="text"
							class="form-control" id="invoiceNo" >
							<span id="invoiceNoValidation" class="text-danger"></span>
					</div>
					<div class="col-lg-3 form-group">
						<label for="receiveDate">Receive Date:</label><span class="text-danger"> *</span>  <input type="text"
							class="form-control" readonly="readonly" onkeydown="return false" id="receiveDate">
							<span id="receiveDateValidation" class="text-danger"></span>
					</div>
				</div>
				
				<div class="col-lg-12 form-group">
					<a class="btn btn-primary pull-right add-record"  id="newInvoice"><i class="glyphicon glyphicon-plus"></i>
						<strong>Add Product </strong>
					</a>
				</div>
				<div id="loading"
						style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>
					<div>
					<p class="text-danger" id="validationMessage"><strong></strong></p>
				</div>
				<div class="table-scrollable">
				<table class="table table-striped table-bordered"
					id="addProductTemporaryList">
					<thead>
						<tr>
							<th><spring:message code="lbl.serialNo"></spring:message></th>
							<th><spring:message code="lbl.productName"></spring:message><span class="text-danger"> *</span></th>
							<th><spring:message code="lbl.currentStock"></spring:message></th>
							<th><spring:message code="lbl.quantityInUnit"></spring:message><span class="text-danger"> *</span></th>
							<th><spring:message code="lbl.expiryDate"></spring:message><span class="text-danger"> *</span></th>
							<th><spring:message code="lbl.actionRequisition"></spring:message></th>
						</tr>
					</thead>
					<tbody id="tbl_posts_body">
						<tr id="rec-1">
							<td><span class="sn">1</span>.</td>
							<td><select class="form-control"
									id="product" name="product">
										<option value="0"><spring:message
												code="lbl.selectProduct" /></option>
										<c:forEach items="${productList}" var="product">
											<option value="${product.id}">${product.name}</option>
										</c:forEach>


								</select></td>
							<td><input type="text" class=" currentStock form-control" id="currentStock" placeholder="Stock" readonly></td>
							<td><input type="number" class="form-control" min="1" oninput="this.value = Math.abs(this.value)" id="quantity" placeholder="Quantity"><p class="text-danger" id="amountSelection"></p></td>
							<td><input type="text" readonly="readonly" class="form-control jqdate"  id="expiryDate" onkeydown="return false" placeholder="Expiry Date"></td>
							<td></td>
						</tr>
					</tbody>
				</table>
				</div>
				<div style="display: none;">
					<table id="sample_table">
						<tr id="">
							<td><span class="sn"></span>.</td>
							<td><select class="form-control"
									id="product" name="product">
										<option value="0"><spring:message
												code="lbl.selectProduct" /></option>
										<c:forEach items="${productList}" var="product">
											<option value="${product.id}">${product.name}</option>
										</c:forEach>


								</select></td>
							<td><input type="text" class="form-control currentStock" id="currentStock" placeholder="Stock" readonly></td>
							<td><input type="number" class="form-control" min="1" oninput="this.value = Math.abs(this.value)" id="quantity" placeholder="Quantity"><p class="text-danger" id="amountSelection"></p></td>
							<td><input type="text"  class="form-control jqdate"  onkeydown="return false" placeholder="Expiry Date"></td>
							<td><a class="btn btn-xs delete-record" data-id="1"><i
									class="glyphicon glyphicon-trash"></i></a></td>
						</tr>
					</table>
					
				</div>
				
				<div class=row>
							<div class="col-md-12 form-group text-right">
						    		<div class="row">
								     	<div class="col-lg-12 ">
								     	 <a class="btn btn-primary" href="${backUrl}">Cancel</a>
											 <button  onclick="saveStockData()" class="btn btn-primary" value="confirm">Confirm All</button>
										</div>
						            </div>
						      </div>
				
						</div>
				<!-- <div class="text-center">
	                <button type="submit" onclick="saveStockData()" class="btn btn-primary" value="confirm">Confirm All</button>
	            </div> -->
				<!-- <div class="modal fade" id="addProductToStock" role="dialog">
							<div class="modal-dialog">

								Modal content
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
						</div> -->
					</div>
							</div>
				<!-- <div class="col-lg-12 form-group text-right">
	                <button type="submit" onclick="saveStockData()" class="btn btn-primary" value="confirm">Confirm All</button>
	            </div> -->
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
var dateToday = new Date();


$(document).on('focus','.jqdate', function(){    
    $(this).datepicker({
        dateFormat: 'yy-mm-dd',
        minDate: dateToday,
        changeYear: true 
    } );
 });


var dates = $("#receiveDate").datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: dateToday,
    changeYear: true 
   
});


var tableData = [];
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
	     jQuery(document).delegate('a.add-record', 'click', function(e) {
	         e.preventDefault();    
	         var content = jQuery('#sample_table tr'),
	         size = jQuery('#addProductTemporaryList >tbody >tr').length + 1,
	         element = null,    
	         element = content.clone();
	         element.attr('id', 'rec-'+size);
	         element.find('.delete-record').attr('data-id', size);
	         element.appendTo('#tbl_posts_body');
	         element.find('.sn').html(size);
	       });
	        jQuery(document).delegate('a.delete-record', 'click', function(e) {
	         e.preventDefault();    
	         var didConfirm = confirm("Are you sure You want to delete");
	         if (didConfirm == true) {
	          var id = jQuery(this).attr('data-id');
	          //var targetDiv = jQuery(this).attr('targetDiv');
	          jQuery('#rec-' + id).remove();
	          
	        //regnerate index number on table
	        $('#tbl_posts_body tr').each(function(index){
	    		$(this).find('span.sn').html(index+1);
	        });
	        return true;
	      } else {
	        return false;
	      }
	    });
});

/* $('#addProductTemporaryList').delegate('.identifier', 'change', function() {
	var $row = $(this).closest("tr");
	var quantity = +$(this).val();
	if(quantity < 1) {
		$(this).val('');
		$row.find("p:first").html("* Quantity Can not be less than 1");
	}
	else $row.find("p:first").html("");
});
 */

function createStockArray() {
	var stockArray = [];
	$('#addProductTemporaryList > tbody > tr').each(function(index, tr) {
		var stockObject = {};
		var todayDate = new Date(), y = todayDate.getFullYear(), m = todayDate.getMonth();
		var invoiceNo = $('#invoiceNo').val();
		var recieveDate = $('#receiveDate').val();
		var branchId = "${branchIdHidden}";
		//get td of each row and insert it into cols array
		$(this).find('td').each(function(colIndex, c) {

			if(colIndex == 1) {
				stockObject["productId"] = +$(this).find('option:selected').val();
			}
			if(colIndex == 2) {
				//stockObject["debit"] = +$(this).find('input[type="text"]').val();
			}
			
			if(colIndex == 3) {
    		 	if(parseInt($(this).find('input[type="number"]').val()) == 0) {
    		 		$(this).find('input[type="number"]').val('');
    		 	}
				stockObject["credit"] = parseInt($(this).find('input[type="number"]').val());
			}
			
			if(colIndex == 4) {
				stockObject["expireyDate"] = $(this).find('input[type="text"]').val();
			}

		});
 		if(stockObject["productId"] == 0 || isNaN(stockObject["credit"]) || stockObject["expireyDate"] == "") {
			$("#validationMessage").html("<strong>* Please fill out the required fields</strong>");
			stockArray = [];
			return false;
		}
		$("#validationMessage").html("");
		stockObject["year"] = todayDate.getFullYear();
		stockObject["month"] = todayDate.getMonth()+1;
		stockObject["branchId"] = parseInt(branchId);
		stockObject["status"] = "ACTIVE";
		stockObject["sellOrPassTo"] = 0;
		stockObject["referenceType"] = "STOCK";
		stockObject["invoiceNumber"] = invoiceNo;
		stockObject["receiveDate"] = recieveDate;
		stockObject["startDate"] = $.datepicker.formatDate('yy-mm-dd', new Date(y, m, 1));
		//insert this cols(full rows data) array into stock array
		if(!isNaN(stockObject["credit"])) {
			stockArray.push(stockObject);
		 }
	});
	return stockArray;
}

$('#addProductTemporaryList').delegate('select', 'change', function() {
	var productId = $(this).val();
	let branchId = "${branchIdHidden}";
	var inputContext = $(this).parents('td').next().find('input[type="text"]');
	var url = "${productByIdURL}/"+branchId+ "/" +productId;
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url,

		dataType : 'html',
		timeout : 300000,
		beforeSend: function() {},
		success : function(data) {
			inputContext.val(data);
		},
		error : function(e) {
			console.log("ERROR: ", e);
			display(e);
		},
		done : function(e) {

			console.log("DONE");
			//enableSearchButton(true);
		}
	});
	
	//$(this).parents('td').next().text(selectedText);
});
	
function saveStockData() {
	var invoiceNo = $('#invoiceNo').val();
	var recieveDate = $('#receiveDate').val();
	if(invoiceNo == "") {
		 $("#invoiceNoValidation").html("<strong>* Please fill out the required fields</strong>");
		 $(window).scrollTop(0);
		 return;
	}
	$("#invoiceNoValidation").html("");
	if(recieveDate == "") {
		 $("#receiveDateValidation").html("<strong>* Please fill out the required fields</strong>");
		 $(window).scrollTop(0);
		 return;
	}
	$("#invoiceNoValidation").html("");
	var stockListArray = createStockArray();
	if(stockListArray.length < 1) {
		 $("#validationMessage").html("<strong>* Please fill out the required fields</strong>");
		 $(window).scrollTop(0);
		 return;
	}
	 $("#loading").show();
	 $("#validationMessage").html("");
	var branchId = "${branchIdHidden}";
	var branchCode = "${branchCode}";
	var url = "${saveURL}";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var formData;
		formData = {
	            'id': 0,
	            "sellTo":[0],
	            "stockId":branchCode,
	            'stockDetailsDTOs': stockListArray
	        };
	console.log(formData)
	
	$(window).scrollTop(0);
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
	            		window.location.replace("${redirectURL}/"+branchId+".html");
		                 }, 1000);			   	   
		   }
		   
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
};	
</script>



















