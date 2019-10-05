<%@page import="java.util.List"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>
<%@ page import="org.opensrp.common.dto.ReportDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<%
    List<Object[]> table1Data = (List<Object[]>) session.getAttribute("table1Data");
    List<Object[]> sevenDaysData = (List<Object[]>) session.getAttribute("sevenDaysData");
    List<Object[]> countPopulation = (List<Object[]>) session.getAttribute("countPopulation");
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta http-equiv="refresh"
          content="<%=session.getMaxInactiveInterval()%>;url=/login" />

    <title>Admin Dashboard</title>

    <jsp:include page="/WEB-INF/views/css.jsp" />

    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
</head>


<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
    <div class="container-fluid">
        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i>
                <spring:message code="lbl.adminDashboard"/>
            </div>

            <div class="card-body">
                <table id="aggregatedStatistics" class="display">
                    <thead>
                        <tr>
                            <th><spring:message code="lbl.district"/> </th>
                            <th><spring:message code="lbl.upazila"/> </th>
                            <th><spring:message code="lbl.totalCCFromHRIS"/> </th>
                            <th><spring:message code="lbl.totalMHVFromCBHC"/> </th>
                            <th><spring:message code="lbl.targetHousehold"/> </th>
                            <th><spring:message code="lbl.targetPopulation"/> </th>
                            <th><spring:message code="lbl.collectedHousehold"/> </th>
                            <th><spring:message code="lbl.collectedPopulation"/> </th>
                            <th><spring:message code="lbl.achievement"/> </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Object[] list: table1Data) {
                        %>
                        <tr>
                            <td><%=list[0]%></td>
                            <td><%=list[1]%></td>
                            <td><%=list[7]%></td>
                            <td><%=list[8]%></td>
                            <td><%=list[5]%></td>
                            <td><%=list[6]%></td>
                            <td><%=list[3]%></td>
                            <td><%=list[4]%></td>
                            <td><%=list[9]%>%</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <table id="mhvWiseStatistics" class="display">
                    <thead>
                    <tr>
                        <th><spring:message code="lbl.district"/> </th>
                        <th><spring:message code="lbl.upazila"/> </th>
                        <th><spring:message code="lbl.totalCCFromHRIS"/> </th>
                        <th><spring:message code="lbl.totalCCFromPrima"/> </th>
                        <th><spring:message code="lbl.coverageCCPrima"/> </th>
                        <th><spring:message code="lbl.totalMHVFromCBHC"/> </th>
                        <th><spring:message code="lbl.totalMHVFromPrima"/> </th>
                        <th><spring:message code="lbl.coverageMHVPrima"/> </th>

                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Object[] list: table1Data) {
                    %>
                    <tr>
                        <td><%=list[0]%></td>
                        <td><%=list[1]%></td>
                        <td><%=list[7]%></td>
                        <td><%=list[11]%></td>
                        <td><%=list[13]%>%</td>
                        <td><%=list[8]%></td>
                        <td><%=list[10]%></td>
                        <td><%=list[12]%>%</td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
                <div class="row">
                    <div class="col-sm-5">
                        <table class="display">
                            <thead>
                            <tr>
                                <th><spring:message code="lbl.date"/> </th>
                                <th><spring:message code="lbl.male"/> </th>
                                <th><spring:message code="lbl.female"/> </th>
                                <th><spring:message code="lbl.total"/> </th>

                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (Object[] list: sevenDaysData) {
                            %>
                            <tr>
                                <td><%=list[0]%></td>
                                <td><%=list[1]%></td>
                                <td><%=list[2]%></td>
                                <td><%=list[3]%></td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row" style="margin-top: 20px;">
                    <div class="col-sm-4">
                        <table class="display">
                            <thead>
                            <tr>
                                <th><spring:message code="lbl.total"/> <spring:message code="lbl.targetPopulation"/> </th>
                                <th><spring:message code="lbl.total"/> <spring:message code="lbl.collectedHousehold"/> </th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (Object[] list: countPopulation) {
                            %>
                            <tr>
                                <td><%=list[0]%></td>
                                <td><%=list[1]%></td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-sm-8">
                        <div id="count_population"></div>
                    </div>
                </div>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/datepicker.js' />"></script>
<script src="<c:url value='/resources/js/jspdf.debug.js' />"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>
<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>
<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>
<script src="<c:url value='/resources/js/jszip.js' />"></script>
<script src="<c:url value='/resources/js/pdfmake.js' />"></script>
<script src="<c:url value='/resources/js/vfs_fonts.js' />"></script>
<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
<script src="<c:url value='/resources/chart/data.js'/>"></script>
<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
<script src="<c:url value='/resources/chart/series-label.js'/>"></script>
<script>
    $(document).ready(function() {
        $('#aggregatedStatistics').DataTable({
            bFilter: true,
            bInfo: true,
            dom: 'Bfrtip',
            destroy: true,
            buttons: [
                'pageLength', 'csv', 'excel', 'pdf'
            ],
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
        });
    });

    $(document).ready(function() {
        $('#mhvWiseStatistics').DataTable({
            bFilter: true,
            bInfo: true,
            dom: 'Bfrtip',
            destroy: true,
            buttons: [
                'pageLength', 'csv', 'excel', 'pdf'
            ],
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
        });
    });
</script>
<script>
    var a = <%=countPopulation.get(0)[2]%>;
    var b = <%=countPopulation.get(0)[3]%>;

    Highcharts.chart('count_population', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: ''
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                }
            }
        },
        series: [{
            name: 'Brands',
            colorByPoint: true,
            data: [{
                name: 'Total Collected Population',
                y: 85.86,
                sliced: false,
                selected: true
            },  {
                name: 'Total Targeted Population',
                y: 14.14
            }]
        }]
    });
</script>
</body>
</html>
