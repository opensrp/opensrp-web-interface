<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="org.opensrp.core.entity.FacilityWorker"%>
<%@ page import="org.opensrp.core.entity.FacilityTraining"%>
<%@ page import="org.opensrp.core.entity.User"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>


<%
	User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
	List<String> roleList = AuthenticationManagerUtil.getLoggedInUserRoles();
	boolean isAdmin = AuthenticationManagerUtil.isAdmin();
	AuthenticationManagerUtil.showRoleAndStatus();
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
	<%if(workerType.equals("MULTIPURPOSE HEALTH VOLUNTEER")){%>
		<td><button onclick="editMHV(<%=worker.getId() %>)"
				class="btn btn-primary btn-block">
				<spring:message code="lbl.edit" />
			</button></td>
	<%}else{ %>
		<td><button onclick="editWorker(<%=worker.getId() %>)"
				class="btn btn-primary btn-block">
				<spring:message code="lbl.edit" />
			</button></td>
	<%} %>
	
	<%if(workerType.equals("CHCP")){
							if(AuthenticationManagerUtil.isAdmin()){
								%>
	<td><button
			onclick="deleteWorker(<%=worker.getFacility().getId()%>,<%=worker.getId() %>)"
			class="btn btn-danger btn-block">
			<spring:message code="lbl.delete" />
		</button></td>

	<% 
							}else{
								%>
	<td></td>
	<%
							}
						} else{
						%>
	<td><button
			onclick="deleteWorker(<%=worker.getFacility().getId()%>,<%=worker.getId() %>)"
			class="btn btn-danger btn-block">
			<spring:message code="lbl.delete" />
		</button></td>
	<% } %>
</tr>
<%
									
									}
	}
									%>
