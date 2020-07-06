<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<!DOCTYPE html>
<!-- 
Template Name: Metronic - Responsive Admin Dashboard Template build with Twitter Bootstrap 3.3.2
Version: 3.3.0
Author: KeenThemes
Website: http://www.keenthemes.com/
Contact: support@keenthemes.com
Follow: www.twitter.com/keenthemes
Like: www.facebook.com/keenthemes
Purchase: http://themeforest.net/item/metronic-responsive-admin-dashboard-template/4021469?ref=keenthemes
License: You must have a valid license purchased only from themeforest(the above link) in order to legally use the theme for your project.
-->
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
<!--<![endif]-->
<!-- BEGIN HEAD -->
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate var="year" value="${now}" pattern="yyyy" />

<head>
<meta charset="utf-8"/>
<title>Chattogram Hill Tracts (CHT) </title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<meta http-equiv="Content-type" content="text/html; charset=utf-8">
<meta content="" name="description"/>
<meta content="" name="author"/>

<jsp:include page="/WEB-INF/views/css.jsp" />
<link rel="shortcut icon" href="favicon.ico"/>
</head>
<c:url var="saveUrl" value="/user/add" />
<c:url var="loginUrl" value="/login" />

<body class="login">
<!-- BEGIN SIDEBAR TOGGLER BUTTON -->
<div class="menu-toggler sidebar-toggler">
</div>
<!-- END SIDEBAR TOGGLER BUTTON -->
<!-- BEGIN LOGO -->
<%-- <div class="logo">
	<a href="index.html">
	<img src="<c:url value="/resources/assets/img/admin-login.png"/>" alt="Telehealth and Telemedicine"/>
	</a>
	
</div> --%>

<div class="content">
	<!-- BEGIN LOGIN FORM -->
		<c:if test="${param.error != null}">
			<div class="alert alert-danger">
				<p>Invalid username or password.</p>
			</div>
		</c:if>
		<c:if test="${param.logout != null}">
			<div class="alert alert-success">
				<p>You have been logged out successfully.</p>
			</div>
		</c:if>
	<form action="${loginUrl}" method="post">
		<h3 class="form-title">Sign In</h3>
		<div class="alert alert-danger display-hide">
			<button class="close" data-close="alert"></button>
			<span>
			Enter any username and password. </span>
			
			
		</div>
		<div class="form-group">
			<!--ie8, ie9 does not support html5 placeholder, so we just show field title for that-->
			<label class="control-label visible-ie8 visible-ie9">Username</label>
			<input id="username" name="username" class="form-control" type="text" autocomplete="off" placeholder="Username"/>
		</div>
		<div class="form-group">
			<label class="control-label visible-ie8 visible-ie9">Password</label>
			<input id="password" name="password" class="form-control" type="password" autocomplete="off" placeholder="Password"/>
		</div>
		<input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}" />
		
		<div class="form-group">
           	<div class="row">
            	<div class="col-sm-12 text-right">		          
		          <button class="btn btn-success btn-lg" id="submit-form" name="signup" value="2" type="submit">Login</button>
		        </div>
            </div>
		</div>
		<!-- <div class="create-account">
			<p>
				<a href="javascript:;" id="register-btn" class="uppercase">   </a>
			</p>
		</div>  -->
	</form>
	<!-- END LOGIN FORM -->
	<!-- BEGIN FORGOT PASSWORD FORM -->
	<%-- <form class="forget-form" action="index.html" method="post">
		<h3>Forget Password ?</h3>
		<p>
			 Enter your e-mail address below to reset your password.
		</p>
		<div class="form-group">
			<input class="form-control placeholder-no-fix" type="text" autocomplete="off" placeholder="Email" name="email"/>
		</div>
		
		<div class="form-actions">
			<button type="button" id="back-btn" class="btn btn-default">Back</button>
			<button type="submit" class="btn btn-success uppercase pull-right">Submit</button>
		</div>
	</form> --%>
	<!-- END FORGOT PASSWORD FORM -->
	<!-- BEGIN REGISTRATION FORM -->
	<!-- END REGISTRATION FORM -->
</div>




<div class="copyright">
	 Copyright © ${year } mPower Social Enterprises Ltd.. All Rights Reserved
</div>
<%-- <jsp:include page="/WEB-INF/views/js.jsp" />
 --%>
<script>
jQuery(document).ready(function() {     
//Metronic.init(); // init metronic core components
//Layout.init(); // init current layout
//Login.init();
//Demo.init();
});
</script>
<!-- END JAVASCRIPTS -->
</body>
<!-- END BODY -->
</html>

