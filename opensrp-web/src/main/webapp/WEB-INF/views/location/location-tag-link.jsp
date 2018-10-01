<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_TAG_LIST")){ %>
<a  href="<c:url value="/location/tag/list.html"/>"> <strong> Manage Tags</strong> 	</a>  | <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_LOCATION_LIST")){ %>
<a  href="<c:url value="/location/location.html"/>"> <strong>Manage Locations</strong></a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_HIERARCHY_LOCATION")){ %>
<a  href="<c:url value="/location/hierarchy.html"/>"> <strong>View Hierarchy</strong></a> |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_UPLOAD_LOCATION")){ %>
<a  href="<c:url value="/location/upload_csv.html"/>"> <strong>Upload location</strong>	</a> <% } %>
    


