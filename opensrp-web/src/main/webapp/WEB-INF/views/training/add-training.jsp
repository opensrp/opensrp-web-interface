<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Add Training</title>
	
	

<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<style>

    /*for computers*/
    @media screen and (min-width: 992px) {
        .modal-margin {
            margin-top: 5%;
        }
    }
    /*for mobile devices*/
    @media screen and (max-width: 992px) {
        .modal-margin {
            margin-top: 40%;
        }
    }
</style>	

<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="center-caption">Add Training</div>


			</div>
			
			<div class="portlet-body">
			<div><h3 class="text-red text-center" id="serverResponseMessage"></h3></div>
				<div class="card-body">
					<div id="loading"
						style="display: none;position: absolute; z-index: 1000; margin-left: 35%">
						<img width="50px" height="50px"
							src="<c:url value="/resources/images/ajax-loading.gif"/>">
					</div>

				</div>
				<form id = "addProduct">
				<div class="col-lg-7">
					<div class="form-group row">
						<label for="trainingTitle" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingTitle"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="trainingTitle" name ="trainingTitle" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingId" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingId"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text" class="form-control" id="trainingId" name ="trainingId">
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingStartDate" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingStartDate"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="date" class="form-control" id="trainingStartDate" name = "trainingStartDate" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingDuration" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingduration"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="number" min="1"  class="form-control" id="trainingDuration" name ="trainingDuration" >
						</div>
					</div>
					<div class="form-group row">
						<label for="trainingAudience" class="col-sm-4 col-form-label"><spring:message code="lbl.trainingAudience"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text"  class="form-control" id="trainingAudience" name ="trainingAudience" required >
						</div>
					</div>
					<div class="form-group row">
						<label for="participantNumber" class="col-sm-4 col-form-label"><spring:message code="lbl.participantNumber"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="number" min="1"  class="form-control" id="participantNumber" name ="participantNumber" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="nameOfTrainer" class="col-sm-4 col-form-label"><spring:message code="lbl.nameOfTrainer"></spring:message><span class="text-danger">*</span> :</label>
						<div class="col-sm-6">
							<input type="text"  class="form-control" id="nameOfTrainer" name ="nameOfTrainer" required>
						</div>
					</div>
					<div class="form-group row">
						<label for="designationOfTrainer" class="col-sm-4 col-form-label"><spring:message code="lbl.designationOfTrainer"></spring:message> :</label>
						<div class="col-sm-6">
							<input type="text"  class="form-control" id="designationOfTrainer" name ="designationOfTrainer" >
						</div>
					</div>
					<div class="form-group row">
						<label  class="col-sm-4 col-form-label"><spring:message code="lbl.location"></spring:message><span class="text-danger">*</span> :</label>
						
						 <div class="col-sm-6">
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="checkbox" value="branch" id="skcheckbox1"> <label
										class="form-check-label" >Branch
									</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="checkbox" value="hq" id="skcheckbox1"> <label
										class="form-check-label">HQ
									</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="checkbox" value="blc" id="skcheckbox1"> <label
										class="form-check-label" >BLC
									</label>
								</div>
								<div class="form-check">
									<input class="form-check-input" name="locationName"
										type="checkbox" value="others" id="skcheckbox1"> <label
										class="form-check-label">Others
									</label>
								</div>
							<p>
	                          		 <span class="text-danger" id="checkBoxSelection"></span>
	                        	</p>
						</div> 
					</div>
					</div>
				<div class="col-lg-5">
					<div class="form-group row">
						<label for=attendanceList class="col-sm-6 col-form-label"><spring:message code="lbl.attendanceList"></spring:message>:<span class="text-danger">*</span></label>
						<div class="col-sm-6">
							<button type="button" class="btn btn-primary" onclick="openAttendaceModal()" id="addAttendance" >Add Attendance</button>
						</div>
					</div>
					<div class="table-scrollable ">
					<table class="table table-striped table-bordered " id="trainingList">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
								    <th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.branch"></spring:message>/<spring:message code="lbl.location"></spring:message></th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						</div>
					</div>

					<div class="form-group row"></div>
					<div class="form-group row">
						<div class="col-sm-3"></div>
						<div class="col-sm-2">
							<a class="btn btn-danger" id="cancelProduct"
								href="<c:url value="/training/view-training.html?lang=${locale}"/>">
								<strong>Cancel</strong>
							</a>
						</div>
						<div class="col-sm-2">
							<button type="submit" onclick="return Validate()" class="btn btn-primary">Confirm</button>
						</div>
					</div>
				</form>
				<div class="modal modal-margin" id="addAttendanceModal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 75%;">
						
					<div class="row">
					<div class="modal-header text-center" style="border-bottom: none;">
										<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
										<h4 class="modal-title">
											<Strong>Trainer List</Strong>
										</h4>
									</div>
						<div id="validationSelectOne" style="display: none"
							class="alert alert-danger text-center" role="alert">Please
							select one to proceed</div>
							<div class="form-group row">
							<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.designation"></spring:message> :</label> 
								    <select class="form-control mx-sm-3 js-example-basic-multiple" id="selectRole" name="selectRole">
									<option value="0"><spring:message
											code="lbl.pleaseSelect" /></option>
									<c:forEach items="${roles}" var="role">
										<option value="${role.id}">${role.name}</option>
									</c:forEach>
									</select>
								</div>
                               <div class="col-lg-3">
											<label class="control-label" for="username"> <spring:message code="lbl.branches"/> <span class="required">* </span>	</label>                                     
											<select id="branches"
			                                class="form-control mx-sm-3 js-example-basic-multiple"
			                                name="branches" required>
			                                <option value="0"><spring:message
												code="lbl.selectBranch" /></option>
			                            <c:forEach items="${branches}" var="branch">
			                                <option value="${branch.id}">${branch.name}</option>
			                            </c:forEach>
			                        </select>
                                </div>
                            </div>
							 
						<div class="row">
							<div class="col-lg-12 form-group text-right">
								<button type="button" onclick="filter()" class="btn btn-primary">Search</button>
							</div>
						</div>
						<br />
						<table class="table table-striped table-bordered record_table"
							id="addAttendanceList">
							<thead>
								<tr><th>Select</th>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
								    <th><spring:message code="lbl.name"></spring:message></th>
								    <th>ID</th>
									<th><spring:message code="lbl.designation"></spring:message></th>
								</tr>
							</thead>
							<tbody>
							<tr>
								<td><input type="checkbox" class="remove-checkbox" value="selectall"></td>
								<td>1</td>
								<td>Tariqul</td>
								<td>xxxxx</td>
								<td>PA</td>
							</tr>
							</tbody>
						</table>
						<div class="text-center" id="proceedDiv">
							<button id="proceeddProductButton" type="button"
								class="btn btn-primary" onclick="appendRowInTable()">Proceed</button>
						</div>
						<div class="footer text-right">
							<a href="#close-modal" class="btn btn-default" rel="modal:close"
								class="close-modal ">Close</a>
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
		$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
		//$('#addAttendanceList').DataTable();
});

function openAttendaceModal() {
	$('#addAttendanceModal').modal({
        escapeClose: false,
        clickClose: false,
        closeExisting: false,
        showClose: false,        // Shows a (X) icon/link in the top-right corner
        show: true
	});
	//$(".close-modal").hide();
/* 	$('#addAttendanceList tbody input[type=checkbox]:checked').each(function(index, tr) {
        $(this).prop("checked", false);
        $('.checked').removeClass('checked').addClass('');
    }); */
}

function appendRowInTable() {
$('#trainingList tbody').empty();
$('#addAttendanceList tbody input[type=checkbox]:checked').each(function(index, tr) {
			var ssId = +$(this).val();
			var $row = $(this).closest('tr');
			var name = $row.find('td').eq(2).text();
			var id = $row.find('td').eq(3).text();
			var designation = $row.find('td').eq(4).text();
			var location = "Unknown";
			var size = jQuery('#trainingList >tbody >tr').length + 1
			$("#trainingList tbody").append("<tr><td>"+size+"</td><td>"+name+"</td><td>"+designation+"</td><td>"+location+"</td></tr>");
	});
	$.modal.close();

	}

	/* $("#addProduct").submit(function(event) { 
		 debugger;
		 $("#loading").show();
		 var url = "/opensrp-dashboard/rest/api/v1/product/save-update";			
		 var token = $("meta[name='_csrf']").attr("content");
		 var header = $("meta[name='_csrf_header']").attr("content");
		 var sellTo = [];
		 $("input:checkbox[name=sellerName]:checked").each(function(){
		 sellTo.push(+$(this).val());
		 });
		 var formData;
		
		 formData = {
		 'name': $('input[name=productName]').val(),
		 'description': $('input[name=productDescription]').val(),
		 'id': 0,
		 'purchasePrice': +$('input[name=purchasePrice]').val(),
		 'sellingPrice': +$('input[name=sellingPrice]').val(),
		 'sellTo': sellTo,
		 'status': "ACTIVE",
		 'type': "PRODUCT"
		 };
		 console.log(formData)
		 event.preventDefault();
		
		 $.ajax({
		 contentType : "application/json",
		 type: "POST",
		 url: url,
		 data: JSON.stringify(formData), 
		 dataType : 'json',
		
		 timeout : 100000,
		 beforeSend: function(xhr) {				    
		 xhr.setRequestHeader(header, token);
		 },
		 success : function(data) {
		 debugger;
		 var response = JSON.parse(data);
		 $("#serverResponseMessage").html(response.msg);
		 $("#loading").hide();
		 if(response.status == "SUCCESS"){					   
		 window.location.replace("/opensrp-dashboard/inventorydm/products-list.html");
		
		 }
		
		 },
		 error : function(e) {
		
		 },
		 done : function(e) {				    
		 console.log("DONE");				    
		 }
		 });
		 });	
	
		 function Validate() {
	
		 if($('input[type=checkbox]:checked').length == 0)
		 {
		 $("#checkBoxSelection").html("<strong>Please fill out this field</strong>");
		 return false;
		 }
		
		 $("#checkBoxSelection").html("");
	 }
	 */
</script>



















