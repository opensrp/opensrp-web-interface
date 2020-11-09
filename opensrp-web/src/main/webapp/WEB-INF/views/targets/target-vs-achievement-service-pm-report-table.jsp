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
		        <th rowspan="2">DM name</th>
		        <th rowspan="2">Number of AM</th>
		        
		        <th colspan="2">ANC package</th>
		        <th colspan="2">PNC package</th>
		        <th colspan="2">NCD package</th>
		        <th colspan="2">IYCF package</th>
		        <th colspan="2">Women package</th>
		    </tr>
		    <tr>
		        <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		    </tr>
	 	</c:when>
	 	<c:otherwise>
	 		 <tr>
		        <th rowspan="2">Location name</th>
		        <th rowspan="2">Number of AM</th>
		        
		        <th colspan="2">ANC package</th>
		        <th colspan="2">PNC package</th>
		        <th colspan="2">NCD package</th>
		        <th colspan="2">IYCF package</th>
		        <th colspan="2">Women package</th>
		    </tr>
		    <tr>
		        <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		        
		         <th>TvA (#)</th>
		        <th>TvA(%)</th>
		    </tr>
	 	</c:otherwise>
	 
	 </c:choose>
    </thead>
   
    <tbody id="t-body">
    	
   		<c:forEach items="${reportDatas}" var="reportData"> 
   			<tr>
   			<c:choose>
				<c:when test="${type =='managerWise'}">
		   			<td> ${reportData.getFullName() }</td>
		   			<td> ${reportData.getNumberOfAm() }</td>
		   			
		   			<td> ${reportData.getANCServiceTarget() }/${reportData.getANCServiceSell() }</td>
		   			<td> ${reportData.getANCServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getPNCServiceTarget() }/${reportData.getPNCServiceSell() }</td>
		   			<td> ${reportData.getPNCServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getNCDServiceTarget() }/${reportData.getNCDServiceSell() }</td>
		   			<td> ${reportData.getNCDServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getIYCFServiceTarget() }/${reportData.getIYCFServiceSell() }</td>
		   			<td> ${reportData.getIYCFServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getWomenServiceTarget() }/${reportData.getWomenServiceSell() }</td>
		   			<td> ${reportData.getWomenServiceAchievement() }</td>
		   			
	   			</c:when>
	 
	 		
	 		<c:otherwise>
	 				<td> ${reportData.getLocationName() }</td>		   			
		   			<td> ${reportData.getNumberOfAm() }</td>
		   			
		   			<td> ${reportData.getANCServiceTarget() }/${reportData.getANCServiceSell() }</td>
		   			<td> ${reportData.getANCServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getPNCServiceTarget() }/${reportData.getPNCServiceSell() }</td>
		   			<td> ${reportData.getPNCServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getNCDServiceTarget() }/${reportData.getNCDServiceSell() }</td>
		   			<td> ${reportData.getNCDServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getIYCFServiceTarget() }/${reportData.getIYCFServiceSell() }</td>
		   			<td> ${reportData.getIYCFServiceAchievement() }</td>
		   			
		   			<td> ${reportData.getWomenServiceTarget() }/${reportData.getWomenServiceSell() }</td>
		   			<td> ${reportData.getWomenServiceAchievement() }</td>
	 		</c:otherwise>
	 		</c:choose>
	 		</tr>
		</c:forEach>
    </tbody>
</table>
</body>