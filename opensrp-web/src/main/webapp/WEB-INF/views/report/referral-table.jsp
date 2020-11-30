<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AggregatedBiometricDTO" %>
<%@ page import="org.opensrp.common.dto.ReferralReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<ReferralReportDTO> report = (List<ReferralReportDTO>) session.getAttribute("referralReport");
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

<table class="display table table-bordered table-striped" id="formWiseAggregatedListTable"
       style="width: 100%;">
    <thead>
    <thead>
    <tr>
        <%--        <th rowspan="2"><spring:message code="lbl.slNo"/></th>--%>
        <th> Location Name</th>
        <th> Total Referred</th>
        <th> Pregnancy Related Problems </th>
        <th> Delivery Related Problems </th>
        <th> PNC Problems </th>
        <th> Child Problems </th>
        <th> Eye Problems</th>
        <th> Daibetes </th>
        <th> Blood Pressure </th>
        <th> Birth Control Related Problems </th>
        <th> Others </th>
    </tr>
    </thead>

    <tbody id="t-body">
    <% for (ReferralReportDTO r: report) { %>
    <tr>
        <td><%=r.getLocName()%></td>
        <td> <%= r.getPregnancyProblems() + r.getDeliveryProblems() + r.getPncProblems() + r.getChildProblems() + r.getEyeProblems() + r.getDiabetes() + r.getBp() + r.getBirthControlProblems() + r.getOtherProblems()%> </td>
        <td><%=r.getPregnancyProblems()%></td>
        <td><%=r.getDeliveryProblems()%></td>
        <td><%=r.getPncProblems()%></td>
        <td><%=r.getChildProblems()%></td>
        <td><%=r.getEyeProblems()%></td>
        <td><%=r.getDiabetes()%></td>
        <td><%=r.getBp()%></td>
        <td><%=r.getBirthControlProblems()%></td>
        <td><%=r.getOtherProblems()%></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>