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
<%
    List<AggregatedBiometricDTO> aggregateBiometricdReports = (List<AggregatedBiometricDTO>) session.getAttribute("aggregatedBiometricReport");
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
        <th rowspan="2"><spring:message code="lbl.provider"/></th>
        <th rowspan="2"><spring:message code="lbl.peopleEligibleForBioReg"/></th>
        <th rowspan="2"><spring:message code="lbl.RegWithBio"/></th>
        <th rowspan="2"><spring:message code="lbl.servicesProvidedWithBio"/></th>
        <th rowspan="2"><spring:message code="lbl.servicesValidateWithBio"/></th>
        <th rowspan="2"><spring:message code="lbl.servicesByPassingValidation"/></th>
        <th colspan="3"><spring:message code="lbl.anc"/></th>
        <th colspan="3"><spring:message code="lbl.pnc"/></th>
        <th colspan="3"><spring:message code="lbl.elco"/></th>
        <th colspan="3"><spring:message code="lbl.otherPackage"/></th>
    </tr>
    <tr>
        <th><spring:message code="lbl.ancWithIdentification"/></th>
        <th><spring:message code="lbl.ancWithVerification"/></th>
        <th><spring:message code="lbl.ancByPassingValidation"/></th>
        <th><spring:message code="lbl.pncWithIdentification"/></th>
        <th><spring:message code="lbl.pncWithVerification"/></th>
        <th><spring:message code="lbl.pncByPassingValidation"/></th>
        <th><spring:message code="lbl.elcoWithIdentification"/></th>
        <th><spring:message code="lbl.elcoWithVerification"/></th>
        <th><spring:message code="lbl.elcoByPassingValidation"/></th>
        <th><spring:message code="lbl.servicesWithIdentification"/></th>
        <th><spring:message code="lbl.servicesWithVerification"/></th>
        <th><spring:message code="lbl.servicesProvidedByPassingValidation"/></th>
    </tr>
    </thead>
    </thead>
    <tbody id="t-body">
    <% for (AggregatedBiometricDTO report: aggregateBiometricdReports) { %>
        <tr>
            <td><%=report.getLocationOrProvider()%></td>
            <td><%=report.getRegisteredWithBio()%></td>
            <td><%=report.getEligibleForRegistration()%></td>
            <td><%=report.getAllIdentified()%></td>
            <td><%=report.getAllVerified()%></td>
            <td><%=report.getAllBypass()%></td>
            <td><%=report.getAncTotalIdentified()%></td>
            <td><%=report.getAncTotalVerified()%></td>
            <td><%=report.getAncTotalBypass()%></td>
            <td><%=report.getPncTotalIdentified()%></td>
            <td><%=report.getPncTotalVerified()%></td>
            <td><%=report.getPncTotalBypass()%></td>
            <td><%=report.getElcoTotalIdentified()%></td>
            <td><%=report.getElcoTotalVerified()%></td>
            <td><%=report.getElcoTotalBypass()%></td>
            <td><%=report.getOtherTotalIdentified()%></td>
            <td><%=report.getOtherTotalVerified()%></td>
            <td><%=report.getOtherTotalBypass()%></td>
        </tr>
    <% } %>
    </tbody>
</table>
</body>