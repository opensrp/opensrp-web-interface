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
            width: 50px;
        }
    </style>
</head>
<body>




<table class="display table table-bordered table-striped" id="dataTable"
       style="width: 100%;">
    <thead>
    
		    <tr> <th> SI</th>
		        <th>Member name</th>
				<th>Member ID</th>				
				<th>Relation with <br/>household head</th>
				<th>DOB</th>
				<th>Age</th>
				<th>Gender</th>									
				<th>Village</th>
				<th>Branch(code)</th>									
				<th>Action</th>
		    </tr>
		    
	 	
    </thead>
   
    <tbody id="t-body">
    	
   		<c:forEach items="${members}" var="member"> 
   			<tr><td>0</td>
   				<td> ${member.getMemberName() }</td>
		   		<td> ${member.getMemberId() }</td>
		   		<td> ${member.getRelationWithHousehold() }</td>
		   		<td> ${member.getDob() }</td>
		   		<td>${member.getAge() } years,${member.getAgeMonth()} months </td>
		   		<td> ${member.getGender() }</td>
		   		<td> ${member.getVillage() }</td>
		   		<td> ${member.getBranchAndCode() }</td>
		   		<td>  <a href="<c:url value="/people/member-details/${member.getBaseEntityId()}/${member.getId() }.html?lang=${locale}"/>">Details</a></td>
	   			
	 		</tr>
		</c:forEach>
    </tbody>
</table>



</body>