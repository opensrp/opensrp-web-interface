<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AggregatedBiometricDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<AggregatedBiometricDTO> aggregateBiometricdReports = (List<AggregatedBiometricDTO>) session.getAttribute("aggregatedBiometricReport");
%>

<head>
    <style>
        th, td {
            text-align: center;
        }
        .elco-number {
            width: 30px;
        }
    </style>
</head>
<body>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>
    <c:choose>
		<c:when test="${type =='managerWise'}">
		    <tr>
				<th>DM name</th>									
				<th>Number of AM</th>
				<th>Number of branch</th>
				<th>Number of active SK</th>
				<th>SK target vs achievement</th>
		    </tr>
	 	</c:when>
	 	<c:otherwise>
	 		 <tr>
				<th>DM name</th>
				<th>Number of branch</th>
				<th>Number of active SK</th>
				<th>SK target vs achievement</th>
		    </tr>
	 	</c:otherwise>
	 
	 </c:choose>
    </thead>
   
    <tbody>
    
   		<c:forEach items="${reportDatas}" var="reportData">
   			<c:choose>
				<c:when test="${type =='managerWise'}">
		   			<td> ${reportData.getFullName() }</td>
		   			<td> ${reportData.getNumberOfAm() }</td>
		   			<td> ${reportData.getNumberOfBranch() }</td>
		   			<td> ${reportData.getNumberOfSK() }</td>
		   			<td> ${reportData.getAchievementInPercentage() }</td>
	   			</c:when>
	 
	 		
	 		<c:otherwise>
	 				<td> ${reportData.getLocationName() }</td>		   			
		   			<td> ${reportData.getNumberOfBranch() }</td>
		   			<td> ${reportData.getNumberOfSK() }</td>
		   			<td> ${reportData.getAchievementInPercentage() }</td>
	 		</c:otherwise>
	 		</c:choose>
		</c:forEach>
    </tbody>
</table>
</body>