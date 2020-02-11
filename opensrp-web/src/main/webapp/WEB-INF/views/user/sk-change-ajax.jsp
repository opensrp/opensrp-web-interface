<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%@page import="java.util.List"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/css.jsp" />
    <style>
        .select2-container--default .select2-results__option { font-size: 18px !important; }
        .select2-container--default .select2-selection--single .select2-selection__arrow { left: 95% !important; }
        .select2-container--default .select2-selection--single { width: 100% !important; }
    </style>
</head>

<body>
<div class="content-wrapper" style="min-height: auto !important;">
    <div class="container-fluid" style="padding-bottom: 20px !important;">
        <div class="card mb-3">
            <div class="card-header"><b>${ssInfo.fullName}'s SK Change</b></div>
            <div class="card-body">
                <div class="row">
                   <div class="col-12 tag-height">
                       <span>CURRENT SK: <b>&nbsp;${skFullName}(${skUsername})</b></span>
                   </div>
                </div>
                <form autocomplete="off">
                    <div class="row">
                        <div class="col-6">
                            <div class="form-group required">
                                <label class="label-width"  for="branches">
                                    <spring:message code="lbl.branches"/>
                                </label>
                                <select id="branches"
                                        class="form-control mx-sm-3 js-example-basic-multiple"
                                        name="branches" required="required">
                                    <c:forEach items="${branches}" var="branch">
                                        <option value="${branch.id}">${branch.name} (${branch.code})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-group required">
                                <label class="label-width"  for="skList"><spring:message code="lbl.sk"/></label>
                                <select class="form-control mx-sm-3 js-example-basic-multipl
                                e" id="skList" name="sk" required="required">
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6 tag-height"></div>
                        <div class="col-6 tag-height">
                            <div><span id="select-sk" style="font-size: small; color: red;display: none;">Please Select an SK...</span></div>
                        </div>
                    </div>
                    <div style="margin-top: 220px;">
                        <a class="btn btn-sm btn-dark" href="#" onclick="changeParent()" style="margin-left: 10px; float: right; bottom: 0px">Change SK</a>
                        <a class="btn btn-sm btn-dark" href="#" rel="modal:close" style="float: right; bottom: 0px">Close</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script src="<c:url value='/resources/js/user-ss.js' />"></script>
<script>
    $(document).ready(function () {
        loadSKList();
    });
    $('#branches').change(function (e) {
        e.preventDefault();
        loadSKList();
    });
    function loadSKList() {
        $("#skList").html("");
        var url = "/opensrp-dashboard/branches/change-sk?branchId="+$("#branches").val();
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function() {},
            success : function(e, data) {
                $("#skList").html(e);
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
</script>
</body>
</html>
