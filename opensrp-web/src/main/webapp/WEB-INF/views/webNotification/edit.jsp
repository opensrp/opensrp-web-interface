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
	
	
<jsp:include page="/WEB-INF/views/header.jsp" />
<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">
<link type="text/css"
	href="<c:url value="/resources/css/magicsuggest-min.css"/>"
	rel="stylesheet"
	http-equiv="Cache-control" content="public">
	<link type="text/css"
	href="<c:url value="/resources/css/jquery-ui.css"/>"
	rel="stylesheet"
	http-equiv="Cache-control" content="public">
<script src="<c:url value='/resources/js/magicsuggest.js' />"></script>

<link type="text/css" href="<c:url value="/resources/css/jquery.simple-dtpicker.css"/>" rel="stylesheet">


<c:url var="roles" value="/rest/api/v1/web-notfication/roles" />
<c:url var="add" value="/rest/api/v1/web-notfication/save-update" />
<c:url var="back" value="/web-notification/list.html" />/

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
				<div class="center-caption">Edit web notification</div>


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
				<form id="addWebNotification">
				
				<!-- First Half of Form Starts -->
				
				<div class="col-lg-6">
					<div class="form-group row">
						<label for="trainingTitle" class="col-sm-4 col-form-label">Notification title<span class="text-danger"> </span> </label>
						<div class="col-sm-12">
							<input type="text" class="form-control" value="${webNotification.notificationTitle}" id="notificationTitle" name ="notificationTitle">
						</div>
					</div>
					<div class="form-group row">
						<label for="notification" class="col-sm-4 col-form-label">Notification<span class="text-danger"> </span> </label>
						<div class="col-sm-12">
							<textarea id="notification" name="notification" style="margin: 0px -11px 0px 0px; height: 107px; width: 100%;" class="form-control">${webNotification.notification}</textarea>
						</div>
					</div>
					
					<div class="form-group row">
						<label for="notification" class="col-sm-4 col-form-label">Recipient types<span class="text-danger"> </span> </label>
						<div class="col-sm-12">
							<input name="roles"  id="roles" type="text" class="form-control">
						</div>
					</div>	
					<div class="form-group row">
						<label for="notification" class="col-sm-4 col-form-label">Date & time<span class="text-danger"> </span> </label>
						<div class="col-sm-12">
							<input name="date"  id="date" type="text" class="form-control" value="${dateTime }">
						</div>
					</div>
						
					</div>
					<div class="col-lg-12">
						<div class="form-group">
						<jsp:include page="/WEB-INF/views/select-options-with-branch.jsp" />
						</div>
					</div>
					
					<div class="col-lg-12">
						<div class="form-group text-right" id="errorText">
						
						</div>
					</div>
					
					
					<div class="form-group row"></div>
					<div class="form-group row">
						<div class="col-lg-12 form-group text-right">
							<a href="${back}" class="btn btn-primary">Back</a>
							<button type="submit"  class="btn btn-primary webNotificationClass" value="DRAFT">Save as draft</button>
							<button type="submit"  class="btn btn-primary webNotificationClass" value="SCHEDULE">Schedule</button>
							<button type="submit"  class="btn btn-primary webNotificationClass" value="SEND">Send</button>
							      		
						</div>
					</div>
				</form>
				 
				
				
			</div>
		</div>
		
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<%-- <jsp:include page="/WEB-INF/views/dataTablejs.jsp" />
 --%>
<script src="<c:url value='/resources/js/jquery.simple-dtpicker.js' />"></script>

<script>

var rolesArray = [];
'<c:forEach items="${webNotification.getWebNotificationRoles()}" var="itm">'
	rolesArray.push("${itm.getRole()}"); 
'</c:forEach>'
window.rolesSelected =  rolesArray 

$('#roles').magicSuggest({
	placeholder: 'Select recipients type',
	data : '${roles}',
	allowFreeEntries: false,
	method: 'get',
	valueField : 'id',
	displayField : 'name',
	name : 'roles',
	inputCfg: {"class":"magicInput"},
	useCommaKey: true,
	maxEntryLength: 150,
	required: true,	
	maxEntryRenderer: function(v) {
		    return '<div style="color:red">Error Typed Word TOO LONG </div>';
		  },
	value:rolesSelected
});


$(function(){
	
	  $('[name=date]').appendDtpicker({
		  "closeOnSelected": true,
		  "todayButton":false,
		  "closeButton":false,
		  "minDate":new Date(),
		  "default":null,

	  });
	  if('${webNotification.getType()}'=='SCHEDULE'){
	  	
	  }else{
		  $("#date").val("");
	  }
});


let type="";
$(".webNotificationClass").on('click', function() { 	
	type = $(this).val();
 	
});
  

$('#addWebNotification').submit(function(event) {
    event.preventDefault();
   
    let validation = Validate();
    if(validation == false){
    	return false;
    }
    let url = '${add}';
    let token = $("meta[name='_csrf']").attr("content");
    let header = $("meta[name='_csrf_header']").attr("content");
    let formData;
    let enableSimPrint = false;
    var roles = [];
    $('input[name^="roles"]').each(function() {           
    	roles.push($(this).val());
    }); 
    let divisionId = $('#divisionList').val();
    let districtId = $('#districtList').val();
    let upazilaId = $('#upazilaList').val();
   
    let branchId = $('#branchList').val();
   
    let locationId = 0;
    let locationType="LOCATION";
    if(branchId !=0){
		locationId = branchId;
		locationType="BRANCH";
	}else if(upazilaId !=0){
		locationId = upazilaId;
		locationType="LOCATION";
		
	}else if(districtId != 0){
		locationId = districtId;
		locationType="LOCATION";
		
	}else if(divisionId != 0){
		locationId =divisionId; 
		locationType="LOCATION";
		
	}
   
    
    let dateTime = $("#date").val();
    let sendDate="2020-09-01";
    let hour = 0;
    let minute=0;
    if(dateTime != ""){
	    let dateTimeInArray = dateTime.split(" ");
	    let timeInArray = dateTimeInArray[1].split(":");
	     sendDate = dateTimeInArray[0];
	     hour = timeInArray[0];
	     minute=timeInArray[1];
    }else{
 	   dateTime = '${webNotification.getSendDateAndTime()}';
    }
    formData = {
        'id': '${id}',
        'notificationTitle': $('#notificationTitle').val(),
        'notification': $('#notification').val(),
        'roles': roles,
        'status': 'ACTIVE',
        'sendDate': sendDate,       
        "sendTimeMinute":minute,
        "sendTimeHour":hour,
        "type":type, 
        "division":divisionId,
        "district":districtId,
        "upazila":upazilaId,
        "branch":branchId,
        "locationType":locationType,
        "locationTypeId":locationId,
        "sendDateAndTime":dateTime

    };
   // alert(branchId);
    console.log(formData);
  //return false;
    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(formData),
        dataType : 'json',
        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
            $("#loading").show();
        },
        success : function(data) {
        	let response = JSON.parse(data);
    		console.log(response);
    		$("#errorMessage").show();            	  
            $("#errormessageContent").html(response.msg)  
            if(response.status == 'SUCCESS'){
            	setTimeout(function(){
            		 window.location.replace("${back}");
                 }, 2000);

            }
        },
        error : function(e) {
            console.log(e);
        },
        done : function(e) {
            console.log("DONE");
        }
    });
});



function Validate() {
	let retValue=true;
	
	if(type=='DRAFT'){
		return true;
	}
	
	$("#errorText").html("");
	if($('#notificationTitle').val() == ""){
		$("#errorText").append("<p style='color:red'>Notification title will not empty</p>");
		retValue = false;
	}
	if($('#notification').val() == ""){
		$("#errorText").append("<p style='color:red'>Notification  will not empty</p>");
		retValue = false;
	}
	var roles = [];
    $('input[name^="roles"]').each(function() {           
    	roles.push($(this).val());
    }); 
    
    if(roles.length==0){
    	$("#errorText").append("<p style='color:red'>Please select Recipient types</p>");
    	retValue = false;
    }
    
    if($('#date').val() == "" && type=="SCHEDULE"){
		$("#errorText").append("<p style='color:red'>Date & time  will not empty</p>");
		retValue = false;
	}
    

    var divisionId = $('#divisionList').val();
    var branchId = $('#branchList').val();
    
    if($('#divisionList').val() == 0 && branchId==0){
		$("#errorText").append("<p style='color:red'>Division or branch will not empty</p>");
		retValue = false;
	}
    let _dateTime = $("#date").val();
    if(type=='SCHEDULE' && _dateTime==''){
    	$("#errorText").append("<p style='color:red'>Date and time will not empty</p>");
		retValue = false;
	}
    
    return retValue;
}
</script>




















