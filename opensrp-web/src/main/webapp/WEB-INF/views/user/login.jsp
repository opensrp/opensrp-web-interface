<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Login</title>


<jsp:include page="/WEB-INF/views/css.jsp"/>

<c:url var="saveUrl" value="/user/add" />
<c:url var="loginUrl" value="/login" />
</head>


<body class="bg-login">

   <div class="col-12" style="text-align:center">
	   <img   alt="" src="<c:url value="/resources/img/logo.png"/>">
	</div>


  <div class="container">
    <div class="card card-login mx-auto mt-5">
      <div class="card-header">Login</div>
      <div class="card-body">
        <form action="${loginUrl}" method="post">
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <p>Invalid username and password.</p>
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-success">
               <p>You have been logged out successfully.</p>
            </div>
        </c:if>
          <div class="form-group">
            <label>User Name</label>
            <input class="form-control" id="username" name="username" placeholder="UserName">
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" class="form-control"id="password" name="password" placeholder="Password" >
          </div>
          <!--<div class="form-group">
            <div class="form-check">
              <label class="form-check-label">
                <input class="form-check-input" type="checkbox"> Remember Password</label>
            </div>
          </div> -->
          
          <input type="hidden" name="${_csrf.parameterName}"  value="${_csrf.token}" />
          <input type="submit" class="btn btn-primary btn-block" onclick="concatPasswordWithUsername()"  value="Log in">
          
        </form>
        
      </div>
      
    </div>
  </div>

	<div class="col-12" style="text-align:center; margin-top:20px;">
	   <img   alt="" src="<c:url value="/resources/img/opensrp-footer.png"/>">
	</div>

 <script src="<c:url value='/resources/vendor/jquery/jquery.min.js' />"></script>
 <script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js' />"></script>
 <script src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js' />"></script>
 <script type="text/javascript"> 
 function concatPasswordWithUsername(){
	 var password = $("#password").val();
	 var username = $("#username").val();
	 var usernameAndPassword = username + "$#$" + password;
	 $("#username").val(usernameAndPassword);
	 console.log(usernameAndPassword);
 }
 </script>
 
 </body>
</html>