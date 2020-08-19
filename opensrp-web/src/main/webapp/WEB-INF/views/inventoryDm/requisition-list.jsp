<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<%
    List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
%>

<title>Requisition</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							Requisition(AM)
						</div>


					</div>				
					<div class="portlet-body">
					
						<div class="form-group">
						<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.division"></spring:message> :</label> <select class="form-control" id="division" name="division">
										<option value=""><spring:message
												code="lbl.selectDivision" />
										</option>
										<%
											for (Object[] objects : divisions) {
										%>
										<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
										<%
											}
										%>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.district"></spring:message> :</label> <select class="form-control" id="district" name="district">
										<option value="0?"><spring:message
												code="lbl.selectDistrict" /></option>
										<option value=""></option>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.upazila"></spring:message> :</label> <select class="form-control" id="upazila" name="upazila">
										<option value="0?"><spring:message
												code="lbl.selectUpazila" /></option>
										<option value=""></option>

									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.branch"></spring:message> :</label> 
								    <select class="form-control js-example-basic-multiple"
										id="branch" name="branch">
										<option value="0"><spring:message
												code="lbl.selectBranch" /></option>
										<c:forEach items="${branches}" var="branch">
										<option value="${branch.id}">${branch.name}</option>
										</c:forEach>

										
									</select>
								</div>
								
							</div>
							<div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation"><spring:message code="lbl.requisitionBy"></spring:message> :</label>
									<select
										name="requisitor" class="form-control" id="requisitor">
										<option value="0">Select Requision By</option>
										<c:forEach items="${roles}" var="role">
										<option value="${role.id}">${role.name}</option>
										</c:forEach>
									</select>
								</div>
								
								<div class="col-lg-3 form-group">
								    <label for="from"><spring:message code="lbl.from"></spring:message> :</label>
									<input type="date" class="form-control" id="from">
								</div>
								<div class="col-lg-3 form-group">
									<label for="to"><spring:message code="lbl.to"></spring:message>:</label>
									<input type="date" class="form-control" id="to">
								</div>
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="button" onclick="filter()"  class="btn btn-primary">View</button>
								</div>
     							</div>
							<br/>
						
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
let requisitionList;
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
	 Layout.init(); // init current layout
   //TableAdvanced.init();
	$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
	requisitionList = $('#requisitionListForAm').DataTable({
           bFilter: false,
           serverSide: true,
           processing: true,
           columnDefs: [
               { targets: [0], orderable: false },
               { width: "20%", targets: 0 },
               { width: "20%", targets: 1 },
               { width: "20%", targets: 2 },
               { width: "20%", targets: 3 },
               { width: "20%", targets: 4 },
               { width: "20%", targets: 5 }
           ],
           ajax: {
               url: "/opensrp-dashboard/rest/api/v1/requisition/list",
               data: function(data){
					data.division = 0;
					data.district = 0;
					data.upazila = 0;
					data.branch = 0;
					data.requisitor = 0;
					data.startDate = "2020-06-30",
					data.endDate = "2020-08-30"
					
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
	var division = +$('#division').val().split("?")[0];;
	var district = +$('#district').val().split("?")[0];;
	var upazila = +$('#upazila').val().split("?")[0];;
	var requisitor = +$('#requisitor').val();
	var branch = +$('#branch').val();
	var startDate = $('#from').val();
	var endDate = $('#to').val();
	if(startDate == "") {
		startDate = $.datepicker.formatDate('yy-mm-dd', new Date());
	}
	
	if(endDate == "") {
		endDate = $.datepicker.formatDate('yy-mm-dd', new Date());
	}
	
 		requisitionList = $('#requisitionListForAm').DataTable({
        bFilter: false,
        serverSide: true,
        processing: true,
        columnDefs: [
            { targets: [0], orderable: false },
            { width: "20%", targets: 0 },
            { width: "20%", targets: 1 },
            { width: "20%", targets: 2 },
            { width: "20%", targets: 3 },
            { width: "20%", targets: 4 },
            { width: "20%", targets: 5 }
        ],
        ajax: {
            url: "/opensrp-dashboard/rest/api/v1/requisition/list",
            data: function(data){
					data.division = division;
					data.district = district;
					data.upazila = upazila;
					data.branch = branch;
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

</script>



















