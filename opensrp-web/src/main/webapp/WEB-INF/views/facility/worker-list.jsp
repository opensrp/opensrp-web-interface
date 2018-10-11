<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.facility.entity.FacilityWorker"%>
<%@page import="org.opensrp.facility.entity.FacilityTraining"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>


<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>


	<%
	List<FacilityWorker> workerList = (List<FacilityWorker>) session.getAttribute("facilityWorkerList");
	String creator = "";
	if(workerList!=null){
	for (FacilityWorker worker : workerList) 
	{
		String workerType = worker.getFacilityWorkerType().getName() != null? worker.getFacilityWorkerType().getName() : "";
		String workerName = worker.getName() != null? worker.getName() : "";
		String workerIdentifier = worker.getIdentifier() != null? worker.getIdentifier() : "";
		String workerOrganization = worker.getOrganization() != null? worker.getOrganization() : "";
	%>
									
									<tr>
										<td><%=workerType %></td>
										<td><%=workerName %></td>
										<td><%=workerIdentifier %></td>
										<td><%=workerOrganization %></td>
										
	<% 	
	String trainingString = "";
	Set<FacilityTraining> trainings = worker.getFacilityTrainings();

	int numOfElement = trainings.size();
	int counter = 1;
		for(FacilityTraining training : trainings){
			trainingString += training.getName();
			if(counter != numOfElement){
				trainingString += "<br>";
			}
			counter++;
		}
	%>
										<td><%=trainingString %></td>
										<td><button onclick="editWorker(<%=worker.getId() %>)" class="btn btn-primary btn-block"><spring:message code="lbl.edit"/></button></td>
										<td><button onclick="deleteWorker(<%=worker.getFacility().getId()%>,<%=worker.getId() %>)" class="btn btn-primary btn-block"><spring:message code="lbl.delete"/></button></td>
									</tr>
									<%
									
									}
	}
									%>