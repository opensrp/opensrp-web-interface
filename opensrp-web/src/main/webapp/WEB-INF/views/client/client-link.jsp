<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

    
<% 
boolean PERM_READ_SIMILAR_EVENT_CLIENT = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT");
boolean PERM_READ_SIMILARITY_DEFINITION = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION");
boolean PERM_READ_HOUSEHOLD = AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD");
boolean PERM_READ_MOTHER = AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER");
boolean PERM_READ_CHILD = AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD");
boolean PERM_READ_MEMBER = AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER");
%>

<ol class="breadcrumb">	
<% if(PERM_READ_HOUSEHOLD){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/client/household.html?lang=${locale}"/>"> <strong><spring:message code="lbl.household"/></strong> </a><% } %>
	</li>
<% if(PERM_READ_MOTHER){ %>
  	<li class="breadcrumb-item">
    	<a  href="<c:url value="/client/mother.html?lang=${locale}"/>"> <strong><spring:message code="lbl.mother"/></strong>  </a><% } %>
    </li>

<% if(PERM_READ_CHILD){ %>
   <li class="breadcrumb-item">
   	<a  href="<c:url value="/client/child.html?lang=${locale}"/>"> <strong><spring:message code="lbl.child"/></strong>  </a><% } %>
   </li>

<% if(PERM_READ_MEMBER){ %>
	<li class="breadcrumb-item">
   		<a href="<c:url value="/client/member.html?lang=${locale}"/>"> <strong><spring:message code="lbl.member"/></strong></a><% } %>
   	</li>

<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>
  <li class="breadcrumb-item">
  		<a  href="<c:url value="/client/similarClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarCLient"/></strong>  </a><% } %>
  </li>

<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %> 
  <li class="breadcrumb-item">
  	<a  href="<c:url value="/client/similarEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarEvent"/></strong>  </a><% } %>
  </li>

<% if(PERM_READ_SIMILARITY_DEFINITION){ %> 
 	<li class="breadcrumb-item">
 		<a  href="<c:url value="/client/similarityDefinitionOfClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarclientRuleDefination"/></strong>  </a><% } %>
 	</li>

<% if(PERM_READ_SIMILARITY_DEFINITION){ %>  
  <li class="breadcrumb-item">
  	<a  href="<c:url value="/client/similarityDefinitionOfEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similareventRuleDefination"/></strong> </a>   <% } %>
  </li>

</ol>
