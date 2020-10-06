<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Members</title>
	
	

<c:url var="get_url" value="/rest/api/v1/people/member/list" />


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
							<i class="fa fa-list"></i>Members
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" />
							
							
							<div class="row">
								<div class="col-lg-3 form-group">
								   
									<select
										name="type" class="form-control" id="type">
										<option value="">Select Type</option>
										<option value="child">Child</option>
										<option value="member">Member</option>										
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="designation"></label>
									<input name="search" class="form-control"id="search" placeholder="Search Key"/> 
								</div>
								
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
     						</div>
     						
     						
						</div>
						
						<div class="table-scrollable">
						
						<table class="table table-striped table-bordered " id="memberTable">
							<thead>
								<tr>
								 	<th>Member name</th>
									<th>Member ID</th>
									<th>Household ID</th>
									<th>Relation with <br/>household head</th>
									<th>Age</th>
									<th>Gender</th>
									<th>Status</th>
									<th>Village</th>
									<th>Branch(code)</th>									
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
		
});




</script>
<script>
    let stockList;
    $(document).ready(function() {
    	
    	
    	stockList = $('#memberTable').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                
                { orderable: false, className: 'reorder', width: "10%", targets: 0 },
                { orderable: false, className: 'reorder',width: "10%", targets: 1 },
                { orderable: false, className: 'reorder', width: "10%", targets: 2 },
                { orderable: false, className: 'reorder',width: "10%", targets: 3 },
                { width: "10%", targets: 4 },
                { width: "10%", targets: 5},
                { orderable: false, className: 'reorder',width: "10%", targets: 6},
                { orderable: false, className: 'reorder', width: "10%", targets: 7},
                { orderable: false, className: 'reorder', width: "10%", targets: 8},
                { orderable: false, className: 'reorder', width: "10%", targets: 9}
                
            ],
            ajax: {
                url: "${get_url}",
                data: function(data){                	
                    data.branchId = 0;
                    data.locationId=0;                    
                    data.type='';
                    
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
	stockList = $('#memberTable').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
             { orderable: false, className: 'reorder', width: "10%", targets: 0 },
                { orderable: false, className: 'reorder',width: "10%", targets: 1 },
                { orderable: false, className: 'reorder', width: "10%", targets: 2 },
                { orderable: false, className: 'reorder',width: "10%", targets: 3 },
                { width: "10%", targets: 4 },
                { width: "10%", targets: 5},
                { orderable: false, className: 'reorder',width: "10%", targets: 6},
                { orderable: false, className: 'reorder', width: "10%", targets: 7},
                { orderable: false, className: 'reorder', width: "10%", targets: 8},
                { orderable: false, className: 'reorder', width: "10%", targets: 9}
         ],
         ajax: {
             url: "${get_url}",
             data: function(data){
            	
            	 data.branchId = $("#branchList option:selected").val();
                 data.locationId=locationId;                    
                 data.type= $("#type option:selected").val();
                 data.search = $("#search").val();
                 
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
















