<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>


<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_REPORT")){ %>
<a  href="<c:url value="/report/child-growth.html?lang=${locale}"/>"> <strong> Child Growth Report</strong> </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("CHILD_GROWTH_SUMMARY_REPORT")){ %> 
<a  href="<c:url value="/report/summary.html?lang=${locale}"/>"> <strong>Sumamry Report</strong>  </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("ANALYTICS")){ %>
<a  href="<c:url value="/analytics/analytics.html?lang=${locale}"/>"> <strong>Analytics</strong> 	</a> <% } %>
    


