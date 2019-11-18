<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.core.entity.FacilityWorker"%>
<%@page import="org.opensrp.core.entity.FacilityTraining"%>


<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<%@ page import="org.json.JSONArray" %>

<%
    List<Object[]> countPopulation = (List<Object[]>) session.getAttribute("countPopulation");
    List<Object[]> upazilaList = (List<Object[]>) session.getAttribute("upazilaList");
    JSONArray countPopulationArray = (JSONArray) session.getAttribute("countPopulationArray");
    List<Object[]> sevenDaysDataUpazilaWise = (List<Object[]>) session.getAttribute("sevenDaysDataUpazilaWise");
    Integer length = sevenDaysDataUpazilaWise.size();
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta http-equiv="refresh"
          content="<%=session.getMaxInactiveInterval()%>;url=/login" />

    <title>UHFPO Dashboard</title>

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
                <i class="fa fa-table"></i> <spring:message code="lbl.upazilaWiseDataStatus"/>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[1]%></h3>
                                    <h5>Total Registered Household</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[2]%></h3>
                                    <h5>Total Population</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[4]%></h3>
                                    <h5>Total Female</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[3]%></h3>
                                    <h5>Total Male</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row" style="margin-top: 30px;">
                    <div class="col-sm-12" id="content">
                        <table class="display" id="householdMemberListTable"
                               style="width: 100%;">
                            <thead>
                            <tr>
                                <th><spring:message code="lbl.upazila"/></th>
                                <th><spring:message code="lbl.householdCount"/></th>
                                <th><spring:message code="lbl.population"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (int i = 0; i < upazilaList.size(); i++) {%>
                            <tr>
                                <td><%=upazilaList.get(i)[0]%></td>
                                <td><%=upazilaList.get(i)[1]%></td>
                                <td><%=upazilaList.get(i)[2]%></td>
                            </tr>
                            <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <br>
        <br>


        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i>
                <spring:message code="lbl.lastSevenDaysDataUpazilaWise"/>
            </div>

            <div class="card-body">
                <table id="lastSevenDaysDataUpazilaWise" class="display">
                    <thead>
                    <tr>
                        <th> <spring:message code="lbl.upazila"></spring:message></th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[1]%> </th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[2]%> </th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[3]%> </th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[4]%> </th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[5]%> </th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[6]%> </th>
                        <th> <%=sevenDaysDataUpazilaWise.get(length-1)[7]%> </th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        Integer count = 0;
                        for (Object[] list: sevenDaysDataUpazilaWise) {
                            count++;
                            if (count == length) break;
                    %>
                    <tr>
                        <td><%=list[0]%></td>
                        <td><%=list[1]%></td>
                        <td><%=list[2]%></td>
                        <td><%=list[3]%></td>
                        <td><%=list[4]%></td>
                        <td><%=list[5]%></td>
                        <td><%=list[6]%></td>
                        <td><%=list[7]%></td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>
        <br>
        <br>

        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i>
                <spring:message code="lbl.populationCoverage"/>
            </div>

            <div class="card-body">
                <div class="row" style="margin-top: 40px;">
                    <div class="col-sm-4">
                        <table class="display">
                            <thead>
                            <tr>
                                <th><spring:message code="lbl.total"/> <spring:message code="lbl.targetPopulation"/> </th>
                                <th><spring:message code="lbl.total"/> <spring:message code="lbl.collectedPopulation"/> </th>
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
        $('#lastSevenDaysDataUpazilaWise').DataTable({
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
    Highcharts.chart('count_population', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: 'Population Coverage'
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
            data: <%=countPopulationArray%>
        }]
    });
</script></body>
</html>
