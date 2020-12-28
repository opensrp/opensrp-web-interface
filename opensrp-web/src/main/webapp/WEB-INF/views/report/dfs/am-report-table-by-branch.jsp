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

<div id="column-chart"></div>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>

    <tr>
        <th>Branch name</th>
        <th>Number of  SK</th>
        <th>Total</th>
        <th >Amount From ANC Service</th>
        <th >Amount From PNC Service</th>
        <th >Amount From IYCF Service</th>
        <th >Amount From NCD Service</th>
        <th >Amount From Women Service</th>
        <th >Amount From Adolescent Service</th>
    </tr>
    </tr>

    </thead>

    <tbody>

    <c:forEach items="${reportDatas}" var="reportData">
        <tr>
            <td> ${reportData.getBranchName() }</td>
            <td> ${reportData.getNumberOfSK() }</td>
            <td> <fmt:formatNumber type="number" minFractionDigits="2" maxFractionDigits="2" value="${reportData.getAchievementInPercentage() }" /> %</td>

        </tr>
    </c:forEach>
    </tbody>
</table>

</body>