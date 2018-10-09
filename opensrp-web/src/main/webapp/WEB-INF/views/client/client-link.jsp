<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>


<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_HOUSEHOLD")){ %>
<a  href="<c:url value="/client/household.html?lang=${locale}"/>"> <strong><spring:message code="lbl.household"/></strong> </a><% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MOTHER")){ %>
  |  <a  href="<c:url value="/client/mother.html?lang=${locale}"/>"> <strong><spring:message code="lbl.mother"/></strong>  </a><% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_CHILD")){ %>
  |  <a  href="<c:url value="/client/child.html?lang=${locale}"/>"> <strong><spring:message code="lbl.child"/></strong>  </a><% } %>

<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_MEMBER")){ %>
  |  <a href="<c:url value="/client/member.html?lang=${locale}"/>"> <strong><spring:message code="lbl.member"/></strong></a><% } %>
    


