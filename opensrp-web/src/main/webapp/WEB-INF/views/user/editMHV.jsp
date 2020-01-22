<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>


<c:url var="saveUrl" value="/user/${id}/${facilityWorkerId}/editMHV.html" />
<%
String selectedParentUser = (String)session.getAttribute("parentUserName");
Integer selectedParentId = (Integer)session.getAttribute("parentUserId");

//for teamMember
Integer selectedPersonId = (Integer)session.getAttribute("selectedPersonId");
String locationList = (String)session.getAttribute("locationList"); 
String selectedLocationList = (String)session.getAttribute("selectedLocationList"); 

Map<Integer, String> teams =  (Map<Integer, String>)session.getAttribute("teams");

String selectedPersonName = (String)session.getAttribute("personName");

Integer selectedTeamId = (Integer)session.getAttribute("selectedTeamId");
int roleIdCHCP= -1;
int roleIdProvider= -1;

%>

					<form:form method="POST" action="${saveUrl}"
						modelAttribute="account" class="form-inline">						
						
								
						<div class="row col-12 tag-height">						 
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"> <spring:message code="lbl.firstName"/> </label>										 
								<form:input path="firstName" class="form-control mx-sm-3"
								required="required"/>
							</div>							
						 </div>
						 
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.lastName"/> </label>										 
								<form:input path="lastName" class="form-control mx-sm-3"
											required="required"/>								
							 </div>
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width"  for="inputPassword6"> <spring:message code="lbl.email"/> </label>								
								<input type="email" class="form-control mx-sm-3" name="email" value="${account.getEmail()}" required="required">										 
															
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.mobile"/></label>										 
								<form:input path="mobile" class="form-control mx-sm-3" />								
							 </div>
						 </div>	
						
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.identifier"/></label>										 
								<form:input path="idetifier" class="form-control mx-sm-3" />
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		<spring:message code="lbl.identifierMsg"/> 
	                        	</small>
							 </div>
						 </div>
						
						
						
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.username"/></label>
								<form:input path="username" class="form-control mx-sm-3"
									readonly="true"	required="required"/>
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		<span class="text-red" id="usernameUniqueErrorMessage"></span> <spring:message code="lbl.userMessage"/> 
	                        	</small>
							 </div>							 
						 </div>
						 <form:hidden path="parentUser" id="parentUser" value="<%=selectedParentId %>"/>
						 <div class="row col-12 tag-height" style="display:none">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.parentUser"/></label>										 
								<select id="combobox" class="form-control">	</select>								
							 </div>							 
						 </div>
						
						
						<form:hidden path="uuid" />
						<form:hidden path="personUUid" />
						<form:hidden path="provider" />
						<form:hidden path="chcp" />
						
						
						<form:hidden path="id" />
						<form:hidden path="password" />
						<div class="row col-12 tag-height" style="display:none">	
							<div class="form-group required">
							<label class="label-width"  for="inputPassword6"><spring:message code="lbl.role"/></label>								
								<%
									if(session.getAttribute("roles")!=null){
										List<Role> roles = (List<Role>) session.getAttribute("roles");
										int[] selectedRoles = (int[]) session.getAttribute("selectedRoles");
										for (Role role : roles) {
											if(role.getName().equals("Provider")){
												roleIdProvider = role.getId();
											}else if(role.getName().equals("CHCP")){
												roleIdCHCP = role.getId();
											}
								%>
										
											<form:checkbox class="checkBoxClass form-check-input"
												path="roles" value="<%=role.getId()%>" onclick='roleSelect(this)'
												checked="<%=CheckboxHelperUtil.checkCheckedBox(selectedRoles,role.getId())%>" />
											<label class="form-control mx-sm-3" for="defaultCheck1"> <%=role.getName()%>
											</label>
										
									<%
											}
									}
									%>
							</div>
						</div>
						
						
						
						<!-- for location -->
						 <div class="row col-12 tag-height" id="locationDiv" style="display:none">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.location"/></label>										 
								<div id="cm" class="ui-widget ">
									<div id="locationsTag" ></div>
									<span class="text-red">${locationSelectErrorMessage}</span>		
								</div>						
							 </div>
						 </div>	
						 
						<%--  <div id="cm" class="ui-widget">
										<label><spring:message code="lbl.location"/> </label>
										<div id="locationsTag"></div>
										<span class="text-red">${locationSelectErrorMessage}</span>
						</div> --%>
						 
						 <!-- end: for location -->
						 <!-- for team -->
						 <div class="row col-12 tag-height" id="teamDiv" style="display:none">							
								<div class="form-group">
									<label class="label-width" for="inputPassword6"><spring:message code="lbl.team"/></label>
										<select class="form-control mx-sm-3" id="team" name="team" required="required" disabled>
									 		<option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
												<%
												for (Map.Entry<Integer, String> entry : teams.entrySet())
												{
													if(selectedTeamId==entry.getKey()){ %>
														<option value="<%=entry.getKey()%>" selected><%=entry.getValue() %></option>
													<% }else{
														%>
															<option value="<%=entry.getKey()%>"><%=entry.getValue() %></option>
														<%
													}
													
												}
												%>
											</select>								
								</div>
							
						</div>
						 <!--end: for team -->
						
						
						
						<div class="row col-12 tag-height" style="display:none">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.activeUser"/></label>										 
								<form:checkbox class="checkBoxClass form-check-input"
											path="enabled" value="${account.isEnabled()}"/>
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">	
							<div class="form-group">								
								<input type="submit" value="<spring:message code="lbl.edit"/>"
										class="btn btn-primary btn-block" />
							</div>
						</div>
					</form:form>

