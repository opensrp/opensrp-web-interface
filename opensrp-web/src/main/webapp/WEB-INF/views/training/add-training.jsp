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

<%
    List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
%>


<title>Add Training</title>
	
	

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

.radio input[type=radio], .radio-inline input[type=radio] {
	margin-left: -7px !important;
}
</style>	

<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Add Training</div>


			</div>
			
			<div class="portlet-body">
				<div style="display: none;" class="alert alert-success" id="serverResponseMessage" role="alert"></div>
				<div class="card-body">
					<div id="loading"
						style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>

				</div>
				<form id = "addTraining">
				
				<!-- First Half of Form Starts -->
				
				<div class="col-lg-6">
					<div class="form-group row">
						<label for="trainingTitle" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingTitle"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="trainingTitle" name ="trainingTitle" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingId" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingId"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="trainingId" name ="trainingId">
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingStartDate" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingStartDate"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="date" class="form-control" id="trainingStartDate" name = "trainingStartDate" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingDuration" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingduration"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="number" min="1"  class="form-control" id="trainingDuration" name ="trainingDuration" >
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingAudience" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingAudience"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text"  class="form-control" id="trainingAudience" name ="trainingAudience" required >
						</div>
					</div>
					<div class="form-group row">
						<label for="participantNumber" class="col-sm-4 col-form-label"><spring:message code="lbl.participantNumber"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="number" min="1"  class="form-control" id="participantNumber" name ="participantNumber" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="nameOfTrainer" class="col-sm-4 col-form-label"><spring:message code="lbl.nameOfTrainer"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text"  class="form-control" id="nameOfTrainer" name ="nameOfTrainer" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="designationOfTrainer" class="col-sm-4 col-form-label"><spring:message code="lbl.designationOfTrainer"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text"  class="form-control" id="designationOfTrainer" name ="designationOfTrainer" >
						</div>
					</div>
					
					<div class="form-group row">
						<label  class="col-sm-4 col-form-label"><spring:message code="lbl.location"></spring:message><span class="text-danger">*</span> :</label>
						
						 <div class="col-sm-6">
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="radio" value="BRANCH" id="branchRadio1"> <label for="branchRadio1"
										class="form-check-label" >Branch
									</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="radio" value="HQ" id="branchRadio2"> <label for="branchRadio2"
										class="form-check-label">HQ
									</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="radio" value="BLC" id="branchRadio3"> <label for="branchRadio3"
										class="form-check-label" >BLC
									</label>
								</div>
								<div class="form-check">							  
									<input class="form-check-input" name="locationName"
										type="radio" value="OTHERS" id="branchRadio4"> <label for="branchRadio4"
										class="form-check-label">Others
									</label>

								</div>
							<p>

	                          		 <span class="text-danger" id="checkBoxSelection"></span>
	                        	</p>
	                        	  
						</div> 
	<%-- 					 <div class="col-sm-5">
								<div class="form-check" id="checkboxDiv" style="display:none">
											<select  id="checkboxBranch"
			                                class="form-control mx-sm-3 search-dropdown"
			                                name="checkboxBranch" required>
			                                <option value="0"><spring:message
											code="lbl.pleaseSelect" /></option>
			                            <c:forEach items="${branches}" var="branch">
			                                <option value="${branch.id}">${branch.name}</option>
			                            </c:forEach>
			                        </select>
								</div>
								 <div class="form-group" id="divisionDiv" style="display:none">
								   <select class="form-control division-dropdown" id="division" name="division">
										<option value=""><spring:message
												code="lbl.selectDivision" />
										</option>
										<%
											for (Object[] objects : divisions) {
										%>
										<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
										<%
											}
										%>
									</select>
								</div> 
								<div class="form-group" id="districtDiv" style="display:none">
								    <select class="form-control district-dropdown" id="district" name="district">
										<option value="0?"><spring:message
												code="lbl.selectDistrict" /></option>
										<option value=""></option>
									</select>
								</div>
								<div class="form-group" id="upazillaDiv" style="display:none">
								    <select class="form-control upazilla-dropdown" id="upazila" name="upazila">
										<option value="0?"><spring:message code="lbl.upazila"></spring:message></option>
										<option value=""></option>

									</select>
								</div>
								<div class="form-group" id="blcDiv" style="display:none">
								   <select class="form-control blc-dropdown" id="blc" name="blc">
										<option value="">Select BLC
										</option>
									</select>
								</div>	
								<div id="descriptionDiv" style="display:none">														
								<input class="form-control" type="text" name="description" id="decription" placeholder="Description">
								</div>
	                        	  
						</div>   --%>
						
					</div>
						<div class="form-group row" id="checkboxDiv" style="display:none">
							<label for="designationOfTrainer" class="col-sm-4 col-form-label"><spring:message
									code="lbl.branch"></spring:message> :</label>
							<div class="col-sm-6">
								<select id="checkboxBranch"
									class="form-control mx-sm-3 search-dropdown"
									name="checkboxBranch" required>
									<option value="0"><spring:message
											code="lbl.pleaseSelect" /></option>
									<c:forEach items="${branches}" var="branch">
										<option value="${branch.id}">${branch.name}</option>
									</c:forEach>
								</select>
							</div>

						</div>
						<div class="form-group row" id="divisionDiv" style="display:none">
							<label for="designationOfTrainer" class="col-sm-4 col-form-label"><spring:message
									code="lbl.division"></spring:message> :</label>
							<div class="col-sm-6">
								<select class="form-control " id="division" name="division">
									<option value=""><spring:message
											code="lbl.selectDivision" />
									</option>
									<%
										for (Object[] objects : divisions) {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
									<%
										}
									%>
								</select>
							</div>
						</div>
						
						<div class="form-group row" id="districtDiv" style="display:none">
							<label for="designationOfTrainer" class="col-sm-4 col-form-label"><spring:message code="lbl.district"></spring:message> :</label>
							<div class="col-sm-6">
								<select class="form-control district-dropdown" id="district" name="district">
										<option value="0?"><spring:message
												code="lbl.selectDistrict" /></option>
										<option value=""></option>
									</select>
							</div>
						</div>
						<div class="form-group row" id="upazillaDiv" style="display:none">
							<label for="designationOfTrainer" class="col-sm-4 col-form-label"><spring:message code="lbl.upazila"></spring:message>:</label>
							<div class="col-sm-6">
								<select class="form-control upazilla-dropdown" id="upazila" name="upazila">
										<option value="0?"><spring:message code="lbl.upazila"></spring:message></option>
										<option value=""></option>

									</select>
							</div>
						</div>
						<div class="form-group row" id="blcDiv" style="display:none">
							<label for="designationOfTrainer" class="col-sm-4 col-form-label">BLC :</label>
							<div class="col-sm-6">
								<select class="form-control blc-dropdown" id="blc" name="blc">
										<option value="">Select BLC
										</option>
									</select>
							</div>
						</div>
						<div class="form-group row" id="descriptionDiv" style="display:none" >
							<label for="designationOfTrainer" class="col-sm-4 col-form-label">Description :</label>
							<div class="col-sm-6">
								<input class="form-control" type="text" name="description" id="decription" placeholder="Description">
							</div>
						</div>
						
					</div>
					
					
					<!-- FIrst Half of Form ENds -->
					
					<!-- Second Half of Form Starts -->
					
				<div class="col-lg-6">
					<div class="form-group row">
						<label for=attendanceList class="col-sm-6 col-form-label"><spring:message code="lbl.attendanceList"></spring:message>:<span class="text-danger">*</span></label>
						<div class="col-sm-6">
							<button type="button" class="btn btn-primary" onclick="openAttendaceModal()" id="addAttendance" >Add Attendance</button>
						</div>
					</div>
					<div class="table-scrollable ">
					<table class="table table-striped table-bordered " id="trainingList">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
								    <th style="display:none;">user_id</th>
								    <th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.branch"></spring:message>/<spring:message code="lbl.location"></spring:message></th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						</div>
					</div>
					
					<!-- Second Half of Form Ends -->
					
					
					<div class="form-group row"></div>
					<div class="form-group row">
						<div class="col-sm-3"></div>
						<div class="col-sm-2">
							<a class="btn btn-danger" id="cancelProduct"
								href="<c:url value="/training/view-training.html?lang=${locale}"/>">
								<strong>Cancel</strong>
							</a>
						</div>
						<div class="col-sm-2">
							<button type="submit" onclick="return Validate()" class="btn btn-primary">Confirm</button>
						</div>
					</div>
				</form>
				 
				 <!-- Attendance Modal Starts-->
				 
				<div class="modal modal-margin" id="addAttendanceModal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 75%;">
					<div class="row">
					<div class="modal-header text-center" style="border-bottom: none;">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Trainer List</Strong>
										</h4>
									</div>
									</br>
						<div id="validationSelectOne" style="display: none"
							class="alert alert-danger text-center" role="alert">Please
							select one to proceed</div>
							<div class="form-group row">
							<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.designation"></spring:message> : <span class="text-danger"> *</span></label> 
								    <select class="form-control mx-sm-3 role-multiple" id="selectRole" name="selectRole">
									<option value="0"><spring:message
											code="lbl.pleaseSelect" /></option>
									<c:forEach items="${roles}" var="role">
										<option value="${role.id}">${role.name}</option>
									</c:forEach>
									</select>
									<span class="text-danger" id="roleValidation"></span>
								</div>
                               <div class="col-lg-4">
											<label class="control-label" for="username"> <spring:message code="lbl.branches"/> :	</label>                                     
											<select id="branches"
			                                class="form-control mx-sm-3 modal-branch-multiple"
			                                name="branches" required>
			                                <option value="0"><spring:message
											code="lbl.pleaseSelect" /></option>
			                            <c:forEach items="${branches}" var="branch">
			                                <option value="${branch.id}">${branch.name}</option>
			                            </c:forEach>
			                        </select>
                                </div>
                                <div class="col-lg-3">
											<button type="button" onclick="filter()" class="btn btn-primary">Search</button>
                                </div>
                            </div>
							 
						<!-- <div class="row">
							<div class="col-lg-12 form-group text-right">
								<button type="button" onclick="filter()" class="btn btn-primary">Search</button>
							</div>
						</div> -->
						<br />
						<table class="table table-striped table-bordered record_table"
							id="addAttendanceList">
							<thead>
								<tr><th>Select</th>
								    <th><spring:message code="lbl.name"></spring:message></th>
								    <th>ID</th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.branch"></spring:message></th>
								</tr>
							</thead>
						</table>
						<div class="text-center" id="proceedDiv">
							<button id="proceeddProductButton" type="button"
								class="btn btn-primary" onclick="appendRowInTable()">Proceed</button>
						</div>
						<div class="footer text-right">
							<a href="#close-modal" class="btn btn-default" rel="modal:close"
								class="close-modal ">Close</a>
						</div>
					</div>
				</div>
				
				<!-- Attendance Modal Ends -->
				
			</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
let trainingAttendanceList;
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		$('.role-multiple').select2({dropdownAutoWidth : true});
		$('.modal-branch-multiple').select2({dropdownAutoWidth : true});
		
/* 		$('.division-dropdown').select2({dropdownAutoWidth : true});
		$('.district-dropdown').select2({dropdownAutoWidth : true});
		$('.upazilla-dropdown').select2({dropdownAutoWidth : true});
		$('.blc-dropdown').select2({dropdownAutoWidth : true});
		$('.search-dropdownn').select2({dropdownAutoWidth : true}); */

		//$('#addAttendanceList').DataTable();
});

function openAttendaceModal() {

	$('#addAttendanceModal').modal({
        escapeClose: false,
        clickClose: false,
        closeExisting: false,
        showClose: false,        // Shows a (X) icon/link in the top-right corner
        show: true
	});
	trainingAttendanceList = $('#addAttendanceList').DataTable({
        bFilter: false,
        serverSide: true,
        processing: true,
        columnDefs: [
            { targets: [0,1,2,3,4], orderable: false },
            { width: "10%", targets: 0 },
            { width: "25%", targets: 1 },
            { width: "20%", targets: 2 },
            { width: "20%", targets: 3 },
            { width: "25%", targets: 4 }
        ],
        ajax: {
            url: "/opensrp-dashboard/rest/api/v1/training/training-attendance-list",
            data: function(data){
					data.branchId = 0;
					data.roleId = 0;
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
	//$(".close-modal").hide();
/* 	$('#addAttendanceList tbody input[type=checkbox]:checked').each(function(index, tr) {
        $(this).prop("checked", false);
        $('.checked').removeClass('checked').addClass('');
    }); */
}

function appendRowInTable() {
$//('#trainingList tbody').empty();
$('#addAttendanceList tbody input[type=checkbox]:checked').each(function(index, tr) {
			var ssId = $(this).val();
			var $row = $(this).closest('tr');
			var name = $row.find('td').eq(1).text();
			var id = $row.find('td').eq(3).text();
			var designation = $row.find('td').eq(3).text();
			var location = $row.find('td').eq(4).text();
			var size = jQuery('#trainingList >tbody >tr').length + 1
			$("#trainingList tbody").append("<tr id='rec-"+size+"'><td><span class=\"sn\">"+size+"</span>.</td><td style='display:none'>"+ssId+"</td><td>"+name+"</td><td>"+designation+"</td><td>"+location+"</td><td><a class=\"btn btn-xs delete-record\" data-id="+size+"><i class=\"glyphicon glyphicon-trash\"></i></a></td></tr>");
		});
	$.modal.close();
 
}

jQuery(document).delegate('a.delete-record', 'click', function(e) {
    e.preventDefault();    
    var didConfirm = confirm("Are you sure You want to delete");
    if (didConfirm == true) {
     var id = jQuery(this).attr('data-id');
     //var targetDiv = jQuery(this).attr('targetDiv');
     jQuery('#rec-' + id).remove();
     
   //regnerate index number on table
    $('#trainingList tr').each(function(index){
		$(this).find('span.sn').html(index+1);
   }); 
   return true;
 } else {
   return false;
 }
});



 $('input:radio[name="locationName"]').change(
	    function(){

	        // checks that the clicked radio button is the one of value 'Yes'
	        // the value of the element is the one that's checked (as noted by @shef in comments)
	        if ($(this).val() == 'BRANCH') {
				$("#checkboxDiv").show();
				$('.search-dropdown').select2({dropdownAutoWidth : true});
				$("#districtDiv").hide();
				$("#divisionDiv").hide();
				$("#upazillaDiv").hide();
				$("#blcDiv").hide();
				$("#descriptionDiv").hide();
				
	            // appends the 'appended' element to the 'body' tag
	           // $(appended).appendTo('body');
	        }
	        else if ($(this).val() == 'HQ') {
				$("#checkboxDiv").hide();
				$("#districtDiv").hide();
				$("#divisionDiv").hide();
				$("#upazillaDiv").hide();
				$("#blcDiv").hide();
				$("#descriptionDiv").hide();
	            // appends the 'appended' element to the 'body' tag
	           // $(appended).appendTo('body');
	        }
	        else if ($(this).val() == 'BLC') {
				$("#checkboxDiv").hide();
				$("#districtDiv").hide();
				$("#divisionDiv").hide();
				$("#upazillaDiv").hide();
				$("#blcDiv").show();
				$("#descriptionDiv").hide();
	        }
	        else if ($(this).val() == 'OTHERS') {
				$("#checkboxDiv").hide();
				$("#districtDiv").show();
				$("#divisionDiv").show();
				$("#upazillaDiv").show();
				$("#blcDiv").hide();
				$("#descriptionDiv").show();
	            // appends the 'appended' element to the 'body' tag
	           // $(appended).appendTo('body');
	        }
	        else {
	        	
	        }
	    }); 
	    
/* 	jQuery(document).delegate('input:radio[name="locationName"]', 'change', function() {
	var productId = $(this).val();

}); */

function filter(){
	debugger;
	var roleId = +$('#selectRole').val();
	var branchId = +$('#branches').val();
	if(roleId == "") {
		//startDate = $.datepicker.formatDate('yy-mm-dd', new Date());
		$("#roleValidation").html("<strong>Please fill out this field</strong>");
		return;
	}
	$("#roleValidation").html("");
/* 	if(endDate == "") {
		//endDate = $.datepicker.formatDate('yy-mm-dd', new Date());
		$("#endDateValidation").html("<strong>Please fill out this field</strong>");
		return;
	}
	$("#endDateValidation").html(""); */
	
	trainingAttendanceList = $('#addAttendanceList').DataTable({
        bFilter: false,
        serverSide: true,
        processing: true,
        columnDefs: [
            { targets: [0,1,2,3,4], orderable: false },
            { width: "10%", targets: 0 },
            { width: "25%", targets: 1 },
            { width: "20%", targets: 2 },
            { width: "20%", targets: 3 },
            { width: "25%", targets: 4 }
        ],
        ajax: {
            url: "/opensrp-dashboard/rest/api/v1/training/training-attendance-list",
            data: function(data){
					data.branchId = branchId;
					data.roleId = roleId;
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

$("#addTraining").submit(function(event) { 
	debugger;
	$("#loading").show();
	var url = "/opensrp-dashboard/rest/api/v1/training/save-update";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var userIdSet = [];
	var roleIdSet = [];
	$('#trainingList > tbody > tr').each(function(index, tr) {
			var $row = $(this).closest('tr'); //get the current row
			var selectedUsers = parseFloat($row.find('td').eq(1).text());
			var splitedItem = selectedUsers.split("_");
			var userId = parseInt(splitedItem[0]);
			var roleId = parseInt(splitedItem[1]);
			if(!isNaN(userId)) {
				userIdSet.push(userId);
			}
			if(!isNaN(roleId)) {
				roleIdSet.push(roleIdSet);
			}
		});
	var formData;
	
		formData = {
	            "title": $('input[name=trainingTitle]').val(),
	            "id":0,
	            "trainingId": $('input[name=trainingId]').val(),
	            "startDate": $("#trainingStartDate").val(),
	            "duration": $('input[name=trainingDuration]').val(),
	            "participantNumber": +$('input[name=participantNumber]').val(),
	            "nameOfTrainer": $('input[name=nameOfTrainer]').val(),
	            "designationOfTrainer": $('input[name=designationOfTrainer]').val(),
	            "division": divisionId,
	            "district": districtId,
	            "upazila": upazillaId,
	            "branch":branchId,
	            "trainingLocationType": trainingLocationType,
	            "type":"NA",
	            "description": $('input[name=description]').val(),
	            "blc":0,
	            "users":userIdSet,
	            "roles":roleIdSet,
	            "status":"ACTIVE" 
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
		   $("#serverResponseMessage").html(response.msg);
		   $("#loading").hide();
		   if(response.status == "SUCCESS"){					   
			   window.location.replace("/opensrp-dashboard/inventorydm/products-list.html");
			   
		   }
		   
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
});	
</script>



















