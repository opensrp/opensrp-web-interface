
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Location"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="org.opensrp.core.entity.FacilityTraining" %>
<%@page import="org.opensrp.core.entity.FacilityWorkerType" %>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="java.util.Iterator"%>


<%
String bahmniVisitURL = (String)session.getAttribute("bahmniVisitURL");
List<FacilityWorkerType> workerTypeList= (List<FacilityWorkerType>)session.getAttribute("workerTypeList");
int facilityId= (Integer)session.getAttribute("facilityId");
String facilityName= (String)session.getAttribute("facilityName");
Map<Integer,Integer> distinctWorkerCountMap = (Map<Integer,Integer>) session.getAttribute("distinctWorkerCountMap");
String detailsUrl = "/facility/"+facilityId+"/details.html";
String selectedPersonName = "";
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
		
		<jsp:include page="/WEB-INF/views/facility/facility-link.jsp" />
		<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
				<li class="breadcrumb-item">
				<a  href="<c:url value="/facility/${facility.id}/details.html?lang=${locale}"/>"> <strong><spring:message code="lbl.ccProfile"/></strong> </a>
				</li>		
		<%} %>
		
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<li class="breadcrumb-item">
		<a  href="<c:url value="/facility/${facility.id}/updateProfile.html?lang=${locale}"/>"> <strong><spring:message code="lbl.updateProfile"/></strong> </a>	 
		</li> 	
		<%} %>
		
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<li class="breadcrumb-item">
		<a  href="<c:url value="/facility/${facility.id}/addWorker.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addWorker"/></strong> </a>	 
		</li> 	
		<%} %>	
		
		<% if(AuthenticationManagerUtil.isPermitted("CREATE_MULTIPURPOSE_VOLUNTEER")){ %>
			<li class="breadcrumb-item">
			<a  href="<c:url value="/facility/mhv/${facility.id}/add.html?lang=${locale}"/>"> <strong><spring:message code="lbl.createMHV"/></strong> </a>	
			</li> 	
		<%} %>	
		
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<li class="breadcrumb-item">
			<a  href="<c:url value="/facility/${facility.id}/addCgCsg.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addCgCsg"/></strong> </a>	 
			</li> 	
		<%} %>	
		
		<jsp:include page="/WEB-INF/views/facility/bahmni-visit-link.jsp" />
		<%-- <% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
				<li class="breadcrumb-item">
				<a  href="https://103.247.238.36/bahmni/home/index.html#/login" target="_blank"> <strong><spring:message code="lbl.visit"/></strong> </a>
				</li>		
		<%} %> --%>
		</ol>
		</div>		
		
			<div class="card mb-3" id="addWorkerDiv">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.addWorker"/> (<b><%=facilityName %></b>)
				</div>
				<div class="card-body" >
				
					<%-- <form:form method="POST" action="${saveUrl}" modelAttribute="facilityWorker"> --%>
					<form:form id="workerInfo" >
					
					<div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.healthWorkerType"/></label>
										<select class="custom-select custom-select-lg mb-3" id="facilityWorkerTypeId" name="facilityWorkerTypeId" onchange="checkForTraining()" required>
									 		<option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
												<%
												//for removing chcp and multiPurposeHealthVolunteer from dropdown
												Iterator<FacilityWorkerType> i = workerTypeList.iterator();
												while (i.hasNext()) {
													FacilityWorkerType workerType = i.next();
													if(workerType.getName().equals("CHCP") 
															|| workerType.getName().equals("MULTIPURPOSE HEALTH VOLUNTEER")
															|| workerType.getName().equals("COMMUNITY GROUP MEMBER") 
															|| workerType.getName().equals("COMMUNITY SUPPORT-GROUP 1")
															|| workerType.getName().equals("COMMUNITY SUPPORT-GROUP 2")
															|| workerType.getName().equals("COMMUNITY SUPPORT-GROUP 3")){
														i.remove();
													}
												}
												//end:  removing chcp and multiPurposeHealthVolunteer from dropdown
												for (FacilityWorkerType workerType : workerTypeList)
												{
													if(workerType.getName().equals("HEALTH ASSISTANT")
															|| workerType.getName().equals("FAMILY WELFARE ASSISTANT")
															|| workerType.getName().equals("OTHER HEALTH WORKER")) {
														%>
															<option id="<%=workerType.getName()%>" value="<%=workerType.getId() %>"><%=workerType.getName()%></option>
														<%
													}
												}
												%>
											</select>
											<span class="text-red">${supervisorUuidErrorMessage}</span>
									</div>									
								</div>
						</div>
						
						
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<label class="form-check-label"><spring:message code="lbl.assigned"/> 
									<input type="checkbox" id="assigned" checked onchange="checkAssigned()"/></label>
									<p>${errorPermission}</p>
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
						
						
						<div class="form-group" id="workerNameWithSuggestionDiv" style="display: none;">
							<div class="row">
								<div class="col-5">
								<div id="cm" class="ui-widget">
										<label><spring:message code="lbl.healthWorkerName"/></label>
										<select id="combobox" name= "name" class="form-control" disabled>									  
										</select>
										 <span class="text-red">${uniqueNameErrorMessage}</span> 
									</div>
								</div>
							</div>
						</div>
						
						<div class="form-group" id="workerNameWithoutSuggestionDiv">
							<div class="row">
								<div class="col-5">
								<div id="cm" class="ui-widget">
										<label><spring:message code="lbl.healthWorkerName"/></label>
										<input name="name" class="form-control" required="required" 
										aria-describedby="nameHelp" id="comboboxWithoutSuggestion" />
										 <span class="text-red">${uniqueNameErrorMessage}</span> 
									</div>
								</div>
							</div>
						</div>
						
						<div class="form-group" id="contactDiv">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.healthWorkerContact"/></label>
									<input name="identifier" class="form-control" id="contact"
										required="required" aria-describedby="nameHelp" 
										pattern="^01[3-9]\d{8}$" title="11 digit mobile number, must start with 013-019 "
										placeholder="<spring:message code="lbl.healthWorkerContact"/>" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
						
						<input name="facilityId" id="facilityId" value="<%=facilityId%>" style="display: none;"/>
						<input name="newWorker" id="newWorker" value="1" style="display: none;"/>
						
						<div class="form-group" id="organizationDiv" style="visibility: hidden">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.healthWorkerOrganization"/></label>
									<input name="organization" class="form-control" id="organization"
										 aria-describedby="nameHelp"
										placeholder="<spring:message code="lbl.healthWorkerOrganization"/>" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
					
						
						<input type="text" id= "trainings" name="trainings" value="" style="display: none;" readonly>
						<div class="form-group" id="trainingDiv"  style="display: none;">
							<div class="form-check">
								<div class="row">
								<div class="col-10">
									<label for="exampleInputName"><spring:message code="lbl.trainingsOfChcp"/></label><br>
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
						
						
						<div class="form-group" >
							<div class="row">
								<div class="col-2">
									<%-- <button onclick="cancelWorkerEdit(<%=facilityId %>)" class="btn btn-danger btn-block"><spring:message code="lbl.cancel"/></button>
								 --%>
								 <a  href="<c:url value="/facility/${facility.id}/details.html?lang=${locale}"/>" class="btn btn-danger btn-block">
								 	 <strong><spring:message code="lbl.cancel"/></strong>
								 </a>
								 </div>
								<div class="col-2" id="saveButtonDiv">
									<input type="submit" value="<spring:message code="lbl.save"/>"
										class="btn btn-success btn-block"/>
								</div>
							</div>
						</div>
					</form:form>
				</div>
			</div>
			
			
			
			
			<%-- <div class="card mb-3">
				<div class="card-header">
				<div class="row">
					<div class="col-10">
					<i class="fa fa-table"></i> <spring:message code="lbl.workerList"/> (<b><%=facilityName %></b>)
					</div>
						<div class="col-2">
							<button onclick="showAddWorkerDiv()" class="btn btn-primary btn-block"><spring:message code="lbl.addNew"/></button>
						</div>
				</div>
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
													style="width: 140px;"><spring:message code="lbl.healthWorkerType"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.name"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;"><spring:message code="lbl.contact"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.organization"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.training"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.action"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.action"/></th>
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
			</div> --%>
		
			
		</div>
		
		
		
		
		
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	

  
<script type="text/javascript" charset="utf8" src="<c:url value='/resources/datatables/jquery.dataTables.js'/>" ></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script type="text/javascript"> 
  $( function() {
	initializeDistinctWorkerCountArray();
	getWorkerList($("#facilityId").val());  
	
    $.widget( "custom.combobox", {
      _create: function() {
        this.wrapper = $( "<div>" )
          .addClass( "custom-combobox" )          
          .insertAfter( this.element );
 
        this.element.hide();
        this._createAutocomplete();
       
      },
      _createAutocomplete: function() {
        var selected = this.element.children( ":selected" ),        
          value = selected.val() ? selected.text() : "";
          value = "<%=selectedPersonName%>";
        this.input = $( "<input required='required'>" )
          .appendTo( this.wrapper )
          .val( value )
          .attr( "title", "" )          
           .attr( "name", "personName" )
          .addClass( "form-control custom-combobox-input ui-widget ui-widget-content  ui-corner-left" )
          .autocomplete({
            delay: 0,
            minLength: 1,
            source: $.proxy( this, "_source" )
          })
          .tooltip({
            classes: {
              "ui-tooltip": "ui-state-highlight"
            }
          });
        this._on( this.input, {
          autocompleteselect: function( event, ui ) {
            ui.item.option.selected = true;
 			$("#person").val(ui.item.option.value);
            this._trigger( "select", event, {
              item: ui.item.option
            });
          },
 
          autocompletechange: "_removeIfInvalid"
        });
      },
 
      _source: function( request, response ) {
    	  var workerTypeId = $("#facilityWorkerTypeId").val();
    	  $.ajax({
              type: "GET",
              dataType: 'html',
              //url: "/opensrp-dashboard/facility/searchWorkerName.html?name="+request.term,
              url: "/opensrp-dashboard/facility/searchWorkerName.html?name="+request.term+"&workerTypeId="+workerTypeId,
              success: function(res)
              {
                $("#combobox").html(res);
              }
          });
        var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
        response( this.element.children( "option" ).map(function() {
          var text = $( this ).text();
          if ( this.value && ( !request.term || matcher.test(text) ) )
            return {
              label: text,
              value: text,
              option: this
            };
        }) );
      },
 
      _removeIfInvalid: function( event, ui ) {
        // Selected an item, nothing to do
        if ( ui.item ) {
          return;
        }
        // Search for a match (case-insensitive)
        var value = this.input.val(),
          valueLowerCase = value.toLowerCase(),
          valid = false;
        this.element.children( "option" ).each(function() {
          if ( $( this ).text().toLowerCase() === valueLowerCase ) {
            this.selected = valid = true;
            return false;
          }
        });
        // Found a match, nothing to do
        if ( valid ) {
          return;
        }
        // Remove invalid value
        this.input
          .val( "" )
          .attr( "title", value + " didn't match any item" )
          .tooltip( "open" );
        $("#person").val(0);
        this.element.val( "" );
        this._delay(function() {
          this.input.tooltip( "close" ).attr( "title", "" );
        }, 2500 );
        this.input.autocomplete( "instance" ).term = "";
      },
 
      _destroy: function() {
        this.wrapper.remove();
        this.element.show();
      }
    });
 
    
    $( "#combobox" ).combobox();
   // $("#combobox").combobox("option", "disabled", true); 
    
    $( "#toggle" ).on( "click", function() {
      $( "#combobox" ).toggle();
    });
    
  } );

$("#workerInfo").submit(function(event) { 
	var url = "/opensrp-dashboard/rest/api/v1/facility/saveWorker";
	var workerName = "Not Assigned";
	var workerIdentifier = "-";
	var workerOrganization = "-";
	
	if(isAssigned === 1){
		console.log("an worker is assigned");
		if(isSuggestionActive==1){
			//workerName = $("#combobox").val();
			workerName = document.getElementsByName("personName")[0].value;
		}else{
			workerName = $("#comboboxWithoutSuggestion").val();
		}
		workerIdentifier = $('input[name=identifier]').val();
		workerOrganization = $('input[name=organization]').val();
	}
	var formData = {
			'workerId': '-99',
            'name': workerName,
            'identifier': workerIdentifier,
            'organization': workerOrganization,
            'facilityWorkerTypeId': $("#facilityWorkerTypeId").val(),
            'facilityTrainings': $('input[name=trainings]').val(),
            'facilityId': $("#facilityId").val()
        };
	var detailsPageUrl = "/opensrp-dashboard/facility/"+$("#facilityId").val()+"/details.html";
	var addWorkerPageUrl = "/opensrp-dashboard/facility/"+$("#facilityId").val()+"/addWorker.html";
	var updateProfilePageUrl = "/opensrp-dashboard/facility/"+$("#facilityId").val()+"/updateProfile.html";
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	event.preventDefault();
	/* if($("#newWorker").val() === "0"){
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
	} */
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
		   window.location.replace(updateProfilePageUrl);
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
var previousWorkerType ;
var distinctWorkerCountArrayForEdit;

function showAddWorkerDiv(){
			 $("#addWorkerDiv").show();
}

function initializeDistinctWorkerCountArray(){
	var distinctWorkerCountString = "<%=distinctWorkerCountMap%>" ;
	distinctWorkerCountString = removeBraces(distinctWorkerCountString);
	distinctWorkerCountArray = stringTOArray(distinctWorkerCountString, ",");
	for(var i=0;i<distinctWorkerCountArray.length;i++){
		distinctWorkerCountArray[i] = stringTOArray(distinctWorkerCountArray[i], "=");
	}
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

var isAssigned = 1;
function checkAssigned(){
	if($("#assigned").is(':checked')){
		isAssigned = 1;
		//$("#workerNameWithoutSuggestionDiv").show();
		//$( "#comboboxWithoutSuggestion" ).prop( "disabled", false );
		checkForTraining();
		
		$("#contactDiv").show();
		$( "#contact").prop( "disabled", false );
		$("#organizationDiv").show();
		$( "#organization" ).prop( "disabled", false );
	}else{
		isAssigned = 0;
		//$("#workerNameWithoutSuggestionDiv").hide();
		//$( "#comboboxWithoutSuggestion" ).prop( "disabled", true );
		hideNameWithoutSuggestionDiv();
		hideNameWithSuggestionDiv();
		
		$("#contactDiv").hide();
		$( "#contact").prop( "disabled", true );
		$("#organizationDiv").hide();
		$( "#organization" ).prop( "disabled", true );
	}
}


var prevTrainings ="";
function checkForTraining(){
	check();
	hideWarning();
	$("#saveButtonDiv").show();
	if($("#newWorker").val() === "1"){
		checkForTrainingNewWorker();
	}else if($("#newWorker").val() === "0"){
		checkForTrainingOldWorker();
	}
}

var isSuggestionActive =0;
function showNameWithSuggestionDiv(){
	//alert("suggestion");
	$("#combobox").combobox("option", "disabled", false); 
	isSuggestionActive =1;
	
	$("#workerNameWithoutSuggestionDiv").hide();
	$( "#comboboxWithoutSuggestion" ).prop( "disabled", true );
	
	$("#workerNameWithSuggestionDiv").show();
	//$( "#combobox" ).prop( "disabled", false );
	$("#combobox").parent().find("input.ui-autocomplete-input").autocomplete("option", "disabled", false).prop("disabled",false);
	$("#combobox").parent().find("a.ui-button").button("enable");
	
	
}

function showNameWithoutSuggestionDiv(){
	//alert("without Suggestion");
	$("#combobox").combobox("option", "disabled", true); 
	isSuggestionActive =0;
	
	$("#workerNameWithoutSuggestionDiv").show();
	$( "#comboboxWithoutSuggestion" ).prop( "disabled", false );
	
	$("#workerNameWithSuggestionDiv").hide();
	//$( "#combobox" ).prop( "disabled", true );
	$("#combobox").parent().find("input.ui-autocomplete-input").autocomplete("option", "disabled", true).prop("disabled",true);
	$("#combobox").parent().find("a.ui-button").button("disable");
}

function hideNameWithoutSuggestionDiv(){
	$("#workerNameWithoutSuggestionDiv").hide();
	$( "#comboboxWithoutSuggestion" ).prop( "disabled", true );
}

function hideNameWithSuggestionDiv(){
	$("#combobox").combobox("option", "disabled", true); 
	
	$("#workerNameWithSuggestionDiv").hide();
	//$( "#combobox" ).prop( "disabled", true );
	$("#combobox").parent().find("input.ui-autocomplete-input").autocomplete("option", "disabled", true).prop("disabled",true);
	$("#combobox").parent().find("a.ui-button").button("disable");
	
	
}

function checkForTrainingOldWorker(){
	var workerType =$("#facilityWorkerTypeId").val();
	
	if(workerType === '7' || workerType === '8' || workerType === '9' || workerType === '10' || workerType === '11'){
		showNameWithSuggestionDiv();
	}else{
		showNameWithoutSuggestionDiv();
	}
	//end:for name suggestion
	if(workerType === '1'){
		warnUser("CHCP", -1);
		if(distinctWorkerCountArrayForEdit[0][1] >0){
			warnUser("CHCP", 1);
		}else{
			$("#trainingDiv").show();
			$("#trainings").val(prevTrainings);
		}
	}else{
		$("#trainingDiv").hide();
		prevTrainings = $("#trainings").val();
		$("#trainings").val("");
		if(workerType === '2' && distinctWorkerCountArrayForEdit[1][1] >0){
				warnUser("HEALTH ASSISTANT", 1); 
		}else if(workerType === '3' && distinctWorkerCountArrayForEdit[2][1] >0){
				warnUser("ASSISTANT HEALTH INSPECTOR", 1);
		}else if(workerType === '4' && distinctWorkerCountArrayForEdit[3][1] >0){
				warnUser("FAMILY PLANNING ASSISTANT", 1);
		}else if(workerType === '5' && distinctWorkerCountArrayForEdit[4][1] >0){
				warnUser("FAMILY PLANNING INSPECTOR", 1);  
		}else if(workerType === '6' ){
				warnUser("MULTIPURPOSE HEALTH VOLUNTEER", -1); 
				if(distinctWorkerCountArrayForEdit[5][1] >4){
					warnUser("MULTIPURPOSE HEALTH VOLUNTEER", 5); 
				}
		}else if(workerType === '7' && distinctWorkerCountArrayForEdit[6][1] >0){
				warnUser("OTHER HEALTH WORKER", 1);
		}else if(workerType === '8' && distinctWorkerCountArrayForEdit[7][1] >16){
				warnUser("COMMUNITY GROUP MEMBER", 17);
		}else if(workerType === '9' && distinctWorkerCountArrayForEdit[8][1] >16){
				warnUser("COMMUNITY SUPPORT-GROUP-1 MEMBER", 17); 
		}else if(workerType === '10' && distinctWorkerCountArrayForEdit[8][1] >16){
				warnUser("COMMUNITY SUPPORT-GROUP-2 MEMBER", 17); 
		}else if(workerType === '11' && distinctWorkerCountArrayForEdit[8][1] >16){
				warnUser("COMMUNITY SUPPORT-GROUP-3 MEMBER", 17); 
		}			
	} 
}

function checkForTrainingNewWorker(){
	var workerType =$("#facilityWorkerTypeId").val();
	
	if(isAssigned === 1){
		if(workerType === '7' || workerType === '8' || workerType === '9'){
			// showNameWithSuggestionDiv();
			showNameWithoutSuggestionDiv();
		}else{
			showNameWithoutSuggestionDiv();
		}
	}
	
	//end:for name suggestion
	if(workerType === '1'){
		warnUser("CHCP", -1);
		if(distinctWorkerCountArray[0][1]>0){
			warnUser("CHCP", 1);
		}else{
			$("#trainingDiv").show();
			$("#trainings").val(prevTrainings);
		}
	}else{
		$("#trainingDiv").hide();
		prevTrainings = $("#trainings").val();
		$("#trainings").val("");
		if(workerType === '2' && distinctWorkerCountArray[1][1]>1){
				warnUser("HEALTH ASSISTANT", 2); 
		}else if(workerType === '3' && distinctWorkerCountArray[2][1]>0){
				//warnUser("ASSISTANT HEALTH INSPECTOR", 1);
		}else if(workerType === '4' && distinctWorkerCountArray[3][1]>1){
				warnUser("FAMILY WELFARE ASSISTANT", 2);
		}else if(workerType === '5' && distinctWorkerCountArray[4][1]>0){
				//warnUser("FAMILY PLANNING INSPECTOR", 1);  
		}else if(workerType === '7' && distinctWorkerCountArray[6][1]>0){
				//warnUser("OTHER HEALTH WORKER", 1);
		}
		
		
	} 
}

function warnUser(workerType, validNumber){
	if(workerType == "CHCP" || workerType == "MULTIPURPOSE HEALTH VOLUNTEER"){
		var messageStr = workerType + " cannot be added in this interface. Please go to 'ADD USER'";
	}else if(validNumber === 1){
		var messageStr = "Already has a "+workerType+". Please delete the previous one and try again.";
	}else if(validNumber >1){
		var messageStr = "Number of "+workerType+" cannot be more than "+validNumber+".";
	}
	$("#msg").text(messageStr);
	$("#messageDiv").show();
	$("#saveButtonDiv").hide();
}

function hideWarning(){
	$("#msg").text("");
	$("#messageDiv").hide();
}

function getWorkerList(id) {
	var workerListURL ="/opensrp-dashboard/facility/"+id+"/getWorkerList.html";
    $.ajax(workerListURL, {
        type: 'GET',
        dataType: 'html',
    }).done(function(workerList) {
    	
    	$("#dataTableBody").html(workerList);
    	showOnDataTable();
    	
    }).error(function() {
    });
}

function editWorker(workerId) {
	var workerListURL ="/opensrp-dashboard/facility/"+workerId+"/editWorker.html";
    $.ajax(workerListURL, {
        type: 'GET',
        dataType: 'html',
    }).done(function(workerDetails) {
    	$("#addWorkerDiv").show();
    	$("#workerInfo").html(workerDetails);
    	previousWorkerType =$("#facilityWorkerTypeId").val();
    	var prevWorkerTypeId = parseInt(previousWorkerType);
    	distinctWorkerCountArrayForEdit = JSON.parse(JSON.stringify(distinctWorkerCountArray));
    	distinctWorkerCountArrayForEdit[prevWorkerTypeId -1][1]--;
    }).error(function() {
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
		   window.location.replace(addWorkerPageUrl);
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
    
}

function cancelWorkerEdit(facilityId){
	var addWorkerPageUrl = "/opensrp-dashboard/facility/"+facilityId+"/addWorker.html";
	//window.location.replace(addWorkerPageUrl);
	$("#workerInfo").trigger('reset');
}

function showOnDataTable(){
	  $('#dataTable').DataTable();
}

</script>

<script type='text/javascript'>
  $(document).ready(function(){
       $('#facilityWorkerTypeId').change(function(){
           if ($(this).children(":selected").attr("id") == 'OTHER HEALTH WORKER') {
               $('#organizationDiv').css({'visibility':'visible'});      
           } else {
        	   $('#organizationDiv').css({'visibility':'hidden'});
        	   $('#organization').val("");
           }
        });
  });
</script>	
	  
</body>
</html>
