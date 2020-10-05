<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Households</title>
	
	

<c:url var="get_url" value="/rest/api/v1/people/household/list" />


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
							<i class="fa fa-list"></i>Households
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" />
							
							
							<!-- <div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation">Designation</label>
									<select
										name="roleList" class="form-control" id="roleList">
										
										<option value="SK">SK</option>
										<option value="PA">PA</option>										
									</select>
								</div>
								
								
							</div> -->
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
     						</div>
     						
     						
						</div>
						
						<div class="table-scrollable">
						
						<table class="table table-striped table-bordered " id="householdTable">
							<thead>
								<tr>
								 <th>HH ID</th>
									<th>HH head name</th>
									<th>#Members</th>
									<th>Registration date</th>
									<th>Last visit date</th>
									<th>Village</th>
									<th>Branch(code)</th>
									<th>Contact</th>
									<th>Action</th>
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




</script>
<script>
    let stockList;
    $(document).ready(function() {
    	
    	
    	stockList = $('#householdTable').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3,3,4,5,6,7,8], orderable: true },
                { width: "10%", targets: 0 },
                { width: "10%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "10%", targets: 3 },
                { width: "10%", targets: 4 },
                { width: "10%", targets: 5},
                { width: "10%", targets: 6},
                { width: "10%", targets: 7},
                { width: "10%", targets: 8}
                
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
	stockList = $('#householdTable').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { targets: [0, 1, 2, 3,3,4,5,6,7,8], orderable: true },
                { width: "10%", targets: 0 },
                { width: "10%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "10%", targets: 3 },
                { width: "10%", targets: 4 },
                { width: "10%", targets: 5},
                { width: "10%", targets: 6},
                { width: "10%", targets: 7},
                { width: "10%", targets: 8}
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
















