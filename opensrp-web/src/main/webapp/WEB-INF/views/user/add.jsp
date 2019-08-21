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
	Integer selectedPersonId = (Integer)session.getAttribute("selectedPersonId");
	String locationList = (String)session.getAttribute("locationList");
	String selectedLocationList = (String)session.getAttribute("selectedLocationList");

	Map<Integer, String> teams =  (Map<Integer, String>)session.getAttribute("teams");

	String selectedPersonName = (String)session.getAttribute("personName");

	Integer selectedTeamId = (Integer)session.getAttribute("selectedTeamId");

	int roleIdCHCP= -1;
	int roleIdProvider= -1;


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

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
	<div class="container-fluid">
		<div class="form-group">
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
		</div>
		<div class="card mb-3">
			<div class="card-header" id="data">
				<i class="fa fa-table"></i> <spring:message code="lbl.addUser"/>
			</div>
			<div class="card-body">

				<span class="text-red" id="usernameUniqueErrorMessage"></span>

				<div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
					<img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>"></div>

			</div>
			<form:form 	modelAttribute="account" id="UserInfo" class="form-inline">

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width" for="inputPassword6"> <spring:message code="lbl.firstName"/> </label>
						<form:input path="firstName" class="form-control mx-sm-3"
									required="required" />
					</div>
				</div>

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width" for="inputPassword6"> <spring:message code="lbl.lastName"/> </label>
						<form:input path="lastName" class="form-control mx-sm-3"
									required="required"/>
					</div>
				</div>

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width"  for="inputPassword6"> <spring:message code="lbl.email"/> </label>
						<input type="email" class="form-control mx-sm-3" name="email" required="required">

					</div>
				</div>

				<div class="row col-12 tag-height">
					<div class="form-group">
						<label class="label-width" for="inputPassword6"><spring:message code="lbl.mobile"/></label>
						<form:input path="mobile" class="form-control mx-sm-3" />
					</div>
				</div>
				<div class="row col-12 tag-height">
					<div class="form-group">
						<label class="label-width" for="inputPassword6"><spring:message code="lbl.identifier"/></label>
						<form:input path="idetifier" class="form-control mx-sm-3" />
						<small id="passwordHelpInline" class="text-muted text-para">
							<spring:message code="lbl.identifierMsg"/>
						</small>

					</div>
				</div>

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width" for="inputPassword6"><spring:message code="lbl.userName"/></label>
						<form:input path="username" class="form-control mx-sm-3"
									required="required" />
						<small id="passwordHelpInline" class="text-muted text-para">
							<spring:message code="lbl.userMessage"/>
						</small>
					</div>
				</div>

				<form:hidden path="parentUser" id="parentUser"/>
				<%-- <div class="row col-12 tag-height">
                   <div class="form-group">
                       <label class="label-width" for="inputPassword6"><spring:message code="lbl.parentUser"/></label>
                       <select id="combobox" class="form-control">	</select>
                    </div>
                </div> --%>


				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width" for="inputPassword6"><spring:message code="lbl.password"/></label>
						<input type="password" class="form-control mx-sm-3" id="password" name="password"  required />
						<small id="passwordHelpInline" class="text-muted text-para">
								<%-- <spring:message code="lbl.passwordMEssage"/> --%>

						</small>
						<input type="checkbox" onclick="toggleVisibilityOfPassword()">Show Password
					</div>
				</div>

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width"  for="inputPassword6"><spring:message code="lbl.confirmedPassword"/></label>
						<form:password path="retypePassword" class="form-control mx-sm-3" id="retypePassword"
									   required="required" />
						<small id="passwordHelpInline" class="text-muted text-para">
							<span class="text-red" id="passwordNotmatchedMessage"></span> <spring:message code="lbl.retypePasswordMessage"/>
						</small>
					</div>

				</div>

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width"  for="inputPassword6"><spring:message code="lbl.role"/></label>
						<%
							List<Role> roles = (List<Role>) session.getAttribute("roles");
							for (Role role : roles) {
								if(role.getName().equals("Provider")){
									roleIdProvider = role.getId();
								}else if(role.getName().equals("CHCP")){
									roleIdCHCP = role.getId();
								}
						%>
						<form:radiobutton
								path="roles" class="chk" value="<%=role.getId()%>" onclick='roleSelect(this)'/>
						<label class="form-control mx-sm-3" for="defaultCheck1"> <%=role.getName()%></label>
						<%
							}
						%>

					</div>
				</div>

				<div class="row col-12 tag-height">
					<div class="form-group required">
						<label class="label-width"  for="branches">
							<spring:message code="lbl.branches"/>
						</label>
						<select id="branches"
								class="form-control mx-sm-3 js-example-basic-multiple"
								name="branches[]" multiple="multiple">
							<c:forEach items="${branches}" var="branch">
								<option value="${branch.id}">${branch.name} (${branch.code})</option>
							</c:forEach>
						</select>
					</div>

				</div>
				<div class="row col-12 tag-height" id="teamDiv" style="display:none">
					<div class="form-group">
						<label class="label-width" for="inputPassword6"><spring:message code="lbl.cc"/></label>
						<select class="form-control mx-sm-3" id="team" name="team" required="required" disabled>
							<option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
							<%
								for (Map.Entry<Integer, String> entry : teams.entrySet())
								{
									if(selectedTeamId==entry.getKey()){ %>
							<option value="<%=entry.getKey()%>" selected><%=entry.getValue() %></option>
							<% }else{
							%>
							<option value="<%=entry.getKey()%>"><%=entry.getValue() %></option>
							<%
									}

								}
							%>
						</select>
					</div>

				</div>
				<!--end: for team -->


				<div class="row col-12 tag-height">
					<div class="form-group">
						<label class="label-width"></label>
						<div class="text-red" id="roleSelectmessage"></div>
					</div>
				</div>
				<div class="row col-12 tag-height">
					<div class="form-group">
						<input type="submit" onclick="return Validate()"  value="<spring:message code="lbl.save"/>" 	class="btn btn-primary btn-block btn-center" />
					</div>
				</div>
			</form:form>
		</div>

	</div>
</div>
<!-- /.container-fluid-->
<!-- /.content-wrapper-->

<jsp:include page="/WEB-INF/views/footer.jsp" />
<script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>

<!-- Bootstrap core JavaScript-->
<script src="<c:url value='/resources/js/jquery-1.10.2.js'/>"></script>
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.min.js'/>"></script>

<!-- Core plugin JavaScript-->
<script src="<c:url value='/resources/vendor/jquery-easing/jquery.easing.min.js'/>"></script>


<!-- Custom scripts for all pages-->
<script src="<c:url value='/resources/js/sb-admin.min.js'/>"></script>
<!-- Custom scripts for this page-->
<%-- <script src="<c:url value='/resources/js/sb-admin-datatables.min.js'/>"></script> --%>
<script src="<c:url value='/resources/js/location.js'/>"></script>
<script src="<c:url value='/resources/js/checkbox.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>


<script type="text/javascript">
	var locationMagicSuggest;
	var isCHCP= 0;
	var isProvider= 0;
	function roleSelect(cBox){
		//alert(cBox.checked+" - "+cBox.value);
		var roleIdOfCHCP = <%=roleIdCHCP%>;
		var roleIdOfProvider = <%=roleIdProvider%>;
		var roleIdOfClickedCheckbox = cBox.value;

		if(roleIdOfClickedCheckbox == roleIdOfCHCP){
			if(cBox.checked){
				isCHCP= 1;
			}else{
				isCHCP= 0;
			}
		}

		if(roleIdOfClickedCheckbox == roleIdOfProvider){
			if(cBox.checked){
				isProvider= 1;
			}else{
				isProvider= 0;
			}
		}
		showTeamAndLocationDiv();
	}

	function toggleVisibilityOfPassword() {
		var pswrd = document.getElementById("password");
		var retypePswrd = document.getElementById("retypePassword");
		if (pswrd.type === "password") {
			pswrd.type = "text";
			retypePswrd.type = "text";
		} else {
			pswrd.type = "password";
			retypePswrd.type = "password";
		}
	}

	function showTeamAndLocationDiv(){
		if(isTeamMember()){
			$("#locationDiv").show();
			$("#team").prop('required',true);
			$("#team").prop('disabled', false);
			$("#teamDiv").show();
		}else{
			$("#locationDiv").hide();
			$("#team").prop('required',false);
			$("#team").prop('disabled', true);
			$("#teamDiv").hide();
		}
	}

	function isTeamMember(){
		if(isCHCP== 1 || isProvider== 1){
			return true;
		}
		return false;
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
		if(isTeamMember()){
			formData = {
				'firstName': $('input[name=firstName]').val(),
				'lastName': $('input[name=lastName]').val(),
				'email': $('input[name=email]').val(),
				'mobile': $('input[name=mobile]').val(),
				'idetifier': $('input[name=idetifier]').val(),
				'username': $('input[name=username]').val(),
				'password': $('input[name=password]').val(),
				'parentUser': $('input[name=parentUser]').val(),
				'roles': getCheckboxValueUsingClass(),
				'team': $('#team').val(),
				'teamMember': isTeamMember(),
				'branches': getBranches()
			};
		}else{
			formData = {
				'firstName': $('input[name=firstName]').val(),
				'lastName': $('input[name=lastName]').val(),
				'email': $('input[name=email]').val(),
				'mobile': $('input[name=mobile]').val(),
				'idetifier': $('input[name=idetifier]').val(),
				'username': $('input[name=username]').val(),
				'password': $('input[name=password]').val(),
				'parentUser': $('input[name=parentUser]').val(),
				'roles': getCheckboxValueUsingClass(),
				'teamMember': isTeamMember(),
				'branches': getBranches()
			};
		}

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
				$("#usernameUniqueErrorMessage").html(data);
				$("#loading").hide();
				if(data == ""){
					window.location.replace("/opensrp-dashboard/user.html");
				}

			},
			error : function(e) {

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
			$("#roleSelectmessage").html("Please select at least one role");
			return false;
		}
		$("#roleSelectmessage").html("");
		return true;
	}

</script>

<script>
	$(document).ready(function() {
		$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
	});
</script>
</body>
</html>