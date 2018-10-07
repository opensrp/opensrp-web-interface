<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT")){ %>
<a  href="<c:url value="/report/child-growth.html?lang=${locale}"/>"> <strong> <spring:message code="lbl.childGrowthReport"/></strong> </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT")){ %> 
<a  href="<c:url value="/report/summary.html?lang=${locale}"/>"> <strong><spring:message code="lbl.childGrowthSummaryReport"/></strong>  </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("ANALYTICS")){ %>
<a  href="<c:url value="/analytics/analytics.html?lang=${locale}"/>"> <strong><spring:message code="lbl.analytics"/></strong> </a> <% } %>
    


