<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Pass Stock Individual</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<c:url var="save_stock_pass_url" value="/rest/api/v1/stock/save-update" />
<c:url var="redirect_url" value="/inventoryam/pass-stock-inventory/${id }.html" />

	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<a  href="<c:url value="/"/>">Home</a>
					<i class="fa fa-arrow-right"></i>
				</li>
				<li>
					<a  href="${redirect_url }">Back</a>
				</li>
		</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
						${branchInfo[0][1]} - ${branchInfo[0][2]}
						</div>
					</div>					
					<div class="portlet-body">
					<div style="display: none;" class="alert alert-success" id="serverResponseMessage" role="alert"></div>
						<div class="card-body">
							<div id="loading"
								style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
								<img width="50px" height="50px"
									src="<c:url value="/resources/images/ajax-loading.gif"/>">
							</div>

						</div>
						<div class="form-group">
							<div class="row">
							<!-- <div class="col-lg-1 form-group" style="margin-top: 5px;">
									<label for="designation">Designation:</label>
								</div> -->
								<div class="col-lg-3 form-group">
									<label for="branch">Branch:</label> <input
										type="text" class="form-control" value="${branchInfo[0][1]}" id="branch" readonly>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="designation">Sk/PS:</label>
									<input type="text" class="form-control" value="${fullname}" id="designation" readonly>
								</div>
								<div class="col-lg-3 form-group">
								    <label class="control-label" for="designation">Challan Number <span class="required">* </span></label>
									<input type="text" name="challan" class="form-control"  id="challan"><p class="text-danger" id="challanNo"></p>
								</div>
							</div>
						</div>
						<h3>${fullname}'s Inventory : </h3>
						<table class="table table-striped table-bordered " id="passStockIndividualInventoryList">
							<thead>
								<tr>
									<th style="display: none"><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<th>${fullname}'s <spring:message code="lbl.currentStock"></spring:message></th>
									<th><spring:message code="lbl.availableProduct"></spring:message></th>
									<th><spring:message code="lbl.stockPass"></spring:message><span class="text-danger"> *</span><p style="display: none" class="text-danger" id="validationMessage"></p></th>
									
								</tr>
							</thead>
							<tbody>
							<c:forEach var="passStock" items="${ passIndividualStockList }">
									<tr>
										<td style="display: none">${ passStock.id }</td>
										<td>${ passStock.name }</td>
										<td>${ passStock.available }</td>
										<td>${ passStock.stock }</td>
										<td><input type="number" min="1" oninput="this.value = Math.abs(this.value)" id="passAmount" name ="passAmount"><p class="text-danger" id="amountSelection"></p><span class="text-danger" id="negativeValue"></span></td>
									</tr>
							</c:forEach>
								</tbody>
						</table>
						<div class=row>
							<div class="col-md-12 form-group text-right">
						    		<div class="row">
								     	<div class="col-lg-12 ">
								     	 <a class="btn btn-primary" href="${redirect_url}">Cancel</a>
											 <button  onclick="saveStockData()" class="btn btn-primary" value="confirm">Save All</button>
										</div>
						            </div>
						      </div>
				
						</div>
						<!-- <div class="text-center">
							<button type="submit" onclick="saveStockData()"
								class="btn btn-primary" value="confirm">Save All</button>
						</div> -->
					</div>
					
				</div>		
				<!-- <div class="col-lg-12 form-group text-right">
	                <button type="submit" onclick="saveStockData()" class="btn btn-primary" value="confirm">Save All</button>
	            </div>	 -->	
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
	var isVa
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();

	$('#passStockIndividualInventoryList').DataTable({
		  "pageLength": 25
	});
	});

/* $('.identifier').change(function() {
	var $row = $(this).closest("tr");
	var quantity = +$(this).val();
	if(quantity < 1) {
		$(this).val('');
		$row.find('span:first').html("<strong>* Quantity Can not be less than 1</strong>");
	}
	else $row.find('span:first').html("");
}); */

function createStockArray() {
	var stockArray = [];
	$('#passStockIndividualInventoryList  > tbody  > tr').each(function(index, tr) {
		var stockObject = {};
		var todayDate = new Date(), y = todayDate.getFullYear(), m = todayDate.getMonth();
		var invoiceNo = "";
		var recieveDate = "";
		var branchId = "${id}";
		var avilableStock = 0;
		//get td of each row and insert it into cols array
		$(this).find('td').each(function(colIndex, c) {

			if(colIndex == 0) {
				stockObject["productId"] = parseInt(c.textContent);
			}
			if(colIndex == 3) {
				avilableStock = parseInt(c.textContent);
			}
			if(colIndex == 4) {
    		 	if(parseInt($(this).find('input[type="number"]').val()) == 0) {
    		 		$(this).find('input[type="number"]').val('');
    		 	}
				stockObject["debit"] = parseInt($(this).find('input[type="number"]').val());;
			}

		});
		if(!isNaN(stockObject["debit"])) {
			if(stockObject["debit"] > avilableStock) {
				$("#validationMessage").show();
				$("#validationMessage").html("<strong>* Not enough stock available to pass.</strong>");
				stockArray = [];
				return false;
			}
		}

		stockObject["credit"] = 0;
		stockObject["year"] = todayDate.getFullYear();
		stockObject["month"] = todayDate.getMonth()+1;
		stockObject["branchId"] = ${id};
		stockObject["status"] = "ACTIVE";
		stockObject["sellOrPassTo"] = 0;
		stockObject["referenceType"] = "PASS";
		stockObject["invoiceNumber"] = invoiceNo;
		stockObject["receiveDate"] = $.datepicker.formatDate('yy-mm-dd', new Date());
		stockObject["startDate"] = $.datepicker.formatDate('yy-mm-dd', new Date(y, m, 1));
		stockObject["expireyDate"] =  $.datepicker.formatDate('yy-mm-dd', new Date(y, m + 1, 0));

		//insert this cols(full rows data) array into stock array
		if(!isNaN(stockObject["debit"])) {
			stockArray.push(stockObject);
		 }
	});
	console.log(stockArray);
	return stockArray;
}

function saveStockData() {
	$("#amountSelection").html("");
	$("#validationMessage").hide();
	$("#validationMessage").html("");
	var stockListArray = createStockArray();
	var challanNumber = $("#challan").val();
	if (challanNumber =='') { 
		 $("#challanNo").html("<strong>* Required</strong>");
		 return false;
	}
	
	if(stockListArray.length < 1) {
		if ($('#validationMessage').is(':empty')) { 
			 $("#amountSelection").html("<strong>* Atleast one field need to be selected</strong>");
		}
		 $(window).scrollTop(0);
		 return;
	}
	$("#loading").show();
	$("#amountSelection").html("");
	$("#validationMessage").hide();
	$("#validationMessage").html("");
	
	
	var branchId = parseInt("${id}");
	var branchCode = "${branchInfo[0][2]}";
	var sellToId = parseInt("${skid}");
	var url ='${save_stock_pass_url}';			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var formData;
		formData = {
	            'id': 0,
	            'challan':challanNumber,
	            "sellTo":[sellToId],
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
	            		window.location.replace('${redirect_url}');
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



















