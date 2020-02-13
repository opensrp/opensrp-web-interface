<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.ElcoReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<ElcoReportDTO> elcoReports = (List<ElcoReportDTO>) session.getAttribute("elcoReports");
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

<table class="display" id="formWiseAggregatedListTable"
       style="width: 100%;">
    <thead>
    <tr> <!--1st-->
        <th rowspan="4">Location/SK</th>
        <th rowspan="3" colspan="3">Number of ELCOs</th>
        <th colspan="20">Family Planning methods user (including adolescent ELCOs)</th>
        <th colspan="20">Family Planning methods user (Only adolescents ELCOs)</th>
        <th rowspan="2" colspan="9">Family Planning methods user (including adolescent ELCOs)</th>
    </tr>
    <tr> <!--2nd-->
        <!--including adolescent-->
        <th colspan="5">User</th>
        <th colspan="5">New</th>
        <th colspan="5">Change</th>
        <th colspan="5">Re-initiated</th>

        <!--only adolescent-->
        <th colspan="5">User</th>
        <th colspan="5">New</th>
        <th colspan="5">Change</th>
        <th colspan="5">Re-initiated</th>
    </tr>
    <tr> <!--3rd-->
        <!--user(including adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--new(including adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--change(including adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--re-initiated(including adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--user(only adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--new(only adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--change(only adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <!--re-initiated(only adolescent)-->
        <th rowspan="2">Total</th>
        <th colspan="2">BRAC</th>
        <th rowspan="2">Provided by Government</th>
        <th rowspan="2">Provided by Other</th>

        <th colspan="3">Permanent</th>
        <th colspan="6">Temporary</th>
    </tr>
    <tr> <!--4th-->
        <th class="elco-number">Total ELCOs visited</th>
        <th class="elco-number">Adolescent ELCOs (10-19)</th>
        <th class="elco-number">ELCOs (non adolescent)</th>

        <!--user(including adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--new(including adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--change(including adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--re-initiated(including adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--user(only adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--new(only adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--change(only adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>

        <!--re-initiated(only adolescent)-->
        <th>Products delivered by BRAC</th>
        <th>Refer</th>


        <th>NSV</th>
        <th>Tubectomy</th>
        <th>Total</th>

        <th>IUD</th>
        <th>Implant</th>
        <th>Injection</th>
        <th>Pill</th>
        <th>Condom</th>
        <th>Total</th>
    </tr>
    </thead>
    <tbody id="t-body">
    <% for (ElcoReportDTO report: elcoReports) { %>
    <tr>
        <td><%=report.getLocationOrProviderName()%></td>
        <td><%=report.getTotalElcoVisited()%></td>
        <td><%=report.getAdolescent()%></td>
        <td><%=report.getNonAdolescent()%></td>
        <td><%=report.getUserTotalFpMethodUserIncludingAdolescent()%></td>
        <td><%=report.getBracUserIncludingAdolescent()%></td>
        <td><%=report.getReferUserIncludingAdolescent()%></td>
        <td><%=report.getGovtUserIncludingAdolescent()%></td>
        <td><%=report.getOtherUserIncludingAdolescent()%></td>
        <td><%=report.getNewTotalFpMethodUserIncludingAdolescent()%></td>
        <td><%=report.getBracNewIncludingAdolescent()%></td>
        <td><%=report.getReferNewIncludingAdolescent()%></td>
        <td><%=report.getGovtNewIncludingAdolescent()%></td>
        <td><%=report.getOtherNewIncludingAdolescent()%></td>
        <td><%=report.getChangeTotalFpMethodUserIncludingAdolescent()%></td>
        <td><%=report.getBracChangeIncludingAdolescent()%></td>
        <td><%=report.getReferChangeIncludingAdolescent()%></td>
        <td><%=report.getGovtChangeIncludingAdolescent()%></td>
        <td><%=report.getOtherChangeIncludingAdolescent()%></td>
        <td><%=report.getReInitiatedTotalFpMethodUserIncludingAdolescent()%></td>
        <td><%=report.getBracReInitiatedIncludingAdolescent()%></td>
        <td><%=report.getReferReInitiatedIncludingAdolescent()%></td>
        <td><%=report.getGovtReInitiatedIncludingAdolescent()%></td>
        <td><%=report.getOtherReInitiatedIncludingAdolescent()%></td>
        <td><%=report.getUserTotalFpMethodUserOnlyAdolescent()%></td>
        <td><%=report.getBracUserOnlyAdolescent()%></td>
        <td><%=report.getReferUserOnlyAdolescent()%></td>
        <td><%=report.getGovtUserOnlyAdolescent()%></td>
        <td><%=report.getOtherUserOnlyAdolescent()%></td>
        <td><%=report.getNewTotalFpMethodUserOnlyAdolescent()%></td>
        <td><%=report.getBracNewOnlyAdolescent()%></td>
        <td><%=report.getReferNewOnlyAdolescent()%></td>
        <td><%=report.getGovtNewOnlyAdolescent()%></td>
        <td><%=report.getOtherNewOnlyAdolescent()%></td>
        <td><%=report.getChangeTotalFpMethodUserOnlyAdolescent()%></td>
        <td><%=report.getBracChangeOnlyAdolescent()%></td>
        <td><%=report.getReferChangeOnlyAdolescent()%></td>
        <td><%=report.getGovtChangeOnlyAdolescent()%></td>
        <td><%=report.getOtherChangeOnlyAdolescent()%></td>
        <td><%=report.getReInitiatedTotalFpMethodUserOnlyAdolescent()%></td>
        <td><%=report.getBracReInitiatedOnlyAdolescent()%></td>
        <td><%=report.getReferReInitiatedOnlyAdolescent()%></td>
        <td><%=report.getGovtReInitiatedOnlyAdolescent()%></td>
        <td><%=report.getOtherReInitiatedOnlyAdolescent()%></td>
        <td><%=report.getNsv()%></td>
        <td><%=report.getTubectomy()%></td>
        <td><%=report.getTotalPermanentFpUser()%></td>
        <td><%=report.getIud()%></td>
        <td><%=report.getImplant()%></td>
        <td><%=report.getInjection()%></td>
        <td><%=report.getPill()%></td>
        <td><%=report.getCondom()%></td>
        <td><%=report.getTotalTemporaryFpUser()%></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>