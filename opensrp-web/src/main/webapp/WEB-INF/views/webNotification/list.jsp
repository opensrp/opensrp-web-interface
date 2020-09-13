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
							
							<jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" />
							
							
							<div class="row">
								<div class="col-lg-4 form-group">
							 		<label class="control-label">Date range </label> 
						            <input  type="text" id="dateRange" name="dateRange" class="form-control"/>
						                         
								</div>
								<div class="col-lg-3 form-group">
								    <label for="designation">Designation</label>
									<select name="roleList" class="form-control" id="roleList">
									<option value="0">Please Select</option>
									<c:forEach items="${roles}" var="role">
										<option value="${role.id}">${role.name}</option>
									</c:forEach>
																			
									</select>
								</div>
								
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
									<a  href="${add_page}" class="btn btn-primary btn-lg" id="back">Add new </a> 
						            		
								</div>
     						</div>
     						
     						
						</div>
						
						<div class="table-scrollable">
						
						<table class="table table-striped table-bordered " id="webNotificationTable">
							<thead>
								<tr>
									<th>Date</th>
									<th>Sending time</th>
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
		</div>
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>
<script src="<c:url value='/resources/js/moment.min.js' />"></script>
 
<script src="<c:url value='/resources/js/daterangepicker.min.js' />"></script>
<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   
});


</script>

<script type="text/javascript">
var dateToday = new Date();
$(function() {

  $('input[name="dateRange"]').daterangepicker({
      autoUpdateInput: false,
      maxDate: dateToday,
      locale: {
          cancelLabel: 'Clear'
      }
  });

  $('input[name="dateRange"]').on('apply.daterangepicker', function(ev, picker) {
      $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
  });

  $('input[name="dateRange"]').on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');
  });

});
</script>
<script>
    let stockList;
    $(document).ready(function() {
    	
    	
    	stockList = $('#webNotificationTable').DataTable({
            bFilter: false,
            serverSide: true,
            processing: true,
            columnDefs: [
                { targets: [0, 1, 2, 3,4], orderable: false },
                { width: "10%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "10%", targets: 3 },
                { width: "5%", targets: 4 }
                
            ],
            ajax: {
                url: "${get_url}",
                data: function(data){                	
                	data.branchId = 0;
                    data.locationId=0;                    
                    data.roleId=0;
                    data.type="";
                    data.startDate="";
                    data.endDate="";
                    
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
	stockList = $('#webNotificationTable').DataTable({
         bFilter: false,
         serverSide: true,
         processing: true,
         columnDefs: [
              { targets: [0, 1, 2, 3,4], orderable: false },
              { width: "10%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "10%", targets: 2 },
                { width: "10%", targets: 3 },
                { width: "5%", targets: 4 }
         ],
         ajax: {
             url: "${get_url}",
             data: function(data){
            	 let dateFieldvalue = $("#dateRange").val();   
            	 if(dateFieldvalue != '' && dateFieldvalue != undefined){
 	     	        data.startDate = $("#dateRange").data('daterangepicker').startDate.format('YYYY-MM-DD');
 	                data.endDate =$("#dateRange").data('daterangepicker').endDate.format('YYYY-MM-DD');
             	}else{
             		data.startDate = '';
                     data.endDate ='';
             	}
            	 data.branchId = $("#branchList").val();
                 data.locationId=locationId;                    
                 data.roleId=$("#roleList").val();
                 data.type="";
                
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
















