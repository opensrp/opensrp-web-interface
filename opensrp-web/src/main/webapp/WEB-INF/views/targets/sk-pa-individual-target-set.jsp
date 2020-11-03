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
	
<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="add_url" value="/rest/api/v1/target/save-update" />
<c:url var="redirect_url" value="/target/target-by-individual.html" />
<c:url var="get_target_url" value="/target/get-target-info" />


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
							<i class="fa fa-list"></i>Individual Target
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							
							<div class="row">
								<form style="margin-top: 10px">
									<div class="col-lg-1">
										<label for="monthly" onclick="onTimeChange('monthly')">
											<input type="radio" id="monthly" value="monthly" name="time-period"> <br>Monthly
										</label>
									</div>
									<div class="col-lg-1">
										<label for="daily" onclick="onTimeChange('daily')">
											<input type="radio" id="daily" value="daily" name="time-period"> <br> Daily
										</label>
									</div>
								</form>
								<div class="col-lg-3 form-group" id="dateField">
									<label >Date:</label> <span class="text-danger"> *</span>
									<input type="text"	readonly name="date" id="dateFieldInput" class="form-control " />
									<span  class="text-danger validationMessage"></span>
								</div>
								<div class="col-lg-3 form-group" id="monthField">
									<label>Month And Year:</label> <span class="text-danger"> *</span>
									<input type="text"	readonly name="startYear" id="monthFieldInput" class="form-control date-picker-year" />
									<span  class="text-danger validationMessage"></span>
								</div>
								<div class="col-lg-2" style="padding-top: 20px"><span id="targetValidationMsg"></span></div>
								<div class="col-lg-5 form-group text-right">
									<button type="submit" onclick="getTargetInfo()" class="btn btn-primary" value="confirm">Same as previous month</button>
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
				        		<div id="productInfoS">
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
				        </div>
				       <div id="errorMessage">
										  <div class="alert-message warn">
										      <div id="errormessageContent" class="alert alert-successs text-right"> </div>
										  </div>
							</div> 
				       		
						
				        <div class="col-md-12 form-group text-right">
					    		<div class="row">
							     	<div class="col-lg-12">
										 <button class="bt btn btn-primary" id="submitTarget" name="s" value="1" type="submit">Submit</button>
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
	var timePeriod = 'monthly';
	//initial value for radio button
	$("#monthly").attr('checked', 'checked');
jQuery(document).ready(function() {       
	Metronic.init(); // init metronic core components
	Layout.init(); // init current layout
	enableTimeField();
});

function getTargetTime() {
	return timePeriod == 'monthly' ? $('#monthFieldInput').val() : $('#dateFieldInput').val();
}

function getTargetInfo(){
	var date = getTargetTime();
	if(date == "" || date ==null) {
		$(".validationMessage").html("<strong>This field is required</strong>");
		return;
	}
	$(".validationMessage").html("");
	var d = new Date(date);
	var date = d.getDate();
	var month = (d.getMonth() + 1)-1;
	var year = d.getFullYear();
	var day = 0;
	
	/* var monthYearString=$('input#startYear').val();
	var splitingString = monthYearString.split("-");
	var month = parseInt(splitingString[0])-1;
	var year = parseInt(splitingString[1]); */
	if(month==0){
		console.log(month);
		month = 12;
		year = year-1;
	}
	var url = '${get_target_url}';
	
    url = url+"?locationOrBranchOrUserId="+'${userId}'+"&role="+'${roleId}'+"&typeName="+'USER'+"&locationTag="+'NA'+"&month="+month+"&year="+year+"&day="+day;

	$.ajax({
        contentType : "application/json",
        type: "GET",
        url: url,        
        dataType : 'html',
        timeout : 100000,
        beforeSend: function(xhr) {            
            $("#loading").show();
        },
        success : function(data) {
        	console.log(data);
        	$("#productInfoS").html(data);
        },
        error : function(e) {
            console.log(e);
        },
        done : function(e) {
            console.log("DONE");
        }
    });
}

$('#targetInfo').submit(function(event) {
    event.preventDefault();
    
/*     var d = new Date($("#startYear").datepicker("getDate"));
	var date = d. getDate();
	var month =0; 
	var year = 0;
	
	var monthYearString=$('input#startYear').val();
	var splitingString = monthYearString.split("-");
	month = parseInt(splitingString[0]);
	year = parseInt(splitingString[1]); */
	var date = getTargetTime();
	if(date == "" || date ==null) {
		$(".validationMessage").html("<strong>This field is required</strong>");
		return;
	}
	$("#validationMessage").html("");
	var d = new Date(date);
	var date = d.getDate();
	var month = d.getMonth() + 1;
	var year = d.getFullYear();

	var todayDate = new Date(), y = todayDate.getFullYear(), m = todayDate.getMonth();
	var startDate = $.datepicker.formatDate('yy-mm-dd', new Date(y, m, 1));
	var endDate =  $.datepicker.formatDate('yy-mm-dd', new Date(y, m + 1, 0));
    var item=[];
    let token = $("meta[name='_csrf']").attr("content");
    let header = $("meta[name='_csrf_header']").attr("content");
    $('input[name^="qty"]').each(function() { 
    	var details={
    		"productId":$($(this)).attr("id"),
    		"branchId":'${branchId}',
    		"unit":'quantity',
    		"percentage":0.0,
    		"userId":'${userId}',    		
    		"quantity":$(this).val(),
    		"startDate":startDate,
    		"endDate":endDate,
    		"month":month,
    		"year":year,
			"day": timePeriod == 'monthly' ? 0 : date,
    		"status":"ACTIVE"
    			
    	}
    	item.push(details);
    	
	
	});
    
  
    formData = {
        'id': 0,
        'targetTo':'${userId}',
        'type': 'USER',
        'role': '${roleId}',
        "targetDetailsDTOs":item
    };
    console.log(formData);
    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: '${add_url}',
        data: JSON.stringify(formData),
        dataType : 'json',

        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
            $("#loading").show();
        },
        success : function(data) {
        	let response = JSON.parse(data);
    		console.log(response);
    		$("#errorMessage").show();            	  
            $("#errormessageContent").html(response.msg)  
            if(response.status == 'SUCCESS'){
            	setTimeout(function(){
            		 window.location.replace("${redirect_url}");
                 }, 2000);

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
	jQuery('#monthFieldInput').datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        minDate: new Date,
        onClose: function(dateText, inst) { 
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
			$(".validationMessage").html("");
            fetchTargetInfo();
        }
    });
	jQuery(".date-picker-year").focus(function () {
        $(".ui-datepicker-calendar").hide();
        $(".ui-datepicker-current").hide();
    });
});

jQuery(function() {
	jQuery('#dateFieldInput').datepicker({
		showButtonPanel: true,
		dateFormat: 'dd-MM-yy',
		minDate: new Date,
		onClose: function(dateText, inst) {
			var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
			$(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay));
			$(".validationMessage").html("");
			fetchTargetInfo();
		}
	});
	jQuery(".date-picker-year").focus(function () {
		$(".ui-datepicker-calendar").hide();
		$(".ui-datepicker-current").hide();
	});
});

function onTimeChange(value) {
	timePeriod = value;
	enableTimeField();
}

function enableTimeField() {
	if(timePeriod == 'monthly') {
		$('#dateField').hide();
		$('#monthField').show();
	}
	else {
		$('#monthField').hide();
		$('#dateField').show();
	}
}

function fetchTargetInfo() {

	let token = $("meta[name='_csrf']").attr("content");
	let header = $("meta[name='_csrf_header']").attr("content");
	var date = new Date(getTargetTime());
	var data = {
		userId: '${userId}',
		branchId: '${branchId}',
		year: date.getFullYear(),
		month: date.getMonth()+1,
		day: timePeriod == 'monthly' ? 0 : date.getDate()
	};
	$.ajax({
		contentType : "application/json",
		type: "GET",
		url: '/opensrp-dashboard/rest/api/v1/target/target-availability',
		data: data,
		dataType : 'json',
		timeout : 100000,
		beforeSend: function(xhr) {
			xhr.setRequestHeader(header, token);
			$("#loading").show();
		},
		success : function(data) {
			console.log("availability: ", data);
			if(data.exist > 0) {
				$('#targetValidationMsg').html('<p style="color: darkred">target has already set for this time period</p>');
				$('#submitTarget').attr("disabled","disabled");
			}
			else {
				$('#targetValidationMsg').html('');
				$('#submitTarget').removeAttr('disabled');
			}
		},
		error : function(e) {
			console.log(e);
		},
		done : function(e) {
			console.log("DONE");
		}
	});
}

</script>

















