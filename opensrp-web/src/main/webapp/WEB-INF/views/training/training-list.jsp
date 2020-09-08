<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<title>Training List</title>
	
	


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
							Training List
						</div>
					</div>				
					<div class="portlet-body">
					
						<div class="form-group">
						<jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" />
							<div class="row">
							<div class="col-lg-3 form-group">
								    <label for="from"><spring:message code="lbl.trainingTopic"></spring:message> :</label>
									<input type="text" class="form-control" id="topic">
								</div> 
								<div class="col-lg-3 form-group">
								    <label for="from"><spring:message code="lbl.trainingAudience"></spring:message>:</label>
									<input type="text" class="form-control" id="audience">
								</div> 
								<div class="col-lg-3 form-group">
								    <label for="from"><spring:message code="lbl.from"></spring:message><span class="text-danger">*</span> :</label>
									<input type="date" class="form-control" id="from">
									<span class="text-danger" id="startDateValidation"></span>
								</div> 
								<div class="col-lg-3 form-group">
									<label for="to"><spring:message code="lbl.to"></spring:message><span class="text-danger">*</span> :</label>
									<input type="date" class="form-control" id="to">
									<span class="text-danger" id="endDateValidation"></span>
								</div>
								
							</div>
							
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="button" onclick="filter()"  class="btn btn-primary">Search</button>
								</div>
     							</div>
							<br/>
						
						<div class="row">
								<div class="col-lg-12 form-group text-left">
									<a class="btn btn-primary" id="addNewTraining"
										href="<c:url value="/training/add-training.html?lang=${locale}"/>">
										<strong> Add New Training </strong>
									</a>
								</div>
     							</div>
							<br/>
						<table class="table table-striped table-bordered " id="trainingList">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
								    <th><spring:message code="lbl.trainingTopic"></spring:message></th>
									<th><spring:message code="lbl.trainingStartDate"></spring:message></th>
									<th><spring:message code="lbl.audience"></spring:message></th>
									<th><spring:message code="lbl.trainerName"></spring:message></th>
									<th><spring:message code="lbl.location"></spring:message></th>
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
let trainingList;
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
	 Layout.init(); // init current layout
	var date = new Date(), y = date.getFullYear(), m = date.getMonth();
	var startDateDm = $.datepicker.formatDate('yy-mm-dd', new Date(y, m, 1));
	var endDateDm = $.datepicker.formatDate('yy-mm-dd', new Date(y, m + 1, 0));
	trainingList = $('#trainingList').DataTable({
           bFilter: false,
           serverSide: true,
           processing: true,
           columnDefs: [
               { targets: [0,1,2,3,4,5], orderable: false },
               { width: "5%", targets: 0 },
               { width: "15%", targets: 1 },
               { width: "15%", targets: 2 },
               { width: "15%", targets: 3 },
               { width: "15%", targets: 4 },
               { width: "20%", targets: 5 },
               { width: "15%", targets: 6 }
           ],
           ajax: {
               url: "/opensrp-dashboard/rest/api/v1/training/training-list",
               data: function(data){
					data.locationId = 0;
					data.branchId = 0;
					data.roleId = 0;
					data.startDate = startDateDm,
					data.endDate = endDateDm
					
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
	var division = +$('#divisionList').val();
	var district = +$('#districtList').val();
	var upazila = +$('#upazilaList').val();
	var requisitor = +$('#selectRequisitionBy').val();
	var branch = +$('#branchList').val();
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
        columnDefs: [
            { targets: [0,1,2,3,4,5], orderable: false },
            { width: "20%", targets: 0 },
            { width: "20%", targets: 1 },
            { width: "20%", targets: 2 },
            { width: "20%", targets: 3 },
            { width: "20%", targets: 4 },
            { width: "20%", targets: 5 }
        ],
        ajax: {
            url: "/opensrp-dashboard/rest/api/v1/requisition/list",
            data: function(data){
					data.division = division;
					data.district = district;
					data.upazila = upazila;
					data.branch = branch;
					data.requisitor = requisitor;
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

$("#branchList").change(function (event) {
	let branchId = +$('#branchList').val();
	var url = "/opensrp-dashboard/inventorydm/user-by-branch/"+branchId;
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
window.location.replace("/opensrp-dashboard/inventory/requisition-details/"+requisitionId+".html?lang="+locale+"&branch="+branchString+"");
}

</script>



















