
<%--<%@ page language="java" contentType="text/html; charset=ISO-8859-1"--%>
<%--		 pageEncoding="ISO-8859-1"%>--%>

<%--<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>--%>
<%--<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>--%>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>--%>
<%--<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>--%>
<%--<%@ page import="org.opensrp.core.entity.User" %>--%>
<%--<style>--%>
<%--	strong{ padding:5px;--%>
<%--		font-size: 17px;--%>
<%--		font-family: ShonarBangla, Helvetica,Arial,sans-serif;}--%>

<%--	li{--%>
<%--		font-size: 13px;--%>
<%--		font-family: ShonarBangla,Helvetica,Arial,sans-serif;}--%>
<%--		--%>
<%--		.navbar-expand-lg .navbar-nav .dropdown-menu {--%>
<%--		    position: absolute;--%>
<%--		    left: -110px !important;--%>
<%--		}--%>
<%--		--%>
<%--	.card-header2 {--%>
<%--	    padding: .75rem 1.25rem;--%>
<%--	    /* margin-bottom: 0; */--%>
<%--	    /* background-color: rgba(0,0,0,.03); */--%>
<%--	    /* border-bottom: 1px solid rgba(0,0,0,.125); */--%>
<%--	}--%>
<%--	--%>
<%--	.card1 {--%>
<%--    position: relative;--%>
<%--    display: -webkit-box;--%>
<%--    display: -ms-flexbox;--%>
<%--    display: flex;--%>
<%--    -webkit-box-orient: vertical;--%>
<%--    -webkit-box-direction: normal;--%>
<%--    -ms-flex-direction: column;--%>
<%--    flex-direction: column;--%>
<%--    min-width: 0;--%>
<%--    word-wrap: break-word;--%>
<%--    background-color: #fff;--%>
<%--    background-clip: border-box;--%>
<%--    border: 0px solid rgba(0,0,0,.125);--%>
<%--    border-radius: .25rem;--%>
<%--}--%>
<%--</style>--%>
<%--<%--%>
<%--	boolean PERM_WRITE_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY");--%>
<%--	boolean PERM_UPLOAD_FACILITY_CSV = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FACILITY_CSV");--%>
<%--	boolean PERM_UPLOAD_HEALTH_ID = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_HEALTH_ID");--%>

<%--	boolean PERM_READ_FACILITY = AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY_LIST");--%>

<%--	boolean PERM_READ_HOUSEHOLD_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD");--%>
<%--	boolean PERM_READ_MOTHER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER");--%>
<%--	boolean PERM_READ_CHILD_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD");--%>
<%--	boolean PERM_READ_MEMBER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER");--%>
<%--	boolean PERM_READ_SIMILAR_EVENT_CLIENT = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT");--%>
<%--	boolean PERM_READ_SIMILARITY_DEFINITION = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION");--%>

<%--	boolean CHILD_GROWTH_REPORT = AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT");--%>
<%--	boolean CHILD_GROWTH_SUMMARY_REPORT = AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT");--%>
<%--	boolean ANALYTICS = AuthenticationManagerUtil.isPermitted("ANALYTICS");--%>
<%--	boolean PERM_READ_USER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_USER_LIST");--%>
<%--	boolean PERM_READ_ROLE_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_ROLE_LIST");--%>
<%--	boolean PERM_READ_LOCATION_TAG_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST");--%>
<%--	boolean PERM_READ_LOCATION_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST");--%>
<%--	boolean PERM_UPLOAD_LOCATION = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION");--%>
<%--	boolean PERM_READ_TEAM_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST");--%>
<%--	boolean PERM_READ_TEAM_MEMBER_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST");--%>
<%--	boolean PERM_READ_EXPORT_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_EXPORT_LIST");--%>
<%--	boolean PERM_EXPORT_LIST = AuthenticationManagerUtil.isPermitted("PERM_EXPORT_LIST");--%>
<%--	boolean PERM_DOWNLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_DOWNLOAD_FORM");--%>
<%--	boolean PERM_UPLOAD_FORM = AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_FORM");--%>
<%--	boolean PERM_READ_AGGREGATED_REPORT = AuthenticationManagerUtil.isPermitted("PERM_READ_AGGREGATED_REPORT");--%>
<%--	boolean MEMBER_APPROVAL = AuthenticationManagerUtil.isPermitted("MEMBER_APPROVAL");--%>
<%--	boolean PERM_READ_BRANCH_LIST = AuthenticationManagerUtil.isPermitted("PERM_READ_BRANCH_LIST");--%>
<%--	boolean PERM_SK_LIST = AuthenticationManagerUtil.isPermitted("PERM_SK_LIST");--%>
<%--	User user = (User) AuthenticationManagerUtil.getLoggedInUser();--%>
<%--%>--%>
<%--<nav style="z-index: 1" class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top"--%>
<%--	 id="mainNav">--%>
<%--	<a class="navbar-brand" href="<c:url value="/?lang=${locale}"/>"><img--%>
<%--			src="<c:url value="/resources/img/brac-logo.png"/>" style = "height: 46px"></a>--%>

<%--	<div class="collapse navbar-collapse" id="navbarResponsive">--%>


<%--		<ul class="navbar-nav ml-auto">--%>

<%--			<li class="nav-item dropdown">--%>
<%--				<a class="nav-link dropdown-toggle mr-lg-2" href="<c:url value="/?lang=${locale}"/>" >--%>
<%--					<% if (AuthenticationManagerUtil.isAM()) {%>--%>
<%--					<spring:message code="lbl.skList"/>--%>
<%--					<%} else {%>--%>
<%--					<spring:message code="lbl.home"/>--%>
<%--					<%}%>--%>
<%--				</a>--%>
<%--			</li>--%>

<%--			<%if (MEMBER_APPROVAL) {%>--%>
<%--			<li class="nav-item dropdown">--%>
<%--				<a class="nav-link dropdown-toggle mr-lg-2" href="--%>
<%--					<c:url value="/client/household-member-list.html"/>">--%>
<%--					<strong><spring:message code="lbl.memberApproval"/></strong>--%>
<%--				</a>--%>
<%--			</li>--%>
<%--			<%}%>--%>

<%--			<%if(PERM_WRITE_FACILITY || PERM_READ_FACILITY || PERM_UPLOAD_FACILITY_CSV ){ %>--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="facilityDropdown"--%>
<%--					href="#" data-toggle="dropdown"><spring:message code="lbl.facility"/> </a>--%>
<%--				<div class="dropdown-menu">--%>

<%--					<% if(PERM_WRITE_FACILITY){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/facility/add.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.registration"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(PERM_READ_FACILITY){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/cbhc-dashboard?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.comunityClinic"/> </strong>--%>

<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_UPLOAD_FACILITY_CSV){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/facility/upload_csv.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.facilityUpload"/> </strong>--%>
<%--					</a>--%>

<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_UPLOAD_HEALTH_ID){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/healthId/upload_csv.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.healthIdUpload"/> </strong>--%>
<%--					</a>--%>

<%--					<% } %>--%>
<%--				</div></li>--%>
<%--			<% } %>--%>


<%--			<%if(PERM_UPLOAD_FORM || PERM_DOWNLOAD_FORM ){ %>--%>
<%--			<li class="nav-item dropdown">--%>
<%--				<a class="nav-link dropdown-toggle mr-lg-2" id="formDropdown" href="#" data-toggle="dropdown">--%>
<%--					<spring:message code="lbl.form"/>--%>
<%--				</a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<% if(PERM_UPLOAD_FORM){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/form/uploadForm.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.uploadForm"/> </strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_DOWNLOAD_FORM){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/form/downloadForm.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.formList"/> </strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--				</div>--%>
<%--			</li>--%>
<%--			<% } %>--%>


<%--			<%if(PERM_READ_HOUSEHOLD_LIST || PERM_READ_MOTHER_LIST || PERM_READ_CHILD_LIST || PERM_READ_MEMBER_LIST--%>
<%--					||PERM_READ_SIMILAR_EVENT_CLIENT || PERM_READ_SIMILARITY_DEFINITION ){ %>--%>
<%--			<li class="nav-item dropdown">--%>
<%--				<a class="nav-link dropdown-toggle mr-lg-2" id="clientDropdown" href="#" data-toggle="dropdown">--%>
<%--					<spring:message code="lbl.client"/>--%>
<%--				</a>--%>
<%--				<div class="dropdown-menu">--%>

<%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD")){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/household.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.household"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER")){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/mother.html?lang=${locale}"/>"> <strong><spring:message code="lbl.mother"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD")){ %>--%>

<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/child.html?lang=${locale}"/>"> <strong><spring:message code="lbl.child"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER")){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/member.html?lang=${locale}"/>"> <strong><spring:message code="lbl.member"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/client/similarClient.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.similarCLient"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/similarEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarEvent"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(PERM_READ_SIMILARITY_DEFINITION){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/similarityDefinitionOfClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarclientRuleDefination"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--					<% if(PERM_READ_SIMILARITY_DEFINITION){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/client/similarityDefinitionOfEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similareventRuleDefination"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>

<%--				</div>--%>
<%--			</li>--%>
<%--			<% } %>--%>


<%--			<%if(CHILD_GROWTH_REPORT || CHILD_GROWTH_SUMMARY_REPORT || ANALYTICS || PERM_READ_AGGREGATED_REPORT){ %>--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="reportDropdown" href="#"--%>
<%--					data-toggle="dropdown"><spring:message code="lbl.report"/> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<% if(CHILD_GROWTH_REPORT){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/child-growth.html?lang=${locale}"/>">--%>
<%--						<strong> <spring:message code="lbl.childGrowthReport"/></strong></a>--%>
<%--					<% } %>--%>
<%--					<% if(CHILD_GROWTH_SUMMARY_REPORT){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/summary.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.childGrowthSummaryReport"/> </strong></a>--%>
<%--					<% } %>--%>

<%--					<% if(ANALYTICS){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--										<a class="dropdown-item" href="<c:url value="/analytics/analytics.html?lang=${locale}"/>">--%>
<%--										<strong><spring:message code="lbl.analytics"/></strong></a>--%>

<%--					<% } %>--%>

<%--					<% if(PERM_READ_AGGREGATED_REPORT){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/aggregatedReport.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.aggregatedReport"/></strong></a>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/clientDataReport.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.clientDataReport"/></strong></a>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/familyPlanningReport.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.familyPlanningReport"/></strong></a>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/pregnancyReport.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.pregnancyReport"/></strong></a>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/miscellaneousReport.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.childNutritionReport"/></strong></a>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/covid-19.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.covid19"/></strong></a>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/report/forum-report.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.forumReport"/></strong></a>--%>
<%--					<% } %>--%>
<%--				</div>--%>
<%--			</li>--%>
<%--			<% } %>--%>

<%--			<%if(PERM_READ_USER_LIST || PERM_READ_ROLE_LIST){ %>--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="userDropdown" href="#"--%>
<%--					data-toggle="dropdown"> <spring:message code="lbl.user"/> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<% if(PERM_READ_USER_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/user.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.manageUuser"/></strong> </a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_READ_ROLE_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/role.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.manageRole"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_READ_BRANCH_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/branch-list.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.manageBranch"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--				</div></li>--%>
<%--			<% } %>--%>

<%--			<%if(PERM_READ_LOCATION_TAG_LIST || PERM_READ_LOCATION_LIST || PERM_UPLOAD_LOCATION){ %>--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="locationDropdown"--%>
<%--					href="#" data-toggle="dropdown"> <spring:message code="lbl.location"/> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<% if(PERM_READ_LOCATION_TAG_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/location/tag/list.html?lang=${locale}"/>">--%>
<%--						<strong> <spring:message code="lbl.manageTag"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_READ_LOCATION_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/location/location.html?lang=${locale}"/>">--%>
<%--						<strong> <spring:message code="lbl.manageLocation"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_UPLOAD_LOCATION){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/location/upload_csv.html?lang=${locale}"/>">--%>
<%--						<strong><spring:message code="lbl.uploadLocation"/></strong></a>--%>
<%--					<% } %>--%>
<%--				</div></li>--%>
<%--			<% } %>--%>

<%--			<%if(PERM_READ_TEAM_LIST || PERM_READ_TEAM_MEMBER_LIST){ %>--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="teamDropdown" href="#"--%>
<%--					data-toggle="dropdown"><spring:message code="lbl.team"/> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<% if(PERM_READ_TEAM_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/team/list.html?lang=${locale}"/>">--%>
<%--						<strong> <spring:message code="lbl.manageTeam"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_READ_TEAM_MEMBER_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.manageTeammember"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--				</div>--%>
<%--			</li>--%>
<%--			<% } %>--%>

<%--			<%if(PERM_READ_EXPORT_LIST){ %>--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="exportDropdown" href="#"--%>
<%--					data-toggle="dropdown"><spring:message code="lbl.exportTitle"/> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<% if(PERM_READ_EXPORT_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/export/exportlist.html?lang=${locale}"/>">--%>
<%--						<strong> <spring:message code="lbl.exportList"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--					<% if(PERM_EXPORT_LIST){ %>--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong>--%>
<%--						<spring:message code="lbl.exportFile"/></strong>--%>
<%--					</a>--%>
<%--					<% } %>--%>
<%--				</div>--%>
<%--			</li>--%>
<%--			<% } %>--%>
<%--			--%>
<%--			<li class="nav-item dropdown"><a--%>
<%--					class="nav-link dropdown-toggle mr-lg-2" id="exportDropdown" href="#"--%>
<%--					data-toggle="dropdown"><%=user.getFullName()%> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					--%>
<%--					<a class="dropdown-item"--%>
<%--					   href="/opensrp-dashboard/user/<%=user.getId()%>/change-password.html?lang=${locale}"><strong> Change Password </strong>--%>
<%--					</a>--%>
<%--					--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/logout"/>"><strong>Logout</strong></a>--%>
<%--					--%>
<%--				</div>--%>
<%--			</li>--%>
<%--			&lt;%&ndash; <li class="nav-item dropdown">--%>
<%--				<a class="nav-link dropdown-toggle mr-lg-2" id="languageDropdown" href="#"--%>
<%--				   data-toggle="dropdown"><spring:message code="lbl.language"/> </a>--%>
<%--				<div class="dropdown-menu">--%>
<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/?lang=bn"/>">--%>
<%--						<strong> <spring:message code="lbl.bengali"/></strong>--%>
<%--					</a>--%>

<%--					<div class="dropdown-divider"></div>--%>
<%--					<a class="dropdown-item" href="<c:url value="/?lang=en"/>">--%>
<%--						<strong><spring:message code="lbl.english"/></strong>--%>
<%--					</a>--%>
<%--				</div>--%>
<%--			</li> &ndash;%&gt;--%>
<%--			<li class="nav-item">--%>
<%--			&lt;%&ndash; <a href="#exampleModal" rel="modal:open" class="nav-link"><i class="fa fa-fw fa-sign-out"></i><spring:message code="lbl.logout"/>--%>
<%--			</a> &ndash;%&gt;--%>
<%--			</li>--%>
<%--		</ul>--%>
<%--	</div>--%>
<%--</nav>--%>

<%--<!-- Logout Modal-->--%>
<%--&lt;%&ndash;<div class="modal fade" id="exampleModal" tabindex="-1">&ndash;%&gt;--%>
<%--&lt;%&ndash;	<div class="modal-dialog">&ndash;%&gt;--%>
<%--&lt;%&ndash;		<div class="modal-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;			<div class="modal-header">&ndash;%&gt;--%>
<%--&lt;%&ndash;				<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>&ndash;%&gt;--%>
<%--&lt;%&ndash;				<button class="close" type="button" data-dismiss="modal">&ndash;%&gt;--%>
<%--&lt;%&ndash;					<span>×</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;				</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;			</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;			<div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;			<div class="modal-footer">&ndash;%&gt;--%>
<%--&lt;%&ndash;				<button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>&ndash;%&gt;--%>
<%--&lt;%&ndash;				<a class="btn btn-primary" href="<c:url value="/logout"/>">Logout</a>&ndash;%&gt;--%>
<%--&lt;%&ndash;			</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;		</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;	</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;</div>&ndash;%&gt;--%>

<%--<div style="overflow: visible; display: none; position: relative; z-index: 1050;"--%>
<%--	 id="exampleModal" class="modal">--%>
<%--	<div id="logout-body">--%>
<%--		<div class="modal-header">--%>
<%--			<h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>--%>
<%--		</div>--%>
<%--		<div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>--%>
<%--		<div class="modal-footer">--%>
<%--			<a href="#" rel="modal:close" class="btn btn-secondary">Cancel</a>--%>
<%--			<a class="btn btn-primary" href="<c:url value="/logout"/>">Logout</a>--%>
<%--		</div>--%>
<%--	</div>--%>
<%--</div>--%>
<div id=""> this navbar has no use in phase 2</div>

