<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>SS Sales Report</title>
	
	
<c:url var="sell_to_ss_list" value="/rest/api/v1/stock/sell_to_ss_list" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>SS sales report </strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>				
				
				<li>
					/ Inventory  
				</li>
				
		</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							Monthly SS Sales Report
						</div>


					</div>				
					<div class="portlet-body">
						<div class="form-group">
						<%-- <jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" /> --%>
						<jsp:include page="/WEB-INF/views/search-option-for-inventory.jsp" />
							 <div class="row">
								<div class="col-lg-3 form-group">
								    <label for="designation"><spring:message code="lbl.selectSk"></spring:message> :</label>
									<select class="form-control" id="selectsk" name="selectsk">
										<option value="0"><spring:message
												code="lbl.selectSk" /></option>
										<option value=""></option>

									</select>
								</div>
								<div class="col-lg-3 form-group">
									<label for="yearMonth">Date:</label>
									<input type="text"	readonly name="yearMonth" id="yearMonth" class="form-control date-picker-year" />
								</div>
								<div class="col-lg-3 form-group" style="padding-top: 22px">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">Search</button>
								</div>
							</div> 
							
							<br/>
						<h3>Monthly SS Sales Report </h3>
						<table class="table table-striped table-bordered " id="ssSalesReportForDm">
							<thead>
								<tr>
								   <%--  <th><spring:message code="lbl.serialNo"></spring:message></th> --%>
									<th><spring:message code="lbl.ssName"></spring:message></th>
									<%-- <th><spring:message code="lbl.ssId"></spring:message></th> --%>
									<th><spring:message code="lbl.skName"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<%-- <th><spring:message code="lbl.targetAmount"></spring:message></th> --%>
									<th><spring:message code="lbl.projectedSalesAmount"></spring:message> (BDT)</th>
									<th><spring:message code="lbl.purchaseAmount"></spring:message> (BDT)</th>
									
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
							
						</table>
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
	window.totalRecords = 0;
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		$('#branchList').select2({dropdownAutoWidth : true});
   //TableAdvanced.init();
		//$('#ssSalesReportForDm').DataTable();
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
	$("#yearMonth").datepicker('setDate', new Date()); 
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
    	
    	stockList = $('#ssSalesReportForDm').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [ ],
            ajax: {
                url: "${sell_to_ss_list}",
                timeout : 300000,
                data: function(data){
                	data.year = currentYear;
                    data.month =currentMonth;
                    data.branchId = 0;
                    data.division=0;
                    data.district=0;
                    data.upazila=0;
                    data.skId=0;
                    if('${roleName}'=='AM' || '${roleName}'=='DivM' ){
                    	data.manager="${manager}";
                    }else{
                    data.manager=0;
                    }
                    data.totalRecords = totalRecords;
                   
                    
                },
                dataSrc: function(json){
                	 totalRecords = json.recordsTotal;
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
	let district = $("#districtList option:selected").val();
	if(typeof district =='undefined'){
		district=0;
	}
	let division = $("#divisionList option:selected").val();
	if(typeof division =='undefined'){
		division=0;
	}
	let upazila = $("#upazilaList option:selected").val();
	
	if( typeof upazila =='undefined'){
		
		upazila=0;
	}
	var skId = +$('#selectsk').val();
	var branch = +$('#branchList').val();
	var date = $("#yearMonth").val();
	var d = new Date(date);
	var date = d.getDate();
	var month = d.getMonth() + 1;
	var year = d.getFullYear();
	if(isNaN(date)) {
		var today = new Date();
		month = today.getMonth() + 1;
		year = today.getFullYear();
	}

	
	stockList = $('#ssSalesReportForDm').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
           
         ],
         ajax: {
             url: "${sell_to_ss_list}",
             timeout : 300000,
             data: function(data){
            	
            	//let dateFieldvalue = $("#dateRange").val();            	
     	      	data.search = $('#search').val();            	
            	
            	
     	      	data.year = year;
                data.month = month;
                data.branchId = branch;
                data.division = division;
                data.district = district;
                data.upazila = upazila;
                data.skId = skId;
                if(branch==0 && division==0 && division==0 && upazila==0 && skId==0){
                	data.manager="${manager}";
                }else{
                data.manager=0;
                };
                data.totalRecords = totalRecords
             },
             dataSrc: function(json){
            	 totalRecords = json.recordsTotal;
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

$("#branchList").change(function (event) {
	let branchId = +$('#branchList').val();
	var url = "/opensrp-dashboard/inventorydm/sk-by-branch/"+branchId;
	$("#selectsk").html("");
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url,

		dataType : 'html',
		timeout : 300000,
		beforeSend: function() {},
		success : function(data) {
			$("#selectsk").html(data);
		},
		error : function(e) {
			console.log("ERROR: ", e);
			display(e);
		},
		done : function(e) {

			console.log("DONE");
			//enableSearchButton(true);
		}
	});
});
</script>

















