<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>


<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD_LIST")){ %>
<a  href="<c:url value="/client/household.html"/>"> <strong>Household</strong> </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER_LIST")){ %>
<a  href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>  </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD_LIST")){ %>
<a  href="<c:url value="/client/child.html"/>"> <strong>Child</strong>  </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILAR_CLIENT_LIST")){ %>
<a  href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar Client</strong>  </a>  | <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_EVENT_LIST")){ %> 
<a  href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar Event</strong>  </a>  | <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_CLIENT_RULE_DEFINATION")){ %> 
<a  href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Similarity Definition of Client</strong>  </a>  |  <% } %>
<% if(AuthenticationManagerUtil.isPermitted("PERM_SIMILER_EVENT_RULE_DEFINATION")){ %>  
<a  href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Similarity Definition of Event</strong> </a>   <% } %>
    


