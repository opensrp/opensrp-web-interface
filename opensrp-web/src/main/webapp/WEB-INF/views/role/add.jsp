<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>59-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="org.opensrp.core.entity.Permission"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.addRoleTitle"/></title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/role/add.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
				<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />			
			</div>
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.addRoleTitle"/>
				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}" modelAttribute="role">
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<label for="exampleInputName"><spring:message code="lbl.name"/></label>
									<form:input path="name" class="form-control"
										required="required" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="form-check">
								<div class="row">
									<%
										List<Permission> permissions = (List<Permission>) session
													.getAttribute("permissions");
											int[] selectedPermissions = (int[]) session
													.getAttribute("selectedPermissions");
											for (Permission permission : permissions) {
									%>
									<div class="col-5">
										<form:checkbox class="checkBoxClass form-check-input"
											path="permissions" value="<%=permission.getId()%>"
											checked="<%=CheckboxHelperUtil.checkCheckedBox(
							selectedPermissions, permission.getId())%>" />
										<label class="form-check-label" for="defaultCheck1"> <%=permission.getName()%>
										</label>
									</div>
									<%
										}
									%>
								</div>

							</div>
							<div class="row">
								<div class="col-3">
									<label class="form-check-label"> <spring:message code="lbl.checkAll"/> <input
										type="checkbox" id="ckbCheckAll" /></label>
									<p>${errorPermission}</p>
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="<spring:message code="lbl.save"/>"
										class="btn btn-primary btn-block" />
								</div>
							</div>
						</div>
					</form:form>
				</div>
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>
</html>
