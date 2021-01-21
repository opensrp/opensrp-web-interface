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
		<div id="loading"
						style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Household</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					 /  People  <b> / Household list </b> 
				</li>
				
			
			</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Household list
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							<jsp:include page="/WEB-INF/views/full-location-search-options.jsp" />
						</div>
						<div class="row" id="errorMsg" style="display: none">
								<div class="col-lg-12 form-group">
									<span style="color:red" >Please select village OR types something on search key</span>
								</div>
							</div>
						<div class="row" style="margin: 0px">
                            <div class="col-sm-12" id="content" style="overflow-x: auto;">
                                
                                <div id="report"></div>

                            </div>
                        </div>
                        
						
						<div class="row" style="margin: 0px">
		                    <div id="report">
								<table style="width: 100%;"
									class="display table table-bordered table-striped"
									id="dataTableId">
									<thead>
										<tr>
										<th> SI</th>
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
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		$('#villageList').select2({dropdownAutoWidth : true});
    	//$('#unionList').select2({dropdownAutoWidth : true});
		window.totalRecords = 0;
		$("#dataTableId").hide();
});




</script>
<script>
    let stockList;
    
    
    
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
    	$("#dataTableId").show();
    	
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
















