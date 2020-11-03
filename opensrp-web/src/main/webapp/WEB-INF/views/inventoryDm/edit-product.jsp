<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="java.util.List"%>
<%@page import="org.opensrp.core.entity.Role"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>

<title>Edit Product</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Edit Product</div>


			</div>
			
			<div class="portlet-body">
			<div><h3 class="text-red text-center" id="serverResponseMessage"></h3></div>
				<div class="card-body">
					<div id="loading"
						style="display: none;position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>

				</div>
				<form id = "addProduct">
					<div class="form-group row">
						<label for="productName" class="col-sm-3 col-form-label"><spring:message code="lbl.productName"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="productName" name ="productName"
								placeholder="Product Name" value="${product.getName() }" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="description" class="col-sm-3 col-form-label"><spring:message code="lbl.description"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="description" name ="productDescription"
								placeholder="Description" value="${product.getDescription() }">
						</div>
					</div>
					<div class="form-group row">
						<label for="purchasePrice" class="col-sm-3 col-form-label"><spring:message code="lbl.purchasePrice"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="number" step="any" class="form-control" id="purchasePrice" name = "purchasePrice"
								placeholder="Purchase Price" value="${product.getPurchasePrice() }">
						</div>
					</div>
					<div class="form-group row">
						<label for="sellingPrice" class="col-sm-3 col-form-label"><spring:message code="lbl.sellingPrice"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="number" step="any" class="form-control" id="sellingPrice" name ="sellingPrice"
								placeholder="Selling Price" value="${product.getSellingPrice() }" required >
						</div>
					</div>
					<div class="form-group row">
						<label  class="col-sm-3 col-form-label"><spring:message code="lbl.seller"></spring:message><span class="text-danger">*</span> :</label>
						
						<div class="col-sm-6">
						<%
						List<Role> roles = (List<Role>) session.getAttribute("roles");
						int[] selectedRoles = (int[]) session.getAttribute("selectRoles");
						for (Role role : roles) {
						%>
							
								<div class="form-check">
									<% if(CheckboxHelperUtil.checkCheckedBox(
										selectedRoles, role.getId()).equalsIgnoreCase("checked")){ %>
									<input class="form-check-input" name="sellerName" type="checkbox" value="<%=role.getId()%>" 
									checked  id="skcheckbox1"> 
									<label class="form-check-label" for="skcheckbox1"><%=role.getName()%></label>
									<% } else { %>
									<input class="form-check-input" name="sellerName" type="checkbox" value="<%=role.getId()%>" 
									  id="skcheckbox1"> 
									<label class="form-check-label" for="skcheckbox1"><%=role.getName()%></label>
									<% } %>
								
								</div>
							
						<% } %>
							<p><span class="text-danger" id="checkBoxSelection"></span></p>
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
							<button type="submit" onclick="return Validate()" class="btn btn-primary">Submit</button>
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
});

$("#addProduct").submit(function(event) { 
	
	$("#loading").show();
	var url = "/opensrp-dashboard/rest/api/v1/product/save-update";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var sellTo = [];
	$("input:checkbox[name=sellerName]:checked").each(function(){
	    sellTo.push(+$(this).val());
	});
	var formData;
	
		formData = {
	            'name': $('input[name=productName]').val(),
	            'description': $('input[name=productDescription]').val(),
	            'id': '${product.id}',
	            'purchasePrice': +$('input[name=purchasePrice]').val(),
	            'sellingPrice': +$('input[name=sellingPrice]').val(),
	            'sellTo': sellTo,
	            'status': "ACTIVE",
	            'type': "PRODUCT"
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
			debugger;
		   var response = JSON.parse(data);
		   $("#loading").hide();
		   $("#serverResponseMessage").show();
		   $("#serverResponseMessage").html(response.msg);

		   if(response.status == "SUCCESS"){
           	setTimeout(function(){
           			window.location.replace("/opensrp-dashboard/inventorydm/products-list.html");
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

	if($('input[type=checkbox]:checked').length == 0)
	{
	   	 $("#checkBoxSelection").html("<strong>Please fill out this field</strong>");
	     return false;
	}
	
	$("#checkBoxSelection").html("");
}

</script>



















