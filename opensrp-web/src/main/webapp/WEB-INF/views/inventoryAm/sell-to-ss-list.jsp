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
									<button type="submit" onclick="" class="btn btn-primary"
										value="confirm">View SS List</button>
								</div></div>
						</div>
						
						<div style="overflow-x: auto">
						<h3>Inventory : </h3>
						<table class="table table-striped table-bordered " id="passStockInventoryList">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.skname"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.saleinMonth"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
							<tbody>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td><a class="btn btn-primary" id="addRequisition" href="<c:url value="/inventoryam/individual-ss-sell/${id}/6540.html?lang=${locale}"/>">
					<strong>
					Sell Products
				</strong></a></td>
							</tbody>
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
										<div style="overflow-x:auto">
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
										</div>
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
									<div style="overflow-x:auto">
										<table class="table table-striped table-bordered "
											id="sellToManySSList">
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
										</div>
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
		$('#sample_1').DataTable();
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



















