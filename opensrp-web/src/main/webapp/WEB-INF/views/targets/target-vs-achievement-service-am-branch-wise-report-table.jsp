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
    
		    <tr>
		        <th rowspan="2">Branch name</th>		        
		        <th rowspan="2">Number of sk</th>
		        <th colspan="2">ANC package</th>
		        <th colspan="2">PNC package</th>
		        <th colspan="2">NCD package</th>
		        <th colspan="2">IYCF package</th>
		        <th colspan="2">Women package</th>
		         <th colspan="2">Adolescent package</th>
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
		        <th>TvA (#)</th>
		        <th>TvA(%)</th>
		    </tr>
	 	
    </thead>
   
    <tbody id="t-body">
    	
   		<c:forEach items="${reportDatas}" var="reportData"> 
   			<tr>
   			
		   			<td> ${reportData.getBranchName() }</td>		   			
		   			<td> ${reportData.getNumberOfSK() }</td>
		   			
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
		   			<td> ${reportData.getAdolescentServiceTarget() }/${reportData.getAdolescentServiceSell() }</td>
		   			<td> ${reportData.getAdolescentServiceAchievement() }</td>
		   			
	   			
	 		</tr>
		</c:forEach>
    </tbody>
</table>
</body>