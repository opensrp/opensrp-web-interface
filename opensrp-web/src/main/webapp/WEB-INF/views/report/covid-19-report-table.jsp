<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.COVID19ReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<COVID19ReportDTO> covid19Reports = (List<COVID19ReportDTO>) session.getAttribute("covid19Reports");
%>

<head>
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
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

<table class="display" id="covidReports"
       style="width: 100%;">
    <thead>
    <tr>
        <th>SK</th>
        <th>SS</th>
        <th>Total Visit</th>
        <th>Number of Symptoms Found</th>
        <th>Number of Contact Person From Abroad</th>
        <th>Number of Person Contacted with Symptoms</th>
        <th>Name</th>
        <th>Contact No.</th>
        <th>Gender</th>
        <th>Symptoms</th>
        <th>Date</th>
    </tr>
    </thead>
    <tbody id="t-body">
    <% for (COVID19ReportDTO report: covid19Reports) { %>
    <tr>
        <td><%=report.getSkId()%></td>
        <td><%=report.getSsName()%></td>
        <td><%=report.getVisitNumberToday()%></td>
        <td><%=report.getNumberOfSymptomsFound()%></td>
        <td><%=report.getNumberOfContactPersonFromAbroad()%></td>
        <td><%=report.getNumberOfPersonContactedWithSymptoms()%></td>
        <td><%=report.getFirstName()%></td>
        <td><%=report.getContactPhone()%></td>
        <td><%=report.getGenderCode()%></td>
        <td><%=report.getSymptomsFound()%></td>
        <td><%=report.getSubmittedDate()%></td>
    </tr>
    <% } %>
    </tbody>
</table>

</body>