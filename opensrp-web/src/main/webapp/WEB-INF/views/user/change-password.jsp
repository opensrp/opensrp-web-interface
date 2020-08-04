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

<%
    String username = (String) session.getAttribute("username");
%>

<title><spring:message code="lbl.changePassword"/></title>

<%
    String fromRole = (String) session.getAttribute("fromRole");
    String role = AuthenticationManagerUtil.isAM()?"AM":"";
    Integer skId = (Integer) session.getAttribute("idFinal");
    String skUsername = (String) session.getAttribute("usernameFinal");
%>

<c:url var="cancelUrl" value="/" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<style>
    .row {
        margin: 0px;
    }
</style>

<div class="page-content-wrapper">
    <div class="page-content">
        <div class="portlet box blue-madison">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-list"></i><spring:message code="lbl.password"/>
                </div>
            </div>
            <div class="portlet-body">
                <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                    <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
                <div id="changePassword" class="form-inline" autocomplete="off">

                    <div class="row">
                        <div class="col-md-1">
                            <label class="label-width" for="password"><spring:message code="lbl.password"/></label>
                        </div>

                        <div class="col-md-3">
                            <input type="text" class="form-control mx-sm-3" id="password" name="password"  required />
                        </div>

                        <div class="col-md-3">
                            <input type="checkbox" checked onclick="toggleVisibilityOfPassword()">Show Password
                        </div>
                    </div>
                    <br>
                    <div class="row ">

                        <div class="col-md-1">
                            <label class="label-width"  for="retypePassword"><spring:message code="lbl.confirmedPassword"/></label>
                        </div>

                        <div class="col-md-3">
                            <input type="text" class="form-control mx-sm-3" id="retypePassword"
                                   required="required" />
                            <small id="confirmPasswordHelpInline" class="text-muted text-para">
                                <span class="text-red" id="passwordNotMatchedMessage"></span>
                            </small>
                        </div>
                    </div>

                    <div class="row ">

                        <div class="col-md-offset-1 col-md-2">
                            <input
                                    type="submit"
                                    onclick="submitted()"
                                    value="<spring:message code="lbl.resetPassword"/>"
                                    class="btn btn-primary btn-block btn-center" />
                        </div>
                        <div class="col-md-2" style="margin-left: -20px; padding: 0px">
                            <a href="${cancelUrl}" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Cancel</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>

<script type="text/javascript">

    jQuery(document).ready(function() {
        Metronic.init(); // init metronic core components
        Layout.init(); // init current layout
        //TableAdvanced.init();
    });

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

        console.log("first chance");
        let url = "/opensrp-dashboard/rest/api/v1/user/change-password";
        let token = $("meta[name='_csrf']").attr("content");
        let header = $("meta[name='_csrf_header']").attr("content");
        console.log("last chance <%=username%>");
        let formData = {
            'username': "<%=username%>",
            'password': $('input[name=password]').val()
        };

        let redirectUrl = "/opensrp-dashboard/user.html";
        let role = "<%=role%>";
        let fromRole = "<%=fromRole%>";
        let skId = "<%=skId%>";
        let skUsername = "<%=skUsername%>";

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
                $("#loading").show();
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
        let password = document.getElementById("password").value;
        let confirmPassword = document.getElementById("retypePassword").value;
        if (password != confirmPassword) {
            $("#passwordNotMatchedMessage").html("Your password doesn't match. Please enter same.");
            return false;
        }

        $("#passwordNotMatchedMessage").html("");
        return true;
    }

</script>

