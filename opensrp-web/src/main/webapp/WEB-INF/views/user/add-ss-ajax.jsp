<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.core.entity.Role"%>

<!DOCTYPE html>
<html lang="en">

<%
    Role ss = (Role) session.getAttribute("ss");
    Integer skId = (Integer)session.getAttribute("skId");
%>

<%-- <head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><spring:message code="lbl.addUserTitle"/></title>
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>
 --%>
<c:url var="cancelUrl" value="/user/${skId}/${skUsername}/my-ss.html?lang=en" />
<body>
<div class="content-wrapper" style="min-height: auto !important;">
    <div class="container-fluid" style="padding-bottom: 20px !important;">
        <div class="card mb-3">
            <div class="card-header" id="data">
                <i class="fa fa-table"></i> Add New SS
            </div>
            <div class="card-body">

                <span class="text-red" id="usernameUniqueErrorMessage"></span>

                <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                    <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
                <div style="margin-left: 10px;">SK NAME:<b>&nbsp;${skFullName}</b></div>
            </div>

            <form:form 	modelAttribute="account" id="SSInfo" class="form-inline" autocomplete="off">
                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="firstName"> <spring:message code="lbl.firstName"/> </label>
                        <form:input path="firstName" class="form-control mx-sm-3" required="required" />
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <label class="label-width" for="lastName"> <spring:message code="lbl.lastName"/> </label>
                        <form:input path="lastName" class="form-control mx-sm-3"/>
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <label class="label-width" for="mobile"><spring:message code="lbl.mobile"/></label>
                        <form:input path="mobile" class="form-control mx-sm-3" />
                    </div>
                </div>



                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="username">SK Username</label>
                        <form:input path="username" type="text" class="form-control mx-sm-3"
                                    required="required" value="${skUsername}" readonly="true"/>

                    </div>
                </div>

                <div class="row col-12 tag-height" id="ssOption">
                    <div class="form-group required">
                        <label class="label-width" for="ssNo"><spring:message code="lbl.ssNo"/></label>
                        <select id="ssNo"
                                class="form-control mx-sm-3 js-example-basic-multiple"
                                name="ssNo" required>
                            <option value="">Please Select SS No</option>
                            <option value="-SS-1">SS-1</option>
                            <option value="-SS-2">SS-2</option>
                            <option value="-SS-3">SS-3</option>
                            <option value="-SS-4">SS-4</option>
                            <option value="-SS-5">SS-5</option>
                            <option value="-SS-6">SS-6</option>
                            <option value="-SS-7">SS-7</option>
                            <option value="-SS-8">SS-8</option>
                            <option value="-SS-9">SS-9</option>
                            <option value="-SS-10">SS-10</option>

                        </select>
                    </div>
                </div>
                <input id="parentUser" value="${skId}" hidden/>
                <div class="row col-12 tag-height" hidden>
                    <div class="form-group required">
                        <label class="label-width"  for="branches">
                            <spring:message code="lbl.branches"/>
                        </label>
                        <select id="branches"
                                class="form-control mx-sm-3 js-example-basic-multiple"
                                name="branches" required>
                            <c:forEach items="${branches}" var="branch">
                                <option value="${branch.id}" selected>${branch.name} (${branch.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>


                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <label class="label-width"></label>
                        <div class="text-red" id="roleSelectmessage"></div>
                    </div>
                </div>
                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <input
                                type="submit"

                                value="<spring:message code="lbl.save"/>"
                                class="btn btn-primary btn-block btn-center" />
                    </div>
                    <div class="form-group">
                        <a href="#" rel="modal:close" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Cancel</a>
                    </div>
                </div>
            </form:form>
        </div>
    </div>
</div>
</body>

<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script src="<c:url value='/resources/js/user-ss.js' />"></script>
</html>
