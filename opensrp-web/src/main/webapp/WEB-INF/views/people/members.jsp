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
		<div id="loading"
						style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Member</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					 /  People  <b> / Member list </b> 
				</li>
				
			
			</ul>
		<div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
            <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
        </div>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Member list
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/full-location-search-options.jsp" />
							
							
							<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="cars"> gender </label> 	
									<select
										name="gender" class="form-control" id="gender">
										<option value="">Select gender</option>
										<option value="M">Male</option>
										<option value="F">Female</option>
										<option value="O">Others</option>											
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"> Age </label> 	
									<select
										name="age" class="form-control" id="age">
										<option value="404-404">Select age range</option>
										<option value="0-1">0-1</option>
										<option value="2-5">2-5</option>
										<option value="6-13">6-13</option>	
										<option value="14-19">14-19</option>	
										<option value="20-35">20-35</option>
										<option value="36-49">36-49</option>									
									</select>
								</div>
								<div class="col-lg-3 form-group">
								     <label for="cars">Search key </label> 	
									<input name="search" class="form-control"id="search" placeholder="member ID,NID,BRID, mobile"/> 
								</div>
								
								<div class="col-lg-3 form-group" style="padding-top: 22px">
								    <button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">Search</button>
								</div>
							</div>
							<div class="row" id="errorMsg" style="display: none">
								<div class="col-lg-12 form-group">
									<span style="color:red" >Please select village OR types something on search key</span>
								</div>
							</div>
						</div>
						
						
						
						<div class="row" style="margin: 0px">
                            <div id="report">
								<table style="width: 100%;"
									class="display table table-bordered table-striped"
									id="dataTableId">
									<thead>
										<tr> <th>SI</th>
									        <th>Member name</th>
											<th>Member ID</th>				
											<th>Relation with <br/>household head</th>
											<th>DOB</th>
											<th>Age</th>
											<th>Gender</th>									
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
		</div>
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>
<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>
<script>
jQuery(document).ready(function() { 
	window.totalRecords = 0;
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		
});
</script>
<script>
    let stockList;
    $(document).ready(function() {
    	$('#villageList').select2({dropdownAutoWidth : true});
    	//$('#unionList').select2({dropdownAutoWidth : true});
    });



function filter() {	

	let village = $("#villageList option:selected").text();
	let villageId = $("#villageList option:selected").val();
	let searchKey = $("#search").val();
	if(villageId ==0){
		village = villageId;
	}
	if(villageId ==0 && searchKey==''){
		 $('#errorMsg').show();
		return ;
	}
	
	
	$('#errorMsg').hide();
	let agePart = $("#age").val();
	let age = agePart.split('-');

	
	stockList = $('#dataTableId').DataTable({
		bFilter : false,
		serverSide : true,
		processing : true,
		scrollY : "300px",
		scrollX : true,
		scrollCollapse : true,
		fixedColumns : {
			leftColumns : 2
		},
		"ordering" : false,
		
		ajax : {
			url : "${get_url}",
			timeout : 300000,
			data : function(data) {
				data.village=village;
			 	data.gender=$("#gender option:selected").val();
			 	data.startAge=age[0];
			 	data.endAge=age[1];
			 	data.searchKey=searchKey;
			 	data.totalRecords = totalRecords;
				
			},
			dataSrc : function(json) {
				totalRecords = json.recordsTotal;
				if (json.data) {
					
					return json.data;
				} else {
					return [];
				}
			},
			complete : function() {
			},
			type : 'GET'
		},
		bInfo : true,
		destroy : true,
		language : {
			searchPlaceholder : ""
		}
	});
}
</script>
















