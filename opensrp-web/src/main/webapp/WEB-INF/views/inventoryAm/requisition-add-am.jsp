<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Add Requisition</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<%-- <div class="portlet-title">
						<div class="center-caption">
							<spring:message code="lbl.addRequisition"/>
						</div>


					</div> --%>
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							${branchInfo[0][1]} - <span id="branchCode">${branchInfo[0][2]} </span>
						</div>
						<p style="display: none;" id="branchId">${branchInfo[0][0]}</p>
						
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
				<table class="table table-striped table-bordered" id="requisitionAddList">
							<thead>
								<tr>
									<th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<th><spring:message code="lbl.currentStock"></spring:message></th>
									<th><spring:message code="lbl.requisitionAmount"></spring:message></th>
								</tr>
							</thead>
							<tbody>
							<c:forEach var="product" items="${ productList }">
									<tr>
										<td>${ product.id }</td>
										<td>${ product.name }</td>
										<td>${ product.stock }</td>
										<td><input type="number" min="1" id="requisitionAmount" name ="requisitionAmount"><span class="text-danger" id="amountSelection"></span></td>
									</tr>
								</c:forEach>
								</tbody>
						</table>
					</div>
							</div>
				<div class="col-lg-12 form-group text-right">
				<button onclick="submitRequisition()" class="btn btn-primary" value="confirm">Confirm All</button>
			
	            </div>
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
var requisitionTable;
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		requisitionTable = $('#requisitionAddList').DataTable({
			  "pageLength": 25
		});
});



function mapRowData() {
	var requisitionDetails = [];
	 /* var data = requisitionTable.row( element.parentNode ).data();
	 data.each(function (value, index) {
		 var productObject = {};
		 productObject["productId"] = parseInt(value[0]);
		 productObject["currentStock"] = parseInt(value[2]);

		 var quantity = requisitionTable.cell(index,3).nodes().to$().find('input').val();
		 var cell = requisitionTable.cell({ row: index, column: 3 }).node();
		 var vaueTest = $('input', cell).val()
		 productObject["qunatity"] = parseInt(quantity);
		 if(!isNaN(productObject["qunatity"])) {
			 requisitionDetails.push(productObject);
		 }
	 }); */
	 $('#requisitionAddList > tbody > tr').each(function (index, tr) {
		    
			var productObject = {};
		    //get td of each row and insert it into cols array
		    $(this).find('td').each(function (colIndex, row) {
		    	if(colIndex == 0) {
		    		productObject['productId'] = parseInt(row.textContent);
		    	}
		    	if(colIndex == 2) {
		    		productObject['currentStock'] = parseInt(row.textContent);
		    	}
		    	if(colIndex == 3) {
		    	 $(this).find('input').each(function() {
		    		     productObject['qunatity'] = parseInt($(this).val());
		    		   })
		    	}
		    });
		    if(!isNaN(productObject["qunatity"])) {
				 requisitionDetails.push(productObject);
			 }
		  }); 
		  
	 
	 return requisitionDetails;
}
	/* $('#requisitionAddList > tbody > tr').each(function (index, tr) {
	    
		var productObject = {};
	    //get td of each row and insert it into cols array
	    $(this).find('td').each(function (colIndex, row) {
	    	if(colIndex == 0) {
	    		productObject['productId'] = parseInt(row.textContent);
	    	}
	    	if(colIndex == 2) {
	    		productObject['currentStock'] = parseInt(row.textContent);
	    	}
	    	if(colIndex == 3) {
	    	 $(this).find('input').each(function() {
	    		     productObject['qunatity'] = +$(this).val();
	    		   })
	    	}
	    });
	    requisitionDetails.push(productObject);
	  });  */
	  
	  function submitRequisition() { 
			var requisionDetailsArray = mapRowData();
			if(requisionDetailsArray.length < 1) {
				 $("#amountSelection").html("<strong>* Atleast one field need to be selected</strong>");
				 $(window).scrollTop(0);
				 return;
			}
			 $("#loading").show();
			 $("#amountSelection").html("");
			var requisitionId = $("#branchCode").text().trim();
			var branchId = +$("#branchId").text();
			var url = "/opensrp-dashboard/rest/api/v1/requisition/save-update";			
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			var formData;
				formData = {
			            'branchId': branchId,
			            'status': "ACTIVE",
			            'id': 0,
			            'requisitionId': requisitionId,
			            'requisitionDetails': requisionDetailsArray
			        };
			console.log(formData)
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
				   $(window).scrollTop(0);
				   $("#serverResponseMessage").show();
				   $("#serverResponseMessage").html(response.msg);
				   
 				   if(response.status == "SUCCESS"){					   
					   window.location.replace("/opensrp-dashboard/inventoryam/requisition-list/"+branchId+".html");
					   
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



















