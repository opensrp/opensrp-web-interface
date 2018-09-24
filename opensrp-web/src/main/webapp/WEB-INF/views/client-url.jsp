<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="form-group">				
			 <a  href="<c:url value="/client/household.html"/>"> <strong>Household</strong> 
			 </a>  |<a  href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>
			 </a>  |<a  href="<c:url value="/client/child.html"/>"> <strong>Child</strong>
			 </a>  |<a  href="<c:url value="/client/member.html"/>"> <strong>Member</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar Event</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Similarity Definition of Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Similarity Definition of Event</strong>
			 </a>  		
			</div>