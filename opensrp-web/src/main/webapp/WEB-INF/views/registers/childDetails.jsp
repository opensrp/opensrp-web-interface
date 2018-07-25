<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/views/header.jsp" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	
	<div class="content-wrapper">
		<div class="container-fluid">
	
	
	
<%
String childId = null;
 if (session.getAttribute("childId") != null) {
	 childId = (String) session.getAttribute("childId");
 }	
		if (session.getAttribute("dataList") != null) {
			List<Object> dataList = (List<Object>) session
					.getAttribute("dataList");
			Iterator dataListIterator = dataList.iterator();
			while (dataListIterator.hasNext()) {
				Object[] clientObject = (Object[]) dataListIterator.next();
				String base_entity_id = String.valueOf(clientObject[1]);
				
				if(base_entity_id.equals(childId)){
				String address_type = String.valueOf(clientObject[2]);
				String birth_date = String.valueOf(clientObject[3]);
				String country = String.valueOf(clientObject[4]);
				String created_date = String.valueOf(clientObject[5]);
				String edited_date = String.valueOf(clientObject[6]);
				String first_name = String.valueOf(clientObject[9]);
				String gender = String.valueOf(clientObject[10]);
				String nid = String.valueOf(clientObject[15]);
				String birth_weight = String.valueOf(clientObject[31]);
				String mother_name = String.valueOf(clientObject[32]);
				
		
%>					
<table class="table table-stripped">
<tr>
<td><b>Name : </b></td>
<td><b><%=first_name%></b></td>
<td><b></b></td>
<td><b></b></td>
</tr>

<tr>
<td><b>Father's Name : </b></td>
<td><b> </b></td>
<td><b></b></td>
<td><b></b></td>
</tr>

<tr>
<td><b>Mother's Name : </b></td>
<td><b><%=mother_name%> </b></td>
<td><b></b></td>
<td><b></b></td>
</tr>

<tr>
<td><b>Birthdate : </b></td>
<td><b><%=birth_date%></b></td>
<td><b></b></td>
<td><b></b></td>
</tr>

<tr>
<td><b>Age : </b></td>
<td><b></b></td>
<td><b></b></td>
<td><b></b></td>
</tr>

<tr>
<td><b>Gender : </b></td>
<td><b><%=gender%></b></td>
<td><b>Birth Weight : </b></td>
<td><b><%=birth_weight%></b></td>
</tr>

<tr>
<td><b></b></td>
<td><b></b></td>
<td><b></b></td>
<td><b></b></td>
</tr>
	
</table>



<%
		}
		}
}
%>
	
	




	
	
	<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>

</body>
</html>