<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<ol class="breadcrumb">
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST")){ %>
  <li class="breadcrumb-item">
  	<a  href="<c:url value="/location/tag/list.html?lang=${locale}"/>"> <strong><spring:message code="lbl.manageTags"/> </strong> 	</a>   <% } %>
  </li>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST")){ %>
  <li class="breadcrumb-item">
  	<a  href="<c:url value="/location/location.html?lang=${locale}"/>"> <strong><spring:message code="lbl.manageLocations"/></strong></a>  <% } %>
  </li>
<% if(AuthenticationManagerUtil.isPermitted("PERM_HIERARCHY_LOCATION")){ %>
  <li class="breadcrumb-item">
 	<a  href="<c:url value="/location/hierarchy.html?lang=${locale}"/>"> <strong><spring:message code="lbl.viewLocationsHierarchy"/> </strong></a>   <% } %>
  </li>
<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION")){ %>
  <li class="breadcrumb-item">
 	<a  href="<c:url value="/location/upload_csv.html?lang=${locale}"/>"> <strong><spring:message code="lbl.uploadLocation"/> </strong>	</a> <% } %>
  </li> 
</ol>

