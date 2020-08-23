<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Sell To SS</title>
	
	
<c:url var="sell_to_ss_list" value="/rest/api/v1/stock/sell_to_ss_list" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Sell To SS
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="designation">Sk :</label>
									<input type="text" class="form-control" id="designation">
								</div>
								<div class="col-lg-3 form-group">
									<label for="date">Date:</label>
									<input type="text"	readonly name="startYear" id="startYear" class="form-control date-picker-year" />
								</div>
     
							</div>
							<br/>
							<div class = "row">
							<div class="col-lg-8 form-group text-right">
										<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#sellToManyModal">Sell To Many</button>				
								</div>
								<div class="col-lg-2 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary"
										value="confirm">View SS List</button>
								</div></div>
						</div>
						<h3>Inventory : </h3>
						<div class="table-scrollable">
						
						<table class="table table-striped table-bordered " id="StockSellHistory">
							<thead>
								<tr>
								   <%--  <th><spring:message code="lbl.serialNo"></spring:message></th> --%>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.skname"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.saleinMonth"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
							
						</table>
						</div>
						<!-- Modal -->
						<div class="modal fade" id="sellToManyModal" role="dialog">
							<div class="modal-dialog modal-lg">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title"><strong>Sell To Many</strong></h4>
									</div>
									<div class="modal-body">
											<table class="table table-striped table-bordered "
												id="sellToManySSList">
												<thead>
													<tr>
														<th></th>
														<th><spring:message code="lbl.name"></spring:message></th>
														<th><spring:message code="lbl.designation"></spring:message></th>
														<th><spring:message code="lbl.skname"></spring:message></th>
														<th><spring:message code="lbl.branchNameCode"></spring:message></th>
													</tr>
												</thead>
												<tbody>
													<td><input type="checkbox" value=""></td>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tbody>
											</table>
										<div class="text-right">
										<button  type="submit" class="btn btn-primary" data-toggle="modal" data-target="#sellToManyProductSelectModal"
											>Proceed</button></div>
									</div>
									
									<div class="modal-footer">
										<button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button>
									</div>
								</div>

							</div>
						</div>
						
						
						<div class="modal fade" id="sellToManyProductSelectModal" role="dialog">
							<div class="modal-dialog modal-dialog-centered modal-lg">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title"><Strong>Select Product</Strong></h4>
									</div>
									<div class="modal-body">
										<table class="table table-striped table-bordered "
											id="sellToManySSProductList">
											<thead>
												<tr>
													<th><spring:message code="lbl.serialNo"></spring:message></th> 
													<th><spring:message code="lbl.name"></spring:message></th>
													<th><spring:message code="lbl.productUnitPrice"></spring:message></th>
													<th><spring:message code="lbl.perPersonProduct"></spring:message></th>
													<th><spring:message code="lbl.perPersonAmount"></spring:message></th>
													<th><spring:message code="lbl.ssSelectedNumber"></spring:message></th>
													<th><spring:message code="lbl.totaAmount"></spring:message></th>
												</tr>
											</thead>
											<tbody>
											<tr>
												<td></td>
												<td></td>
												<td></td>
												<td><input type ="number" name="productQuantity" id= "productQuantity" ></td>
												<td></td>
												<td></td>
												<td></td>
												</tr>
											</tbody>
										</table>
										<div class="text-right">
										<button  type="button" data-dismiss="modal" data-toggle="modal" data-target="#Second_modal" class="btn btn-danger"
											value="proceed">Back</button>
										<button  data-toggle="modal" data-target="#confirmSellModal" class="btn btn-primary"
											value="proceed">Sell</button></div>
									</div>
									
									<div class="modal-footer">
										<button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button>
									</div>
								</div>

							</div>
						</div>
						
						<div class="modal fade" id="confirmSellModal" role="dialog">
							<div class="modal-dialog">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title"><Strong>Sell Summary</Strong></h4>
									</div>
									<div class="modal-body">
										<p><strong>Number of SS Selected :</strong></p>
										<p><strong>Per Person Sales Amount :</strong></p>
										<p><strong>Total Sales Amount :</strong></p>
										<div class="text-right">
										<button  type="button" data-dismiss="modal" data-toggle="modal" data-target="#Second_modal" class="btn btn-danger"
											value="proceed">Back</button>
										<button  type="buttopn" onclick="" class="btn btn-primary"
											value="confirm">Confirm</button></div>
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
		//$('#StockSellHistory').DataTable();
		$('#sellToManySSList').DataTable();
		$('#sellToManySSProductList').DataTable();
});
jQuery(function() {
	jQuery('.date-picker-year').datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        maxDate: new Date,
        onClose: function(dateText, inst) { 
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
    });
	jQuery(".date-picker-year").focus(function () {
        $(".ui-datepicker-calendar").hide();
        $(".ui-datepicker-current").hide();
    });
});

</script>
<script>
    let stockList;
    $(document).ready(function() {
    	var today = new Date();    	
    	var currentMonth = today.getMonth() + 1; 
    	var currentYear = today.getFullYear();
    	
    	stockList = $('#StockSellHistory').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3, 4,5], orderable: false },
                { width: "20%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "20%", targets: 3 },
                { width: "5%", targets: 4 },
                { width: "30%", targets: 5 }
                
            ],
            ajax: {
                url: "${sell_to_ss_list}",
                data: function(data){
                	data.year = currentYear;
                    data.month =currentMonth;
                    data.branchId = ${id};
                    data.division=0;
                    data.district=0;
                    data.upazila=0;
                    data.skId=0;
                    
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
	
	var d = new Date($("#startYear").datepicker("getDate"));
	var date = d. getDate();
	var month = d. getMonth() + 1; 
	var year = d. getFullYear();
	
	stockList = $('#StockSellHistory').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { targets: [0, 1, 2, 3, 4,5], orderable: false },
             { width: "20%", targets: 0 },
             { width: "5%", targets: 1 },
             { width: "20%", targets: 2 },
             { width: "20%", targets: 3 },
             { width: "5%", targets: 4 },
             { width: "30%", targets: 5 }
         ],
         ajax: {
             url: "${sell_to_ss_list}",
             data: function(data){
            	
            	//let dateFieldvalue = $("#dateRange").val();            	
     	      	data.search = $('#search').val();            	
            	
            	
     	      	data.year = year;
                data.month =month;
                data.branchId =${id};
                data.division=0;
                data.district=0;
                data.upazila=0;
                data.skId=0;
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
</script>
















