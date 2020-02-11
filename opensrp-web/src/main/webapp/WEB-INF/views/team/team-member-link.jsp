<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<ol class="breadcrumb">
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_LIST")){ %>
	<li class="breadcrumb-item">
		<a  href="<c:url value="/team/list.html?lang=${locale}"/>"> <strong> <spring:message code="lbl.manageTeam"/></strong> 	</a>   <% } %>
	</li> 
<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_TEAM_MEMBER_LIST")){ %>
 <li class="breadcrumb-item">
 	<a  href="<c:url value="/team/teammember/list.html?lang=${locale}"/>"> <strong><spring:message code="lbl.manageTeamMember"/></strong> </a> <% } %>
 </li>    
</ol>

