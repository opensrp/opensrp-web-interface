<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.opensrp.core.entity.FormUpload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/views/header.jsp" />

<%
byte[] fileContent = null;
if (session.getAttribute("jsonForm") != null) {
	fileContent = (byte[])session.getAttribute("jsonForm");
}
JSONObject jsonObj=new JSONObject(new String(fileContent));
%>


<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<jsp:include page="/WEB-INF/views/form/form-link.jsp" />
		<div><%= jsonObj%></div>
		</div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
<script type="text/javascript"> 
var temp = <%=jsonObj%>;
console.log(temp);
</script>
</body>
</html>