<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Individual Target</title>
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

	
<c:url var="urlForSKPAList" value="/rest/api/v1/target/sk-pa-user-list-for-individual-target-setting" />



<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Set Target Individually</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					/ Target  
				</li>
				
		</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Individual Target
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/search-option-for-target-by-position.jsp" />
							
							
							<div class="row">
								
								<div class="col-lg-3 form-group ">
								    <label for="designation">Designation</label>
									<select
										name="roleList" class="form-control" id="roleList">
										
										<option value="SK">SK</option>
										<option value="PA">PA</option>										
									</select>
								</div>
								<div class="col-lg-9 form-group form-group text-right">
								<br />
								<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
								
								
							</div>
							
						</div>
						<h3>Target </h3>
						
						<table class="table table-striped table-bordered " id="StockSellHistory">
							<thead>
								<tr>
								   <th>Si</th>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th>Username</th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th>Location name</th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
									<th>View</th>
									<th>Edit</th>
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
});


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
    	
    	
    	stockList = $('#StockSellHistory').DataTable({
            bFilter: true,
            serverSide: true,
            processing: true,
            ordering:false,
            scrollY:        "300px",
            scrollX:        true,
            scrollCollapse: true,
            "ordering": false,
            fixedColumns:   {
                leftColumns: 2/* ,
             rightColumns: 1 */
            },
            ajax: {
                url: "${urlForSKPAList}",
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
	stockList = $('#StockSellHistory').DataTable({
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
             url: "${urlForSKPAList}",
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
















