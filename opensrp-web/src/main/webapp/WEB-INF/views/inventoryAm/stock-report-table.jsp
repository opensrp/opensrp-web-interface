<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AMStockReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<AMStockReportDTO> amStockReport = (List<AMStockReportDTO>) session.getAttribute("amStockReport");
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
        <th rowspan="2"><spring:message code="lbl.skId"/></th>
        <th rowspan="2"><spring:message code="lbl.skname"/></th>
        <th colspan="4"><spring:message code="lbl.iycfpackage"/></th>
        <th colspan="4"><spring:message code="lbl.adolescentPackage"/></th>
        <th colspan="4"><spring:message code="lbl.womenPackage"/></th>
    </tr>
    <tr>
        <th><spring:message code="lbl.startingBalance"/></th>
        <th><spring:message code="lbl.supply"/></th>
        <th><spring:message code="lbl.sell"/></th>
        <th><spring:message code="lbl.endBalance"/></th>
        <th><spring:message code="lbl.startingBalance"/></th>
        <th><spring:message code="lbl.supply"/></th>
        <th><spring:message code="lbl.sell"/></th>
        <th><spring:message code="lbl.endBalance"/></th>
        <th><spring:message code="lbl.startingBalance"/></th>
        <th><spring:message code="lbl.supply"/></th>
        <th><spring:message code="lbl.sell"/></th>
        <th><spring:message code="lbl.endBalance"/></th>
    </tr>
    </thead>
    </thead>
    <tbody id="t-body">
    <% for (AMStockReportDTO report: amStockReport) { %>
    <tr>
        <td><%=report.getSkusername()%></td>
        <td><%=report.getSkname()%></td>
        <td><%=report.getIycfStartingBalance()%></td>
        <td><%=report.getIycfMonthlySupply()%></td>
        <td><%=report.getIycfMonthlySell()%></td>
        <td><%=report.getIycfEndingBalance()%></td>
        <td><%=report.getAdolescentPackageStartingBalance()%></td>
        <td><%=report.getAdolescentPackageMonthlySupply()%></td>
        <td><%=report.getAdolescentPackageMonthlySell()%></td>
        <td><%=report.getAdolescentPackageEndingBalance()%></td>
        <td><%=report.getWomenPackageStartingBalance()%></td>
        <td><%=report.getWomenPackageMonthlySupply()%></td>
        <td><%=report.getWomenPackageMonthlySell()%></td>
        <td><%=report.getWomenPackageEndingBalance()%></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>