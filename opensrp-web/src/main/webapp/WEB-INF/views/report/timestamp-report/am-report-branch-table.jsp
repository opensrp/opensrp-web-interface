<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.TargetReportDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.google.gson.JsonArray" %>
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
        <th colspan="7"> Average Submission Duration per Form by SK</th>
    </tr>
    <tr>
        <th>All</th>
        <th>ANC</th>
        <th>IYCF Package</th>
        <th>NCD Package</th>
        <th>Women Package</th>
        <th>Adolescent Package</th>
        <th>HH Visit</th>
    </tr>
    </thead>

    <tbody>

    <c:forEach items="${reportDatas}" var="reportData">
        <tr>
            <td> ${reportData.getBranchName() }</td>
            <td> ${reportData.getAncTime() + reportData.getIycfTime() + reportData.getNcdTime() + reportData.getWomenTime() + reportData.getAdolescentTime() + reportData.getHhVisitTime()}</td>
            <td> ${reportData.getAncTime() }</td>
            <td> ${reportData.getIycfTime() }</td>
            <td> ${reportData.getNcdTime() }</td>
            <td> ${reportData.getWomenTime() }</td>
            <td> ${reportData.getAdolescentTime() }</td>
            <td> ${reportData.getHhVisitTime() }</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<%--<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>--%>
<script>




</script>
</body>
