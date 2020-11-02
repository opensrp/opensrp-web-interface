<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Target by position</title>
	
	
<c:url var="get_url" value="/rest/api/v1/target/branch-list-for-positional-target" />
<c:url var="set_target_url" value="/target/set-target-by-position.html" />


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
							<i class="fa fa-list"></i>Target By Position
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" />
							
							
							<div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation">Designation</label>
									<select
										name="roleList" class="form-control" id="roleList">
										
										<option value="SK">SK</option>
										<option value="PA">PA</option>										
									</select>
								</div>
								
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
     						</div>
     						
     						
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-lg-3 form-group">
									
								</div>
								<div class="col-lg-9 form-group text-right">
									<button type="submit" onclick="settTaretForAll()" class="btn btn-primary" value="confirm">Set target for all</button>
									
									
								</div>
							</div>
						
						</div>
						<div class="table-scrollable">
						
						<table class="table table-striped table-bordered " id="targetTable">
							<thead>
								<tr>
								 <th>Branch name</th>
									<th>Branch code</th>
									<th>Upazila</th>
									<th>Total worker</th>
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

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		$('#branchList').select2({dropdownAutoWidth : true});
});

function settTaretForAll(){
	var url = '${set_target_url}';
	let district = $("#districtList option:selected").val();
	let districtText = $("#districtList option:selected").text();
	let division = $("#divisionList option:selected").val();
	let divisionText = $("#divisionList option:selected").text();
	let upazila = $("#upazilaList option:selected").val();
	let upazilaText = $("#upazilaList option:selected").text();
	var branch = $("#branchList option:selected").val();
	var branchText = $("#branchList option:selected").text();
	var role = $("#roleList option:selected").val();
	var targetName = "";
	var locationTag = "";
	if(division != 0){
		targetName = "Division : "+divisionText;
		locationTag="division";
	}
	if(district != 0){
		targetName +=", District : "+districtText;
		locationTag="district";
	} 
	
	if(upazila != 0){
		targetName +=", Upazila : "+upazilaText;
		locationTag="upazila";
	} 
	
	if(branch !=0){
		targetName +=", Branch : "+branchText;
	}
	if(role !=0){
		targetName +=", Role : "+role;
	}
	
	var type="ROLE";
	var locationId="";
	if(branch!=0){
		locationId = branch;
		type = "BRANCH"
	}else if(upazila != 0){
		locationId = upazila;
		type = "LOCATION"
	}else if(district != 0){
		locationId = district;
		type = "LOCATION"
	}else if(division != 0){
		locationId =division; 
		type = "LOCATION"
	}	
    url = url+"?setTargetTo="+locationId+"&role="+role+"&type="+type+"&text="+targetName+"&locationTag="+locationTag
	window.location.replace(url);
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
    	
    	
    	stockList = $('#targetTable').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3], orderable: false },
                { width: "10%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "5%", targets: 3 }
                
            ],
            ajax: {
                url: "${get_url}",
                data: function(data){                	
                    data.branchId = 0;
                    data.locationId=0;                    
                    data.roleName='SK';
                    
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
		locationId = district;
	}else if(division != 0){
		locationId =division; 
	}
	stockList = $('#targetTable').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { targets: [0, 1, 2, 3], orderable: false },
             { width: "20%", targets: 0 },
             { width: "5%", targets: 1 },
             { width: "10%", targets: 2 },
             { width: "5%", targets: 3 }
         ],
         ajax: {
             url: "${get_url}",
             data: function(data){
            	
            	 data.branchId = $("#branchList option:selected").val();
                 data.locationId=locationId;                    
                 data.roleName=$("#roleList option:selected").val();
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
















