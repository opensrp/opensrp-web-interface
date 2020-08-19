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
   
</head>

<c:url var="saveUrl" value="/user/${id}/edit-SS.html" />
<c:url var="cancelUrl" value="/user/${skId}/${skUsername}/my-ss.html?lang=en" />

<%
    String selectedParentUser = (String)session.getAttribute("parentUserName");
%>

<body>



       
        <div class="card mb-3">
            <div class="card-header">
                <h3>Edit ${account.fullName}'s Information</h3>
            </div>
            <div class="card-body">
                <form:form modelAttribute="account" id="update-ss-information">
					<div class="form-group row" >
                    
                        <div class="col-sm-6">
                            <label class="control-label" for="firstName"> <spring:message code="lbl.firstName"/> <span class="required">* </span> </label>
                            <form:input path="firstName" class="form-control mx-sm-3"
                                        required="required"/>
                        </div>
                        <div class="col-sm-6">
                            <label class="control-label" for="lastName"><spring:message code="lbl.lastName"/> </label>
                            <form:input path="lastName" class="form-control mx-sm-3"/>
                        </div>
                    
                    </div>
                    
                    <div class="form-group row" >
                    	<div class="col-sm-6">
                            <label class="control-label" for="mobile"><spring:message code="lbl.mobile"/></label>
                            <form:input path="mobile" class="form-control mx-sm-3" />
                        </div>
                    
                        <div class="col-sm-6">
                            <label class="control-label" for="username"><spring:message code="lbl.username"/><span class="required">* </span></label>
                            <form:input path="username" class="form-control mx-sm-3"
                                        readonly="true"	required="required"/>

                        </div>
                   
					</div>
                    <form:input path="id" name = "id" style="display: none;"/>


                    <div class="form-group text-right row" style="margin-top: 50px">
                        <input type="submit" id="updateContinue" name="updateContinue" value="Update & Continue To Edit Catchment Area"
                               class="btn btn-primary col-md-offset-6 col-md-3 col-xs-12" style="margin-bottom: 5px; padding: 7px" />


                        <input type="submit" id="update" name="update"  value="Update"
								  class="btn btn-primary col-md-1 col-xs-12 " style=" margin-left: 5px;margin-bottom: 5px" />

                        <a href="#"  rel="modal:close" class="btn btn-primary col-md-1 col-xs-12 " style="margin-left: 5px; margin-bottom: 5px">Close</a>


                    </div>
                </form:form>

            </div>
            <div class="card-footer small text-muted"></div>
        </div>
   
</body>

<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script src="<c:url value='/resources/js/user-ss.js'/>"></script>
</html>
