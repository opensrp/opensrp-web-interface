<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"
	id="mainNav">
	<a class="navbar-brand" href="<c:url value="/"/>"><img
		src="<c:url value="/resources/img/ministry.png"/>" style = "height: 46px"></a>

	<div class="collapse navbar-collapse" id="navbarResponsive">


		<ul class="navbar-nav ml-auto">
						
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown">Facility </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("FACILITY_REGISTRATION")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/facility/add.html"/>"> <strong>
							Registration</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("COMMUNITY_CLINIC_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/facility/index.html"/>"> <strong>
							Community Clinic</strong>
					</a>
					<% } %>

				</div></li>

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown">Client </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/household.html"/>"> <strong>
							Household</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>
					</a>
					<% } %>
					
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/child.html"/>"> <strong>Child</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/member.html"/>"> <strong>Member</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILAR_CLIENT_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar Client</strong>
					</a>	
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_EVENT_LIST")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar Event</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_CLIENT_RULE_DEFINATION")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Similar Definition Client</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_EVENT_RULE_DEFINATION")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Similar Definition Event</strong>
					</a>		
					<% } %>
				</div></li>
			
			
				
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown" href="#"
				data-toggle="dropdown">Report </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("ANALYTICS")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/analytics/analytics.html"/>">
					<strong> Analytics</strong></a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT")){ %>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/child-growth.html"/>">
					<strong> Child Growth Report</strong></a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT")){ %>				
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/summary.html"/>">
					<strong> Sumamry Report</strong></a>
					<% } %>
				</div>
				
				
			</li>

			

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="userDropdown" href="#"
				data-toggle="dropdown"> User </a>
				<div class="dropdown-menu">
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/user.html"/>"> <strong>
							Manage User</strong> </a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_ROLE_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/role.html"/>"> <strong>Manage
							Role</strong>
					</a>
					<% } %>
				</div></li>

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown"
				href="#" data-toggle="dropdown">Location </a>
				<div class="dropdown-menu">
				<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/location/tag/list.html"/>"> <strong>
							Manage Tag</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/location.html"/>">
						<strong>Manage Location</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/upload_csv.html"/>">
						<strong>Upload location</strong></a>
					<% } %>
				</div></li>

				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"
				data-toggle="dropdown">Team </a>
				<div class="dropdown-menu">
				<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/team/list.html"/>">
						<strong> Manage Team</strong>
					</a>
					<% } %>
					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST")){ %>	
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/team/teammember/list.html"/>"> <strong>Manage
							Team Member</strong>
					</a>
					<% } %>
				</div></li>


			<li class="nav-item"><a class="nav-link" data-toggle="modal"
				data-target="#exampleModal"> <i class="fa fa-fw fa-sign-out"></i>Logout
			</a></li>
		</ul>
	</div>
</nav>


