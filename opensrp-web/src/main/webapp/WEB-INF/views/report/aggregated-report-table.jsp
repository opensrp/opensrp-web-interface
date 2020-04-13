<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.ElcoReportDTO" %>
<%@ page import="org.opensrp.common.dto.AggregatedReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<AggregatedReportDTO> aggregatedReports = (List<AggregatedReportDTO>) session.getAttribute("aggregatedReports");
    Boolean isSKList = (Boolean) session.getAttribute("isSKList");
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
    <thead>
    <tr>
        <th rowspan="2"><spring:message code="lbl.provider"/></th>
        <th rowspan="2"><spring:message code="lbl.householdCount"/></th>
        <th colspan="3"><spring:message code="lbl.householdVisited"/></th>
        <th colspan="2"><spring:message code="lbl.population"/></th>
        <th colspan="6"><spring:message code="lbl.childInformation"/></th>
        <th rowspan="2"><spring:message code="lbl.childrenUnderFive"/></th>
        <th rowspan="2"><spring:message code="lbl.childrenFiveToTenYears"/></th>
        <th colspan="3"><spring:message code="lbl.adolescentTenToNineteen"/></th>
        <th colspan="3"><spring:message code="lbl.agedNineteenToThirtyFive"/></th>
        <th colspan="3"><spring:message code="lbl.numberOfPopulationThirtyFiveDivideThirtyFivePlusYearsOld"/></th>
        <th rowspan="2"><spring:message code="lbl.numberOfHHWithSanitaryLatrine"/></th>
        <th rowspan="2"><spring:message code="lbl.memberWithFingerprint"/></th>
        <th rowspan="2"><spring:message code="lbl.reproductiveAgeGroup"/></th>
        <% if (isSKList == null || isSKList == false) {%>
        <th rowspan="2"><spring:message code="lbl.activeSK"/></th>
        <%}%>
    </tr>
    <tr>
        <th><spring:message code="lbl.vo"/></th>
        <th><spring:message code="lbl.nvo"/></th>
        <th><spring:message code="lbl.total"/></th>
        <th><spring:message code="lbl.registered"/></th>
        <th><spring:message code="lbl.total"/></th>
        <th><spring:message code="lbl.zeroToSix"/></th>
        <th><spring:message code="lbl.sevenToTwelve"/></th>
        <th><spring:message code="lbl.thirteenToEighteen"/></th>
        <th><spring:message code="lbl.nineteenToTwentyFour"/></th>
        <th><spring:message code="lbl.twentyFiveToThirtySix"/></th>
        <th><spring:message code="lbl.thirtySevenToSixty"/></th>
        <th><spring:message code="lbl.male"/></th>
        <th><spring:message code="lbl.female"/></th>
        <th><spring:message code="lbl.total"/></th>
        <th><spring:message code="lbl.male"/></th>
        <th><spring:message code="lbl.female"/></th>
        <th><spring:message code="lbl.total"/></th>
        <th><spring:message code="lbl.male"/></th>
        <th><spring:message code="lbl.female"/></th>
        <th><spring:message code="lbl.total"/></th>
    </tr>
    </thead>
    </thead>
    <tbody id="t-body">
    <% for (AggregatedReportDTO report: aggregatedReports) { %>
    <tr>
        <td><%=report.getLocationOrProvider()%></td>
        <td><%=report.getHouseholdCount()%></td>
        <td><%=report.getBracVo()%></td>
        <td><%=report.getNvo()%></td>
        <td><%=report.getHouseholdTotal()%></td>
        <td><%=report.getPopulationCount()%></td>
        <td><%=report.getTotalPopulation()%></td>
        <td><%=report.getFrom0To6()%></td>
        <td><%=report.getFrom6to11()%></td>
        <td><%=report.getFrom12To17()%></td>
        <td><%=report.getFrom18To23()%></td>
        <td><%=report.getFrom24To35()%></td>
        <td><%=report.getFrom36To59()%></td>
        <td><%=report.getFrom0To59()%></td>
        <td><%=report.getFrom60To119()%></td>
        <td><%=report.getFrom120To227Male()%></td>
        <td><%=report.getFrom120To227Female()%></td>
        <td><%=report.getFrom120To227Total()%></td>
        <td><%=report.getFrom240To419Male()%></td>
        <td><%=report.getFrom240To419Female()%></td>
        <td><%=report.getFrom240To419Total()%></td>
        <td><%=report.getFrom420AndPlusMale()%></td>
        <td><%=report.getFrom420AndPlusFemale()%></td>
        <td><%=report.getFrom420AndPlusTotal()%></td>
        <td><%=report.getLatrineCount()%></td>
        <td><%=report.getFingerPrintTaken()%></td>
        <td><%=report.getReproductiveAgeGroup()%></td>
        <% if (isSKList == null || isSKList == false) {%>
        <td><%=report.getActiveSk()%></td>
        <%}%>
    </tr>
    <% } %>
    </tbody>
</table>
</body>