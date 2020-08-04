<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.IndividualBiometricReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<IndividualBiometricReportDTO> individualBiometricReport = (List<IndividualBiometricReportDTO>) session.getAttribute("individualBiometricReport");
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
<%--        <th><spring:message code="lbl.slNo"/></th>--%>
        <th><spring:message code="lbl.date"/></th>
        <th><spring:message code="lbl.identified"/></th>
        <th><spring:message code="lbl.memberName"/></th>
        <th><spring:message code="lbl.memberId"/></th>
        <th><spring:message code="lbl.serviceTaken"/></th>
        <th><spring:message code="lbl.serviceProvider"/></th>
        <th><spring:message code="lbl.branch"/></th>

    </tr>
    </thead>
    </thead>
    <tbody id="t-body">
        <% for(IndividualBiometricReportDTO report: individualBiometricReport) { %>
        <tr>
            <td><%= report.getEventDate() %></td>
            <td><%= report.getIdentifiedStr() %></td>
            <td><%= report.getMemberName() %></td>
            <td><%= report.getMemberId()%></td>
            <td><%= report.getServiceName() %></td>
            <td><%= report.getProviderName() %></td>
            <td><%= report.getBranchName() %></td>
        </tr>
        <% } %>
    </tbody>
</table>
</body>