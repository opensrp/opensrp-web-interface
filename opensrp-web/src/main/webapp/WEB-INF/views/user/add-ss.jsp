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
    Role ss = (Role) session.getAttribute("ss");
    Integer skId = (Integer)session.getAttribute("skId");
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
    <title><spring:message code="lbl.addUserTitle"/></title>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/add.html" />
<c:url var="cancelUrl" value="/user/${skId}/${skUsername}/my-ss.html?lang=en" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid">
        
        <div class="card mb-3">
            <div class="card-header" id="data">
                <i class="fa fa-table"></i> Add New SS
            </div>
            <div class="card-body">

                <span class="text-red" id="usernameUniqueErrorMessage"></span>

                <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                    <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>"></div>

            </div>
            <form:form 	modelAttribute="account" id="UserInfo" class="form-inline" autocomplete="off">

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
                        <form:input path="lastName" class="form-control mx-sm-3"/>
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

                
                
                 <div class="row col-12 tag-height">
                    <div class="form-group required">
                        <label class="label-width" for="username">SK Username</label>
                        <form:input path="username" class="form-control mx-sm-3"
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

                <form:hidden path="parentUser" id="parentUser"/>
                <div class="row col-12 tag-height" hidden>
                    <div class="form-group required">
                        <label class="label-width"  for="branches">
                            <spring:message code="lbl.branches"/>
                        </label>
                        <select id="branches"
                                class="form-control mx-sm-3 js-example-basic-multiple"
                                name="branches" multiple="multiple" required>
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
	                    	<a href="${cancelUrl}" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Cancel</a>
	                    </div>
                </div>
            </form:form>
        </div>

    </div>
</div>
<!-- /.container-fluid-->
<!-- /.content-wrapper-->

<jsp:include page="/WEB-INF/views/footer.jsp" />
<%-- <script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script> --%>

<!-- Bootstrap core JavaScript-->
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.min.js'/>"></script>

<!-- Core plugin JavaScript-->
<%-- <script src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>
 --%>

<!-- Custom scripts for all pages-->
<%-- <script src="<c:url value='/resources/js/sb-admin.min.js'/>"></script>
 --%><!-- Custom scripts for this page-->
<%-- <script src="<c:url value='/resources/js/sb-admin-datatables.min.js'/>"></script> --%>
<script src="<c:url value='/resources/js/location.js'/>"></script>
<script src="<c:url value='/resources/js/checkbox.js'/>"></script>
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

    $("#UserInfo").submit(function(event) {
        $("#loading").show();
        var url = "/opensrp-dashboard/rest/api/v1/user/save";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var formData;
        var enableSimPrint = false;
        var skId = <%=skId%>; 
       
        var ssRole = <%=ss.getId()%>; 
        var username = $('input[name=username]').val();
        formData = {
            'firstName': $('input[name=firstName]').val(),
            'lastName': $('input[name=lastName]').val(),
            'email': $('input[name=email]').val(),
            'mobile': $('input[name=mobile]').val(),
            'username': username,
            'password': "###",
            'parentUser': skId,
            'ssNo': $('#ssNo').val(),
            'roles': ssRole,
            'team': "",
            'teamMember': false,
            'branches': getBranches(),
            'enableSimPrint': enableSimPrint
        };
       event.preventDefault();
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
            		 $("#usernameUniqueErrorMessage").html("This SS already exists");
            	}
               
                $("#loading").hide();
                if(data == ""){
                    window.location.replace("/opensrp-dashboard/user/"+skId+"/"+username+"/my-ss.html?lang=en");
                }

            },
            error : function(e) {

            },
            done : function(e) {
                console.log("DONE");
            }
        });
    });

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
