<%@page import="java.util.List"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<%@ page import = "java.util.ResourceBundle" %>
<% ResourceBundle resource = ResourceBundle.getBundle("project");
    String downloadUrl = resource.getString("download.url");
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

    <title>Form Wise Client Data Report</title>
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <style>
        #errorMsg{
            color: darkred;
            margin-bottom: 10px;
        }
        #downloadFailedMsg {
            color: red;
        }
    </style>

    <jsp:include page="/WEB-INF/views/css.jsp" />

    <style>
        th, td { text-align: center; }
        .select2-container--default .select2-results__option { font-size: 18px!important; }
        .select2-container--default .select2-selection--single .select2-selection__arrow { left: 88% !important; }
        .select2-container--default .select2-selection--single { width: 100% !important; }
        .select2-container--open .select2-dropdown--below {width: 80% !important;}
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
                <div id="search_form">
                    <div class="form-group">
                        <form autocomplete="off">
                            <div class="row">
                                <div class="col-2">
                                    <label><spring:message code="lbl.startDate"/></label>
                                    <input class="form-control custom-select custom-select-lg mb-3" type=text
                                           name="start" id="start">
                                    <label style="display: none;" class="text-danger" id="startDateValidation"><small>Input is not valid for date</small></label>
                                </div>
                                <div class="col-2">
                                    <label><spring:message code="lbl.endDate"/></label>
                                    <input class="form-control custom-select custom-select-lg mb-3" type=text
                                           name="end" id="end">
                                    <label style="display: none;" class="text-danger" id="endDateValidation"><small>Input is not valid for date</small></label>
                                </div>
                                <% if (AuthenticationManagerUtil.isAM()) {%>
                                <div class="col-2">
                                    <label><spring:message code="lbl.branches"/></label>
                                    <select class="custom-select custom-select-lg mb-3 js-example-basic-multiple" id="branch" name="branch" onchange="branchChange()">
                                        <option value="0">Select Branch</option>
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
                                    <select class="custom-select custom-select-lg mb-3 js-example-basic-multiple" id="skList" name="sk">
                                        <option value="">Select SK</option>
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
                                    <select class="custom-select custom-select-lg mb-3 js-example-basic-multiple" id="formName" name="formName">
                                        <option value="">Select Form Name</option>
                                        <c:forEach var="map" items="${formNameList}">
                                            <option value="${map.key}"><c:out value="${map.value}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </form>
                        <div class="row" id="msg">
                            <div class="col-6" id="errorMsg"> </div>
                        </div>
                        <div class="row">

                            <div class="col-1">
                                <button name="search" id="bth-search" onclick="getClientDataReportTable()"
                                        class="btn btn-primary" value="search"><spring:message code="lbl.search"/></button>
                            </div>
                            <div class="col-1">
                                <button name="export" id="bth-export" onclick="generateExportData()"
                                        class="btn btn-primary" value="export"><spring:message code="lbl.export"/></button>
                            </div>
                            <div class="col-6" id="downloadingFile" style="margin-top: 5px; display: none;">
                                <i class="fa fa-spinner fa-spin" style="font-size:24px"></i> Downloading..
                            </div>
                            <div class="col-6" id="downloadFailedMsg" style="display: none;">
                                Failed to export data.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
            </div>
            <div id="client-data-report-table"></div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/datepicker.js' />"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script>

    let downloadInterval = null;
    $(document).ready(function() {
        $('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
        $("#msg").hide();
        console.log("Form Name: "+ $('#formName').val());
        console.log("SK Name: "+ $('#skList').val());
        console.log("Branch Name: "+ $('#branch').val());
    });
    function branchChange() {
        console.log("in branch change");
        let url = "/opensrp-dashboard/branches/sk?branchId="+$("#branch").val();
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

    function getClientDataReportTable(pageNo = 0) {

        let flagS = true;
        let flagE = true;
        if (!checkDate($('#start').val())) {
            $('#startDateValidation').show();
            flagS = false;
        } else {
            $('#startDateValidation').hide();
            flagS = true;
        }
        if (!checkDate($('#end').val())) {
            $('#endDateValidation').show();
            flagE = false;
        } else {
            $('#endDateValidation').hide();
            flagE = true;
        }
        if (!flagE || !flagS) return false;

        if(!getValidationMsg())return false;

        var url = "/opensrp-dashboard/report/clientDataReportTable";
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 100000,
            data: {
                startDate: $("#start").val(),
                endDate: $("#end").val(),
                formName: $("#formName").val(),
                branch: $("#branch").val(),
                sk: $("#skList").val(),
                pageNo: pageNo
            },
            beforeSend: function() {
                $('#loading').show();
            },
            success : function(data) {
                $('#loading').hide();
                $("#client-data-report-table").html(data);
                $('#pagination-'+pageNo).addClass("active");
                if (pageNo != 0) $('#pagination-'+0).removeClass("active");
            },
            error : function(e) {
                $('#loading').hide();
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {
                $('#loading').hide();
                console.log("DONE");
                //enableSearchButton(true);
            }
        });
    }

    function goTo(pageNo){
        getClientDataReportTable(pageNo);
    }

    function generateExportData() {

        var flagS = true;
        var flagE = true;
        if (!checkDate($('#start').val())) {
            $('#startDateValidation').show();
            flagS = false;
        } else {
            $('#startDateValidation').hide();
            flagS = true;
        }
        if (!checkDate($('#end').val())) {
            $('#endDateValidation').show();
            flagE = false;
        } else {
            $('#endDateValidation').hide();
            flagE = true;
        }
        if (!flagE || !flagS) return false;

        if(!getValidationMsg())return false;

        var url = "/opensrp-dashboard/rest/api/v1/export/data";
        $("#msg").hide();
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 100000,
            data: {
                startDate: $("#start").val(),
                endDate: $("#end").val(),
                formName: $("#formName").val(),
                branch: $("#branch").val(),
                sk: $("#skList").val()
            },
            beforeSend: function() {},
            success : function(data) {
                $("#downloadFailedMsg").hide();
                $("#downloadingFile").show();
                $('#bth-export').attr("disabled", true);
                downloadInterval = setInterval(getExportTable, 3000);
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

    function getExportTable(){

        var url = "/opensrp-dashboard/rest/api/v1/export/download-data";
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function() {},
            success : function(data) {
                $("#downloadingFile").hide();
                $('#bth-export').attr("disabled", false);
                data = JSON.parse(data);
                console.log("Successfully get the data and clear the interval", data);

                if(data[0][1].toLowerCase() === "completed") {
                    downloadFile("/opt/multimedia/export/" + data[0][0]);
                }
                else {
                    $("#downloadFailedMsg").show();
                }
                clearInterval(downloadInterval);
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

    function downloadFile(url) {

        console.log("File to download ", url);
        var a = document.createElement('a');
        a.href = url;
        a.download = url.split('/').pop();
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    }

    function getValidationMsg() {
        if($("#start").val() == "" || $("#start").val() == null || $("#end").val() == "" || $("#end").val() == null) {
            $("#msg").show();
            $("#errorMsg").html("Date can not be empty");
            return false;
        }

        if($("#formName").val() == "" || $("#formName").val() == null) {
            $("#msg").show();
            $("#errorMsg").html("Form Name can not be empty");
            return false;
        } else {
            $("#msg").hide();
            $("#errorMsg").html("");
        }
        return true;
    }
</script>
</body>
