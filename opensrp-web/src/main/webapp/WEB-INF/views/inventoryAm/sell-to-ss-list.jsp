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
<c:url var="save_url" value="/rest/api/v1/stock/save-update" />
<c:url var="backUrl" value="/inventoryam/sell-to-ss.html" />
<c:url var="redirect_url" value="/inventoryam/sell-to-ss-list" />
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
						<div class="center-caption">${branchInfo[0][1]} -
							${branchInfo[0][2]}</div>
					</div>
					<div class="portlet-body">
						<div class="form-group">
							<div class="row">
								<div class="col-lg-3 form-group">
									<label for="designation">Sk :</label> 
									<select class="form-control"
										id="skList" name="skList">
										<option value="0"><spring:message
												code="lbl.selectSk" /></option>
										<c:forEach items="${skList}" var="sk">
										<option value="${sk.id}">${sk.name}</option>
										</c:forEach>

										
									</select>
								</div>
								<div class="col-lg-3 form-group">
									<label for="date">Date:</label> <input type="text" readonly
										name="startYear" id="startYear"
										class="form-control date-picker-year" />
								</div>

							</div>
							<br />
							<div class="row">
								<div class="col-lg-8 form-group text-right">
									<button type="button" onclick="sellToMany()"
										class="btn btn-primary">Sell To Many</button>
								</div>
								<div class="col-lg-2 form-group text-right">
									<button type="submit" onclick="filter()"
										class="btn btn-primary" value="confirm">View SS List</button>
								</div>
							</div>
						</div>
						<h3>Inventory :</h3>
						<table class="table table-striped table-bordered "
							id="StockSellHistory">
							<thead>
								<tr>
									<th><input type="checkbox" value=""></th>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.skname"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.saleinMonth"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>

						</table>
						<!-- Modal -->
						<div class="modal modal-margin" id="sellToManyModal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 70%;">

						<div class="row">
												<div class="modal-header" style="border-bottom: none;">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Sell To Many</Strong>
										</h4>
									</div>
							<div id="validationSelectOne" style="display: none" class="alert alert-danger text-center" role="alert">
											Please select one to proceed
										</div>
							<table class="table table-striped table-bordered record_table"
											id="sellToManySSList">
											<thead>
												<tr>
													<th><input type="checkbox" class="remove-checkbox" value="selectall"></th>
													<th><spring:message code="lbl.name"></spring:message></th>
													<th><spring:message code="lbl.designation"></spring:message></th>
													<th><spring:message code="lbl.skname"></spring:message></th>
													<th><spring:message code="lbl.branchNameCode"></spring:message></th>
													<th><spring:message code="lbl.saleinMonth"></spring:message></th>
													<th><spring:message code="lbl.actionRequisition"></spring:message></th>
												</tr>
											</thead>
										</table>
							<div class="text-center" id="proceedDiv">
								<button id="proceeddProductButton" type="button"
									class="btn btn-primary" onclick="proceedToChooseProduct()">Proceed</button>
							</div>
							<div class="footer text-right">
							<button id="closeselltomany" type="button"
									class="btn btn-default" onclick="closeModal()">Close</button>
							<!-- <a href="#" class="btn btn-default" onclick="closeModal()" class="close-modal ">Close</a> -->
									</div>
						</div>
						</div>
						<%-- <div class="modal" id="sellToManyModal" tabindex="-1" role="dialog" aria-labelledby="skListPage" aria-hidden="true">
							<div class="modal-dialog modal-lg" role="document">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">
											<strong>Sell To Many</strong>
										</h4>
									</div>
									<div class="modal-body">
										<div id="validationSelectOne" style="display: none" class="alert alert-danger text-center" role="alert">
											Please select one to proceed
										</div>
										<table class="table table-striped table-bordered record_table"
											id="sellToManySSList">
											<thead>
												<tr>
													<th><input type="checkbox" class="remove-checkbox" value="selectall"></th>
													<th><spring:message code="lbl.name"></spring:message></th>
													<th><spring:message code="lbl.designation"></spring:message></th>
													<th><spring:message code="lbl.skname"></spring:message></th>
													<th><spring:message code="lbl.branchNameCode"></spring:message></th>
													<th><spring:message code="lbl.saleinMonth"></spring:message></th>
													<th><spring:message code="lbl.actionRequisition"></spring:message></th>
												</tr>
											</thead>
										</table>
										<div class="text-center"  id = "proceedDiv">
											<button id="proceeddProductButton"
												type="button" class="btn btn-primary"
												onclick="proceedToChooseProduct()" >Proceed</button>
										</div>
									</div>

									<div class="modal-footer">
										<button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button>
									</div>
								</div>

							</div>
						</div> --%>
						<div class="modal modal-margin" id="sellToManyProductSelectModal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 75%;">

						<div class="row">
												<div class="modal-header" style="border-bottom: none;">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Select Product</Strong>
										</h4>
									</div>
									<div class="modal-body">
									<div id="validationOnSelectProduct" style="display: none"  class="alert alert-danger text-center" role="alert">
										</div>
										<table class="table table-striped table-bordered "
											id="sellToManySSProductList">
											<thead>
												<tr>
													<th style="display: none"><spring:message code="lbl.serialNo"></spring:message></th>
													<th><spring:message code="lbl.productName"></spring:message></th>
													<th><spring:message code="lbl.productUnitPrice"></spring:message></th>
													<%-- <th><spring:message code="lbl.currentStock"></spring:message></th> --%>
													<th>Available product</th>
													<th><spring:message code="lbl.perPersonProduct"></spring:message><span class="text-danger"> *</span><p style="display: none" class="text-danger" id="validationMessage"></p></th>
													<th><spring:message code="lbl.perPersonAmount"></spring:message></th>
													<th><spring:message code="lbl.ssSelectedNumber"></spring:message></th>
													<th><spring:message code="lbl.totaAmount"></spring:message></th>
												</tr>
											</thead>
											<c:forEach var="product" items="${ productList }">
												<tr>
													<td style="display: none">${ product.id }</td>
													<td>${ product.name }</td>
													<td>${ product.salesPrice }</td>
													<td>${ product.stock }</td>
													<td><input type="number" class="identifier" min="1" id="sellAmount"
														name="sellAmount"><span class="text-danger"
														id="sellAmountSelection"></span></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</c:forEach>
										</table>
										<div class="text-right">
											<a href="#close-modal" class="btn btn-danger" rel="modal:close" class="close-modal ">Back</a>
												<button id="sellNavigate"
												type="button" class="btn btn-primary"
												onclick="proceedToSellDetails()" >Sell</button>
												
										</div>
									</div>
							
							<div class="footer text-right">
							<a href="#close-modal" class="btn btn-default" rel="modal:close" class="close-modal ">Close</a>
									</div>
						</div>
						</div>
						
						<%-- <div class="modal " id="sellToManyProductSelectModal"
							 role="dialog" >
							<div class="modal-dialog  modal-lg">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Select Product</Strong>
										</h4>
										<input type="text">
									</div>
									<div class="modal-body">
										<table class="table table-striped table-bordered "
											id="sellToManySSProductList">
											<thead>
												<tr>
													<th style="display: none"><spring:message code="lbl.serialNo"></spring:message></th>
													<th><spring:message code="lbl.productName"></spring:message></th>
													<th><spring:message code="lbl.productUnitPrice"></spring:message></th>
													<th><spring:message code="lbl.currentStock"></spring:message></th>
													<th><spring:message code="lbl.perPersonProduct"></spring:message><span class="text-danger"> *</span><p style="display: none" class="text-danger" id="validationMessage"></p></th>
													<th><spring:message code="lbl.perPersonAmount"></spring:message></th>
													<th><spring:message code="lbl.ssSelectedNumber"></spring:message></th>
													<th><spring:message code="lbl.totaAmount"></spring:message></th>
												</tr>
											</thead>
											<c:forEach var="product" items="${ productList }">
												<tr>
													<td style="display: none">${ product.id }</td>
													<td>${ product.name }</td>
													<td>${ product.salesPrice }</td>
													<td>${ product.stock }</td>
													<td><input type="number" class="identifier" min="1" id="sellAmount"
														name="sellAmount"><span class="text-danger"
														id="sellAmountSelection"></span></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</c:forEach>
										</table>
										<div class="text-right">
											<a href="#close-modal" class="btn btn-danger" rel="modal:close" class="close-modal ">Back</a>
												<button id="sellNavigate"
												type="button" class="btn btn-primary"
												onclick="proceedToSellDetails()" >Sell</button>
												
										</div>
									</div>

									<div class="modal-footer">
									<a href="#close-modal" class="btn btn-primary" rel="modal:close" class="close-modal ">Close</a>
										<!-- <button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button> -->
									</div>
								</div>

							</div>
						</div> --%>
						<div class="modal modal-margin" id="confirmSellModal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 55%;">

						<div class="row">
									<div class="modal-header" style="border-bottom: none;">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Sell Summary</Strong>
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
										<p>
											<strong>Number of SS Selected : </strong><span style="font-weight: bold;font-size: medium;" id="numberOfSSSelected"></span>
										</p>
										<p>
											<strong>Per Person Sales Amount : </strong><span style="font-weight: bold;font-size: medium;" id="perPersonAmount"></span>
										</p>
										<p>
											<strong>Total Sales Amount : </strong><span style="font-weight: bold;font-size: medium;" id="totalSalesAmount"></span>
										</p>
										<div class="text-right">
											<a href="#close-modal" class="btn btn-danger" rel="modal:close" class="close-modal ">Back</a>
											<!-- <button type="button" onclick="goToSellProduct()" class="btn btn-danger"
												value="confirm">Back</button> -->
											<button type="button" onclick="sellManyTOSSSubmit()" class="btn btn-primary"
												value="confirm">Confirm</button>
										</div>
									</div>
							<div class="footer text-right">
							<a href="#close-modal" class="btn btn-default" rel="modal:close" class="close-modal ">Close</a>
									</div>
						</div>
						</div>
						<!-- <div class="modal" id="confirmSellModal" tabindex="-1" role="dialog" aria-labelledby="sellDetailsPage" aria-hidden="true">
							<div class="modal-dialog  modal-lg" role="document">

								Modal content
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">
											<Strong>Sell Summary</Strong>
										</h4>
									</div>
									<div class="modal-body">
										<p>
											<strong>Number of SS Selected : </strong><span style="font-weight: bold;font-size: medium;" id="numberOfSSSelected"></span>
										</p>
										<p>
											<strong>Per Person Sales Amount : </strong><span style="font-weight: bold;font-size: medium;" id="perPersonAmount"></span>
										</p>
										<p>
											<strong>Total Sales Amount : </strong><span style="font-weight: bold;font-size: medium;" id="totalSalesAmount"></span>
										</p>
										<div class="text-right">
											<a href="#close-modal" onclick="goToSellProduct()" class="btn btn-primary" rel="modal:close" class="close-modal ">Back</a>
											<button type="button" onclick="goToSellProduct()" class="btn btn-danger"
												value="confirm">Back</button>
											<button type="button" onclick="" class="btn btn-primary"
												value="confirm">Confirm</button>
										</div>
									</div>

									<div class="modal-footer">
										<button type="button"  onclick="goToSellProduct()" class="btn btn-default">Close</button>
											<a href="#close-modal" class="btn btn-primary" rel="modal:close" class="close-modal ">Close</a>
									</div>
								</div>

							</div>
						</div> -->
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

<script
	src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
	jQuery(document).ready(function() {
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		//TableAdvanced.init();
		//$('#StockSellHistory').DataTable();
		//$('#sellToManySSList').DataTable();
		$('#sellToManySSProductList').DataTable({
			bFilter : false,
			columnDefs : [ {
				targets : [ 0, 1, 2, 3, 4, 5, 6 ,7],
				orderable : false,
				"searchable" : false
			}]
		});
	});
	jQuery(function() {
		jQuery('.date-picker-year')
				.datepicker(
						{
							changeMonth : true,
							changeYear : true,
							showButtonPanel : true,
							dateFormat : 'MM yy',
							maxDate : new Date,
							onClose : function(dateText, inst) {
								var year = $(
										"#ui-datepicker-div .ui-datepicker-year :selected")
										.val();
								$(this).datepicker(
										'setDate',
										new Date(inst.selectedYear,
												inst.selectedMonth, 1));
							}
						});
		jQuery(".date-picker-year").focus(function() {
			$(".ui-datepicker-calendar").hide();
			$(".ui-datepicker-current").hide();
		});
	});
</script>
<script>
	let stockList;
	let selltoMany;
	var sellToArray = [];
	var sellStockObjectArrayPayload = [];
	var totalSelectedAll = 0;
	var perPersonAmountAll = 0;
	var totalAmountAll = 0;
	$(document).ready(function() {
		var today = new Date();
		var currentMonth = today.getMonth() + 1;
		var currentYear = today.getFullYear();

		stockList = $('#StockSellHistory').DataTable({
			bFilter : false,
			serverSide : true,
			processing : true,
			columnDefs : [ {
				targets : [ 0, 1, 2, 3, 4, 5, 6 ],orderable : false}, 
				{width : "5%",targets : 0,"visible" : false}, 
				{width : "20%",targets : 1}, 
				{width : "20%",targets : 2}, 
				{width : "20%",targets : 3},
				{width : "5%",targets : 4}, 
				{width : "5%",targets : 5},
				{width : "25%",targets : 6
			}],
			ajax : {
				url : "${sell_to_ss_list}",
				data : function(data) {
					data.year = currentYear;
					data.month = currentMonth;
					data.branchId = ${id};
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					data.skId = 0;

				},
				dataSrc : function(json) {
					if (json.data) {
						return json.data;
					} else {
						return [];
					}
				},
				complete : function() {
				},
				type : 'GET'
			},
			bInfo : true,
			destroy : true,
			language : {
				searchPlaceholder : ""
			}
		});
	});

	function filter() {
		var date = $("#startYear").val();
		var d = new Date(date);
		var date = d.getDate();
		var month = d.getMonth() + 1;
		var year = d.getFullYear();
		if(isNaN(date)) {
			var today = new Date();
			month = today.getMonth() + 1;
			year = today.getFullYear();
		}
		var skId = parseInt($("#skList").val());
		
		stockList = $('#StockSellHistory').DataTable({
			bFilter : false,
			serverSide : true,
			processing : true,
			columnDefs : [ {
				targets : [ 0, 1, 2, 3, 4, 5, 6 ],orderable : false}, 
				{width : "5%",targets : 0,"visible" : false}, 
				{width : "20%",targets : 1}, 
				{width : "20%",targets : 2}, 
				{width : "20%",targets : 3},
				{width : "5%",targets : 4}, 
				{width : "5%",targets : 5},
				{width : "25%",targets : 6
			}],
			ajax : {
				url : "${sell_to_ss_list}",
				data : function(data) {

					//let dateFieldvalue = $("#dateRange").val();            	
					//data.search = $('#search').val();
					data.year = year;
					data.month = month;
					data.branchId = ${id};
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					data.skId = skId;
				},
				dataSrc : function(json) {
					if (json.data) {
						return json.data;
					} else {
						return [];
					}
				},
				complete : function() {
				},
				type : 'GET'
			},
			bInfo : true,
			destroy : true,
			language : {
				searchPlaceholder : ""
			}
		});
	}

	function sellToMany() {
		//$('.checked').removeClass('checked').addClass('');
        $('#sellToManyModal').modal({
            escapeClose: false,
            clickClose: false,
            closeExisting: false,
            showClose: false,
            show: true
        });
		$("#validationSelectOne").hide();
		var d = new Date($("#startYear").datepicker("getDate"));
		var date = d.getDate();
		var month = d.getMonth() + 1;
		var year = d.getFullYear();
		
		selltoMany = $('#sellToManySSList').DataTable({
			bFilter : false,
			serverSide : true,
			processing : true,
			columnDefs : [ {
				targets : [ 0, 1, 2, 3, 4, 5, 6 ],orderable : false,"searchable" : false}, 
				{width : "5%",targets : 0,"searchable" : false,orderable : false}, 
				{width : "20%",targets : 1}, 
				{width : "20%",targets : 2}, 
				{width : "20%",targets : 3}, 
				{width : "5%",targets : 4}, 
				{width : "5%",targets : 5,"visible" : false}, 
				{width : "25%",targets : 6,"visible" : false
			}],
			ajax : {
				url : "${sell_to_ss_list}",
				data : function(data) {

					//let dateFieldvalue = $("#dateRange").val();            	
					data.search = $('#search').val();

					data.year = year;
					data.month = month;
					data.branchId = ${id};
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					data.skId = 0;
				},
				dataSrc : function(json) {
					

			       // $(".close-modal").hide();
					if (json.data) {
						return json.data;
					} else {
						return [];
					}
				},
				complete : function() {
				},
				type : 'GET'
			},
			bInfo : true,
			destroy : true,
			language : {
				searchPlaceholder : ""
			}
		});
	
		
	}

$('#sellToManySSList th input:checkbox').click(
		function(e) {
			$('tbody tr td input[type="checkbox"]').prop('checked',$(this).prop('checked'));
});

/* 	$('#sellToManySSList').delegate('input.select-checkbox', 'change', function() {
		var productId = $(this).val();
		var inputContext = $(this).parents('td').next().find('input[type="text"]');
	}); */

	function proceedToChooseProduct() {
		sellToArray = [];
		$('#sellToManySSList tbody input[type=checkbox]:checked').each(
				function(index, tr) {
					var ssId = +$(this).val();
					sellToArray.push(ssId);
				});

		$('#sellToManySSProductList > tbody > tr').each(function(index, tr) {

			var $row = $(this).closest('tr'); //get the current row
			$row.find('input[type="number"]').val('');
			$row.find('span:first').html("");
			$row.find('td').eq(6).text(sellToArray.length); // change third cell
			$row.find('td').eq(5).text(0);
			$row.find('td').eq(7).text(0);

		});

		if (sellToArray.length < 1) {
			$("#validationSelectOne").show();
			$(window).scrollTop(0);
			return;
		} 
		else {
			$("#validationSelectOne").hide();
			$("#validationOnSelectProduct").hide();
			//$("#sellToManyProductSelectModal").modal('show');
			$('#sellToManyProductSelectModal').modal({
	            escapeClose: false,
	            clickClose: false,
	            closeExisting: false,
	            showClose: false,
	            show: true
			});
			//$(".close-modal").hide();
		}

	}

	$('.identifier').change(function() {
		var $row = $(this).closest("tr");
		var va = $(this).val();
		if($(this).val() !="") {
			var quantity = +$(this).val();
			
			if(quantity < 1) {
				$row.find('span:first').html("<strong>* Quantity Can not be less than 1</strong>");
				$("#sellButton").hide();
				return;
			}
			else $row.find('span:first').html("");
			var productUnitPrice = parseFloat($row.find('td').eq(2).text());
			var totalSelected = sellToArray.length;
			var currentStock = parseInt($row.find('td').eq(3).text());
			if(quantity*totalSelected > currentStock) {
				$row.find('span:first').html("<strong>* Not available Stock</strong>");
				return;
			}
			else $row.find('span:first').html("");
			//var totalSelected = parseInt($row.find('td').eq(5).val());
			//var totalSelected = sellToArray.length;
			var perPersonAmount = quantity * productUnitPrice;
			var totalAmount = totalSelected * perPersonAmount;
			$row.find('td').eq(5).text(perPersonAmount);
			$row.find('td').eq(7).text(totalAmount);
		}
		else {
			$row.find('span:first').html("");
			$row.find('td').eq(5).text(0);
			$row.find('td').eq(7).text(0);
		}
	});
	
	function goToSellProduct() {
		$("#sellToManyProductSelectModal").modal('show');
		$(".close-modal").hide();
	}
	
	function proceedToSellDetails() {
		
		//$("#sellToManyProductSelectModal").modal('show');
		var visaFlag = true;
		perPersonAmountAll = 0;
		totalAmountAll= 0;
		$('#sellToManySSProductList > tbody > tr').each(function(index, tr) {
		var $row = $(this).closest('tr'); //get the current row
			if (!$row.find('span:first').is(':empty')) { 
				visaFlag = false;
				$("#validationOnSelectProduct").show();
				$("#validationOnSelectProduct").html("Please fix the error to proceed");
				return false;
			}

			var perpersonAmountPerRow = parseFloat($row.find('td').eq(5).text());
			var totalAmountPerRow = parseFloat($row.find('td').eq(7).text());
			perPersonAmountAll = perPersonAmountAll + perpersonAmountPerRow;
			totalAmountAll = totalAmountAll + totalAmountPerRow;
			totalSelectedAll = parseInt($row.find('td').eq(6).text());
		});
		if(visaFlag) {
			sellStockObjectArrayPayload = [];
			sellStockObjectArrayPayload = createStockArray();
			if(sellStockObjectArrayPayload.length < 1) {
				visaFlag = false;
				$("#validationOnSelectProduct").show();
				$("#validationOnSelectProduct").html("Please Select One To Proceed");
				return false;
			}
			else {
				$("#validationOnSelectProduct").hide();
				$("#validationOnSelectProduct").html("");
				$("#numberOfSSSelected").html(totalSelectedAll);
				$("#perPersonAmount").html(perPersonAmountAll);
				$("#totalSalesAmount").html(totalAmountAll);
				$('#confirmSellModal').modal({
		            escapeClose: false,
		            clickClose: false,
		            closeExisting: false,
		            showClose: false,
		            show: true
				});
				//$("#confirmSellModal").modal('show');
				//$(".close-modal").hide();
			}

		}
	}

	function createStockArray() {
		var stockArray = [];
		$('#sellToManySSProductList  > tbody  > tr').each(function(index, tr) {
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
					stockObject["debit"] = parseInt($(this).find('input[type="number"]').val());;
				}

			});
	
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
	
	
	function sellManyTOSSSubmit() {
		var sellToIdList = sellToArray;
		$("#loading").show();
		var stockListArray=sellStockObjectArrayPayload
		var branchId = parseInt("${id}");
		var branchCode = "${branchInfo[0][2]}";
		var sellToId = parseInt("${ssid}");
		var url = "${save_url}";			
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		var formData;
			formData = {
		            'id': 0,
		            "sellTo":sellToIdList,
		            "stockId":branchCode,
		            'stockDetailsDTOs': stockListArray
		        };
		console.log(formData);
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
				   window.location.replace("${redirect_url}/"+branchId+".html?lang=${locale}");
				   
			   }
			   
			},
			error : function(e) {
			   
			},
			done : function(e) {				    
			    console.log("DONE");				    
			}
		});
	};
	
	
   function closeModal() {
	   location.reload();
   }
</script>
















