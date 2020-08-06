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
    </tr>
    </thead>
    </thead>
    <tbody id="t-body">
    </tbody>
</table>
</body>