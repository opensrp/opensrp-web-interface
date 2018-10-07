<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"
	id="mainNav">
	<a class="navbar-brand" href="<c:url value="/?lang=${locale}"/>"><img
		src="<c:url value="/resources/img/ministry.png"/>" style = "height: 46px"></a>

	<div class="collapse navbar-collapse" id="navbarResponsive">


		<ul class="navbar-nav ml-auto">
						
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown"><spring:message code="lbl.facility"/> </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("FACILITY_REGISTRATION")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/facility/add.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.registration"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("COMMUNITY_CLINIC_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/facility/index.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.comunityClinic"/> </strong>
					</a>
					<% } %>

				</div></li>

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown"><spring:message code="lbl.client"/> </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/household.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.household"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/mother.html?lang=${locale}"/>"> <strong><spring:message code="lbl.mother"/></strong>
					</a>
					<% } %>
					
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/child.html?lang=${locale}"/>"> <strong><spring:message code="lbl.child"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/member.html?lang=${locale}"/>"> <strong><spring:message code="lbl.member"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILAR_CLIENT_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarCLient"/></strong>
					</a>	
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_EVENT_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarEvent"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_CLIENT_RULE_DEFINATION")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateDefinitionOfClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarclientRuleDefination"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_EVENT_RULE_DEFINATION")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateDefinitionOfEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similareventRuleDefination"/></strong>
					</a>		
					<% } %>
				</div></li>
			
			
				
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown" href="#"
				data-toggle="dropdown"><spring:message code="lbl.report"/> </a>
				<div class="dropdown-menu">					
					<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/child-growth.html?lang=${locale}"/>">
					<strong> <spring:message code="lbl.childGrowthReport"/></strong></a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT")){ %>				
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/summary.html?lang=${locale}"/>">
					<strong><spring:message code="lbl.childGrowthSummaryReport"/> </strong></a>
					<% } %>
					
					<% if(AuthenticationManagerUtil.isPermitted("ANALYTICS")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/analytics/analytics.html?lang=${locale}"/>">
					<strong><spring:message code="lbl.analytics"/></strong></a>
					<% } %>
				</div>
				
				
			</li>

			

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="userDropdown" href="#"
				data-toggle="dropdown"> <spring:message code="lbl.user"/> </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/user.html?lang=${locale}"/>"> <strong>
							<spring:message code="lbl.manageUuser"/></strong> </a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_ROLE_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/role.html?lang=${locale}"/>"> <strong>
					 <spring:message code="lbl.manageRole"/></strong>
					</a>
					<% } %>
				</div></li>

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown"
				href="#" data-toggle="dropdown"> <spring:message code="lbl.location"/> </a>
				<div class="dropdown-menu">
				<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/location/tag/list.html?lang=${locale}"/>"> 
						<strong> <spring:message code="lbl.manageTag"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/location.html?lang=${locale}"/>">
						<strong> <spring:message code="lbl.manageLocation"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/upload_csv.html?lang=${locale}"/>">
						<strong><spring:message code="lbl.uploadLocation"/></strong></a>
					<% } %>
				</div></li>

				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"
				data-toggle="dropdown"><spring:message code="lbl.team"/> </a>
				<div class="dropdown-menu">
				<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/team/list.html?lang=${locale}"/>">
						<strong> <spring:message code="lbl.manageTeam"/></strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>
						 <spring:message code="lbl.manageTeammember"/></strong>
					</a>
					<% } %>
				</div>
				</li>
				
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


