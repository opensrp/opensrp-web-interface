<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Web notification list</title>
	
<style>
	.select2-results__option .wrap:before {
		font-family: fontAwesome;
		color: #999;
		content: "\f096";
		width: 25px;
		height: 25px;
		padding-right: 10px;
	}

	.select2-results__option[aria-selected=true] .wrap:before {
		content: "\f14a";
	}


	/* not required css */

	.row {
		padding: 10px;
	}

	.select2-multiple,
	.select2-multiple2 {
		width: 50%
	}

	.select2-results__group .wrap:before {
		display: none;
	}
</style>
<c:url var="get_url" value="/rest/api/v1/web-notfication/list" />
<c:url var="add_page" value="/web-notification/add-new.html" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	
<link type="text/css"
	href="<c:url value="/resources/css/daterangepicker.css"/>"
	rel="stylesheet"
	http-equiv="Cache-control" content="public">
<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Web notification list
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/search-option-for-notification.jsp" />
							
							
							<div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation">Designation</label>
									<select name="roleList" class="form-control" id="roleList">
									<option value="0">Please Select</option>
									<c:forEach items="${roles}" var="role">
										<option value="${role.id}">${role.name}</option>
									</c:forEach>
																			
									</select>
								</div>
								
								<div class="col-lg-2 form-group">
								    <label for="designation">Notification type</label>
									<select name="nType" class="form-control" id="nType">
									<option value="">Please Select</option>
									<c:forEach items="${types}" var="type">
										<option value="${type.name()}">${type.name()}</option>
									</c:forEach>
																			
									</select>
								</div>
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
								<div class="col-lg-3 form-group text-left" style="padding-top: 24px">
									<button type="submit" onclick="filter()" class="btn btn-primary btn-sm" value="confirm">Search</button>
									<a  href="${add_page}" class="btn btn-primary btn-sm" id="back">Add new </a> 
						            		
								</div>
								
								
							</div>
							<%-- <div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary btn-sm" value="confirm">View</button>
									<a  href="${add_page}" class="btn btn-primary btn-sm" id="back">Add new </a> 
						            		
								</div>
     						</div> --%>
     						
     						
						</div>
						<div class="row">
							<div class="col-lg-3 form-group">
								<span style="color: red" id="errMsg"></span>
							</div>
						</div>
						
						
						<table class="table table-striped table-bordered " id="webNotificationTable">
							<thead>
								<tr><th> SI</th>
									<th id="dtime">Sending date & time</th>
									<th>Notification type</th>
									<th>Notification title</th>
									<th>Recipient type</th>
									<th>Action</th>
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

 <script src="<c:url value='/resources/assets/global/js/select2-multicheckbox.js'/>"></script>

<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>

<script>
jQuery(document).ready(function() { 
	window.totalRecords = 0;
	$('#branchList').select2MultiCheckboxes({
		placeholder: "Select branch",
		width: "auto",
		templateSelection: function(selected, total) {
			return "Selected " + selected.length + " of " + total;
		}
	});
	 Metronic.init(); // init metronic core components
	Layout.init(); // init current layout
	$("#branchList > option").prop("selected","selected");
    $("#branchList").trigger("change");
   
});


</script>

<script type="text/javascript">
var dateToday = new Date();
var dates = $(".date").datepicker({
dateFormat: 'yy-mm-dd',
/* maxDate: dateToday,
onSelect: function(selectedDate) {
    var option = this.id == "from" ? "minDate" : "maxDate",
        instance = $(this).data("datepicker"),
        date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
    dates.not(this).datepicker("option", option, date);
} */
});
var d = new Date();
var startDate =  $.datepicker.formatDate('yy-mm-dd', new Date(d.getFullYear(), d.getMonth(), 1));

$("#from").datepicker('setDate', startDate); 
$("#to").datepicker('setDate', new Date()); 
</script>
<script>
    let stockList;
    $(document).ready(function() {
    	
    	
    	stockList = $('#webNotificationTable').DataTable({
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
                url: "${get_url}",
                timeout : 300000,
                data: function(data){  
                	var branchIds =  $("#branchList").val();
                  	if( branchIds ==null || typeof branchIds == 'undefined'){
                  		branchIds = ''
                  	}else{
                  		branchIds = $("#branchList").val().join();
                  	}
                  	
                	data.branchId = branchIds;
                    data.locationId=0;                    
                    data.roleId=0;
                    data.type="";
                    data.startDate = $('#from').val();
                    data.endDate =$('#to').val();
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
	let locationId = 0;
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
	
	
	if(upazila != 0){
		locationId = upazila;
	}else if(district != 0){
		locationId = district;
	}else if(division != 0){
		locationId =division; 
	}
	let _nType = $("#nType").val();
	let header="";
	if(_nType=='SEND'){
		_nType="Sending";
	}else if(_nType=='DRAFT'){
		_nType="Draft";
	}else if(_nType=='SCHEDULE'){
		_nType="Schedule";
	}
	
	var branchIds =  $("#branchList").val();
  	if( branchIds ==null || typeof branchIds == 'undefined'){
  		branchIds = ''
  	}else{
  		branchIds = $("#branchList").val().join();
  	}
  	
  	if( branchIds =="" || typeof branchIds == 'undefined'){
		$("#errMsg").html("Please select branch");
		return false;
	}else{
		$("#errMsg").html("");
	}
  	
	var dateTimeHeader = _nType+" date & time";
	stockList = $('#webNotificationTable').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         scrollY:        "300px",
         scrollX:        true,
         scrollCollapse: true,
         fixedColumns:   {
             leftColumns: 2/* ,
          rightColumns: 1 */
         },
         "ordering": false,
         ajax: {
             url: "${get_url}",
             timeout : 300000,
             data: function(data){
            	 
          		 data.startDate = $('#from').val();
                 data.endDate =$('#to').val();
             	
            	 data.branchId = branchIds;
                 data.locationId=locationId;                    
                 data.roleId=$("#roleList").val();
                 data.type=$("#nType").val();
                 data.totalRecords = totalRecords;
                
             },
             dataSrc: function(json){
            	 totalRecords = json.recordsTotal;
                 if(json.data){
                	 $("#dtime").html(dateTimeHeader);
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
















