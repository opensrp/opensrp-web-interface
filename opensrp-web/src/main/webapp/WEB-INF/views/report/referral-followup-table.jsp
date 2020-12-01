<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AggregatedBiometricDTO" %>
<%@ page import="org.opensrp.common.dto.ReferralReportDTO" %>
<%@ page import="org.opensrp.common.dto.ReferralFollowupReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<ReferralFollowupReportDTO> report = (List<ReferralFollowupReportDTO>) session.getAttribute("referralFollowupReport");
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
        <th> Total Followup</th>
        <th id="specificReason"> Followup </th>
        <th> Didn't go </th>
        <th> BMC </th>
        <th> Union Sub Health Center </th>
        <th> Upazila Health Complex </th>
        <th> Union Family Welfare Center </th>
        <th> Union Health and Family Welfare Center </th>
        <th> Mother and Child Welfare Center </th>
        <th> Sadar Hospital </th>
        <th> Medical Collage Hospital </th>
        <th> Private Clinic </th>
        <th> Specialized Hospital </th>
        <th> Others </th>
    </tr>
    </thead>

    <tbody id="t-body">
    <% for (ReferralFollowupReportDTO r: report) { %>
    <tr>
        <td><%=r.getLocName()%></td>
        <td><%=r.getTotalFollowup()%></td>
        <td><%=r.getReferralReason()%></td>
        <td><%=r.getDidNotVisit()%></td>
        <td><%=r.getBracMaternityCenter()%></td>
        <td><%=r.getUnionHealthCenter()%></td>
        <td><%=r.getUpazilaHealthComplex()%></td>
        <td><%=r.getUnionFamilyKollanCenter()%></td>
        <td><%=r.getUnionHealthAndFamilyKollanCenter()%></td>
        <td><%=r.getMotherChildKollanCenter()%></td>
        <td><%=r.getCenterHospital()%></td>
        <td><%=r.getMedicalCollageHospital()%></td>
        <td><%=r.getPrivateClinic()%></td>
        <td><%=r.getSpecialHospital()%></td>
        <td><%=r.getOtherOption()%></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>