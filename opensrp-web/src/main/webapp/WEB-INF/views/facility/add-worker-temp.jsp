<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

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
	%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" href="<c:url value="/resources/css/jqx.base.css"/>" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/resources/css/dataTables.jqueryui.min.css">

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
		<div class="form-group">				
				   <a  href="<c:url value="/facility/add.html"/>" > <strong>Registration</strong> 
					</a>  |  <a  href="<c:url value="/facility/index.html"/>"> <strong>Community Clinic</strong>
					</a>		
		</div>
		
		
		<div class="form-group">	
		<a  href="/facility/<%=facilityId%>/details.html"> <strong>Details</strong> </a>		
		</div>
		
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Add Worker
				</div>
				<div class="card-body">
				
					<%-- <form:form method="POST" action="${saveUrl}" modelAttribute="facilityWorker"> --%>
					<form:form id="workerInfo" >
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Name  </label>
									<input name="name" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Name" /> 
									<span class="text-red">${uniqueNameErrorMessage}</span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Identifier (Email/Mobile No.)</label>
									<input name="identifier" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Identifier (Email/Mobile No.)" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
						
						<input name="facilityId" id="facilityId" value="<%=facilityId%>" style="display: none;"/>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Organization</label>
									<input name="organization" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Organization" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
					
					
					
					
					
					    <div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName">Worker type</label>
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
						
						
						<input type="text" id= "trainings" name="trainings" value="" style="display: none;" readonly>
						<div class="form-group" id="trainingDiv"  style="display: none;">
							<div class="form-check">
								<div class="row">

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
					<i class="fa fa-table"></i> Worker List
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
											</tr>
										</thead>
										
										
										<tfoot>
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
											</tr>
										</tfoot>
										
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
	

  
<script type="text/javascript" charset="utf8" src="/resources/datatables/jquery.dataTables.js"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js'/>"></script>

	
<script type="text/javascript"> 


$("#workerInfo").submit(function(event) { 
	var detailsPageUrl = "/facility/"+$("#facilityId").val()+"/details.html";
	var url = "/rest/api/v1/facility/saveWorker";			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	var formData = {
            'name': $('input[name=name]').val(),
            'identifier': $('input[name=identifier]').val(),
            'organization': $('input[name=organization]').val(),
            'facilityWorkerTypeId': $("#facilityWorkerTypeId").val(),
            'facilityTrainings': $('input[name=trainings]').val(),
            'facilityId': $("#facilityId").val()
        };
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
		   //getWorkerList($("#facilityId").val());
		   window.location.replace(detailsPageUrl);
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
$(document).ready(function() {
	//$("#trainings").hide();
	//$("#trainingDiv").hide();
	getWorkerList($("#facilityId").val());
	//$('#dataTable').DataTable();
	
});

function check(){
	var allVals = [];
	$('input:checked').each(function () {
		allVals.push($(this).val());
	});
	trainingList = allVals;
	$("#trainings").val(trainingList.toString());
}

function checkForTraining(){
	var chcp = '1';
	var workerType =$("#facilityWorkerTypeId").val();
	if(workerType === chcp){
		$("#trainingDiv").show();
	}else{
		$("#trainingDiv").hide();
	}
	
}

function getWorkerList(id) {
	var workerListURL ="getWorkerList.html";
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

function deleteWorker(workerId) {
	var detailsPageUrl = "details.html";
	var url = "/rest/api/v1/facility/deleteWorker";			
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
		   window.location.replace(detailsPageUrl);
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
