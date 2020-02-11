<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<ol class="breadcrumb">
<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/report/child-growth.html?lang=${locale}"/>"> <strong> <spring:message code="lbl.childGrowthReport"/></strong> </a>    <% } %>
	</li>
<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT")){ %> 
 	<li class="breadcrumb-item">
 		<a  href="<c:url value="/report/summary.html?lang=${locale}"/>"> <strong><spring:message code="lbl.childGrowthSummaryReport"/></strong>  </a>    <% } %>
 	</li>
<% if(AuthenticationManagerUtil.isPermitted("ANALYTICS")){ %>
 	<li class="breadcrumb-item">
 		<a  href="<c:url value="/analytics/analytics.html?lang=${locale}"/>"> <strong><spring:message code="lbl.analytics"/></strong> </a> <% } %>
 	</li>    
</ol>

