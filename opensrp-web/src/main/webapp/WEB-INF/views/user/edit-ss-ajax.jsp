<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><spring:message code="lbl.editUserTitle"/></title>
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/${id}/edit-SS.html" />
<c:url var="cancelUrl" value="/user/${skId}/${skUsername}/my-ss.html?lang=en" />

<%
    String selectedParentUser = (String)session.getAttribute("parentUserName");
%>

<body>

<div class="content-wrapper" style="min-height: auto !important;">
    <div class="container-fluid" style="padding-bottom: 20px !important;">

        <h5>Edit SS</h5>
        <div class="card mb-3">
            <div class="card-header">
                <b>Edit ${account.fullName}'s Information</b>
            </div>
            <div class="card-body">
                <form:form modelAttribute="account" id="update-ss-information" class="form-inline">

                    <div class="row col-12 tag-height">
                        <div class="form-group required">
                            <label class="label-width" for="firstName"> <spring:message code="lbl.firstName"/> </label>
                            <form:input path="firstName" class="form-control mx-sm-3"
                                        required="required"/>
                        </div>
                    </div>

                    <div class="row col-12 tag-height">
                        <div class="form-group">
                            <label class="label-width" for="lastName"><spring:message code="lbl.lastName"/> </label>
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
                            <label class="label-width" for="username"><spring:message code="lbl.username"/></label>
                            <form:input path="username" class="form-control mx-sm-3"
                                        readonly="true"	required="required"/>

                        </div>
                    </div>

                    <form:input path="id" name = "id" style="display: none;"/>


                    <div class="row col-12 tag-height">
                        <div class="form-group">
                            <input type="submit" id="updateContinue" name="updateContinue" value="Update & Continue To Edit Catchment Area"
                                   class="btn btn-primary btn-block btn-sm uc" />
                        </div>
                        <div class="form-group">
                            <input type="submit" id="update" name="update" style="margin-left: 10px;" value="Update"
                                   class="btn btn-primary btn-block btn-sm u" />
                        </div>
                        <div class="form-group">
                            <a href="#"  rel="modal:close" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Close</a>
                        </div>
                    </div>
                </form:form>

            </div>
            <div class="card-footer small text-muted"></div>
        </div>
    </div>
</div>
</body>

<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script src="<c:url value='/resources/js/user-ss.js'/>"></script>
</html>
