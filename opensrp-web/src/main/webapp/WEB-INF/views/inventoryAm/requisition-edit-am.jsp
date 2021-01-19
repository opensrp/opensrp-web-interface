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
	
	
<c:url var="backUrl" value="/inventoryam/requisition-list/${branchInfo[0][0]}.html" />
<c:url var="save_url" value="/rest/api/v1/requisition/save-update" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Requisition</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					/ Inventory  / Requisition list / <b>Edit Requisition </b> / 
				</li>
				<li>
					<a  href="${backUrl }">Back</a>
				</li>
		</ul>
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
									<th>Product Id</th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<th><spring:message code="lbl.currentStock"></spring:message></th>
									<th><spring:message code="lbl.requisitionAmount"></spring:message></th>
								</tr>
							</thead>
							<tbody>
							<c:forEach var="product" items="${ productList }">
									<tr>
										<td class="">${ product.id }</td>
										<td>${ product.name }</td>
										<td>${ product.stock }</td>
										<td>
										<c:choose>
											<c:when
													test="${requisitionDetails.has(product.id) ==true }">
													
													<input  class="allProduct" type="number"  min="1" value="${requisitionDetails.getString(product.id) }"  id="${ product.id }" name ="${ product.id }"><span class="text-danger" id="amountSelection"></span>
											</c:when>
											<c:otherwise>
											<input  class="allProduct" type="number"  min="1"   id="${ product.id }" name ="${ product.id }"><span class="text-danger" id="amountSelection"></span>
											</c:otherwise>
										</c:choose>
										
										</td>
									</tr>
							</c:forEach>
								</tbody>
						</table>
						<div class=row>
							<div class="col-md-12 form-group text-right">
						    		<div class="row">
								     	<div class="col-lg-12 ">
								     	 <a class="btn btn-primary" href="${backUrl}">Cancel</a>
											 <button  onclick="submitRequisition()" class="btn btn-primary" value="confirm">Confirm All</button>
										</div>
						            </div>
						      </div>
				
						</div>
					</div>
				</div>
				<!-- <div class="col-lg-12 form-group text-right">
				<button onclick="submitRequisition()" class="btn btn-primary" value="confirm">Confirm All</button>
			
	            </div> -->
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
  
		 var oTable = $('#requisitionAddList').DataTable({
			  "pageLength": 10
		});
		
		 
		

});

function getValue(id){
	
	
}

function inputValue(name){
	var oTable = $('#requisitionAddList').DataTable();
	 var values = oTable.$('input').serializeArray();
	
	 
	 for (var j = 0; j < values.length; j++){
		 var xName = values[j].name;
		    var val = values[j].value;		   
		    if(name ==xName){		    	
		    	return val;
		    }else {
		    	
		    }
	 }
	 
}
function mapRowData() {
	
	
	
	var requisitionDetails = [];
	var oTable = $('#requisitionAddList').DataTable();	
	 
	 var rowcollection =  oTable.$(".allProduct", {"page": "all"});
	 var form_data  = oTable.rows().data();
	 var f = form_data;
	 for(var i=0 ; f.length>i;i++){
		 var productObject = {}; 
		 var id =f[i][0];
		 productObject['productId'] = parseInt(f[i][0]);		 
		 productObject['currentStock'] = parseInt(f[i][2]);
		 console.log("ID:"+id);
		 console.log(inputValue(id));
		 productObject['qunatity'] =  inputValue(id);
		 if(parseInt(inputValue(id)) > 0) {
    		 requisitionDetails.push(productObject);
    	 }
	  
	 }
	
	
	
		  
	 
	 return requisitionDetails;
}
	
	  function submitRequisition() { 
			var requisionDetailsArray = mapRowData();
			console.log(requisionDetailsArray);
			if(requisionDetailsArray.length < 1) {
				 $("#amountSelection").html("<strong>* Atleast one field need to be selected</strong>");
				 $(window).scrollTop(0);
				 return;
			}
			 $("#loading").show();
			 $("#amountSelection").html("");
			var requisitionId = $("#branchCode").text().trim();
			var branchId = +$("#branchId").text();
			var url = '${save_url}';			
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			var formData;
				formData = {
			            'branchId': branchId,
			            'status': "ACTIVE",
			            'id': "${requisition.getId()}",
			            'requisitionId': requisitionId,
			            'requisitionDetails': requisionDetailsArray
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



















