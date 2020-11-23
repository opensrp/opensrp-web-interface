<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Requistion List</title>
	
	

<c:url var="backUrl" value="/inventoryam/requisition.html" />
<c:url var="searchUrl" value="/rest/api/v1/requisition/list" />
<c:url var="viewURL" value="/inventory/requisition-details" />



<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<a  href="<c:url value="/"/>">Home</a>
					<i class="fa fa-arrow-right"></i>
				</li>
				<li>
					<a  href="${backUrl }">Back</a>
				</li>
		</ul>
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class=center-caption>${branchInfo[0][1]} - ${branchInfo[0][2]}</div>
						</div>
				<input type="hidden" id="selectRequisitionBy" value="<%=AuthenticationManagerUtil.getLoggedInUser().getId() %>">
				<input type="hidden" id="branchid" value="${branchInfo[0][0]}">
			<div class="portlet-body">
				<div class="col-lg-12 form-group requisition-add">
					<a class="btn btn-primary" id="addRequisition"
						href="<c:url value="/inventoryam/requisition-add/${branchInfo[0][0]}.html?lang=${locale}"/>">
						<strong> Add Requisition </strong>
					</a>
				</div>
				<div class="row">

					<div class="col-lg-3 form-group">
						<label for="from"><spring:message code="lbl.from"></spring:message><span
							class="text-danger"> *</span> </label> <input readonly="readonly" type="text"
							class="form-control date" id="from"> <span class="text-danger"
							id="startDateValidation"></span>
					</div>
					<div class="col-lg-3 form-group">
						<label for="to"><spring:message code="lbl.to"></spring:message><span
							class="text-danger"> *</span> </label> <input readonly="readonly" type="text"
							class="form-control date" id="to"> <span class="text-danger"
							id="endDateValidation"></span>
					</div> 

				</div>
				<div class="row">
					<div class="col-lg-12 form-group text-right">
						<button type="button" onclick="filter()" class="btn btn-primary">Search</button>
					</div>
				</div>
				<table class="table table-striped table-bordered " id="requisitionListForAm">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.date"></spring:message></th>
									<th><spring:message code="lbl.requisitionId"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.requisitionBy"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
						</table>
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

var dateToday = new Date();
	var dates = $(".date").datepicker({
    dateFormat: 'yy-mm-dd',
    maxDate: dateToday,
    onSelect: function(selectedDate) {
        var option = this.id == "from" ? "minDate" : "maxDate",
            instance = $(this).data("datepicker"),
            date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
        dates.not(this).datepicker("option", option, date);
    }
});
	$(".date-picker-year").focus(function () {
    $(".ui-datepicker-calendar").hide();
    $(".ui-datepicker-current").hide();
});

	
let requisitionList;
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
	 Layout.init(); // init current layout
   //TableAdvanced.init();
	var branchId = +$('#branchid').val();
	var requisitor = +$('#selectRequisitionBy').val();
	var date = new Date(), y = date.getFullYear(), m = date.getMonth();
	var startDateDm = $.datepicker.formatDate('yy-mm-dd', new Date(y, m, 1));
	var endDateDm = $.datepicker.formatDate('yy-mm-dd', new Date(y, m + 1, 0));
	requisitionList = $('#requisitionListForAm').DataTable({
           bFilter: false,
           serverSide: true,
           processing: true,
           columnDefs: [
               { targets: [0], orderable: false },
               { width: "10%", targets: 0 },
               { width: "20%", targets: 1 },
               { width: "20%", targets: 2 },
               { width: "20%", targets: 3,"visible": false },
               { width: "20%", targets: 4,"visible": false },
               { width: "20%", targets: 5 }
           ],
           ajax: {
               url: "${searchUrl}",
               data: function(data){
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					data.branch = branchId;
					data.requisitor = requisitor;
					data.startDate = startDateDm,
					data.endDate = endDateDm
					
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
/* 	var division = +$('#division').val().split("?")[0];;
	var district = +$('#district').val().split("?")[0];;
	var upazila = +$('#upazila').val().split("?")[0];; */
	var branchId = +$('#branchid').val();
	var requisitor = +$('#selectRequisitionBy').val();
	var startDate = $('#from').val();
	var endDate = $('#to').val();
	if(startDate == "") {
		//startDate = $.datepicker.formatDate('yy-mm-dd', new Date());
		$("#startDateValidation").html("<strong>Please fill out this field</strong>");
		return;
	}
	$("#startDateValidation").html("");
	if(endDate == "") {
		//endDate = $.datepicker.formatDate('yy-mm-dd', new Date());
		$("#endDateValidation").html("<strong>Please fill out this field</strong>");
		return;
	}
	$("#endDateValidation").html("");
	
 		requisitionList = $('#requisitionListForAm').DataTable({
        bFilter: false,
        serverSide: true,
        processing: true,
        columnDefs: [
             { targets: [0], orderable: false },
             { width: "10%", targets: 0 },
             { width: "20%", targets: 1 },
             { width: "20%", targets: 2 },
             { width: "20%", targets: 3,"visible": false },
             { width: "20%", targets: 4,"visible": false },
             { width: "20%", targets: 5 }
        ],
        ajax: {
            url: "${searchUrl}",
            data: function(data){
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					data.branch = branchId;
					data.requisitor = requisitor;
					data.startDate = startDate,
					data.endDate = endDate
					
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

function navigateTodetails(requisitionId,branchName,branchCode) {
	var locale = "${locale}";
	var branchString= "${branchInfo[0][1]}"+"-"+"${branchInfo[0][2]}";
	window.location.assign("${viewURL}/"+requisitionId+".html?lang="+locale+"&branch="+branchString+"&branchid="+'${branchInfo[0][0]}');
}

</script>



















