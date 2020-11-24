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
<div id="column-chart"></div>

<table class="display table table-bordered table-striped" id="reportDataTable"
       style="width: 100%;">
    <thead>

    <tr>
        <th rowspan="2">AM name</th>
        <th rowspan="2">Total Branch</th>
        <th colspan="4">SK</th>

    </tr>
    <tr>
        <th>Position</th>
        <th>Active</th>

        <th>Dropout(Inactive)</th>
        <th>Maternity Leave</th>
    </tr>

    </thead>

    <tbody id="t-body">

    <c:forEach items="${reportDatas}" var="reportData">
        <tr>

            <td> ${reportData.getAmName() }</td>
            <td> ${reportData.getTotalBranch() }</td>
            <td> ${reportData.getPositions() }</td>
            <td> ${reportData.getActiveUsers() }</td>
            <td> ${reportData.getPositions() - reportData.getActiveUsers() - reportData.getOnLeaveUsers() }</td>
            <td> ${reportData.getOnLeaveUsers() }</td>

        </tr>
    </c:forEach>
    </tbody>
</table>
<script>

    initialLoad();

    function initialLoad() {
        var reportData = <%= targets%>;
        console.log(reportData);
        var managers = [];
        var positions = [], activeUsers = [], onLeaves = [];
        for(var i=0; i < reportData.length; i++) {
            managers.push(reportData[i].amName);
            positions.push(reportData[i].positions );
            activeUsers.push(reportData[i].activeUsers);
            onLeaves.push(reportData[i].onLeaveUsers );
        }
        reloadChart(managers, positions, activeUsers, onLeaves);
    }


    function reloadChart(managers, positions, activeUsers, onLeaves) {
        Highcharts.chart('column-chart', {
            chart: {
                type: 'column'
            },
            title: {
                text: 'HR Report'
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
                    text: 'Users'
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
            series: [
                {name:'positoins', data: positions},
                {name:'active users', data: activeUsers},
                {name:'maternity leave', data: onLeaves}
            ],
        });

    }



</script>

</body>