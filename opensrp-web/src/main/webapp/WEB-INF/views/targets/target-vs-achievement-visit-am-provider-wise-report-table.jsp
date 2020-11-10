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
		        <th rowspan="2">SK name</th>
		        <th rowspan="2">ID</th>
		        <th colspan="2">Household Visit</th>
		        <th colspan="2">ELCO Visit</th>
		        <th colspan="2">Methods Users</th>
		        <th colspan="2">Adolescent Methods Users</th>
		        <th colspan="2">Pregnancy Identified</th>
		        <th colspan="2">Delivery</th>
		        
		        <th colspan="2">Institutionalized Delivery</th>
		        <th colspan="2">Child Visit(0-6 months)</th>
		        <th colspan="2">Child Visit(7-24 months)</th>
		        
		        <th colspan="2">Child Visit(18-36 months)</th>
		        <th colspan="2">Immunization(0-59 months)</th>
		        <th colspan="2">Pregnant Visit</th>
		        
		        
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
		   			<td> ${reportData.getFullName() }</td>
		   			<td> ${reportData.getMobile() }</td>
		   			<td> ${reportData.getHhVisitTarget() }/${reportData.getHhVisitAchievement() }</td>
		   			<td> ${reportData.getHhVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getElcoVisitTarget() }/${reportData.getElcoVisitAchievement() }</td>
		   			<td> ${reportData.getElcoVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getMethodsUsersVisitTarget() }/${reportData.getMethodsUsersVisitAchievement() }</td>
		   			<td> ${reportData.getMethodsUsersVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getAdolescentMethodsUsersVisitTarget() }/${reportData.getAdolescentMethodsUsersVisitAchievement() }</td>
		   			<td> ${reportData.getAdolescentMethodsUsersVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getPregnancydentifiedVisitTarget() }/${reportData.getPregnancydentifiedVisitAchievement() }</td>
		   			<td> ${reportData.getPregnancydentifiedVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getDeliveryVisitTarget() }/${reportData.getDeliveryVisitAchievement() }</td>
		   			<td> ${reportData.getDeliveryVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getInstitutionalizedDeliveryVisitTarget() }/${reportData.getInstitutionalizedDeliveryVisitAchievement() }</td>
		   			<td> ${reportData.getInstitutionalizedDeliveryVisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getChild06VisitTarget() }/${reportData.getChild06VisitAchievement() }</td>
		   			<td> ${reportData.getChild06VisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getChild724VisitTarget() }/${reportData.getChild724VisitAchievement() }</td>
		   			<td> ${reportData.getChild724VisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getChild1836VisitTarget() }/${reportData.getChild1836VisitAchievement() }</td>
		   			<td> ${reportData.getChild1836VisitAchievementInPercentage() }</td>
		   			
		   			<td> ${reportData.getImmunizationVisitTarget() }/${reportData.getImmunizationVisitAchievement() }</td>
		   			<td> ${reportData.getImmunizationVisitAchievementInPercentage() }</td>
		   			<td> ${reportData.getPregnantVisitTarget() }/${reportData.getPregnantVisitAchievement() }</td>
		   			<td> ${reportData.getPregnantVisitAchievementInPercentage() }</td>
	   			
	   			
	 		</tr>
		</c:forEach>
    </tbody>
</table>
</body>