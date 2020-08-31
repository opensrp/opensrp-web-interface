<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>
<title><spring:message code="lbl.addUserTitle"/></title>



<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="cancelUrl" value="/user/sk-list.html" />
<style>
.page-content-wrapper .page-content {
    margin-left: 0px; 
    margin-top: 0px;
    /* min-height: 600px; */
    padding: 0 /* 10px */ 0 0 20px;
}
</style>
<%
    Integer amId = (Integer) session.getAttribute("amId");
    Role sk = (Role) session.getAttribute("sk");
%>
<div class="page-content-wrapper">
    <div class="page-content">
        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-add"></i>Add new SK
                        </div>


                    </div>
                    <span class="text-red" id="usernameUniqueErrorMessage"></span>
                    <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                        <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                    </div>
                    <div class="portlet-body">
                        <form:form 	modelAttribute="account"  id="AddSk" autocomplete="off">
                            <div class="form-group row">
                                <div class="col-sm-6">
                                   <label class="control-label" for="firstName"> <spring:message code="lbl.firstName"/>  <span class="required">* </span></label>
                        			<form:input path="firstName" class="form-control mx-sm-3" required="required" />
                                </div>

                                <div class="col-sm-6"> 
                                    <label class="control-label" for="lastName"> <spring:message code="lbl.lastName"/></label>
                                     <form:input path="lastName" class="form-control mx-sm-3"/>
                                    
                                </div>
                            </div>
							<input type="hidden" name="skRole" value="<%=sk.getId()%>">
                			<input type="hidden" name="amId" value="<%=amId%>">
                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class="control-label" for="email"> <spring:message code="lbl.email"/> </label>
                                    <input id="email" class="form-control mx-sm-3" name="email" type="email"/>
                                </div>

                                <div class="col-sm-6">
                                    <label class="control-label" for="mobile"> <spring:message code="lbl.mobile"/>	</label>
                                    <input id="mobile" name="mobile" class="form-control mx-sm-3" />
                                </div>
                            </div>

                            

                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class="control-label" for="nId"> <spring:message code="lbl.username"/> <span class="required">* </span>	</label>
                                    <input autocomplete="none" id="username" name="username" class="form-control mx-sm-3" required="required"/>
			                        <small id="usernameHelpInline" class="text-muted text-para">
			                            <spring:message code="lbl.userMessage"/>
			                        </small>
                                </div>

                                <div class="col-sm-6">
                                    <label class="control-label"><spring:message code="lbl.password"/> <span class="required">* </span>
                                       
                                    </label>
                                    <input  type="text" class="form-control mx-sm-3" id="password" name="password"  required />
			                        <small id="passwordHelpInline" class="text-muted text-para">
			                                <%-- <spring:message code="lbl.passwordMEssage"/> --%>
			                        </small>
			                        <input type="checkbox" checked onclick="toggleVisibilityOfPassword()">Show Password
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class="label-width"> <spring:message code="lbl.confirmedPassword"/><span class="required">* </span>	</label>
                                    <input type="text" id="retypePassword" name="retypePassword" class="form-control mx-sm-3" required="required" />
			                        <small id="confirmPasswordHelpInline" class="text-muted text-para">
			                            <span class="text-red" id="passwordNotmatchedMessage"></span>
			                            <spring:message code="lbl.retypePasswordMessage"/>
			                        </small>
			                        
			                        
                                </div>

                                <div class="col-sm-6">
                                    <label class="control-label" for="username"> <spring:message code="lbl.branches"/> <span class="required">* </span>	</label>
                                    <select id="branches"
		                                class="form-control mx-sm-3"
		                                name="branches" required>
			                            <c:forEach items="${branches}" var="branch">
			                                <option value="${branch.id}">${branch.name} (${branch.code})</option>
			                            </c:forEach>
		                        	</select>
                                </div>
                            </div>
                            <div class="form-group row" id="_enableSimprint">
			                     <div class="col-sm-6">
			                        <label class="control-label" for="enableSimPrint"><spring:message code="lbl.enableSimprint"/></label>
                                     <form:checkbox class="checkBoxClass form-check-input"
                                                    path="enableSimPrint" />
			                   </div>
			                </div>

                            <hr class="dotted">
                            <div class="form-group text-right">
                                <button type="submit" id="submit-form"  class="btn btn-primary" name="signup" value="Validate">Submit</button>
                                <a class="btn btn-info" href="${cancelUrl}">Cancel</a>
                            </div>
                            <div id="errorMessage" style="display:none">
                                <div class="alert-message warning">
                                    <div id="errormessageContent" class="alert alert-danger" role="alert"> </div>
                                </div>
                            </div>
                       </form:form>




                    </div>
                </div>





            </div>
        </div>
        <!-- END PAGE CONTENT-->
    </div>
</div>
<!-- END CONTENT -->
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

