<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.PregnancyReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<PregnancyReportDTO> pregnancyReports = (List<PregnancyReportDTO>) session.getAttribute("pregnancyReports");
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
    <tr> <!--1st row-->
        <th colspan="23">Pregnancy Related Information</th>
    </tr>
    <tr> <!--2nd row-->
        <th rowspan="3">Location/SK</th>
        <th rowspan="3">Total no. of pregnant women</th>
        <th rowspan="3">No. Of Adolescents pregnant girls (10-19 years)</th>
        <th colspan="2">No. Of new pregnant women identified in current month</th>
        <th rowspan="3">No of total pregnant women (Old + New)</th>
        <th colspan="6">Delivery Information (No.)</th>
        <th colspan="3">No. Of ANCs given</th>
        <th rowspan="3">No. Of  TT  protected mothers</th>
        <th colspan="2" rowspan="2">No. Of PNC visits within 48 hours</th>
        <th rowspan="3">No. Of mothers completed 42 days after delivery</th>
        <th colspan="3">Post natal care (PNC)</th>
        <th rowspan="3">No. of referred cases with Pregnancy related complications</th>
    </tr>
    <tr> <!--3rd row-->
        <th rowspan="2">Within 1st three month (Ist trimester)</th>
        <th rowspan="2">After 1st three month</th>

        <th colspan="2">Institutionalized</th>
        <th colspan="3">Delivery at Home</th>
        <th rowspan="2">Total no.of deliveries</th>

        <th rowspan="2">1-3</th>
        <th rowspan="2">4-4+</th>
        <th rowspan="2">Total ANC</th>

        <th rowspan="2">1-2</th>
        <th rowspan="2">3-3+</th>
        <th rowspan="2">Total PNC</th>
    </tr>
    <tr> <!--4th row-->
        <th>Normal</th>
        <th>Cesarean</th>

        <th>BRAC CSBA</th>
        <th>Doctor/nurse/FWV/CSBA/SACMO</th>
        <th>TBA/others</th>

        <th>SK</th>
        <th>Others</th>
    </tr>
    </thead>
    <tbody id="t-body">
    <% for (PregnancyReportDTO report: pregnancyReports) { %>
    <tr>
        <td><%=report.getLocationOrProvider()%></td>
        <td><%=report.getTotalPregnant()%></td>
        <td><%=report.getAdolescentPregnant()%></td>
        <td><%=report.getFirstTrimesterPregnant()%></td>
        <td><%=report.getSecondTrimesterPregnant()%></td>
        <td><%=report.getPregnantOldAndNew()%></td>
        <td><%=report.getNormal()%></td>
        <td><%=report.getCesarean()%></td>
        <td><%=report.getBracCsba()%></td>
        <td><%=report.getDnfcs()%></td>
        <td><%=report.getTbaAndOthers()%></td>
        <td><%=report.getTotalDeliveries()%></td>
        <td><%=report.getAnc1To3()%></td>
        <td><%=report.getAnc4And4Plus()%></td>
        <td><%=report.getTotalAnc()%></td>
        <td><%=report.getTtProtectedMothers()%></td>
        <td><%=report.getPnc48SK()%></td>
        <td><%=report.getPnc48Others()%></td>
        <td><%=report.getCompleted42Days()%></td>
        <td><%=report.getPnc1And2()%></td>
        <td><%=report.getPnc3And3Plus()%></td>
        <td><%=report.getTotalPnc()%></td>
        <td><%=report.getPregnancyComplicationReferred()%></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>