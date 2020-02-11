<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<% 
boolean PERM_READ_SIMILAR_EVENT_CLIENT = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILAR_EVENT_CLIENT");
boolean PERM_READ_SIMILARITY_DEFINITION = AuthenticationManagerUtil.isPermitted("PERM_READ_SIMILARITY_DEFINITION");
%>

<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %>
<a  href="<c:url value="/similarRecord/similarClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarCLient"/></strong>  </a>  | <% } %>

<% if(PERM_READ_SIMILAR_EVENT_CLIENT){ %> 
<a  href="<c:url value="/similarRecord/similarEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarEvent"/></strong>  </a>  | <% } %>

<% if(PERM_READ_SIMILARITY_DEFINITION){ %> 
<a  href="<c:url value="/similarRecord/similarityDefinitionOfClient.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similarclientRuleDefination"/></strong>  </a>  |  <% } %>

<% if(PERM_READ_SIMILARITY_DEFINITION){ %>  
<a  href="<c:url value="/similarRecord/similarityDefinitionOfEvent.html?lang=${locale}"/>"> <strong><spring:message code="lbl.similareventRuleDefination"/></strong> </a>   <% } %>

    


