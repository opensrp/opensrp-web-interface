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
							
							<jsp:include page="/WEB-INF/views/search-option-for-target-by-position.jsp" />
							
							
							<div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation">Designation</label>
									<select
										name="roleList" class="form-control" id="roleList">
										
										<option value="SK">SK</option>
										<option value="PA">PA</option>										
									</select>
								</div>
								<div class="col-lg-2 form-group form-group text-right">
								<br />
								<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
								<div class="col-lg-2 form-group form-group text-right">
								<br />
								<button type="submit" onclick="settTaretForAll()" class="btn btn-primary" value="confirm">Set target for all</button>
									
								</div>
								
								
							</div>
							
     						
						</div>
						
						
						
						<table class="table table-striped table-bordered " id="targetTable">
							<thead>
								<tr><th>SI</th>
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
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		window.totalRecords = 0;

		$('#branchList').select2MultiCheckboxes({
			placeholder: "Select branch",
			width: "auto",
			templateSelection: function(selected, total) {
				return "Selected " + selected.length + " of " + total;
			}
		});
		$("#branchList > option").prop("selected","selected");
	    $("#branchList").trigger("change");
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
	
	if(typeof branch !='undefined'){
		targetName +=", Branch : "+branchText;
	}
	if(role !=0){
		targetName +=", Role : "+role;
	}
	
	var type="ROLE";
	var locationId="";
	if(typeof branch !='undefined'){
		
		locationId = $("#branchList").val();
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
	window.location.assign(url);
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
                data: function(data){                	
                    data.branchId = '';
                    data.locationId=0;                    
                    data.roleName='SK';
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
             data: function(data){
            	var branchIds =  $("#branchList").val();
             	if( branchIds ==null || typeof branchIds == 'undefined'){
             		branchIds = ''
             	}else{
             		branchIds = $("#branchList").val().join();
             	}
             	 data.branchId = branchIds;
                 data.locationId=locationId;                    
                 data.roleName=$("#roleList option:selected").val();
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
</script>
















