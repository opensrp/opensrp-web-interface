<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.StockReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<StockReportDTO> amStockReport = (List<StockReportDTO>) session.getAttribute("amStockReport");
%>


    <style>
        th, td {
            text-align: center;
        }

    </style>


<table class="display table table-bordered table-striped table-scrollable" id="stockReport"
       style="width: 100%;">
    <thead>
    <tr>
        <%--        <th rowspan="2"><spring:message code="lbl.slNo"/></th>--%>
        <th rowspan="2"><spring:message code="lbl.skId"/></th>
        <th rowspan="2"><spring:message code="lbl.skname"/></th>
        <th colspan="4"><spring:message code="lbl.iycfpackage"/></th>
        <th colspan="4"><spring:message code="lbl.adolescentPackage"/></th>
        <th colspan="4"><spring:message code="lbl.womenPackage"/></th>
        <th colspan="4"><spring:message code="lbl.ncdPackage"/></th>
        <th colspan="4"><spring:message code="lbl.ancPackage"/></th>
        <th colspan="4"><spring:message code="lbl.pncPackage"/></th>
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
    <tbody id="t-body">
    <% for (StockReportDTO report: amStockReport) { %>
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
        <td><%=report.getNcdPackageStartingBalance()%></td>
        <td><%=report.getNcdPackageMonthlySupply()%></td>
        <td><%=report.getNcdPackageMonthlySell()%></td>
        <td><%=report.getNcdPackageEndingBalance()%></td>
        <td><%=report.getAncPackageStartingBalance()%></td>
        <td><%=report.getAncPackageMonthlySupply()%></td>
        <td><%=report.getAncPackageMonthlySell()%></td>
        <td><%=report.getAncPackageEndingBalance()%></td>
        <td><%=report.getPncPackageStartingBalance()%></td>
        <td><%=report.getPncPackageMonthlySupply()%></td>
        <td><%=report.getPncPackageMonthlySell()%></td>
        <td><%=report.getPncPackageEndingBalance()%></td>
    </tr>
    <% } %>
    </tbody>
</table>