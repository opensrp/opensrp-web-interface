<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"
	id="mainNav">
	<a class="navbar-brand" href="<c:url value="/"/>"><img
		src="<c:url value="/resources/img/ministry.png"/>" style = "height: 46px"></a>

	<div class="collapse navbar-collapse" id="navbarResponsive">


		<ul class="navbar-nav ml-auto">
			<%-- <li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="messagesDropdown"
				href="#" data-toggle="dropdown"> Registers
			</a>
				<div class="dropdown-menu">					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/household.html"/>"> <strong> Household</strong> 
						
					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/elco.html"/>"> <strong>Elco</strong>
						
					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/mother.html"/>"> <strong>Mother</strong> 
						
					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item small" href="<c:url value="/child.html"/>"><strong>Child</strong> </a>
				</div>
			</li> --%>

			

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown"
				href="#" data-toggle="dropdown">Client </a>
				<div class="dropdown-menu">

					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/household.html"/>"> <strong>
							Household</strong>
					</a>

					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>
					</a>

					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/child.html"/>"> <strong>Child</strong>
					</a>

					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/member.html"/>"> <strong>Member</strong>
					</a>

					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateClient.html"/>"> <strong>Duplicate Client</strong>
					</a>	
					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Duplicate Event</strong>
					</a>
						
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Duplicate Definition Client</strong>
					</a>
					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Duplicate Definition Event</strong>
					</a>		

				</div></li>
			
			
				
				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown" href="#"
				data-toggle="dropdown">Report </a>
				<div class="dropdown-menu">
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/analytics/analytics.html"/>">
					<strong> Analytics</strong></a>
					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/child-growth.html"/>">
					<strong> Child Growth Report</strong></a>
										
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/report/summary.html"/>">
					<strong> Sumamry Report</strong></a>
				</div>
				
				
			</li>

			<%-- <li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="exportDropdown"
				href="#" data-toggle="dropdown"> Exports
			</a>
				<div class="dropdown-menu">					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/export.html"/>"> <strong> Export CSV</strong> 
						
					</a>
										
					
				</div>
			</li>
			
			
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="fwaMonitoringDropdown"
				href="#" data-toggle="dropdown"> FWA Monitoring
			</a>
				<div class="dropdown-menu">					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/fwa/anc/monitoring.html"/>"> <strong> ANC</strong> 
						
					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/fwa/pnc/monitoring.html"/>"> <strong>PNC</strong>
					</a>
					
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/fwa/encc/monitoring.html"/>"> <strong>ENCC</strong>
					</a>					
					
				</div>
			</li> --%>

			<%-- 
			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="roleDropdown"
				href="#" data-toggle="dropdown"> Role
			</a>
				<div class="dropdown-menu">	
				
				<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/role/add.html"/>"> <strong>Add</strong>
					</a>				
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/role.html"/>"> <strong> List</strong> 
						
					</a>
				</div>
			</li> --%>

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="userDropdown" href="#"
				data-toggle="dropdown"> User </a>
				<div class="dropdown-menu">

					<div class="dropdown-divider"></div>

					<a class="dropdown-item" href="<c:url value="/user.html"/>"> <strong>
							Manage User</strong>

					</a>

					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/role.html"/>"> <strong>Manage
							Role</strong>
					</a>
				</div></li>

			<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown"
				href="#" data-toggle="dropdown">Location </a>
				<div class="dropdown-menu">
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/location/tag/list.html"/>"> <strong>
							Manage Tag</strong>
					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/location.html"/>">
						<strong>Manage Location</strong>
					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/location/upload_csv.html"/>">
						<strong>Upload location</strong></a>

				</div></li>

				<li class="nav-item dropdown"><a
				class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"
				data-toggle="dropdown">Team </a>
				<div class="dropdown-menu">
					<div class="dropdown-divider"></div>
					<a class="dropdown-item" href="<c:url value="/team/list.html"/>">
						<strong> Manage Team</strong>

					</a>
					<div class="dropdown-divider"></div>
					<a class="dropdown-item"
						href="<c:url value="/team/teammember/list.html"/>"> <strong>Manage
							Team Member</strong>
					</a>

				</div></li>


			<li class="nav-item"><a class="nav-link" data-toggle="modal"
				data-target="#exampleModal"> <i class="fa fa-fw fa-sign-out"></i>Logout
			</a></li>
		</ul>
	</div>
</nav>


