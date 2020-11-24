<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Individual Sell To SS</title>
	
	
<c:url var="backUrl" value="/inventoryam/sell-to-ss-list/${branchInfo[0][0]}.html" />
<c:url var="saveURL" value="/rest/api/v1/stock/save-update" />

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<a class="btn btn-primary" href="<c:url value="/"/>">Home</a>
					<i class="fa fa-arrow-right"></i>
				</li>
				<li>
					<a class="btn btn-primary" href="${backUrl }">Back</a>
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
										type="text" value="${branchInfo[0][1]}" class="form-control" id="branch" readonly>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="skName">Sk:</label>
									<input type="text" value="${skName}" class="form-control" id="skName" readonly>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="ssName">SS:</label>
									<input type="text" value="${ssName}" class="form-control" id="ssName" readonly>
								</div>
							</div>
						</div>
						<h3>Sell To ${ssName} </h3>
						<br>
						<table class="table table-striped table-bordered " id="individualSellListToSS">
							<thead>
								<tr>
									<th style="display: none"><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<%-- <th>${ssName}'s <spring:message code="lbl.currentStock"></spring:message></th> --%>
									<th><spring:message code="lbl.availableProduct"></spring:message></th>
									<th><spring:message code="lbl.sellProduct"></spring:message><span class="text-danger"> *</span><p style="display: none" class="text-danger" id="validationMessage"></p></th>
								</tr>
							</thead>
							<tbody>
							<c:forEach var="product" items="${ productList }">
									<tr>
										<td style="display: none">${ product.id }</td>
										<td>${ product.name }</td>
										<%-- <td>${ product.available }</td> --%>
										<td>${ product.stock }</td>
										<td><input type="number"  min="1" oninput="this.value = Math.abs(this.value)" id="sellAmount" name ="sellAmount"><p class="text-danger" id="sellAmountSelection"></p><span class="text-danger" id="negativeValue"></span></td>
									</tr>
								</c:forEach>
								</tbody>
						</table>
						
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
					</div>
					
				</div>		
				<!-- <div class="col-lg-12 form-group text-right">
	                <button type="submit" onclick="" class="btn btn-primary" value="confirm">Sell</button>
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
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		$('#individualSellListToSS').DataTable({
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
	$('#individualSellListToSS  > tbody  > tr').each(function(index, tr) {
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
			if(colIndex == 2) {
				avilableStock = parseInt(c.textContent);
			}
			if(colIndex == 3) {
    		 	if(parseInt($(this).find('input[type="number"]').val()) == 0) {
    		 		$(this).find('input[type="number"]').val('');
    		 	}
				stockObject["debit"] = parseInt($(this).find('input[type="number"]').val());;
			}

		});
		if(!isNaN(stockObject["debit"])) {
			if(stockObject["debit"] > avilableStock) {
				$("#validationMessage").show();
				$("#validationMessage").html("<strong>* Not enough stock available to sell.</strong>");
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
		stockObject["referenceType"] = "SELL";
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
	$("#sellAmountSelection").html("");
	$("#validationMessage").hide();
	$("#validationMessage").html("");
	var stockListArray = createStockArray();
	if(stockListArray.length < 1) {
		if ($('#validationMessage').is(':empty')) { 
			 $("#sellAmountSelection").html("<strong>* Atleast one field need to be selected</strong>");
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
	var sellToId = parseInt("${ssid}");
	var url = "${saveURL}";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var formData;
		formData = {
	            'id': 0,
	            "sellTo":[sellToId],
	            "stockId":branchCode,
	            'stockDetailsDTOs': stockListArray
	        };
	console.log(formData);
	$(window).scrollTop(0);
	event.preventDefault();
	$.ajax({
		contentType : "application/json",
		type: "POST",
        url: url,
        data: JSON.stringify(formData), 
        dataType : 'json',
        
		timeout : 100000,
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
	            		window.location.replace("${backUrl}");
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



















