
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.acl.entity.Location"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="org.opensrp.facility.entity.FacilityTraining" %>
<%@page import="org.opensrp.facility.entity.FacilityWorkerType" %>
<%
List<FacilityWorkerType> workerTypeList= (List<FacilityWorkerType>)session.getAttribute("workerTypeList");
int facilityId= (Integer)session.getAttribute("facilityId");
String facilityName= (String)session.getAttribute("facilityName");
Map<Integer,Integer> distinctWorkerCountMap = (Map<Integer,Integer>) session.getAttribute("distinctWorkerCountMap");
	%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" href="<c:url value="/resources/css/jqx.base.css"/>" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>">


<meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Add Worker</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/facility/saveWorker.html" />
<c:url var="deleteUrl" value="/facility/deleteWorker.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<jsp:include page="/WEB-INF/views/facility-url.jsp" />
		
		<div class="form-group">	
		<a  href="/opensrp-dashboard/facility/<%=facilityId%>/details.html"> <strong>CC Profile</strong> </a>		
		</div>
		
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Add Worker (<b><%=facilityName %></b>)
				</div>
				<div class="card-body">
				
					<%-- <form:form method="POST" action="${saveUrl}" modelAttribute="facilityWorker"> --%>
					<form:form id="workerInfo" >
					
					<div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName">স্বাস্থ্য কর্মীর প্রকারভেদ</label>
										<select class="custom-select custom-select-lg mb-3" id="facilityWorkerTypeId" name="facilityWorkerTypeId" onchange="checkForTraining()" required>
									 		<option value="" selected>Please Select</option>
												<%
												for (FacilityWorkerType workerType : workerTypeList)
												{
														%>
															<option value="<%=workerType.getId() %>"><%=workerType.getName()%></option>
														<%
												}
												%>
											</select>
											<span class="text-red">${supervisorUuidErrorMessage}</span>
									</div>									
								</div>
						</div>
						
						
						<div class="form-group" id="messageDiv"  style="display: none;">
							<div class="form-check">
								<div class="row">
									<div class="col-10">
										<label for="exampleInputName" id="msg" style="color:Tomato;border:2px solid Tomato;"></label><br>
									</div>
								</div>
							</div>
						</div>
						
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">স্বাস্থ্য কর্মীর নাম  </label>
									<input name="name" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Worker Name" /> 
									<span class="text-red">${uniqueNameErrorMessage}</span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">স্বাস্থ্য কর্মীর মোবাইল নম্বর / ইমেইল </label>
									<input name="identifier" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Identifier (Email/Mobile No.)" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
						
						<input name="facilityId" id="facilityId" value="<%=facilityId%>" style="display: none;"/>
						<input name="newWorker" id="newWorker" value="1" style="display: none;"/>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">স্বাস্থ্য কর্মীর প্রতিষ্ঠান</label>
									<input name="organization" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Organization" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
					
					
					
					
					
					    
						
						
						<input type="text" id= "trainings" name="trainings" value="" style="display: none;" readonly>
						<div class="form-group" id="trainingDiv"  style="display: none;">
							<div class="form-check">
								<div class="row">
								<div class="col-10">
									<label for="exampleInputName">সিএইচসিপির প্রাপ্ত প্রশিক্ষণ সমূহ:</label><br>
								</div>
									<%
										List<FacilityTraining> CHCPTrainingList = (List<FacilityTraining>) session.getAttribute("CHCPTrainingList");											
										for (FacilityTraining facilityTraining : CHCPTrainingList) {
									%>
									<div class="col-5">
										<input type="checkbox" value=<%=facilityTraining.getId()%> onclick="check()">
												
										<label class="form-check-label" for="defaultCheck1"> <%=facilityTraining.getName()%>
										</label>
									</div>
									<%
										}
										%>


								</div>
							</div>
							
						</div>
						
						
						
						
						
							
						
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="Save"
										class="btn btn-primary btn-block"/>
								</div>
							</div>
						</div>
					</form:form>
				</div>
			</div>
			
			
			
			
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Worker List (<b><%=facilityName %></b>)
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<div id="dataTable_wrapper"
							class="dataTables_wrapper container-fluid dt-bootstrap4">
							<div class="row">
								<div class="col-sm-12">
									<table class="table table-bordered dataTable" id="dataTable"
										style="width: 100%;">
										<thead>
											<tr>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Worker Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Identifier</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Organization</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Training</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Action</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Action</th>
											</tr>
										</thead>
										
										
										
										
										<tbody id="dataTableBody">
										
										</tbody>
										
									</table>

								</div>
							</div>

						</div>
					</div>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
			
			
			
			
			
			
			
		</div>
		
		
		
		
		
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	

  
<script type="text/javascript" charset="utf8" src="<c:url value='/resources/datatables/jquery.dataTables.js'/>" ></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js'/>"></script>

	
<script type="text/javascript"> 


$("#workerInfo").submit(function(event) { 
	var url = "/opensrp-dashboard/rest/api/v1/facility/saveWorker";
	var formData = {
			'workerId': '-99',
            'name': $('input[name=name]').val(),
            'identifier': $('input[name=identifier]').val(),
            'organization': $('input[name=organization]').val(),
            'facilityWorkerTypeId': $("#facilityWorkerTypeId").val(),
            'facilityTrainings': $('input[name=trainings]').val(),
            'facilityId': $("#facilityId").val()
        };
	var detailsPageUrl = "/opensrp-dashboard/facility/"+$("#facilityId").val()+"/details.html";
	var addWorkerPageUrl = "/opensrp-dashboard/facility/"+$("#facilityId").val()+"/addWorker.html";
	
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	event.preventDefault();
	
	
	if($("#newWorker").val() === "0"){
		//alert("old worker : "+$("#facilityId").val()+" -> "+$("#workerId").val());
		url = "/opensrp-dashboard/rest/api/v1/facility/editWorker";
		formData = {
				'workerId': $("#workerId").val(),
	            'name': $('input[name=name]').val(),
	            'identifier': $('input[name=identifier]').val(),
	            'organization': $('input[name=organization]').val(),
	            'facilityWorkerTypeId': $("#facilityWorkerTypeId").val(),
	            'facilityTrainings': $('input[name=trainings]').val(),
	            'facilityId': $("#facilityId").val()
	        };
	}else if($("#newWorker").val() === "1"){
		//alert("new worker");
		var newWorkerType = $("#facilityWorkerTypeId").val();
		var chcp = '1';
		if(newWorkerType == chcp && distinctWorkerCountArray[newWorkerType-1][1]>0){
			var messageStr = "Already has a chcp. Please delete the previous one and try again.";
			alert(messageStr);
			//$("#msg").text(messageStr);
			//$("#messageDiv").show();
			return;
		}
	}
	
	
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
		   //getWorkerList($("#facilityId").val());
		   window.location.replace(addWorkerPageUrl);
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
});	


var trainingList = [];
var facilityWorkerList;
var i=0;
var distinctWorkerCountArray;
$(document).ready(function() {
	initializeDistinctWorkerCountArray();
	//$("#trainings").hide();
	//$("#trainingDiv").hide();
	getWorkerList($("#facilityId").val());
	//$('#dataTable').DataTable();
	
});

function initializeDistinctWorkerCountArray(){
	var distinctWorkerCountString = "<%=distinctWorkerCountMap%>" ;
	var distinctWorkerCountString = removeBraces(distinctWorkerCountString);
	distinctWorkerCountArray = stringTOArray(distinctWorkerCountString, ",");
	for(var i=0;i<distinctWorkerCountArray.length;i++){
		distinctWorkerCountArray[i] = stringTOArray(distinctWorkerCountArray[i], "=");
	}
	//alert(distinctWorkerCountArray);
}

function removeBraces(inputString){
	inputString = inputString.replace(/{/g, '').replace(/}/g, '');
	return inputString;
}
function stringTOArray(inputString, separator){
	var array = inputString.split(separator);
	return array;
}

function check(){
	var allVals = [];
	$('input:checked').each(function () {
		allVals.push($(this).val());
	});
	trainingList = allVals;
	$("#trainings").val(trainingList.toString());
}

var prevTrainings ="";
function checkForTraining(){
	check();
	hideWarning();
	//alert($("#trainings").val());
	var chcp = '1';
	var workerType =$("#facilityWorkerTypeId").val();
	if(workerType === '1'){
		if(distinctWorkerCountArray[0][1]>0){
			warnUser("CHCP", 1);
		}
		$("#trainingDiv").show();
		$("#trainings").val(prevTrainings);
	}else{
		$("#trainingDiv").hide();
		prevTrainings = $("#trainings").val();
		$("#trainings").val("");
		
		//alert(workerType);
		if(workerType === '2'){
			if(distinctWorkerCountArray[1][1]>0){
				warnUser("HEALTH ASSISTANT", 1);
			}  
		}else if(workerType === '3'){
			if(distinctWorkerCountArray[2][1]>0){
				warnUser("ASSISTANT HEALTH INSPECTOR", 1);
			}  
		}else if(workerType === '4'){
			if(distinctWorkerCountArray[3][1]>0){
				warnUser("FAMILY PLANNING ASSISTANT", 1);
			}  
		}else if(workerType === '5'){
			if(distinctWorkerCountArray[4][1]>0){
				warnUser("FAMILY PLANNING INSPECTOR", 1);
			}  
		}else if(workerType === '6'){
			if(distinctWorkerCountArray[5][1]>0){
				warnUser("MULTIPURPOSE HEALTH VOLUNTEER", 1);
			}  
		}else if(workerType === '7'){
			if(distinctWorkerCountArray[6][1]>0){
				warnUser("OTHER HEALTH WORKER", 1);
			}  
		}else if(workerType === '8'){
			if(distinctWorkerCountArray[7][1]>16){
				warnUser("COMMUNITY GROUP MEMBER", 17);
			}  
		}else if(workerType === '9'){
			if(distinctWorkerCountArray[8][1]>16){
				warnUser("COMMUNITY SUPPORT-GROUP MEMBER", 17);
			}  
		}
		
			
	} 
	
}

function warnUser(workerType, validNumber){
	if(validNumber === 1){
		var messageStr = "Already has a "+workerType+". Please delete the previous one and try again.";
	}else if(validNumber >1){
		var messageStr = "Number of "+workerType+"cannot be more than "+validNumber+".";
	}
	
	$("#msg").text(messageStr);
	$("#messageDiv").show();
}

function hideWarning(){
	$("#msg").text("");
	$("#messageDiv").hide();
}


function getWorkerList(id) {
	var workerListURL ="/opensrp-dashboard/facility/"+id+"/getWorkerList.html";
	//var workerListURL = "/rest/api/v1/facility/"+id+"/getWorkerList.html";
	
    $.ajax(workerListURL, {
        type: 'GET',
        dataType: 'html',
    }).done(function(workerList) {
    	
    	$("#dataTableBody").html(workerList);
    	//refreshDataTable();
    	showOnDataTable();
    	
    }).error(function() {
        //alert('Error');
    });
}

function editWorker(workerId) {
	var workerListURL ="/opensrp-dashboard/facility/"+workerId+"/editWorker.html";
	
    $.ajax(workerListURL, {
        type: 'GET',
        dataType: 'html',
    }).done(function(workerDetails) {
    	
    	$("#workerInfo").html(workerDetails);
    	
    }).error(function() {
        //alert('Error');
    });
}

function deleteWorker(facilityId,workerId) {
	var detailsPageUrl = "/opensrp-dashboard/facility/"+facilityId+"/details.html";
	var addWorkerPageUrl = "/opensrp-dashboard/facility/"+facilityId+"/addWorker.html";
	var url = "/opensrp-dashboard/rest/api/v1/facility/deleteWorker";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var formData = {
            'workerId': workerId
        };
	
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
		   //getWorkerList($("#facilityId").val());
		   window.location.replace(addWorkerPageUrl);
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
    
}

function showOnDataTable(){
	  $('#dataTable').DataTable();
}
function refreshDataTable(){
	//$("#dataTable").datatable().fnDestroy();
    //$("#dataTable").dataTable();
    /* var table = $('#dataTable').DataTable();
    table.draw(); */
	
}


</script>	
	  
</body>
</html>
