<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>



<title>Requisition list</title>
	
	
<c:url var="requisition_list_url" value="/rest/api/v1/requisition/list" />
<c:url var="branch_list_url" value="/inventorydm/user-by-branch" />

<c:url var="viewURL" value="/inventory/requisition-details" />

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							Requisition list
						</div>
					</div>				
					<div class="portlet-body">
					
						<div class="form-group">
						
						<jsp:include page="/WEB-INF/views/search-option-for-requisition.jsp" />					
						
							<div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation"><spring:message code="lbl.requisitionBy"></spring:message> :</label>
									<select class="form-control" id="selectRequisitionBy" name="selectRequisitionBy">
										

									</select>
								</div>
								
								<div class="col-lg-3 form-group">
								<label for="from"><spring:message code="lbl.from"></spring:message><span
									class="text-danger"> </span> </label> <input readonly="readonly" type="text"
									class="form-control date" id="from"> <span class="text-danger"
									id="startDateValidation"></span>
							</div>
							<div class="col-lg-3 form-group">
								<label for="to"><spring:message code="lbl.to"></spring:message><span
									class="text-danger"> </span> </label> <input readonly="readonly" type="text"
									class="form-control date" id="to"> <span class="text-danger"
									id="endDateValidation"></span>
							</div> 
							<div class="col-lg-3 form-group" style="padding-top: 24px;">
									<button type="button" onclick="filter()"  class="btn btn-primary">Search</button>
								</div>
								
							</div>
							
							<br/>
						
						<table class="table table-striped table-bordered " id="requisitionListForAm">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.date"></spring:message></th>
									<th><spring:message code="lbl.requisitionId"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.requisitionBy"></spring:message></th>
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
<script src="<c:url value='/resources/assets/global/js/select2-multicheckbox.js'/>"></script>

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>
<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>

<script>
let requisitionList;
jQuery(document).ready(function() {    
	window.totalRecords = 0;
	 Metronic.init(); // init metronic core components
	 Layout.init(); // init current layout
   //TableAdvanced.init();
	//$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
	$('#branchList').select2MultiCheckboxes({
			placeholder: "Select branch",
			width: "auto",
			templateSelection: function(selected, total) {
				return "Selected " + selected.length + " of " + total;
			}
		});
	$("#branchList > option").prop("selected","selected");
    $("#branchList").trigger("change");
    
    
    

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
	
	
	var startDate = $('#from').val();
	var endDate = $('#to').val();
	requisitionList = $('#requisitionListForAm').DataTable({
           bFilter: false,
           serverSide: true,
           processing: true,
           scrollY:        "300px",
           scrollX:        true,
           scrollCollapse: true,
           "ordering": false,
           fixedColumns:   {
               leftColumns: 2/* ,
            rightColumns: 1 */
           },
           ajax: {
               url: "${requisition_list_url}",
               timeout : 300000,
               data: function(data){
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					var branchIds =  $("#branchList").val();
					if( branchIds ==null || typeof branchIds == 'undefined'){
				  		branchIds = ''
				  	}else{
				  		branchIds = $("#branchList").val().join();
				  	}
					data.branch = branchIds;
					data.requisitor = 0;
					data.startDate = startDate,
					data.endDate = endDate,
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
});

function filter(){
	var division = $('#divisionList').val();
	if( division ==null || typeof division == 'undefined'){
		division = 0
  	}
	var district = $('#districtList').val();
	if( district ==null || typeof district == 'undefined'){
		district = 0
  	}
	var upazila = $('#upazilaList').val();
	if( upazila ==null || typeof upazila == 'undefined'){
		upazila = 0
  	}
	var requisitor = $('#selectRequisitionBy').val();
	if( requisitor ==null || typeof requisitor == 'undefined'){
		requisitor = 0
  	}else{
  		requisitor = $("#selectRequisitionBy").val().join();
  	}
	
	
	var branchIds =  $("#branchList").val();
	if( branchIds ==null || typeof branchIds == 'undefined'){
  		branchIds = ''
  	}else{
  		branchIds = $("#branchList").val().join();
  	}
	
	console.log(branchIds);
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
		
 		requisitionList = $('#requisitionListForAm').DataTable({
        bFilter: false,
        serverSide: true,
        processing: true,
        scrollY:        "300px",
        scrollX:        true,
        scrollCollapse: true,
        "ordering": false,
        fixedColumns:   {
            leftColumns: 2/* ,
         rightColumns: 1 */
        },
        ajax: {
            url: "${requisition_list_url}",
            data: function(data){
					data.division = division;
					data.district = district;
					data.upazila = upazila;
					data.branch = branchIds;
					data.requisitor = requisitor;
					data.startDate = startDate,
					data.endDate = endDate,
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
}

$("#branchList").change(function (event) {
	var branchIds =  $("#branchList").val();
	if( branchIds ==null || typeof branchIds == 'undefined'){
  		branchIds = ''
  	}else{
  		branchIds = $("#branchList").val().join();
  	}
	
	console.log(branchIds);
	var url = "${branch_list_url}/"+branchIds;
	$("#selectRequisitionBy").html("");
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url,

		dataType : 'html',
		timeout : 100000,
		beforeSend: function() {},
		success : function(data) {			
			$("#selectRequisitionBy").html(data);
			$('#selectRequisitionBy').select2MultiCheckboxes({
				placeholder: "Select requisition by",
				width: "auto",
				templateSelection: function(selected, total) {
					return "Selected " + selected.length + " of " + total;
				}
			});
			$("#selectRequisitionBy > option").prop("selected","selected");
			$("#selectRequisitionBy").trigger("change");
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

function navigateTodetails(requisitionId,branchName,branchCode) {
	var locale = "${locale}";
	var branchString= branchName+"-"+branchCode;
	window.location.assign("${viewURL}/"+requisitionId+".html?lang="+locale+"&branch="+branchString+"&branchid=${branchInfo[0][0]}");
}


</script>



















