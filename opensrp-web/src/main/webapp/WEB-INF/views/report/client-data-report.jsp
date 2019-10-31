<%@page import="java.util.List"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>
<%@ page import="org.opensrp.common.dto.ReportDTO" %>
<%@ page import="org.opensrp.web.util.SearchUtil" %>
<%@ page import="org.opensrp.common.util.FormName" %>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta http-equiv="refresh"
          content="<%=session.getMaxInactiveInterval()%>;url=/login" />

    <title>Form Wise Client Data Report</title>

    <jsp:include page="/WEB-INF/views/css.jsp" />

    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
    <style>
        th, td {
            text-align: center;
        }
    </style>
</head>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
    <div class="container-fluid">

        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i> ${title.toString()} <spring:message code="lbl.searchArea"/>
            </div>
            <div class="card-body">
                <div class="row">

                </div>
            <form id="search_form" autocomplete="off">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-2">
                                <label><spring:message code="lbl.startDate"/></label>
                                <input class="form-control custom-select custom-select-lg mb-3" type=text
                                       name="start" id="start" value="">
                            </div>
                            <div class="col-2">
                                <label><spring:message code="lbl.endDate"/></label>
                                <input class="form-control custom-select custom-select-lg mb-3" type=text
                                       name="end" id="end" value="">
                            </div>
                            <% if (AuthenticationManagerUtil.isAM()) {%>
                            <div class="col-2">
                                <label><spring:message code="lbl.branches"/></label>
                                <select class="custom-select custom-select-lg mb-3" id="branch" name="branch" onchange="branchChange()">
                                    <option value="-1">Select Branch</option>
                                    <%
                                        List<Branch> ret = (List<Branch>) session.getAttribute("branchList");
                                        for (Branch str : ret) {
                                    %>
                                    <option value="<%=str.getId()%>"><%=str.getName()%></option>
                                    <%}%>
                                </select>
                            </div>
                            <%}%>
                            <div class="col-2">
                                <label><spring:message code="lbl.sk"/></label>
                                <select class="custom-select custom-select-lg mb-3" id="skList" name="sk">
                                    <option value="-1">Select SK</option>
                                    <%
                                        List<Object[]> ret = (List<Object[]>) session.getAttribute("skList");
                                        for (Object[] str : ret) {
                                    %>
                                    <option value="<%=str[1]%>"><%=str[2]%>(<%=str[1]%>)</option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-2">
                                <label><spring:message code="lbl.formName"/></label>
                                <select class="custom-select custom-select-lg mb-3" id="formName" name="formName">
                                    <option value="-1">Select Form Name</option>
                                    <c:forEach var="map" items="${formNameList}">
                                        <option value="${map.key}"><c:out value="${map.value}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-6">
                                <button name="search" type="submit" id="bth-search"
                                        class="btn btn-primary" value="search"><spring:message code="lbl.search"/></button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>

      <% Integer flag = (Integer) session.getAttribute("emptyFlag"); %>
       <% if(flag == 0) { %>
        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i> ${title.toString()} <spring:message code="lbl.clientDataTable"/>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-sm-12" id="content">
                        <table class="display" id="clientTableList"
                               style="width: 100%;">
                            <thead>
                               <tr>
                                   <% List<String> ths = (List<String>) session.getAttribute("headerList"); %>
                                   <% for(String str: ths) {%>
                                    <th><%=str%></th>
                                   <% } %>
                                </tr>
                            </thead>
                            <tbody>
                            <%  List<Object[]> allClientInfo = (List<Object[]>) session.getAttribute("clientInfoList");
                                for(Object[] object: allClientInfo){
                            %>
                                <tr>
                                    <% for(Object obj: object){ %>
                                        <td><%=obj%></td>
                                    <% } %>
                                </tr>
                            <%  } %>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>
    <% } %>

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
<script>
    function branchChange() {
        console.log("in branch change");
        var url = "/opensrp-dashboard/branches/sk?branchId="+$("#branch").val();
        $("#skList").html("");
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function() {},
            success : function(data) {
                console.log(data);
                $("#skList").html(data);
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {

                console.log("DONE");
                //enableSearchButton(true);
            }
        });
    }
    $(document).ready(function() {
        $('#clientTableList').DataTable({
            bFilter: true,
            bInfo: true,
            dom: 'Bfrtip',
            destroy: true,
            scrollX: true,
            buttons: [
                'pageLength', 'csv', 'excel', 'pdf'
            ],
            "order": [[ 3, "desc" ]],
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
        });
        $('.dataTables_length').addClass('bs-select');
    });
    $(document).ready(function() {
        $('#ccListTable').DataTable({
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
    <%--$('#formName').val('${formName}');--%>
    <%--$('#sk').val('${sk}');--%>
</script>
</body>
