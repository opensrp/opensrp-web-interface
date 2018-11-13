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
String formName ="";
if (session.getAttribute("formName") != null) {
	 String formNameWithExtension = (String)session.getAttribute("formName");
	 String[] formNameArray = formNameWithExtension.split("\\.");
	 formName = formNameArray[0];
}
try{
	if (session.getAttribute("jsonForm") != null) {
		fileContent = (byte[])session.getAttribute("jsonForm");
	}
}catch(Exception e){}

JSONObject jsonObj=new JSONObject(new String(fileContent));
%>


<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<jsp:include page="/WEB-INF/views/form/form-link.jsp" />
		
		<div class="row">
	        <div class="col-md-7">
	            <h4><%=formName %></h4>
	            <div id="formDiv"></div>
	        </div>
   		 </div>
   		 
		</div>

	<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	
<script src="<c:url value='/resources/form-viewer/jquery.medea.js'/>"></script>
<script src="<c:url value='/resources/form-viewer/converter.js'/>"></script>
<script type="text/javascript"> 
var jsonObj = <%=jsonObj%>;

$(function() {
    var convertedObj = convertForMedea(jsonObj);
    var form = $("#formDiv").medea(convertedObj);
    manageReleventInputs();
    manageFieldAttributes();

/* $("#formDiv").on("medea.submit", function(e, objUp) { 
alert(JSON.stringify(objUp));
}); */

});
</script>
</body>
</html>