<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Adjust History</title>
	
	

<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">

<c:url var="adjust_list_url" value="/rest/api/v1/stock/stock-adjust-history-list" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />


<div class="page-content-wrapper">
		<div class="page-content">
		
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							Stock Adjust History
						</div>


					</div>
		
					<div class="portlet-body">
							<div class="row">
								<div class="col-lg-2 form-group">
								<label for="from"><spring:message code="lbl.from"></spring:message><span
									class="text-danger"> </span> </label> <input readonly="readonly" type="text"
									class="form-control date" id="from"> <span class="text-danger"
									id="startDateValidation"></span>
							</div>
							<div class="col-lg-2 form-group">
								<label for="to"><spring:message code="lbl.to"></spring:message><span
									class="text-danger"> </span> </label> <input readonly="readonly" type="text"
									class="form-control date" id="to"> <span class="text-danger"
									id="endDateValidation"></span>
							</div> 
								
								
									<div class="col-lg-3 form-group">
									<label for="to"><spring:message code="lbl.branch"></spring:message> </label>
									<select id=branchSelect class="form-control" name="branchSelect" required>
										<option value="0"><spring:message
												code="lbl.pleaseSelect" /></option>
										<c:forEach items="${branches}" var="branch">
											<option value="${branch.id}">${branch.name}</option>
										</c:forEach>
									</select>
									<p>
										<span class="text-danger" id="branchSelectionValidation"></span>
									</p>
								</div>
								
							
								<div class="col-lg-12 form-group text-right">
									<button type="button" onclick="filter()"  class="btn btn-primary">Search</button>
								</div>

							</div>
					
						<table class="table table-striped table-bordered" id="adjustHistoryList">
							<thead>
								<tr>
									<th><spring:message code="lbl.date"></spring:message></th>
									<th><spring:message code="lbl.productName"></spring:message></th>
									<th>Product ID</th>
									<th>Branch</th>
									<th>Previous Stock</th>
									<th>Adjustment</th>
									<th>After Adjustment</th>
									<th>Reason</th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
				</table>
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
var dateToday = new Date();
	var dates = $(".date").datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: dateToday,
    onSelect: function(selectedDate) {
        var option = this.id == "from" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        dates.not(this).datepicker("option", option, date);
    }
});
var d = new Date();
var startDate =  $.datepicker.formatDate('yy-mm-dd', new Date(d.getFullYear(), d.getMonth(), 1));

$("#from").datepicker('setDate', startDate); 
$("#to").datepicker('setDate', new Date()); 
let stockAdjustList;

jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		$('#branchSelect').select2({dropdownAutoWidth : true});
		//var date = new Date(), y = date.getFullYear(), m = date.getMonth();
		//var startDateDm = $.datepicker.formatDate('yy-mm-dd', new Date(y, m, 1));
		//var endDateDm = $.datepicker.formatDate('yy-mm-dd', new Date(y, m + 1, 0));
		stockAdjustList = $('#adjustHistoryList').DataTable({
		       bFilter: false,
		       serverSide: true,
		       processing: true,
		       columnDefs: [
		           { targets: [0,1,2,3,4,5,6,7], orderable: false },
	               { width: "15%", targets: 0 },
	               { width: "10%", targets: 1 },
	               { width: "10%", targets: 2 },
	               { width: "15%", targets: 3 },
	               { width: "5%", targets: 4 },
	               { width: "5%", targets: 5 },
	               { width: "10%", targets: 6 },
	               { width: "15%", targets: 7 },
	               { width: "15%", targets: 8 }
		       ],
		       ajax: {
		           url: "${adjust_list_url}",
		           data: function(data){
						data.branchId = 0;
						data.startDate = '',
						data.endDate = ''
						
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



function openAdjustStockModal(id,currentStock,productName) {
	
	$("#productName").val(productName);
	$("#productId").val(id);
	$("#currentStock").val(currentStock);


	$('#adjustStockModal').modal({
        escapeClose: false,
        clickClose: false,
        closeExisting: false,
        showClose: false,        // Shows a (X) icon/link in the top-right corner
        show: true
	});
}



function filter(){

var branch = +$('#branchSelect').val();
var startDate = $('#from').val();
var endDate = $('#to').val();
if(startDate == "") {
	//startDate = $.datepicker.formatDate('yy-mm-dd', new Date());
	$("#startDateValidation").html("<strong>Please fill out this field</strong>");
	return;
}
$("#startDateValidation").html("");
if(endDate == "") {
	//endDate = $.datepicker.formatDate('yy-mm-dd', new Date());
	$("#endDateValidation").html("<strong>Please fill out this field</strong>");
	return;
}
$("#endDateValidation").html("");

	stockAdjustList = $('#adjustHistoryList').DataTable({
    bFilter: false,
    serverSide: true,
    processing: true,
    columnDefs: [
        { targets: [0,1,2,3,4,5], orderable: false },
        { width: "15%", targets: 0 },
        { width: "10%", targets: 1 },
        { width: "10%", targets: 2 },
        { width: "15%", targets: 3 },
        { width: "5%", targets: 4 },
        { width: "5%", targets: 5 },
        { width: "10%", targets: 6 },
        { width: "15%", targets: 7 },
        { width: "15%", targets: 8 }
    ],
    ajax: {
    	url: "${adjust_list_url}",
        data: function(data){
			data.branchId = branch;
			data.startDate = startDate,
			data.endDate = endDate
				
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



















