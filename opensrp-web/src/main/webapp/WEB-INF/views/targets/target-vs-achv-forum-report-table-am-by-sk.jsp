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
<% Object targets = request.getAttribute("jsonReportData"); %>

<div class="row">
    <div class="col-sm-offset-10 col-sm-2">
        <select class="custom-select" id="visitCategory" style="width: 95%" onclick="reloadSkChart()">
            <option value="">Please Select </option>
            <option value="pnc">Adult Forum</option>
            <option value="ncd">NCD Forum</option>
            <option value="iycf">IYCF Forum</option>
            <option value="women">Women Forum</option>
            <option value="adolescent">Adolescent Forum</option>
        </select>
    </div>
</div>

<div id="column-chart"></div>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>

            <tr>
                <th rowspan="2">Branch name</th>
                <th rowspan="2">SK </th>
                <th colspan="2">Adolescent Forum</th>
                <th colspan="2">NCD Forum</th>
                <th colspan="2">IYCF Forum</th>
                <th colspan="2">Women Forum</th>
                <th colspan="2">Adult Forum</th>
            </tr>
            <tr>
                <th>Achievement/Target (#)</th>
                <th>Avg articipant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg articipant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg articipant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg articipant/Target avg participant</th>

                <th>Achievement/Target (#)</th>
                <th>Avg articipant/Target avg participant</th>
            </tr>

    </thead>

    <tbody id="t-body">

    <c:forEach items="${reportDatas}" var="reportData">
        <tr>


                    <td> ${reportData.getBranchName() }</td>
                    <td> ${reportData.getFullName() }</td>
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
        </tr>
    </c:forEach>
    </tbody>
</table>
<script>

    var reportData = <%= targets%>;
    console.log(reportData);
    var managers = [];
    var percentages = []
    for(var i=0; i < reportData.length; i++) {
        managers.push(reportData[i].firstName + ' '+ reportData[i].lastName);
        percentages.push(reportData[i].achievementInPercentage);
    }

    Highcharts.chart('column-chart', {
        chart: {
            type: 'column'
        },
        title: {
            text: 'Target vs Achievement'
        },
        subtitle: {
            text: ''
        },
        xAxis: {
            categories: managers,
            crosshair: true
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Average Achievement'
            }
        },
        tooltip: {
            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            pointFormat: '<tr><td style="color:{series.color};padding:0"> </td>' +
                '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
            footerFormat: '</table>',
            shared: true,
            useHTML: true
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },
        series: [{name:'', data: percentages}],
    });


</script>
</body>