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
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getANCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getANCServiceSell()*100/reportData.getANCServiceTarget() }" />  
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
		   			
		   			<td> ${reportData.getPNCServiceTarget() }/${reportData.getPNCServiceSell() }</td>
		   			
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getPNCServiceSell()*100/reportData.getPNCServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			</td>
		   			
		   			<td> ${reportData.getNCDServiceTarget() }/${reportData.getNCDServiceSell() }</td>
		   			
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getNCDServiceSell()*100/reportData.getNCDServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getIYCFServiceTarget() }/${reportData.getIYCFServiceSell() }</td>
		   			
		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getIYCFServiceSell()*100/reportData.getIYCFServiceTarget() }" /> 
		   			
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			
		   			
		   			<td> ${reportData.getWomenServiceTarget() }/${reportData.getWomenServiceSell() }</td>
		   			
		   			<td> 
		   			
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getWomenServiceSell()*100/reportData.getWomenServiceTarget() }" /> 
		   				</c:otherwise>
		   			</c:choose>
		   			 </td>
		   			
		   			
		   			<td> ${reportData.getAdolescentServiceTarget() }/${reportData.getAdolescentServiceSell() }</td>
		   			<td> 
		   			<c:choose>
		   				<c:when test="${reportData.getPNCServiceTarget()==0}">
		   				
		   				N/A
		   				</c:when>
		   				<c:otherwise>		   				
		   				<fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getAdolescentServiceSell()*100/reportData.getAdolescentServiceTarget() }" /> 
		   				 
		   				</c:otherwise>
		   			</c:choose>
		   			
		   			 </td>
	 		</tr>
		</c:forEach>
    </tbody>
</table>
</body>