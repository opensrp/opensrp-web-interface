<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Member details</title>



<c:url var="get_url" value="/rest/api/v1/people/household/list" />


<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<c:url var="get_member_url" value="/rest/api/v1/people/member/list" />

        <!--Modal start-->
        <div style="overflow: unset;display: none;top:30px; max-width: none; position: relative; z-index: 1050"
             id="content" class="modal modal-margin">
             <a class="btn btn-sm btn-dark text-right" style="float: right; bottom: 0px" href="#" rel="modal:close">Close</a>
            <div id="user-info-body" class="row"></div>
            
                 <div class="form-group row" id ="modal-body">
	                <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
                </div>
                
           
            <div id="table-body" class="row" style="overflow-x: auto; margin-bottom: 10px;">
            </div>
<a class="btn btn-sm btn-dark text-right" style="float: right; bottom: 0px" href="#" rel="modal:close">Close</a>            
        </div>

<div class="page-content-wrapper">
	<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
			<li><a href="<c:url value="/"/>">Home</a> <i
				class="fa fa-circle"></i></li>
			<li><a href="<c:url value="/people/members.html"/>">Members</a>

			</li>

		</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Member details
						</div>
					</div>
					<div class="portlet-body">

						<div class="tabbable tabbable-custom tabbable-noborder">
							<ul class="nav nav-tabs">

								<li data-target="#member_info" role="tab" data-toggle="tab"
									class="active btn btn-success btn-sm">Member information</li>

								<li data-target="#reg_visit" role="tab" data-toggle="tab"
									class="btn btn-success btn-sm">Service information</li>
							</ul>
							<div class="tab-content">
								<div class="tab-pane active" id="member_info">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">
													<jsp:include page="/WEB-INF/views/dynamic_content.jsp" />

												</div>
											</div>
										</div>
									</div>
								</div>


								<div class="tab-pane" id="reg_visit">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">

													<jsp:include page="/WEB-INF/views/service_list.jsp" />
												</div>
											</div>
										</div>
									</div>
								</div>







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

<script
	src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		
});

/* var loadContent = function(id, formName){
	$('#content').modal({
        escapeClose: false,
        clickClose: false,
        showClose: false,
        show: true
    });
	alert("ok");
} */
let url = '${get_service_url}';
function loadContent(id, formName ,url) {
	
	 var token = $("meta[name='_csrf']").attr("content");
     var header = $("meta[name='_csrf_header']").attr("content");
	$.ajax({
		type : "GET",
		contentType : "application/json",
	    url: url+"/"+formName+"/"+id,	    
	    dataType : 'html',
	    timeout : 100000,
	    beforeSend: function(xhr) {
	        xhr.setRequestHeader(header, token);
	        $('#content').modal({
	            escapeClose: false,
	            clickClose: true,
	            showClose: false,
	            show: true,
	            closeExisting: false
	        });
	       
	    },
	    success : function(data) {
	    	
	    	
	    	$('#modal-body').html(data);
	       /*  $('#pleaseWait').hide(); */
	       
	    },
	    error : function(e) {
	       
	    },
	    done : function(e) {
	       /*  $('#saveCatchmentArea').prop('disabled', false);
	        $('#pleaseWait').hide(); */
	    }
	});
	
	
	
	
} 
function closeMainModal() {
    console.log("IN CLOSE");
    
    $.modal.getCurrent.close();
}



</script>


