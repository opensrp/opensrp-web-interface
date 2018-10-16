<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%
boolean PERM_WRITE_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY");
boolean PERM_UPLOAD_FACILITY_CSV = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV");

boolean PERM_READ_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY");

boolean PERM_READ_HOUSEHOLD_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD");
boolean PERM_READ_MOTHER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER");
boolean PERM_READ_CHILD_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD");
boolean PERM_READ_MEMBER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER");
boolean PERM_READ_SIMILAR_EVENT_CLIENT = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT");
boolean PERM_READ_SIMILARITY_DEFINITION = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION");

boolean CHILD_GROWTH_REPORT = AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT");
boolean CHILD_GROWTH_SUMMARY_REPORT = AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT");
boolean ANALYTICS = AuthenticationManagerUtil.isPermitted("ANALYTICS");
boolean PERM_READ_USER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST");
boolean PERM_READ_ROLE_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_ROLE_LIST");
boolean PERM_READ_LOCATION_TAG_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST");
boolean PERM_READ_LOCATION_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST");
boolean PERM_UPLOAD_LOCATION = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION");
boolean PERM_READ_TEAM_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST");
boolean PERM_READ_TEAM_MEMBER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST");
boolean PERM_READ_EXPORT_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_EXPORT_LIST");
boolean PERM_EXPORT_LIST = AuthenticationManagerUtil.isPermitted("PERM_EXPORT_LIST");



%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"
	id="mainNav">
	<a class="navbar-brand" href="<c:url value="/?lang=${locale}"/>"><img
		src="<c:url value="/resources/img/ministry.png"/>" style = "height: 46px"></a>

	<div class="collapse navbar-collapse" id="navbarResponsive">


		<ul class="navbar-nav ml-auto">
			<%if(PERM_WRITE_FACILITY || PERM_READ_FACILITY || PERM_UPLOAD_FACILITY_CSV ){ %>			
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown"><spring:message code="lbl.facility"/> </a>
				<div class="dropdown-menu">

					<% if(PERM_WRITE_FACILITY){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/facility/add.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.registration"/></strong>
					</a>
					<% } %>

					<% if(PERM_READ_FACILITY){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/cbhc-dashboard?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.comunityClinic"/> </strong>

					</a>
					<% } %>
					<% if(PERM_UPLOAD_FACILITY_CSV){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/facility/upload_csv.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.facilityUpload"/> </strong>
					</a>
		
					<% } %>
				</div></li>
				<% } %>
				
				
				<%if(PERM_UPLOAD_FACILITY_CSV ){ %>			
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown"><spring:message code="lbl.form"/> </a>
				<div class="dropdown-menu">
					<% if(PERM_UPLOAD_FACILITY_CSV){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/form/uploadForm.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.uploadForm"/> </strong>
					</a>
					<% } %>
					<% if(PERM_UPLOAD_FACILITY_CSV){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/form/downloadForm.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.downloadForm"/> </strong>
					</a>
					<% } %>
				</div></li>
				<% } %>
				
				
			   <%if(PERM_READ_HOUSEHOLD_LIST || PERM_READ_MOTHER_LIST || PERM_READ_CHILD_LIST || PERM_READ_MEMBER_LIST
					   ||PERM_READ_SIMILAR_EVENT_CLIENT || PERM_READ_SIMILARITY_DEFINITION ){ %>
			    <li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown"><spring:message code="lbl.client"/> </a>
				<div class="dropdown-menu">

					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/household.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.household"/></strong>
					</a>
					<% } %>

					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/mother.html?lang=${locale}"/>"> <strong><spring:message code="lbl.mother"/></strong>
					</a>
					<% } %>

					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD")){ %>

					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/child.html?lang=${locale}"/>"> <strong><spring:message code="lbl.child"/></strong>
					</a>
					<% } %>

					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/member.html?lang=${locale}"/>"> <strong><spring:message code="lbl.member"/></strong>
					</a>
					<% } %>
					
					<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/similarClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarCLient"/></strong>
					</a>	
					<% } %>

					<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/similarEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarEvent"/></strong>
					</a>
					<% } %>

					<% if(PERM_READ_SIMILARITY_DEFINITION){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/similarityDefinitionOfClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarclientRuleDefination"/></strong>
					</a>
					<% } %>

					<% if(PERM_READ_SIMILARITY_DEFINITION){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/similarityDefinitionOfEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similareventRuleDefination"/></strong>
					</a>		
					<% } %>
					
				</div></li>
			<% } %>
			
			
				<%if(CHILD_GROWTH_REPORT || CHILD_GROWTH_SUMMARY_REPORT || ANALYTICS){ %>
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown" href="#"
				data-toggle="dropdown"><spring:message code="lbl.report"/> </a>
				<div class="dropdown-menu">					
					<% if(CHILD_GROWTH_REPORT){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/child-growth.html?lang=${locale}"/>">
					<strong> <spring:message code="lbl.childGrowthReport"/></strong></a>
					<% } %>
					<% if(CHILD_GROWTH_SUMMARY_REPORT){ %>				
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/summary.html?lang=${locale}"/>">
					<strong><spring:message code="lbl.childGrowthSummaryReport"/> </strong></a>
					<% } %>
					
					<% if(ANALYTICS){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/analytics/analytics.html?lang=${locale}"/>">
					<strong><spring:message code="lbl.analytics"/></strong></a>
					<% } %>
				</div>				
				</li>
			<% } %>
			
			<%if(PERM_READ_USER_LIST || PERM_READ_ROLE_LIST){ %>
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="userDropdown" href="#"
				data-toggle="dropdown"> <spring:message code="lbl.user"/> </a>
				<div class="dropdown-menu">
					<% if(PERM_READ_USER_LIST){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/user.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.manageUuser"/></strong> </a>
					<% } %>
					<% if(PERM_READ_ROLE_LIST){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/role.html?lang=${locale}"/>"> <strong>
					 <spring:message code="lbl.manageRole"/></strong>
					</a>
					<% } %>
				</div></li>
			 <% } %>
			 
			<%if(PERM_READ_LOCATION_TAG_LIST || PERM_READ_LOCATION_LIST || PERM_UPLOAD_LOCATION){ %> 
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown"
				href="#" data-toggle="dropdown"> <spring:message code="lbl.location"/> </a>
				<div class="dropdown-menu">
				<% if(PERM_READ_LOCATION_TAG_LIST){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/location/tag/list.html?lang=${locale}"/>"> 
						<strong> <spring:message code="lbl.manageTag"/></strong>
					</a>
					<% } %>
					<% if(PERM_READ_LOCATION_LIST){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/location.html?lang=${locale}"/>">
						<strong> <spring:message code="lbl.manageLocation"/></strong>
					</a>
					<% } %>
					<% if(PERM_UPLOAD_LOCATION){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/upload_csv.html?lang=${locale}"/>">
						<strong><spring:message code="lbl.uploadLocation"/></strong></a>
					<% } %>
				</div></li>
				<% } %>
				
				<%if(PERM_READ_TEAM_LIST || PERM_READ_TEAM_MEMBER_LIST){ %>
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"
				data-toggle="dropdown"><spring:message code="lbl.team"/> </a>
				<div class="dropdown-menu">
				<% if(PERM_READ_TEAM_LIST){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/team/list.html?lang=${locale}"/>">
						<strong> <spring:message code="lbl.manageTeam"/></strong>
					</a>
					<% } %>
					<% if(PERM_READ_TEAM_MEMBER_LIST){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>
						 <spring:message code="lbl.manageTeammember"/></strong>
					</a>
					<% } %>
				</div>
				</li>
				<% } %>

				<%if(PERM_READ_EXPORT_LIST){ %>
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"
				data-toggle="dropdown"><spring:message code="lbl.exportTitle"/> </a>
				<div class="dropdown-menu">
				<% if(PERM_READ_EXPORT_LIST){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/export/exportlist.html?lang=${locale}"/>">
						<strong> <spring:message code="lbl.exportList"/></strong>
					</a>
					<% } %>
					<% if(PERM_EXPORT_LIST){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>
						 <spring:message code="lbl.exportFile"/></strong>
					</a>
					<% } %>
				</div>
				</li>
				<% } %>
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"
				data-toggle="dropdown"><spring:message code="lbl.language"/> </a>
				<div class="dropdown-menu">					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/?lang=bn"/>">
						<strong> <spring:message code="lbl.bengali"/></strong>
					</a>			
					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/?lang=en"/>"> <strong>	<spring:message code="lbl.english"/></strong>
					</a>
					
				</div>
				</li>

			<li class="nav-item"><a class="nav-link" data-toggle="modal"
				data-target="#exampleModal"> <i class="fa fa-fw fa-sign-out"></i><spring:message code="lbl.logout"/>
			</a></li>
		</ul>
	</div>
</nav>

