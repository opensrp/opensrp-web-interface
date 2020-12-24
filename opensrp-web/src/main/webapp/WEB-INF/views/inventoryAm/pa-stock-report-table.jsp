<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.StockReportDTO" %>
<%@ page import="org.opensrp.common.dto.PAStockReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<PAStockReportDTO> paStockReport = (List<PAStockReportDTO>) session.getAttribute("stockReport");
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
        <th rowspan="2">PA Id</th>
        <th colspan="4">NCD</th>
        <th colspan="4">Sun Glass</th>
        <th colspan="4">SV 1</th>
        <th colspan="4">SV 1.5</th>
        <th colspan="4">SV 2</th>
        <th colspan="4">SV 2.5</th>
        <th colspan="4">SV 3</th>

        <th colspan="4">BF 1</th>
        <th colspan="4">BF 1.5</th>
        <th colspan="4">BF 2</th>
        <th colspan="4">BF 2.5</th>
        <th colspan="4">BF 3</th>


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
    <% for (PAStockReportDTO report: paStockReport) { %>
    <tr>
        <td><%=report.getUsername()%></td>

        <td><%=report.getNcdStartingBalance()%></td>
        <td><%=report.getNcdMonthlySupply()%></td>
        <td><%=report.getNcdMonthlySell()%></td>
        <td><%=report.getNcdEndingBalance()%></td>

        <td><%=report.getSgStartingBalance()%></td>
        <td><%=report.getSgMonthlySupply()%></td>
        <td><%=report.getSgMonthlySell()%></td>
        <td><%=report.getSgEndingBalance()%></td>

        <td><%=report.getSv1StartingBalance()%></td>
        <td><%=report.getSv1MonthlySupply()%></td>
        <td><%=report.getSv1MonthlySell()%></td>
        <td><%=report.getSv1EndingBalance()%></td>

        <td><%=report.getSv15StartingBalance()%></td>
        <td><%=report.getSv15MonthlySupply()%></td>
        <td><%=report.getSv15MonthlySell()%></td>
        <td><%=report.getSv15EndingBalance()%></td>

        <td><%=report.getSv2StartingBalance()%></td>
        <td><%=report.getSv2MonthlySupply()%></td>
        <td><%=report.getSv2MonthlySell()%></td>
        <td><%=report.getSv2EndingBalance()%></td>

        <td><%=report.getSv25StartingBalance()%></td>
        <td><%=report.getSv25MonthlySupply()%></td>
        <td><%=report.getSv25MonthlySell()%></td>
        <td><%=report.getSv25EndingBalance()%></td>

        <td><%=report.getSv3StartingBalance()%></td>
        <td><%=report.getSv3MonthlySupply()%></td>
        <td><%=report.getSv3MonthlySell()%></td>
        <td><%=report.getSv3EndingBalance()%></td>

        <td><%=report.getBf1StartingBalance()%></td>
        <td><%=report.getBf1MonthlySupply()%></td>
        <td><%=report.getBf1MonthlySell()%></td>
        <td><%=report.getBf1EndingBalance()%></td>

        <td><%=report.getBf15StartingBalance()%></td>
        <td><%=report.getBf15MonthlySupply()%></td>
        <td><%=report.getBf15MonthlySell()%></td>
        <td><%=report.getBf15EndingBalance()%></td>

        <td><%=report.getBf2StartingBalance()%></td>
        <td><%=report.getBf2MonthlySupply()%></td>
        <td><%=report.getBf2MonthlySell()%></td>
        <td><%=report.getBf2EndingBalance()%></td>

        <td><%=report.getBf25StartingBalance()%></td>
        <td><%=report.getBf25MonthlySupply()%></td>
        <td><%=report.getBf25MonthlySell()%></td>
        <td><%=report.getBf25EndingBalance()%></td>

        <td><%=report.getBf3StartingBalance()%></td>
        <td><%=report.getBf3MonthlySupply()%></td>
        <td><%=report.getBf3MonthlySell()%></td>
        <td><%=report.getBf3EndingBalance()%></td>

    </tr>
    <% } %>
    </tbody>
</table>