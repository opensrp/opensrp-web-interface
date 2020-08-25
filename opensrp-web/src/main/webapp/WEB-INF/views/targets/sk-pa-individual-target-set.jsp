<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>SK, PA  list</title>
	
	
<c:url var="urlForSKPAList" value="/rest/api/v1/target/sk-pa-user-list-for-individual-target-setting" />



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
							<i class="fa fa-list"></i>SK, PA  list
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							
							<div class="row">
								
								<div class="col-lg-3 form-group">
									<label for="date">Date:</label>
									<input type="text"	readonly name="startYear" id="startYear" class="form-control date-picker-year" />
								</div>
								
								
							</div>
							
						</div>
						<h3>${name }'s target </h3>
						<div class="table-scrollable ">
						<form id="targetInfo"  autocomplete="off">
						<div class="col-md-12 form-group text-al">
				        	<div class="row  form-group">
				        		<div class="col-lg-12 form-group">
				        			<div class="col-md-3">
				                    	<label><strong>Item </strong></label>
				                    </div>
				                     <div class="col-md-3">
				                    	<label><strong>Target</strong></label>
				                    </div>
				                    <div class="col-md-3">
				                    	<label><strong>Item </strong></label>
				                    </div>
				                     <div class="col-md-3">
				                    	<label><strong>Target</strong></label>
				                    </div>
				        		</div>
				        		<br />
				        		<hr />
				        		<c:forEach var="target" items="${ targets }">
				        		<div class="col-lg-6 form-group">
				        			<div class="col-md-6">
				                    	<label><strong>${ target.name } </strong></label>
				                    </div>
				                     <div class="col-md-6">
				                    	<input type="number" class="form-control" min="1" id="${target.id }" name ="qty[]">
				                    </div>
				        		</div>
				        		</c:forEach>
				        	</div>
				        </div>
				        
				        	<div class="col-md-12 form-group text-right">
					    		<div class="row">
							     	<div class="col-lg-12">
										 <button class="bt btn btn-primary" id="approve" name="approve" value="1" type="submit">Submit</button>
									</div>
					            </div>
					        </div>
					       </form>
					            
						</div>
						
						
					</div>
					
				</div>		
					
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

$('#targetInfo').submit(function(event) {
    event.preventDefault();
    
    var d = new Date($("#startYear").datepicker("getDate"));
	var date = d. getDate();
	var month = d. getMonth() + 1; 
	var year = d. getFullYear();
    var item=[];
    
    $('input[name^="qty"]').each(function() { 
    	var details={
    		"productId":$($(this)).attr("id"),
    		"branchId":'${branchId}',
    		"unit":'',
    		"percentage":0.0,
    		"userId":'${userId}',    		
    		"quantity":$(this).val(),
    		"startDate":'2020-08-01',
    		"endDate":'2020-08-01',
    		"month":month,
    		"year":year,
    		"status":"ACTIVE"
    			
    	}
    	item.push(details);
    	
	
	});
    console.log(JSON.stringify(item));
    return 0;
    formData = {
        'id': 0,
        'targetTo':'${userId}',
        'type': '',
        'role': '${roleId}',
        "targetDetailsDTOs":item
    };
    console.log(formData);
    return 0;
    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(formData),
        dataType : 'json',

        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
            $("#loading").show();
        },
        success : function(data) {
            $("#usernameUniqueErrorMessage").html(data);
            $("#loading").hide();
            if(data == ""){
                window.location.replace("/opensrp-dashboard/user.html");
            }
        },
        error : function(e) {
            console.log(e);
        },
        done : function(e) {
            console.log("DONE");
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

















