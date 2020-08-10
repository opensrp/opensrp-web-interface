<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.ElcoReportDTO" %>
<%@ page import="org.opensrp.common.dto.AggregatedReportDTO" %>
<%@ page import="org.opensrp.common.dto.ForumReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<%
    List<ForumReportDTO> forumReport = (List<ForumReportDTO>) session.getAttribute("forumReport");
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

<table class="display table table-bordered table-striped" id="forum"
       style="width: 100%;">
    <thead>
    <thead>
    <tr>
        <th rowspan="2"><spring:message code="lbl.provider"/></th>
        <th colspan="2"><spring:message code="lbl.adolescentForum"/></th>
        <th colspan="2"><spring:message code="lbl.childForum"/></th>
        <th colspan="2"><spring:message code="lbl.womenHealthForum"/></th>
        <th colspan="2"><spring:message code="lbl.ncdForum"/></th>
        <th colspan="2"><spring:message code="lbl.adultForum"/></th>

    </tr>
    <tr>
        <th><spring:message code="lbl.target"/></th>
        <th><spring:message code="lbl.acvMnt"/></th>
        <th><spring:message code="lbl.target"/></th>
        <th><spring:message code="lbl.acvMnt"/></th>
        <th><spring:message code="lbl.target"/></th>
        <th><spring:message code="lbl.acvMnt"/></th>
        <th><spring:message code="lbl.target"/></th>
        <th><spring:message code="lbl.acvMnt"/></th>
        <th><spring:message code="lbl.target"/></th>
        <th><spring:message code="lbl.acvMnt"/></th>
    </tr>
    </thead>
    </thead>
    <tbody id="t-body" style="font-size: 12px">
    <% for ( ForumReportDTO report: forumReport) { %>
    <tr>
        <td><%= report.getLocationOrProvider() %></td>
        <td><%= report.getAdolescentForumTarget() %></td>
        <td><%= report.getAdolescentForumAchievement() %></td>
        <td><%= report.getChildForumTarget() %></td>
        <td><%= report.getChildForumAchievement() %></td>
        <td><%= report.getWomenForumTarget() %></td>
        <td><%= report.getWomenForumAchievement() %></td>
        <td><%= report.getNcdForumTarget() %></td>
        <td><%= report.getNcdForumAchievement() %></td>
        <td><%= report.getAdultForumTarget() %></td>
        <td><%= report.getAdultForumAchievement() %></td>
    </tr>
    <% } %>
    </tbody>
</table>
</body>