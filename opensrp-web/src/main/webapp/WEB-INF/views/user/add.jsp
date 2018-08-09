<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>

<%@page import="java.util.List"%>
<%@page import="org.opensrp.acl.entity.Role"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Add user information</title>

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/add.html" />






<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
					   <a  href="<c:url value="/user.html"/>"> <strong> Manage User</strong> 
						</a>  |   <a  href="<c:url value="/role.html"/>"> <strong>Manage Role</strong>
						</a>			
			</div>
			<div class="card mb-3">
				<div class="card-header" id="data">
					<i class="fa fa-table"></i> Add User
				</div>
				<div class="card-body">
					<div id="usernameErrorMessage"></div>
					<div id="passwordNotmatchedMessage"></div>
					<div id="roleSelectmessage"></div>
					<form:form 	modelAttribute="account" id="UserInfo" class="form-inline">	
										
						<div class="row col-12 tag-height">						 
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"> First name </label>										 
								<form:input path="firstName" class="form-control mx-sm-3"
								required="required" placeholder="Enter first name" />																	
									
							</div>
							
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"> Last name </label>										 
								<form:input path="lastName" class="form-control mx-sm-3"
											required="required" placeholder="Enter last name" />								
							 </div>
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width"  for="inputPassword6"> Email </label>
								<input type="email" class="form-control mx-sm-3" name="email" placeholder="Enter your email" required="required">										 
															
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6">Mobile Number</label>										 
								<form:input path="mobile" class="form-control mx-sm-3"
											placeholder="Enter mobile number" />								
							 </div>
						 </div>	
						
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6">Identifier</label>										 
								<form:input path="idetifier" class="form-control mx-sm-3"
											placeholder="Enter identifier" />
								
							 </div>
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6">Username</label>										 
								<form:input path="username" class="form-control mx-sm-3"
										required="required" placeholder="Enter user name" />
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		User can log in with  Username.
	                        	</small>
							 </div>
						 </div>				
							
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6">Password</label>										 
								<input type="password"  class="form-control mx-sm-3" id="password" name="password" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required />
								<small id="passwordHelpInline" placeholder="Enter password" class="text-muted text-para">
	                          		 Password should be 8 characters long and should have both upper and lower case characters ,
	                          		 at least one digit , at least one non digit.
	                        	</small>
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width"  for="inputPassword6">Confirm password</label>										 
								<form:password path="retypePassword"
										placeholder="Confirm password" class="form-control mx-sm-3"
										required="required" />
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		 Retype the password (for accuracy).
	                        	</small>
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group required">
							<label class="label-width"  for="inputPassword6">Role</label>
									<%
										List<Role> roles = (List<Role>) session.getAttribute("roles");
											int[] selectedRoles = (int[]) session
													.getAttribute("selectedRoles");
											for (Role role : roles) {
									%>
									
										<form:checkbox 
											path="roles" class="chk" value="<%=role.getId()%>"
											checked="<%=CheckboxHelperUtil.checkCheckedBox(selectedRoles,
							role.getId())%>" />
										<label class="form-control mx-sm-3" for="defaultCheck1"> <%=role.getName()%>
										</label>
									
									<%
										}
									%>
								
							</div>
						</div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group">
									<input type="submit" onclick="return Validate()"  value="Save" 	class="btn btn-primary btn-block btn-center" />
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
	
	<script type="text/javascript">
	$("#UserInfo").submit(function(event) { 
			var url = "/opensrp-dashboard/rest/api/v1/user/save";			
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			var formData = {
		            'firstName': $('input[name=firstName]').val(),
		            'lastName': $('input[name=lastName]').val(),
		            'email': $('input[name=email]').val(),
		            'mobile': $('input[name=mobile]').val(),
		            'idetifier': $('input[name=idetifier]').val(),
		            'username': $('input[name=username]').val(),
		            'password': $('input[name=password]').val(),
		            'roles': getCheckboxValueUsingClass()
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
					$("#loading").hide();
				   $("#data").html(data);
				},
				error : function(e) {
				    console.log("ERROR: ", e);
				   
				},
				done : function(e) {				    
				    console.log("DONE");				    
				}
			});
		});		
		 
	
	function getCheckboxValueUsingClass(){
		/* declare an checkbox array */
		var chkArray = [];
		
		/* look for all checkboes that have a class 'chk' attached to it and check if it was checked */
		$(".chk:checked").each(function() {
			chkArray.push($(this).val());
		});
		
		/* we join the array separated by the comma */
		var selected;
		selected = chkArray.join(',') ;		
		if(selected.length > 0){			
		}else{			
			$("#roleSelectmessage").html("Please at least one role");
			return false;
		}
		$("#roleSelectmessage").html("e");
		return selected;
	}
	
	 function Validate() {
         var password = document.getElementById("password").value;
         var confirmPassword = document.getElementById("retypePassword").value;
         if (password != confirmPassword) {
        	 $("#passwordNotmatchedMessage").html("Your password is not similar with confirm password. Please enter same password in both");
        	
        	 return false;
         }
         $("#passwordNotmatchedMessage").html("");
     	
         return true;
     }
	
		</script>
</body>
</html>