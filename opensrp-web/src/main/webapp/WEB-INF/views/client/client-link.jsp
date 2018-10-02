<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>


<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD")){ %>
<a  href="<c:url value="/client/household.html"/>"> <strong>Household</strong> </a>  |  <% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER")){ %>
<a  href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>  </a>  |  <% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD")){ %>
<a  href="<c:url value="/client/child.html"/>"> <strong>Child</strong>  </a>  |  <% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT")){ %>
<a  href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar Client</strong>  </a>  | <% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT")){ %> 
<a  href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar Event</strong>  </a>  | <% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION")){ %> 
<a  href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Similarity Definition of Client</strong>  </a>  |  <% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION")){ %>  
<a  href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Similarity Definition of Event</strong> </a>   <% } %>
    


