<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Stock list</title>
	
	
<c:url var="stock_in_list" value="/rest/api/v1/stock/in-list" />

<c:url var="backUrl" value="/inventoryam/stock-in.html" />
<c:url var="viewUrl" value="/inventoryam/stock-list/view" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	
<link type="text/css"
	href="<c:url value="/resources/css/daterangepicker.css"/>"
	rel="stylesheet"
	http-equiv="Cache-control" content="public">

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
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class=center-caption> ${branchInfo[0][1]} - ${branchInfo[0][2]}</div>
						</div>
		</div>
		<div class="form-group">
			<div class="row">								 	
				<div class="col-lg-2 form-group">
				<label for="from"><spring:message code="lbl.from"></spring:message><span
					class="text-danger"> *</span> </label> <input type="text"
					class="form-control date" id="from" readonly="readonly"> <span class="text-danger"
					id="startDateValidation"></span>
				</div>
			<div class="col-lg-2 form-group">
				<label for="to"><spring:message code="lbl.to"></spring:message><span
					class="text-danger"> *</span> </label> <input type="text" readonly="readonly"
					class="form-control date" id="to"> <span class="text-danger"
					id="endDateValidation"></span>
			</div> 
				<div class="col-lg-4 form-group ">
					<label class="control-label">Invoice number </label> 
				 		<input class="form-control" type="text" id="invoiceNumber" placeholder="Invoice number"> 
				</div>
				<div class="col-lg-4" style="padding-top: 20px">
				
					<div  onclick="filter()"  class="btn btn-primary btn-lg">Search</div>
				</div>
			
			</div>
		</div>
		<div class="col-lg-12 form-group requisition-add">
	                <a class="btn btn-primary" id="newInvoice" href="<c:url value="/inventoryam/stock-add/${id}.html?lang=${locale}"/>">
					<strong>
					New Invoice
				</strong></a>
	            </div>
					<div class="portlet-body">
						<table class="table table-striped table-bordered" id="stockListOfAm">
							<thead>
								<tr>
									<th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.date"></spring:message></th>
									<th><spring:message code="lbl.invoiceNo"></spring:message></th>
									<th><spring:message code="lbl.stockInId"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.requisitionBy"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>

						</table>
					</div>
					
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>
<script src="<c:url value='/resources/js/moment.min.js' />"></script>
 
<script src="<c:url value='/resources/js/daterangepicker.min.js' />"></script>
<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		//$('#stockListOfAm').DataTable();
});
</script>


<script type="text/javascript">
var dateToday = new Date();

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
	$(".date-picker-year").focus(function () {
    $(".ui-datepicker-calendar").hide();
    $(".ui-datepicker-current").hide();
});
	var d = new Date();
	var startDate =  $.datepicker.formatDate('yy-mm-dd', new Date(d.getFullYear(), d.getMonth(), 1));
	
	$("#from").datepicker('setDate', startDate); 
	$("#to").datepicker('setDate', new Date()); 
</script>
<script>

    let stockList;
    $(document).ready(function() {
    	stockList = $('#stockListOfAm').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3, 4,5,6], orderable: false },
                { width: "10%", targets: 0 },
                { width: "10%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "15%", targets: 3 },
                { width: "15%", targets: 4 },
                { width: "20%", targets: 5 },
                { width: "20%", targets: 6 }
            ],
            ajax: {
                url: "${stock_in_list}",
                data: function(data){
                	let startDate = $("#from").val();   
                	let endDate = $("#to").val(); 
                	data.startDate = startDate;
                    data.endDate =endDate;
                    data.branchId =  ${id};
                    data.invoiceNumber='';
                    data.stockInId='';
                    data.division=0;
                    data.district=0;
                    data.upazila=0;
                    data.userId=0;
                    
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
	
	stockList = $('#stockListOfAm').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { targets: [0, 1, 2, 3, 4,5,6], orderable: false },
             { width: "10%", targets: 0 },
             { width: "10%", targets: 1 },
             { width: "10%", targets: 2 },
             { width: "15%", targets: 3 },
             { width: "15%", targets: 4 },
             { width: "20%", targets: 5 },
             { width: "20%", targets: 6 }
         ],
         ajax: {
             url: "${stock_in_list}",
             data: function(data){
            	
            	let startDate = $("#from").val();   
            	let endDate = $("#to").val(); 
            	
     	      	data.search = $('#search').val();            	
            	/* if(dateFieldvalue != '' && dateFieldvalue != undefined){
	     	        data.startDate = $("#dateRange").data('daterangepicker').startDate.format('YYYY-MM-DD');
	                data.endDate =$("#dateRange").data('daterangepicker').endDate.format('YYYY-MM-DD');
            	}else{
            		data.startDate = '';
                    data.endDate ='';
            	} */
            	
                data.branchId =  ${id};
                data.invoiceNumber=$('#invoiceNumber').val();
                data.stockInId='';
                data.division=0;
                data.district=0;
                data.upazila=0;
                data.userId=0;
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

function navigateTodetails(stockId,branchName,branchCode) {
	var locale = "${locale}";
	var branchString= "${branchInfo[0][1]}"+"-"+"${branchInfo[0][2]}";
	window.location.assign("${viewUrl}/"+stockId+".html?lang="+locale+"&branch="+branchString+"&branchid=${id}");
}
</script>



















