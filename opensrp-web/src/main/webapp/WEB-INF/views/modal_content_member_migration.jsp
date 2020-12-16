<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">
<c:url var="url" value="/migration/member-details-data" />
<!--Modal start-->
<div
	style="overflow: unset; display: none; top: 30px; min-height: 300px; max-width: none; position: relative; z-index: 1050"
	id="content" class="modal modal-margin">
	<a class="btn btn-sm btn-dark text-right"
		style="float: right; bottom: 0px" href="#" rel="modal:close"><strong>X</strong></a>
	<div id="user-info-body" class="row"></div>

	<div class="form-group row" id="modal-body">
	
		<div style="position: absolute; margin-left: 45%; margin-top: 105px;">
			<img width="90px" height="90px"
				src="<c:url value="/resources/images/ajax-loading.gif"/>">
		</div>
	</div>


	<div id="table-body" class="row"
		style="overflow-x: auto; margin-bottom: 10px;"></div>
	<a class="btn btn-sm btn-dark text-right"
		style="float: right; bottom: 0px" href="#" rel="modal:close"><strong>X</strong></a>
</div>
<script>


function loadContent(id) {
	
	
	
	 var token = $("meta[name='_csrf']").attr("content");
     var header = $("meta[name='_csrf_header']").attr("content");
		$.ajax({
		type : "GET",
		contentType : "application/json",
	    url: "${url}"+"/"+id,	    
	    dataType : 'html',
	    timeout : 300000,
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
	      
	       
	    },
	    error : function(e) {
	       
	    },
	    done : function(e) {
	      
	    }
	});
	
} 


</script>