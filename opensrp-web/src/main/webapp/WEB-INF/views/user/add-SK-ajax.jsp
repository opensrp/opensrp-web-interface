<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>

<!DOCTYPE html>
<html lang="en">

<%
    Integer amId = (Integer) session.getAttribute("amId");
    Role sk = (Role) session.getAttribute("sk");
%>

<%-- <head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link type="text/css" href="<c:url value="/resources/css/magicsuggest-min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title><spring:message code="lbl.addUserTitle"/></title>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head> --%>

<c:url var="cancelUrl" value="/user/sk-list.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<%-- <jsp:include page="/WEB-INF/views/navbar.jsp" />
 --%>
<div class="content-wrapper">
    <div class="container-fluid">
        <div class="card mb-3">
            <div class="card-header" id="data">
                Add new SK
            </div>
            <div class="card-body">

                <span class="text-red" id="usernameUniqueErrorMessage"></span>

                <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                    <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>"></div>

            </div>
            <form:form 	modelAttribute="account" id="AddSk" class="form-inline" autocomplete="off">

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="firstName"> <spring:message code="lbl.firstName"/> </label>
                        <form:input path="firstName" class="form-control mx-sm-3"
                                    required="required" />
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <label class="label-width" for="lastName"> <spring:message code="lbl.lastName"/> </label>
                        <form:input path="lastName" class="form-control mx-sm-3"
                                    />
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <label class="label-width" for="email"> <spring:message code="lbl.email"/> </label>
                        <input type="email" class="form-control mx-sm-3" name="email">
                    </div>
                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group">
                        <label class="label-width" for="mobile"><spring:message code="lbl.mobile"/></label>
                        <form:input path="mobile" class="form-control mx-sm-3" />
                    </div>
                </div>

                <div class="row col-12 tag-height" id="_enableSimprint">
						<div class="form-group">
							<label class="label-width" for="inputPassword6"><spring:message code="lbl.enableSimprint"/></label>
							<form:checkbox class="checkBoxClass form-check-input"
										   path="enableSimPrint" />
						</div>
				</div>

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="username"><spring:message code="lbl.username"/></label>
                        <form:input path="username" class="form-control mx-sm-3"
                                    required="required" />
                        <small id="usernameHelpInline" class="text-muted text-para">
                            <spring:message code="lbl.userMessage"/>
                        </small>
                    </div>
                </div>

                <%-- <form:hidden path="parentUser" id="parentUser"/> --%>

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="password"><spring:message code="lbl.password"/></label>
                        <input type="text" class="form-control mx-sm-3" id="password" name="password"  required />
                        <small id="passwordHelpInline" class="text-muted text-para">
                        </small>
                        <input type="checkbox" checked onclick="toggleVisibilityOfPassword()">Show Password
                    </div>
                </div>
                <input type="hidden" name="skRole" value="<%=sk.getId()%>">
                <input type="hidden" name="amId" value="<%=amId%>">

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="retypePassword"><spring:message code="lbl.confirmedPassword"/></label>
                        <input type="text" class="form-control mx-sm-3" id="retypePassword" name="retypePassword"  required />

                        <small id="confirmPasswordHelpInline" class="text-muted text-para">
                            <span class="text-red" id="passwordNotmatchedMessage"></span> 
                            <spring:message code="lbl.retypePasswordMessage"/>
                        </small>
                    </div>

                </div>

                <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width"  for="branches">
                            <spring:message code="lbl.branches"/>
                        </label>
                        <select id="branches"
                                class="form-control mx-sm-3"
                                name="branches" required>
                            <c:forEach items="${branches}" var="branch">
                                <option value="${branch.id}">${branch.name} (${branch.code})</option>
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
                                onclick="return Validate()"
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
<script src="<c:url value='/resources/js/user.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>


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

    function getBranches() {
        var branches = $('#branches').val();
        var selectedBranches = "";
        branches.forEach(function(branch){
            selectedBranches += parseInt(branch) + ",";
        });
        if (selectedBranches.length > 0) selectedBranches = selectedBranches.slice(0, -1);
        return selectedBranches;
    }

   <%--  $("#UserInfo").submit(function(event) {
        $("#loading").show();
        var url = "/opensrp-dashboard/rest/api/v1/user/save";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var formData;
        var enableSimPrint = false;
        if ($('#enableSimPrint1').is(":checked"))
        {
        	enableSimPrint = true;
        }
        var skRole = <%=sk.getId()%>;
        var amId = <%=amId%>;
        formData = {
            'firstName': $('input[name=firstName]').val(),
            'lastName': $('input[name=lastName]').val(),
            'email': $('input[name=email]').val(),
            'mobile': $('input[name=mobile]').val(),
            'username': $('input[name=username]').val(),
            'password': $('input[name=password]').val(),
            'parentUser': amId,
            'ssNo': "",
            'roles': skRole,
            'team': "",
            'teamMember': false,
            'branches': getBranches(),
            'enableSimPrint': enableSimPrint
        };

        event.preventDefault();

        console.log(formData);

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
            	if(data!=""){
           		 $("#usernameUniqueErrorMessage").html("This SK already exists");
           	}
                $("#loading").hide();
                if(data == ""){
                    window.location.replace("/opensrp-dashboard/user/sk-list.html");
                }

            },
            error : function(e) {

            },
            done : function(e) {
                console.log("DONE");
            }
        });
    });
  --%>
    function Validate() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("retypePassword").value;
        if (password != confirmPassword) {        	
            $("#usernameUniqueErrorMessage").html("Your password is not similar with confirm password. Please enter same password in both");
			return false;
        }else{

        $("#passwordNotMatchedMessage").html("");
        return true;
        }
    }

</script>

<script>
    $(document).ready(function() {
        $('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
    });
</script>
</body>
</html>
