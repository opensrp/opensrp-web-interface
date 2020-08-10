<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@ page import="org.opensrp.core.entity.User" %>

<!DOCTYPE html>
<!-- 
Template Name: Metronic - Responsive Admin Dashboard Template build with Twitter Bootstrap 3.3.2
Version: 3.7.0
Author: KeenThemes
Website: http://www.keenthemes.com/
Contact: support@keenthemes.com
Follow: www.twitter.com/keenthemes
Like: www.facebook.com/keenthemes
Purchase: http://themeforest.net/item/metronic-responsive-admin-dashboard-template/4021469?ref=keenthemes
License: You must have a valid license purchased only from themeforest(the above link) in order to legally use the theme for your project.
-->
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<!-- BEGIN HEAD -->
<head>
<meta charset="utf-8"/>

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta content="" name="description"/>
<meta content="" name="author"/>
<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="login" value="/login" />
<link rel="shortcut icon" href="<c:url value="/resources/assets/img/favicon.ico"/>" />
<title>${title}</title>	
<meta http-equiv="Cache-control" content="public">
<meta http-equiv="refresh" content="<%=session.getMaxInactiveInterval()%>;url=${login}"/>
<jsp:include page="/WEB-INF/views/css.jsp" />
<c:url var="sendPrescriptionMessage" value="/rest/api/v1/message/prescription" />
<c:url var="sendBookingMessage" value="/rest/api/v1/message/booking" />


<jsp:include page="/WEB-INF/views/js.jsp" />

   <%
   
   User user = (User) AuthenticationManagerUtil.getLoggedInUser();
   
   boolean PERM_WRITE_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY");
	boolean PERM_UPLOAD_FACILITY_CSV = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV");
	boolean PERM_UPLOAD_HEALTH_ID = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_HEALTH_ID");

	boolean PERM_READ_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY_LIST");

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
	boolean PERM_DOWNLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_DOWNLOAD_FORM");
	boolean PERM_UPLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FORM");
	boolean PERM_READ_AGGREGATED_REPORT = AuthenticationManagerUtil.isPermitted("PERM_READ_AGGREGATED_REPORT");
	boolean MEMBER_APPROVAL = AuthenticationManagerUtil.isPermitted("MEMBER_APPROVAL");
	boolean PERM_READ_BRANCH_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_BRANCH_LIST");
	boolean PERM_SK_LIST = AuthenticationManagerUtil.isPermitted("PERM_SK_LIST");
	
   %>
  
<body>
<c:url var="home" value="/" />

<body class="page-header-fixed page-sidebar-closed-hide-logo ">
<!-- BEGIN HEADER -->
<div class="page-header navbar navbar-fixed-top">
	<!-- BEGIN HEADER INNER -->
	<div class="page-header-inner">
		<!-- BEGIN LOGO -->
		<div class="page-logo">
			<a href="<c:url value="/" />">
			<img src="<c:url value="/resources/assets/img/brac-logo.png"/>" alt="logo" class="logo-default" style = "height: 46px"/>
			</a> 
			<div class="menu-toggler sidebar-toggler">
				<!-- DOC: Remove the above "hide" to enable the sidebar toggler button on header -->
			</div>
		</div>
		<!-- END LOGO -->
		<!-- BEGIN RESPONSIVE MENU TOGGLER -->
		<a href="javascript:;" class="menu-toggler responsive-toggler" data-toggle="collapse" data-target=".navbar-collapse">
		</a>
		
		<!-- END PAGE ACTIONS -->
		<!-- BEGIN PAGE TOP -->
		<div class="page-top">
		
			<span id="confirmedNotification" class="success" style="position: absolute; top: 5px; right: 651px;color:#578ebe;font-weight:bold; font-size: 14px"></span>
			<span id="mobileMsssage" class="successs" style="position: absolute; top: 24px; right: 651px;color:#578ebe;font-weight:bold; font-size: 14px"></span>
					
			<!-- BEGIN TOP NAVIGATION MENU -->
			 <div class="top-menu">
			
			
				<ul class="nav navbar-nav pull-right">
				
					
					
					<li class="dropdown dropdown-user dropdown-dark">
						<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
						<span class="username">
						Login as <%=AuthenticationManagerUtil.getLoggedInUser().getUsername() %> </span>
						<!-- DOC: Do not remove below empty space(&nbsp;) as its purposely used -->
							<i class="fa fa-user"></i>
						
						</a>
						<ul class="dropdown-menu dropdown-menu-default">
							<!-- <li>
								<a href="extra_profile.html">
								<i class="icon-user"></i> My Profile </a>
							</li>
							
							<li class="divider">
							</li>
							<li>
								<a href="extra_lock.html">
								<i class="icon-lock"></i> Lock Screen </a>
							</li> -->
							<li>
								<a  href="<c:url value="/logout/"/>">
								<i class="icon-key"></i> Log Out </a>
							</li>
							<li>
								<a  href="/opensrp-dashboard/user/<%=user.getId()%>/change-password.html?lang=${locale}">
								Change Password  </a>
							</li>
						</ul>
					</li>
					
					
				</ul>
			</div>
			<!-- END TOP NAVIGATION MENU -->
		</div>
		<!-- END PAGE TOP -->
	</div>
	<!-- END HEADER INNER -->
</div>
<!-- END HEADER -->
<div class="clearfix">
</div>
<!-- BEGIN CONTAINER -->
<div class="page-container">
	<!-- BEGIN SIDEBAR -->
	<div class="page-sidebar-wrapper">
		<!-- DOC: Set data-auto-scroll="false" to disable the sidebar from auto scrolling/focusing -->
		<!-- DOC: Change data-auto-speed="200" to adjust the sub menu slide up/down speed -->
		<div class="page-sidebar navbar-collapse collapse">
			<!-- BEGIN SIDEBAR MENU -->
			<!-- DOC: Apply "page-sidebar-menu-light" class right after "page-sidebar-menu" to enable light sidebar menu style(without borders) -->
			<!-- DOC: Apply "page-sidebar-menu-hover-submenu" class right after "page-sidebar-menu" to enable hoverable(hover vs accordion) sub menu mode -->
			<!-- DOC: Apply "page-sidebar-menu-closed" class right after "page-sidebar-menu" to collapse("page-sidebar-closed" class must be applied to the body element) the sidebar sub menu mode -->
			<!-- DOC: Set data-auto-scroll="false" to disable the sidebar from auto scrolling/focusing -->
			<!-- DOC: Set data-keep-expand="true" to keep the submenues expanded -->
			<!-- DOC: Set data-auto-speed="200" to adjust the sub menu slide up/down speed -->
			<ul class="page-sidebar-menu " data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200">
				<li class="start ">
					<a href="<c:url value="/" />">
					<i class="fa fa-home"></i>
					<% if (AuthenticationManagerUtil.isAM()) {%>
					<span class="title"> <spring:message code="lbl.skList"/></span>
					<%} else {%>
					<span class="title"> <spring:message code="lbl.home"/></span>
					<%}%>
					
					</a>
				</li>
				
				
				
				
<%--				<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST")){ %>--%>
<%--				<li>--%>
<%--					<a  href="<c:url value="/location/tag/list.html?lang=${locale}"/>">--%>
<%--					<i class="fa fa-cogs"></i>--%>
<%--					<span class="title"> Location Tag</span></a>--%>
<%--					--%>
<%--				</li>--%>
<%--				<%} %>--%>
				
				
				<% if(PERM_READ_LOCATION_LIST || PERM_UPLOAD_LOCATION){ %>
				<li>
					<a href="javascript:;">
					<i class="fa fa-map-marker"></i>
					<span class="title"> Location</span>
					<span class="arrow "></span>
					</a>
					<ul class="sub-menu">
					<% if(PERM_READ_LOCATION_LIST){ %>
						<li>
							<a href="<c:url value="/location/location.html?lang=${locale}"/>">
							<spring:message code="lbl.manageLocation"/>
							</a>
						</li>
						<%} %>
					<% if(PERM_UPLOAD_LOCATION){ %>
						<li>
							<a  href="<c:url value="/location/upload_csv.html?lang=${locale}"/>">
							
							<spring:message code="lbl.uploadLocation"/>
							</a>
						</li>
						<%} %>
						
						
					</ul>
				</li>
				<% }%>
				
				<% if(PERM_READ_ROLE_LIST){ %>
				<li>
					<a href="<c:url value="/role.html"/>">
						<i class="fa fa-group"></i>
						<span class="title"> Role</span>
					</a>
				</li>
				<%} %>
				
				<% if(AuthenticationManagerUtil.isPermitted("PERM_USER_UPLOAD")){ %>
				<li>
					<a href="<c:url value="/user/upload.html"/>">
						<i class="fa fa-user"></i>
						<span class="title"> Upload user</span>
					</a>
				</li>
				<%} %>
				
				<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_IMEI")){ %>
				<li>
					<a href="<c:url value="/user/upload-imei.html"/>">
						<i class="fa fa-upload"></i>
						<span class="title">  Upload IMEI</span>
					</a>
				</li>
				<%} %>
				
				
				<% if(PERM_READ_BRANCH_LIST){ %>
				<li>
					<a href="<c:url value="/branch-list.html?lang=${locale}"/>">
						<i class="fa fa-cubes"></i>

						<span class="title"> <spring:message code="lbl.manageBranch"/> </span>
					</a>
				</li>
				<%} %>
				
				<% if(PERM_READ_AGGREGATED_REPORT){ %>
				<li>
					<a href="javascript:;">
					<i class="fa fa-bar-chart"></i>
					<span class="title"><spring:message code="lbl.report"/></span>
					<span class="arrow "></span>
					</a>
					<ul class="sub-menu">					
						<li>
							<a href="<c:url value="/report/aggregatedReport.html?lang=${locale}"/>">
							<spring:message code="lbl.aggregatedReport"/>
							</a>
						</li>
						<li><a href="<c:url value="/report/clientDataReport.html?lang=${locale}"/>">
							<spring:message code="lbl.clientDataReport"/>
							</a>
						</li>
						<li><a href="<c:url value="/report/familyPlanningReport.html?lang=${locale}"/>">
							<spring:message code="lbl.familyPlanningReport"/>
							</a>
						</li>
						<li><a href="<c:url value="/report/pregnancyReport.html?lang=${locale}"/>">
							<spring:message code="lbl.pregnancyReport"/>
							</a>
						</li>
						<li><a href="<c:url value="/report/miscellaneousReport.html?lang=${locale}"/>">
							<spring:message code="lbl.childNutritionReport"/>
							</a>
						</li>
						<li><a href="<c:url value="/report/covid-19.html?lang=${locale}"/>">
							<spring:message code="lbl.covid19"/>
							</a>
						</li>
						<li><a href="<c:url value="/report/forum-report.html?lang=${locale}"/>">
							<spring:message code="lbl.forumReport"/>
						</a>
						</li>
						<li><a href="<c:url value="/report/aggregated-biometric-report.html?lang=${locale}"/>">
							<spring:message code="lbl.aggregatedBiometricReport"/>
						</a>
						</li>
						<li><a href="<c:url value="/report/individual-biometric-report.html?lang=${locale}"/>">
							<spring:message code="lbl.individualBiometricReport"/>
						</a>
						</li>
						
					</ul>
				</li>
				<% }%>
				
				
				<!-- <li>
					<a href="javascript:;">
					<i class="icon-diamond"></i>
					<span class="title">UI Features</span>
					<span class="arrow "></span>
					</a>
					<ul class="sub-menu">
						<li>
							<a href="ui_general.html">
							General Components</a>
						</li>
						<li>
							<a href="ui_buttons.html">
							Buttons</a>
						</li>
						<li>
							<a href="ui_icons.html">
							<span class="badge badge-danger">new</span>Font Icons</a>
						</li>
						<li>
							<a href="ui_colors.html">
							Flat UI Colors</a>
						</li>
						<li>
							<a href="ui_typography.html">
							Typography</a>
						</li>
						<li>
							<a href="ui_tabs_accordions_navs.html">
							Tabs, Accordions & Navs</a>
						</li>
						<li>
							<a href="ui_tree.html">
							<span class="badge badge-danger">new</span>Tree View</a>
						</li>
						<li>
							<a href="ui_page_progress_style_1.html">
							<span class="badge badge-warning">new</span>Page Progress Bar - Style 1</a>
						</li>
						<li>
							<a href="ui_blockui.html">
							Block UI</a>
						</li>
						<li>
							<a href="ui_bootstrap_growl.html">
							<span class="badge badge-roundless badge-warning">new</span>Bootstrap Growl Notifications</a>
						</li>
						<li>
							<a href="ui_notific8.html">
							Notific8 Notifications</a>
						</li>
						<li>
							<a href="ui_toastr.html">
							Toastr Notifications</a>
						</li>
						<li>
							<a href="ui_alert_dialog_api.html">
							<span class="badge badge-danger">new</span>Alerts & Dialogs API</a>
						</li>
						<li>
							<a href="ui_session_timeout.html">
							Session Timeout</a>
						</li>
						<li>
							<a href="ui_idle_timeout.html">
							User Idle Timeout</a>
						</li>
						<li>
							<a href="ui_modals.html">
							Modals</a>
						</li>
						<li>
							<a href="ui_extended_modals.html">
							Extended Modals</a>
						</li>
						<li>
							<a href="ui_tiles.html">
							Tiles</a>
						</li>
						<li>
							<a href="ui_datepaginator.html">
							<span class="badge badge-success">new</span>Date Paginator</a>
						</li>
						<li>
							<a href="ui_nestable.html">
							Nestable List</a>
						</li>
					</ul>
				</li> -->
				
				
				
			</ul>
			<!-- END SIDEBAR MENU -->
		</div>
	</div>
	
