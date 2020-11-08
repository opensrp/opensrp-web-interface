<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Target vs achievement visit pm report</title>

<c:url var="branch_url" value="/branch-list-options-by-user-ids" />
<c:url var="all_branch_url" value="/all-branch-list-options" />

<c:url var="user_list_url" value="/user-list-options-by-parent-user-ids" />
	
<c:url var="urlForPKList" value="/rest/api/v1/target/pk-user-list-for-population-target-setting" />
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


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Target vs achievement visit report
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							<div class="col-lg-12 form-group">

								<div  class="col-lg-3 form-group">
								  <input type="radio"  id="managerWise"  onclick="reportType('manager')"  value="managerWise" name="managerOrLocation" 
								         checked>
								  <label for="managerWise">Manager wise</label>
								</div>
								
								<div  class="col-lg-3 form-group">
								  <input type="radio"  id="locationWise" onclick="reportType('location')" value="locationWise" name="managerOrLocation">
								  <label for="locationWise">Location wise</label>
								</div>



							</div>
							
							<div class="row" id="manager">
									<div class="col-lg-3 form-group">
									    <label for="cars">Divisional manager </label> 
									    <select	onclick="getAm(this.value,'AM')" name="divM" class="form-control" id="divM">
											<option value="0">Please select</option>
											<c:forEach items="${divms}" var="divm">
											<option value="${divm.getId()}">${divm.getFullName()}</option>
											</c:forEach>
										</select>
									</div>
									<div class="col-lg-3 form-group">
									    <label for="cars">Area manager </label>
									    <select	onclick="getBranchListByUserId(this.value,'branchList')" name="AM"  id="AM" class="form-control">
											<option value="0">Please select </option>
										</select>
									</div>
									
									 <div class="col-lg-3 form-group">
								        <label ><spring:message code="lbl.branch"></spring:message></label>
								        <select	name="branchList" class="form-control" id="branchList">
											<%-- <c:forEach items="${branches}" var="branch">
												<option value="${branch.id}" selected>${branch.name}</option>
											</c:forEach> --%>
								        </select>
								    </div>
														
							</div>
	
							<jsp:include page="/WEB-INF/views/location-search-options.jsp" />
							
							
							<jsp:include page="/WEB-INF/views/target-report-common-search-section.jsp" />
							
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
     						</div>
						</div>
						
						
						<div class="table-scrollable">
						
						<table class="table table-striped table-bordered " id="targetByPopulationList">
							<thead>
								<tr>
								   
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.id"></spring:message></th>
									<th><spring:message code="lbl.union"></spring:message></th>
									<th><spring:message code="lbl.population"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
						</table>
						</div>
						
						
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


<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		getAllBranch();
		$('#branchList').select2MultiCheckboxes({
			placeholder: "Select branch",
			width: "auto",
			templateSelection: function(selected, total) {
				return "Selected " + selected.length + " of " + total;
			}
		});
		
		reportType('manager');
		//$("#managerWise").attr('checked', 'checked');
   //TableAdvanced.init();
		//$('#StockSellHistory').DataTable();
});



function reportType(value) {	
	if(value == 'manager') {
		$('#location').hide();
		$('#manager').show();
	}
	else {
		$('#manager').hide();
		$('#location').show();
	}
}

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
	jQuery(".date-picker-year").focus(function () {
        $(".ui-datepicker-calendar").hide();
        $(".ui-datepicker-current").hide();
    });
});

</script>
<script>
     let stockList;
    $(document).ready(function() {
    	
    	
    	stockList = $('#targetByPopulationList').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3,4,5], orderable: false },
                { width: "20%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "20%", targets: 3 },
                { width: "20%", targets: 4 },
                { width: "20%", targets: 5 }
                
            ],
            ajax: {
                url: "${urlForPKList}",
                data: function(data){                	
                    data.branchId = 0;
                    data.locationId=0;                    
                    data.roleName='PK';
                    
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
	
	let locationId = 0;
	let district = $("#districtList option:selected").val();
	let division = $("#divisionList option:selected").val();
	let upazila = $("#upazilaList option:selected").val();
	if(upazila != 0){
		locationId = upazila;
	}else if(district != 0){
		locationId = upazila;
	}else if(division != 0){
		locationId =division; 
	}
	stockList = $('#targetByPopulationList').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { targets: [0, 1, 2, 3,4,5], orderable: false },
             { width: "20%", targets: 0 },
             { width: "5%", targets: 1 },
             { width: "20%", targets: 2 },
             { width: "20%", targets: 3 },
             { width: "20%", targets: 4 },
             { width: "20%", targets: 5 }
         ],
         ajax: {
             url: "${urlForPKList}",
             data: function(data){
            	
            	 data.branchId = $("#branchList option:selected").val();
                 data.locationId=locationId;                    
                 data.roleName=$("#roleList option:selected").val() == "0" ? "PK" : $("#roleList option:selected").val();
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
</script>

<script>
function getAm(userId,divId) {
	
	let url = '${user_list_url}';	
	getBranchListByUserId(userId,'branchList');
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url+"?id="+userId+"&roleId=32",
		dataType : 'html',
		timeout : 100000,
		beforeSend: function() {},
		success : function(data) {
			$("#"+divId).html(data);
		},
		error : function(e) {
			console.log("ERROR: ", e);
			display(e);
		},
		done : function(e) {
			console.log("DONE");			
		}
	});

}


function getBranchListByUserId(userId,divId) {
    
    console.log("---------->>>>  getBranchList method is getting called");
    let url = '${branch_url}';
    $.ajax({
        type : "GET",
        contentType : "application/json",
        url : url+"?id="+userId,

        dataType : 'html',
        timeout : 100000,
        beforeSend: function() {},
        success : function(data) {
            $("#branchList").html(data);
            $("#branchList > option").prop("selected","selected");
            $("#branchList").trigger("change");
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

}


function getAllBranch(userId,divId) {
    
    console.log("---------->>>>  getBranchList method is getting called");
    let url = '${all_branch_url}';
    $.ajax({
        type : "GET",
        contentType : "application/json",
        url : url,

        dataType : 'html',
        timeout : 100000,
        beforeSend: function() {},
        success : function(data) {
            $("#branchList").html(data);
            $("#branchList > option").prop("selected","selected");
            $("#branchList").trigger("change");
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

}


</script>












