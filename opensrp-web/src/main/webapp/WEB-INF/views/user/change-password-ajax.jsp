<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>

<!DOCTYPE html>
<html lang="en">

<%
    String username = (String) session.getAttribute("username");
%>

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link type="text/css" href="<c:url value="/resources/css/magicsuggest-min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title><spring:message code="lbl.changePassword"/></title>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<%
    String fromRole = (String) session.getAttribute("fromRole");
    String role = AuthenticationManagerUtil.isAM()?"AM":"";
    Integer skId = (Integer) session.getAttribute("idFinal");
    String skUsername = (String) session.getAttribute("usernameFinal");
%>

<body>
<div class="content-wrapper" style="min-height: auto !important;">
    <div class="container-fluid" style="padding-bottom: 20px !important;">
        <h5>Change Password</h5>
        <div class="card mb-3">
            <div class="card-header">
                <b>${account.fullName}'s Password Change</b>
            </div>
            <div class="card-body">

                <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                    <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>

            </div>
            <div id="changePassword" class="form-inline" autocomplete="off">

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="password"><spring:message code="lbl.password"/></label>
                        <input type="text" class="form-control mx-sm-3" id="password" name="password"  required />
                        <input type="checkbox" checked onclick="toggleVisibilityOfPassword()">Show Password
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width"  for="retypePassword"><spring:message code="lbl.confirmedPassword"/></label>
                        <input type="text" class="form-control mx-sm-3" id="retypePassword"
                               required="required" />
                        <small id="confirmPasswordHelpInline" class="text-muted text-para">
                            <span class="text-red" id="passwordNotMatchedMessage"></span>
                        </small>
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <input
                                type="submit"
                                onclick="submitted()"
                                value="<spring:message code="lbl.resetPassword"/>"
                                class="btn btn-primary btn-block btn-center" />
                    </div>
                    <div class="form-group">
                        <a href="#" rel="modal:close" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Cancel</a>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
<!-- /.container-fluid-->
<!-- /.content-wrapper-->
<script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>

<!-- Custom scripts for all pages-->
<script src="<c:url value='/resources/js/sb-admin.min.js'/>"></script>


<script type="text/javascript">

    function toggleVisibilityOfPassword() {
        var password = document.getElementById("password");
        var retypePassword = document.getElementById("retypePassword");
        if (password.type === "password") {
            password.type = "text";
            retypePassword.type = "text";
        } else {
            password.type = "password";
            retypePassword.type = "password";
        }
    }

    function submitted() {

        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("retypePassword").value;
        if (password != confirmPassword) {
            $("#passwordNotMatchedMessage").html("Your password doesn't match. Please enter same.");
            return;
        }
        if (password.length < 4) {
            $("#passwordNotMatchedMessage").html("Password should be 4 character long...");
            return;
        }
        $("#passwordNotMatchedMessage").html("");

        $("#loading").show();
        console.log("first chance");
        var url = "/opensrp-dashboard/rest/api/v1/user/change-password";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        console.log("last chance <%=username%>");
        var formData = {
            'username': "<%=username%>",
            'password': $('input[name=password]').val()
        };

        var redirectUrl = "/opensrp-dashboard/user.html";
        var role = "<%=role%>";
        var fromRole = "<%=fromRole%>";
        var skId = "<%=skId%>";
        var skUsername = "<%=skUsername%>";

        console.log(role);
        if (role == 'AM') {
            if (fromRole == 'SK') {
                redirectUrl = "/opensrp-dashboard/user/sk-list.html";
            } else if (fromRole == 'SS') {
                redirectUrl = "/opensrp-dashboard/user/"+skId+"/"+skUsername+"/my-ss.html?lang=en"
            }
        }

        $.ajax({
            contentType : "application/json",
            type: "POST",
            url: url,
            data: JSON.stringify(formData),
            dataType : 'json',

            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(data) {
                console.log("response data: "+data);
                $("#usernameUniqueErrorMessage").html(data);
                $("#loading").hide();
                if(data == ""){
                    window.location.replace(redirectUrl);
                }
            },
            error : function(e) {
                $("#loading").hide();
                console.log("In Error");
            },
            done : function(e) {
                $("#loading").hide();
                console.log("DONE");
            }
        });
    }

    function Validate() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("retypePassword").value;
        if (password != confirmPassword) {
            $("#passwordNotMatchedMessage").html("Your password doesn't match. Please enter same.");
            return false;
        }

        $("#passwordNotMatchedMessage").html("");
        return true;
    }

</script>

</body>
</html>
