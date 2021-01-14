<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Edit training title</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	
<c:url var="save_url" value="/rest/api/v1/training/save-update-title" />
<c:url var="back_url" value="/training/training-title-list.html" />


<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>Training title</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>
				<li>
					/ Training / <b> Edit Training title</b>  /  
				</li>
				<li>
					<a  href="${back_url }">Back</a>
					
				</li>
				
				
			
			</ul>
		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Edit training title</div>


			</div>
			
			<div class="portlet-body">
				<div style="display: none;" class="alert alert-success" id="serverResponseMessage" role="alert"></div>
				<div class="card-body">
					<div id="loading"
						style="display: none; position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>

				</div>
				<form id="addTitle">
				
				<!-- First Half of Form Starts -->
				
				<div class="col-lg-6">
					<div class="form-group row">
						<label for="title" class="col-sm-4 col-form-label">Training title<span class="text-danger"> *</span> </label>
						<div class="col-sm-12">
							<input type="text" required="required" class="form-control" id="title" name ="title" value="${trainingTitle.getName() }">
						</div>
					</div>
						
					</div>
					<div class="form-group row"></div>
					<div class="form-group row">
						<div class="col-lg-12 form-group ">
							<a href="${back_url}" class="btn btn-primary">Cancel</a>							
							<button type="submit"  class="btn btn-primary" value="SEND">Submit</button>
							      		
						</div>
					</div>
				</form>
				
			</div>
			
			
		</div>
		
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

$("#addTitle").submit(function(event) { 
	
	$("#loading").show();
	var url = '${save_url}';			
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	
	var formData;	
		formData = {
				id:'${trainingTitle.getId() }',
	            'title': $('input[name=title]').val()	           
	        };
	event.preventDefault();
	
	$.ajax({
		contentType : "application/json",
		type: "POST",
        url: url,
        data: JSON.stringify(formData), 
        dataType : 'json',
        
        timeout : 300000,
		beforeSend: function(xhr) {				    
			 xhr.setRequestHeader(header, token);
		},
		success : function(data) {
			
		   var response = JSON.parse(data);
		   $("#loading").hide();
		   $("#serverResponseMessage").show();
		   $("#serverResponseMessage").html(response.msg);

		   if(response.status == "SUCCESS"){
           	setTimeout(function(){
           			window.location.replace('${back_url}');
                }, 1000);
		   }
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
});	



</script>