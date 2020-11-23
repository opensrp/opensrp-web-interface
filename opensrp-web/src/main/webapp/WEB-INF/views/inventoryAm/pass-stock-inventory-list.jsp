<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Pass stock List</title>
	
	

<c:url var="pass_stock_list" value="/rest/api/v1/stock/pass-user-list" />
<c:url var="backUrl" value="/inventoryam/pass-stock.html" />
<c:url var="pass_stock_url" value="/inventoryam/individual-stock" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

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
						<div class="form-group">
							<div class="row">
							<!-- <div class="col-lg-1 form-group" style="margin-top: 5px;">
									<label for="designation">Designation:</label>
								</div> -->
								<div class="col-lg-3 form-group">
								<label class="control-label"><spring:message
												code="lbl.designation" /> </label> 
									<select class="form-control" id="roleId" name="roleId">
										<option value="0"><spring:message
												code="lbl.pleaseSelect" /></option>
										<c:forEach items="${roles}" var="role">
										<option value="${role.id}">${role.name}</option>
										</c:forEach>

										
									</select>
								</div>
								<div class="col-lg-4 form-group ">
									<label class="control-label">Name </label> 
								 	<input class="form-control" type="text" id="userName" placeholder="name"> 
								</div>
								<div class="col-lg-4" style="padding-top: 20px">
				
									<div  onclick="filter()"  class="btn btn-primary btn-lg">Search</div>
								</div>
								<%-- <div class="col-lg-3 form-group">
									<button type="submit" onclick="filter()"
										class="btn btn-primary">
										<spring:message code="lbl.viewStock" />
									</button>
								</div> --%>
							</div>
						</div>
						<table class="table table-striped table-bordered " id="passStockInventoryList">
							<thead>
								<tr>
									<th>Name</th>
									<th>Designation</th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
							
							
							
							</tbody>

						</table>
					<%-- 	<td><a class="btn btn-primary" id="passStock" href="<c:url value="/inventoryam/individual-stock/${id}/321.html?lang=${locale}"/>">
					<strong>
					Pass Stock
				</strong></a></td> --%>
					</div>
					
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
		//$('#passStockInventoryList').DataTable();
});
</script>

<script>

    let passStockList;
    $(document).ready(function() {
    	passStockInventoryList = $('#passStockInventoryList').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3], orderable: false },
                { width: "20%", targets: 0 },
                { width: "20%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "20%", targets: 3 }
            ],
            ajax: {
                url: "${pass_stock_list}",
                data: function(data){                	
                    data.branchId = ${id} ;
                    data.roleId =  0;
                    data.name='';
                    
                },
                dataSrc: function(json){
                    if(json.data){
                        return json.data;
                    }
                    else {
                        return [];
                    }
                },
                complete: function() {
                },
                type: 'GET'
            },
            bInfo: true,
            destroy: true,
            language: {
                searchPlaceholder: ""
            }
        });
    });

function filter(){
	let roleId = +$('#roleId').val();
	passStockInventoryList = $('#passStockInventoryList').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { targets: [0, 1, 2, 3], orderable: false },
             { width: "20%", targets: 0 },
             { width: "20%", targets: 1 },
             { width: "20%", targets: 2 },
             { width: "20%", targets: 3 }
         ],
         ajax: {
             url: "${pass_stock_list}",
             data: function(data){           	
     	      	data.search = $('#search').val();            	
	     	    data.branchId = ${id} ;
	            data.roleId =  roleId;
	            data.name=$('#userName').val();
             },
             dataSrc: function(json){
                 if(json.data){
                     return json.data;
                 }
                 else {
                     return [];
                 }
             },
             complete: function() {
             },
             type: 'GET'
         },
         bInfo: true,
         destroy: true,
         language: {
             searchPlaceholder: ""
         }
     });
}

function navigateToPassStock(skId) {
	var locale = "${locale}";
	var branchId= ${branchInfo[0][0]};
	//window.location.replace("/opensrp-dashboard/inventoryam/individual-stock/"+branchId+"/"+skId+".html?lang="+locale);
	window.location.assign("${pass_stock_url}/"+branchId+"/"+skId+".html?lang="+locale);
}
</script>

















