<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.acl.entity.Location"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@page import="org.opensrp.facility.entity.FacilityTraining" %>
<%@page import="org.opensrp.facility.entity.FacilityWorkerType" %>
<%
List<FacilityWorkerType> workerTypeList= (List<FacilityWorkerType>)session.getAttribute("workerTypeList");

/* Map<Integer, String> supervisors =  (Map<Integer, String>)session.getAttribute("supervisors");

String selectedLocationName = (String)session.getAttribute("locationName");

Integer selectedSupervisor = (Integer)session.getAttribute("selectedSuperviosr"); */


	%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" href="<c:url value="/resources/css/jqx.base.css"/>" rel="stylesheet">

<title>Add Team</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/facility/saveWorker.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		<div class="form-group">				
				   <a  href="<c:url value="/team/list.html"/>"> <strong> Manage Team</strong> 
					</a>  |  <a  href="<c:url value="/team/teammember/list.html"/>"> <strong>Manage Team Member</strong>
					</a>		
		</div>
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Add Worker
				</div>
				<div class="card-body">
				
					<form:form method="POST" action="${saveUrl}" modelAttribute="facilityWorker">
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Name  </label>
									<form:input path="name" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Name" /> 
									<span class="text-red">${uniqueNameErrorMessage}</span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Identifier</label>
									<form:input path="identifier" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="identifier" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
						
						<form:hidden path="facility.id" id="facilityId"/>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Organization</label>
									<form:input path="organization" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="identifier" />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
					
					
					
					
					
					    <div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName">Worker type</label>
										<select class="custom-select custom-select-lg mb-3" id="facilityWorkerTypeId" name="facilityWorkerTypeId" required>
									 		<option value="" selected>Please Select</option>
												<%
												for (FacilityWorkerType workerType : workerTypeList)
												{
														%>
															<option value="<%=workerType.getId() %>"><%=workerType.getName()%></option>
														<%
												}
												%>
											</select>
											<span class="text-red">${supervisorUuidErrorMessage}</span>
									</div>									
								</div>
							
						</div>
						
						
						<input type="text" id= "trainings" name="trainings" value="" readonly>
						<div class="form-group">
							<div class="form-check">
								<div class="row">

									<%
										List<FacilityTraining> CHCPTrainingList = (List<FacilityTraining>) session.getAttribute("CHCPTrainingList");											
										for (FacilityTraining facilityTraining : CHCPTrainingList) {
									%>
									<div class="col-5">
										<input type="checkbox" value=<%=facilityTraining.getId()%> onclick="check()">
												
										<label class="form-check-label" for="defaultCheck1"> <%=facilityTraining.getName()%>
										</label>
									</div>
									<%
										}
										%>


								</div>
							</div>
							
						</div>
						
						
						
						
						
							
						
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="Save"
										class="btn btn-primary btn-block" />
								</div>
							</div>
						</div>
					</form:form>
				</div>
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	
<script type="text/javascript"> 
var trainingList = [];

$(document).ready(function() {
	$("#trainings").hide();
});


function check(){
	var allVals = [];
	$('input:checked').each(function () {
		allVals.push($(this).val());
	});
	trainingList = allVals;
	$("#trainings").val(trainingList.toString());
}

</script>	
	  
</body>
</html>
