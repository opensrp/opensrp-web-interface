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

<jsp:include page="/WEB-INF/views/header.jsp" />

<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="saveUrl" value="/user/add.html" />
<c:url var="saveRestUrl" value="/rest/api/v1/user/add" />
<c:url var="cancelUrl" value="/user.html" />
<c:url var="userList" value="/user.html" />

<%
    Map<Integer, String> teams =  (Map<Integer, String>)session.getAttribute("teams");
    Integer selectedTeamId = (Integer)session.getAttribute("selectedTeamId");
    Role ss = (Role) session.getAttribute("ss");
%>
<div class="page-content-wrapper">
    <div class="page-content">


        <ul class="page-breadcrumb breadcrumb">
            <li>
                <a href="<c:url value="/user.html"/>">Home</a>
                <i class="fa fa-circle"></i>
            </li>
            <li>
                <a href="<c:url value="/user.html"/>">User list</a>
                <i class="fa fa-circle"></i>
            </li>

        </ul>
        <!-- END PAGE BREADCRUMB -->
        <!-- END PAGE HEADER-->
        <!-- BEGIN PAGE CONTENT-->


        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-edit"></i>Add new user
                        </div>


                    </div>
                    <span class="text-red" id="usernameUniqueErrorMessage"></span>
                    <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                        <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                    </div>
                    <div class="portlet-body">
                        <form id="UserInfo"  autocomplete="off">
                            <div class="form-group row">
                                <div class="col-sm-6">
                                   <label class="control-label" for="firstName"> <spring:message code="lbl.firstName"/>  <span class="required">* </span></label>
                        			<input id="firstName" name="firstName" class="form-control mx-sm-3"
                                    required="required" />
                                </div>

                                <div class="col-sm-6">
                                	 
                                    <label class="control-label" for="lastName"> <spring:message code="lbl.lastName"/></label>
                                     <input id="lastName" name="lastName" class="form-control mx-sm-3"/>
                                    
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class="control-label" for="email"> <spring:message code="lbl.email"/> </label>
                                    <input id="email" class="form-control mx-sm-3" name="email" type="email"/>
                                </div>

                                <div class="col-sm-6">
                                    <label class="control-label" for="email"> <spring:message code="lbl.mobile"/>	</label>
                                    <input id="mobile" name="mobile" class="form-control mx-sm-3" />
                                </div>
                            </div>

                            <div class="form-group row">
                               <div class="col-sm-6">
                                    <label class="control-label" for="birthDate"> <spring:message code="lbl.role"/> <span class="required">* </span>	</label>
                                     <select onchange="isSS()"
			                                id="role"
			                                class="form-control mx-sm-3 js-example-basic-multiple"
			                                name="role" required>
			                            <c:forEach items="${roles}" var="role">
			                                <option value="${role.id}">${role.name}</option>
			                            </c:forEach>
			                        </select>
                                </div>

                                <div class="col-sm-6">
                                    <label class="control-label" for="username"> <spring:message code="lbl.branches"/> <span class="required">* </span>	</label>
                                    <select id="branches"
			                                class="form-control mx-sm-3 js-example-basic-multiple"
			                                name="branches" multiple="multiple" required>
			                            <c:forEach items="${branches}" var="branch">
			                                <option value="${branch.id}">${branch.name} (${branch.code})</option>
			                            </c:forEach>
			                        </select>
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

                                
                            </div>
                            <div class="row col-12 tag-height" id="ssOption" style="display: none;">
			                    <div class="form-group required">
			                        <label class="label-width" for="ssNo"><spring:message code="lbl.ssNo"/></label>
			                        <select id="ssNo"
			                                class="form-control mx-sm-3 js-example-basic-multiple"
			                                name="ssNo">
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
			                <div class="row col-12 tag-height" id="_enableSimprint">
			                    <div class="form-group">
			                        <label class="label-width" for="enableSimPrint"><spring:message code="lbl.enableSimprint"/></label>
			                        <input type="checkbox" id="enableSimPrint" name="enableSimPrint"  class="checkBoxClass form-check-input"/>
			                    </div>
			                </div>
			              
						
                            
                            

                            <div class="form-group error"  style="display:none; color:red;">

                            </div>

                            <hr class="dotted">
                            <div class="form-group">
                                <button type="submit" id="submit-form"  class="btn btn-primary" name="signup" value="Validate">Submit</button>
                                <a class="btn btn-info" href="${cancelUrl}">Cancel</a>
                            </div>
                            <div id="errorMessage" style="display:none">
                                <div class="alert-message warning">
                                    <div id="errormessageContent" class="alert alert-danger" role="alert"> </div>
                                </div>
                            </div>
                        </form>




                    </div>
                </div>





            </div>
        </div>
        <!-- END PAGE CONTENT-->
    </div>
</div>
<!-- END CONTENT -->
</div>
<script>
    jQuery(document).ready(function() {
        Metronic.init(); // init metronic core components
        Layout.init(); // init current layout
        //TableAdvanced.init();
    });
</script>
<script src="<c:url value='/resources/js/location.js'/>"></script>
<script src="<c:url value='/resources/js/checkbox.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<jsp:include page="/WEB-INF/views/footer.jsp" />




<script type="text/javascript">
    $('#_enableSimprint').hide();
    function isSS() {
        var selectedRoleId = $('#role').val();
        var selectedRoleName = $('#role option:selected').text();
        var ssId = <%=ss.getId()%>;
        if(selectedRoleName == "SK"){
            $('#_enableSimprint').show();
        }else{
            $('input[type="checkbox"][name="enableSimPrint"]').prop("checked", false).change();
            $('#_enableSimprint').hide();
        }
        if (selectedRoleName != "SS") {
            $('#ssNo').val("");
            $('#ssNo').trigger('change');
            $('#ssOption').hide();
            $("#ssNo").prop('required',false);
        } else {
            $('#ssOption').show();
            $("#ssNo").prop('required',true);
        }


    }

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
        let branches = $('#branches').val();
        let selectedBranches = "";
        if ($('#role').val() == 29 || $('#role').val() == 28) return branches;
        branches.forEach(function(branch){
            selectedBranches += parseInt(branch) + ",";
        });
        if (selectedBranches.length > 0) selectedBranches = selectedBranches.slice(0, -1);
        return selectedBranches;
    }

    $('#UserInfo').submit(function(event) {
    	
        event.preventDefault();
        let validation = Validate();
        if (validation == false) return false;
        let url = "/opensrp-dashboard/rest/api/v1/user/add";
        let token = $("meta[name='_csrf']").attr("content");
        let header = $("meta[name='_csrf_header']").attr("content");
        let formData;
        let enableSimPrint = false;
        if ($('#enableSimPrint').is(":checked")) {
            enableSimPrint = true;
        }
       
        formData = {
            'firstName': $('input[name=firstName]').val(),
            'lastName': $('input[name=lastName]').val(),
            'email': $('input[name=email]').val(),
            'mobile': $('input[name=mobile]').val(),
            'username': $('input[name=username]').val(),
            'password': $('input[name=password]').val(),
            'ssNo': $('#ssNo').val(),
            'roles': $('#role').val(),
            'teamMember': false,
            'branches': getBranches(),
            'enableSimPrint': enableSimPrint,
            'parentUserId': $('#parent-user').val()
        };
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
                $("#loading").show();
            },
            success : function(data) {
                $("#usernameUniqueErrorMessage").html(data);
                $("#loading").hide();
                if(data == ""){
                    window.location.replace("/opensrp-dashboard/user.html");
                }
            },
            error : function(e) {
                console.log(e);
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
        forRoleSelection();
    });

    $('#role').change(function (event) {
        forRoleSelection();
    });

    function forRoleSelection() {
        let roleId = $('#role').val();
        if (roleId == 29 || roleId == 28) {
            $('#branches').removeAttr("multiple");
            $("#branches option:selected").prop("selected", false);
            $('#branches').trigger('change');
        } else {
            $('#branches').attr('multiple', 'multiple');
            $("#branches option:selected").prop("selected", false);
            $('#branches').trigger('change');
        }
        if (roleId == 29) { //role for ss
            $('#parentUserForSS').show();
            $('#parentUserForSS').prop('required', true);

            $('#username-div').hide();
            $('#password-div').hide();
            $('#retypePassword-div').hide();

            $('#username').val('');
            $('#password').val('');
            $('#retypePassword').val('');

            $('#username').prop('required', false);
            $('#password').prop('required', false);
            $('#retypePassword').prop('required', false);

            $('#ssNo').prop('required', true);
        } else {
            $('#ssNo').val('').trigger('change');
            $('#parentUserForSS').hide();
            $('#parent-user').html("");
            $('#parentUserForSS').prop('required', false);

            $('#username-div').show();
            $('#password-div').show();
            $('#retypePassword-div').show();

            $('#username').val('');
            $('#password').val('');
            $('#retypePassword').val('');

            $('#username').prop('required', true);
            $('#password').prop('required', true);
            $('#retypePassword').prop('required', true);
            $('#ssNo').prop('required', false);
        }
    }
</script>

