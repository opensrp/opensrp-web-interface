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
    <title><spring:message code="lbl.userUpload"/> </title>
    <%@page import="org.json.JSONObject" %>
    <%@page import="org.json.JSONArray" %>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/upload/user-catchment.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid">
        <!-- Example DataTables Card-->
        <div class="form-group">
            <jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
        </div>

        <div class="card mb-3">
            <div class="card-header">
                <spring:message code="lbl.userUpload"/>
            </div>
            <div class="card-body">
                <form:form method="POST" action="${saveUrl}?${_csrf.parameterName}=${_csrf.token}" modelAttribute="location" enctype="multipart/form-data">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-5">
                                <label for="exampleInputName">File  </label>
                                <input id="file" type="file" name="file" />
                            </div>

                        </div>
                        <span class="text-red">${msg}</span>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-3">
                                <input type="submit" value="Upload"
                                       class="btn btn-primary btn-block" />
                            </div>
                        </div>
                    </div>
                </form:form>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>
    </div>
    <!-- /.container-fluid-->
    <!-- /.content-wrapper-->
    <jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>

