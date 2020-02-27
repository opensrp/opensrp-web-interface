<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.ElcoReportDTO" %>
<%@ page import="org.opensrp.common.dto.ChildNutritionReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%
    List<ChildNutritionReportDTO> childNutritionReports = (List<ChildNutritionReportDTO>) session.getAttribute("childNutritionReports");
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
        <th rowspan="2">Location/SK</th>
        <th rowspan="2">Total number of children visited aged 19-36 months</th>
        <th rowspan="2">No. Of fully immunized children (18-36 months)</th>
        <th rowspan="2">No. Of  NCD services by SK</th>
        <th rowspan="2">No. Of  Adolescent services by SK</th>
        <th rowspan="2">No. Of  IYCF services by SK</th>
        <th rowspan="2">No. Of  Women services by SK</th>
        <th colspan="4">Child Nutrition Information</th>
    </tr>
    <tr> <!--2nd row-->
        <th>No. Of neonates started breast feed within 1 hour of birth</th>
        <th>No. Of children breastfeed (24 hours recall)</th>
        <th>No. Of children initiated complementary feeding (at 7 months)</th>
        <th>No. Of children took pustikona in the last 24 hours (7 - 59 month)</th>
    </tr>
    </thead>
    <tbody id="t-body">
    <% for (ChildNutritionReportDTO report: childNutritionReports) { %>
    <tr>
        <td><%=report.getLocationOrProvider()%></td>
        <td><%=report.getChildrenVisited19To36()%></td>
        <td><%=report.getImmunizedChildren18To36()%></td>
        <td><%=report.getNcdPackage()%></td>
        <td><%=report.getAdolescentPackage()%></td>
        <td><%=report.getIycfPackage()%></td>
        <td><%=report.getWomenPackage()%></td>
        <td><%=report.getBreastFeedIn1Hour()%></td>
        <td><%=report.getBreastFeedIn24Hour()%></td>
        <td><%=report.getComplementaryFoodAt7Months()%></td>
        <td><%=report.getPushtikonaInLast24Hour()%></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>