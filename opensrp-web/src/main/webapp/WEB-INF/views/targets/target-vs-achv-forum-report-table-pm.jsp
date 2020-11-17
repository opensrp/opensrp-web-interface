<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.AggregatedBiometricDTO" %>
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

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>
    <c:choose>
        <c:when test="${type =='managerWise'}">
            <tr>
                <th rowspan="2">DM name</th>
                <th rowspan="2">Number of AM</th>
                <th rowspan="2">Number of Branch</th>
                <th rowspan="2">Number of SK</th>
                <th colspan="2">Adolescent Forum</th>
                <th colspan="2">NCD Forum</th>
                <th colspan="2">IYCF Forum</th>
                <th colspan="2">Women Forum</th>
                <th colspan="2">Adult Forum</th>
            </tr>
            <tr>
                <th>Achievement/Target (#)</th>
                <th>Avg participant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg participant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg participant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg participant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg participant/Target avg participant</th>
            </tr>
        </c:when>
        <c:otherwise>
        </c:otherwise>

    </c:choose>
    </thead>

    <tbody id="t-body">

    <c:forEach items="${reportDatas}" var="reportData">
        <tr>
            <c:choose>
                <c:when test="${type =='managerWise'}">
                    <td> ${reportData.getFullName() }</td>
                    <td> ${reportData.getNumberOfAM() }</td>
                    <td> ${reportData.getNumberOfBranch() }</td>
                    <td> ${reportData.getNumberOfSK() }</td>
                    <td> ${reportData.getAdolescentAchv() } / ${reportData.getAdolescentTarget()} </td>
                    <td> ${reportData.getAdolescnetAvgParticipantAchv() } / ${reportData.getAdolescnetAvgParticipantTarget()} </td>
                    <td> ${reportData.getNcdAchv() } / ${reportData.getNcdTarget()} </td>
                    <td> ${reportData.getNcdAvgParticipantAchv() } / ${reportData.getNcdAvgParticipantTarget()} </td>
                    <td> ${reportData.getIycfAchv() } / ${reportData.getIycfTarget()} </td>
                    <td> ${reportData.getIycfAvgParticipantAchv() } / ${reportData.getIycfAvgParticipantTarget()} </td>
                    <td> ${reportData.getWomenAchv() } / ${reportData.getWomenTarget()} </td>
                    <td> ${reportData.getWomenAvgParticipantAchv() } / ${reportData.getWomenAvgParticipantTarget()} </td>
                    <td> ${reportData.getAdultAchv() } / ${reportData.getAdultTarget()} </td>
                    <td> ${reportData.getAdultAvgParticipantAchv() } / ${reportData.getAdultAvgParticipantTarget()} </td>


                </c:when>


                <c:otherwise>

                </c:otherwise>
            </c:choose>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>