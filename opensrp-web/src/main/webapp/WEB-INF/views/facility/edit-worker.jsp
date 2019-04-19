<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.core.entity.FacilityWorker"%>
<%@page import="org.opensrp.core.entity.FacilityTraining"%>
<%@page import="org.opensrp.core.entity.FacilityWorkerType" %>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

	<%
	FacilityWorker workerToEdit = (FacilityWorker) session.getAttribute("workerToEdit");
	int facilityId = workerToEdit.getFacility().getId();
	int workerId = workerToEdit.getId();
	String name = workerToEdit.getName()!=null? workerToEdit.getName() : "";
	String identifier = workerToEdit.getIdentifier()!=null? workerToEdit.getIdentifier() : "";
	String organization = workerToEdit.getOrganization()!=null? workerToEdit.getOrganization() : "";
	FacilityWorkerType workerToEditType = workerToEdit.getFacilityWorkerType();
	Set<FacilityTraining> workerToEditTrainings = workerToEdit.getFacilityTrainings();
	String visualStatus = "none";
	if(workerToEditType.getId()==1){
		visualStatus = "block";
	}
	List<FacilityWorkerType> workerTypeList= (List<FacilityWorkerType>)session.getAttribute("workerTypeList");
	List<FacilityTraining> CHCPTrainingList = (List<FacilityTraining>) session.getAttribute("CHCPTrainingList");
	%>
	<input name="facilityId" id="facilityId" value="<%=facilityId%>" style="display: none;"/>
	<input name="workerId" id="workerId" value="<%=workerId%>" style="display: none;"/>
	<input name="newWorker" id="newWorker" value="0" style="display: none;"/>
	
	<div class="form-group">							
	<div class="row">									
		<div class="col-5">
		<label for="exampleInputName"><spring:message code="lbl.healthWorkerType"/> </label>
			<select class="custom-select custom-select-lg mb-3" id="facilityWorkerTypeId" name="facilityWorkerTypeId" onchange="checkForTraining()" required>
		 		<option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
					<%
					for (FacilityWorkerType workerType : workerTypeList)
					{
						if(workerToEditType.getId()==workerType.getId() ){
							%>
							<option value="<%=workerType.getId() %>" selected><%=workerType.getName()%></option>
						<%
						}else{
							%>
								<option value="<%=workerType.getId() %>"><%=workerType.getName()%></option>
							<%													
						}
					}
					%>
				</select>
				<span class="text-red">${supervisorUuidErrorMessage}</span>
			</div>									
		</div>
	</div>
	
	<div class="form-group" id="messageDiv"  style="display: none;">
		<div class="form-check">
			<div class="row">
				<div class="col-10">
					<label for="exampleInputName" id="msg" style="color:Tomato;border:2px solid Tomato;"></label><br>
				</div>
			</div>
		</div>
	</div>
	
	<div class="form-group">
		<div class="row">
			<div class="col-5">
			 <label for="exampleInputName"><spring:message code="lbl.healthWorkerName"/>  </label>
				<input name="name" class="form-control"
					required="required" aria-describedby="nameHelp"
					placeholder="<spring:message code="lbl.name"/>" value="<%=name%>"/> 
				<span class="text-red">${uniqueNameErrorMessage}</span>
			</div>
		</div>
	</div>
	<div class="form-group">
		<div class="row">
			<div class="col-5">
				<label for="exampleInputName"><spring:message code="lbl.healthWorkerContact"/></label>
				<input name="identifier" class="form-control"
					required="required" aria-describedby="nameHelp"
					pattern="^01[3-9]\d{8}$" title="11 digit mobile number,must start with 013-019 "
					placeholder="<spring:message code="lbl.healthWorkerContact"/>" value="<%=identifier%>"/>
				<span class="text-red">${uniqueIdetifierErrorMessage}</span>
			</div>
		</div>
	</div>
	
	<div class="form-group" id="organizationDiv">
		<div class="row">
			<div class="col-5">
				<label for="exampleInputName"><spring:message code="lbl.healthWorkerOrganization"/> </label>
				<input name="organization" class="form-control"
					required="required" aria-describedby="nameHelp"
					placeholder="<spring:message code="lbl.healthWorkerOrganization"/>" value="<%=organization%>"/>
				<span class="text-red">${uniqueIdetifierErrorMessage}</span>
			</div>
		</div>
	</div>
					
	
	<div class="form-group" id="trainingDiv"  style="display:<%=visualStatus%> ;">
		<div class="form-check">
			<div class="row">
				<div class="col-10">
				<label for="exampleInputName"><spring:message code="lbl.trainingsOfChcp"/></label><br>
			    </div>
				<%
					String trainingListString = "";
					int counter = 0;							
					for (FacilityTraining facilityTraining : CHCPTrainingList) {
						if(workerToEditTrainings.size()>0 && workerToEditTrainings.contains(facilityTraining)){
							if(counter == 0){
								trainingListString += facilityTraining.getId();
							}else{
								trainingListString += ","+facilityTraining.getId();
							}
							counter++;
							%>
							<div class="col-5">
								<input type="checkbox" value=<%=facilityTraining.getId()%> onclick="check()" checked>
										
								<label class="form-check-label" for="defaultCheck1"> <%=facilityTraining.getName()%>
								</label>
							</div>
							<%
							
						}else{
							%>
							<div class="col-5">
								<input type="checkbox" value=<%=facilityTraining.getId()%> onclick="check()">
										
								<label class="form-check-label" for="defaultCheck1"> <%=facilityTraining.getName()%>
								</label>
							</div>
							<%
						}
					}
					%>
			</div>
		</div>
	</div>
	
	<input type="text" id= "trainings" name="trainings" value="<%=trainingListString %>" style="display: none;" readonly>
						
	<div class="form-group">
		<div class="row">
		<div class="col-2">
				<%-- <button onclick="cancelWorkerEdit(<%=facilityId %>)" class="btn btn-danger btn-block"><spring:message code="lbl.cancel"/></button>--%>
	   	 	<a  href="" onclick="location.reload()" class="btn btn-danger btn-block">
								 	 <strong><spring:message code="lbl.cancel"/></strong>
								 </a>
	   	 </div>
			<div class="col-2" id="saveButtonDiv">
				<input type="submit" value="<spring:message code="lbl.save"/>"
					class="btn btn-success btn-block"/>
			</div>
		</div>
	</div>