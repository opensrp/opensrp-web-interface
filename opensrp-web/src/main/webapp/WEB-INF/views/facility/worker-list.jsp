<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.facility.entity.FacilityWorker"%>
<%@page import="org.opensrp.facility.entity.FacilityTraining"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>


	<%
	List<FacilityWorker> workerList = (List<FacilityWorker>) session.getAttribute("facilityWorkerList");
	String creator = "";
	for (FacilityWorker worker : workerList) 
	{
		
	%>
									
									<tr>
										<td><%=worker.getFacilityWorkerType().getName() %></td>
										<td><%=worker.getName() %></td>
										<td><%=worker.getIdentifier() %></td>
										<td><%=worker.getOrganization() %></td>
										
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
										<td><button onclick="deleteWorker(<%=worker.getId() %>)" class="btn btn-primary btn-block">Delete</button></td>
									</tr>
									<%
									
									}
									%>