<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.ElcoReportDTO" %>
<%@ page import="org.opensrp.common.dto.AggregatedReportDTO" %>
<%@ page import="org.opensrp.common.dto.ForumIndividualReportDTO" %>
<%@ page import="org.opensrp.web.util.ArithmeticUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

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

<%
    List<ForumIndividualReportDTO> forumIndividualReport = (List<ForumIndividualReportDTO>) session.getAttribute("forumIndividualReport");
%>


<table class="display table table-bordered table-striped" id="forum"
       style="width: 100%;">
    <thead>
    <thead>
    <tr>
        <th rowspan="2"><spring:message code="lbl.provider"/></th>
        <th colspan="5"><%= session.getAttribute("forumType") %></th>

    </tr>
    <tr>
        <th><spring:message code="lbl.target"/></th>
        <th><spring:message code="lbl.acvMnt"/></th>
        <th><spring:message code="lbl.totalParticipant"/></th>
        <th><spring:message code="lbl.avgParticipantPerForum"/></th>
        <th><spring:message code="lbl.numberOfServiceSold"/></th>
    </tr>
    </thead>
    </thead>
    <tbody id="t-body" style="font-size: 12px">
    <% for ( ForumIndividualReportDTO report: forumIndividualReport) { %>
    <tr>
        <td><%= report.getLocationOrProvider() %></td>
        <td><%= report.getTarget() %></td>
        <td><%= report.getAchievement() %></td>
        <td><%= report.getTotalParticipant() %> </td>
        <td><%= ArithmeticUtil.getForumAvg(report.getTotalParticipant(), report.getAchievement()) %> </td>
        <td><%= report.getServiceSold() %></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>