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
String motherId = null;
 if (session.getAttribute("motherId") != null) {
	 motherId = (String) session.getAttribute("motherId");
 }
 if (session.getAttribute("dataList") != null) {
	List<Object> dataList = (List<Object>) session
			.getAttribute("dataList");
	Iterator dataListIterator = dataList.iterator();
	while (dataListIterator.hasNext()) {
		Object[] clientObject = (Object[]) dataListIterator.next();
		String id = String.valueOf(clientObject[1]);
		if(id.equals(motherId)){
		String first_name = String.valueOf(clientObject[9]);
		String last_name = String.valueOf(clientObject[13]);
		String birth_date = String.valueOf(clientObject[3]);
		String spouse_name = String.valueOf(clientObject[19]);
		String phone_number = String.valueOf(clientObject[17]);

		String division = String.valueOf(clientObject[8]);
		String district = String.valueOf(clientObject[7]);
		String upazilla = String.valueOf(clientObject[22]);
		String union = String.valueOf(clientObject[21]);
		String ward = String.valueOf(clientObject[23]);
		String householdId = String.valueOf(clientObject[12]);
		
		
		String lmp_date = String.valueOf(clientObject[24]);
		
%>					
<table class="table table-stripped">
<tr>
<td><b>Name : </b></td>
<td><b><%=first_name%></b></td>
<td><b>Division : </b></td>
<td><b><%=division%></b></td>
</tr>

<tr>
<td><b>Birthdate : </b></td>
<td><b><%=birth_date%> </b></td>
<td><b>District : </b></td>
<td><b><%=district%></b></td>
</tr>

<tr>
<td><b>Age : </b></td>
<td><b> </b></td>
<td><b>Upazilla : </b></td>
<td><b><%=upazilla%></b></td>
</tr>

<tr>
<td><b>Marital Status : </b></td>
<td><b>Married</b></td>
<td><b>Union : </b></td>
<td><b><%=union%></b></td>
</tr>

<tr>
<td><b>Husband's Name : </b></td>
<td><b><%=spouse_name%></b></td>
<td><b>Ward : </b></td>
<td><b><%=ward%></b></td>
</tr>

<tr>
<td><b>Contact Number : </b></td>
<td><b><%=phone_number%></b></td>
<td><b>Household : </b></td>
<td><b><%=householdId%></b></td>
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
	
	


 <div class="container-fluid">
  <div class="row">
  
  <div class="span6">
  <h3><b>Pregnancy Details</b></h3>
  
  
  
  	
<%

 if (session.getAttribute("eventList") != null) {
	List<Object> dataList = (List<Object>) session
			.getAttribute("eventList");
	Iterator dataListIterator = dataList.iterator();
	while (dataListIterator.hasNext()) {
		Object[] clientObject = (Object[]) dataListIterator.next();
		String id = String.valueOf(clientObject[0]);
		String isPregnant = String.valueOf(clientObject[19]);
		
%>					
<b><%=id%>  :  </b>
<b><%=isPregnant%></b></br>

<%
		}
		}
%>
  
</div>


</div>
</div>	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	</div></ br>
	<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>

</body>
</html>