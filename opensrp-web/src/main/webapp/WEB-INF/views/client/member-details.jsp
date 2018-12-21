<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
	
	
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>Member Details</title>
  <!-- Bootstrap core CSS-->
  <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <!-- Custom fonts for this template-->
  <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  <!-- Page level plugin CSS-->
  <link href="/resources/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
  <!-- Custom styles for this template-->
  <link href="/resources/css/sb-admin.css" rel="stylesheet">
</head>

<jsp:include page="/WEB-INF/views/header.jsp" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

  <div class="content-wrapper">
    <div class="container-fluid">
    
    <div class="form-group">				
			 <jsp:include page="/WEB-INF/views/client/client-link.jsp" />  		
	</div>
    
    
      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="/opensrp-dashboard/client/member.html"><spring:message code="lbl.member"/></a>
        </li>
        <li class="breadcrumb-item"><spring:message code="lbl.memberDetails"/></li>
      </ol>
      <!-- Child Register-->
      <div class="card mb-3">
            <div class="card-header">
               <spring:message code="lbl.memberDetails"/></div>
            <div class="list-group list-group-flush small">
              <a class="list-group-item list-group-item-action" href="#">
                <div class="media">
                  <img class="d-flex mr-3 rounded-circle" src="/resources/img/child.png" alt="">
<%
String memberId = null;

 if (session.getAttribute("memberId") != null) {
	 memberId = (String) session.getAttribute("memberId");
 }	
		if (session.getAttribute("dataList") != null) {
			List<Object> dataList = (List<Object>) session
					.getAttribute("dataList");
			Iterator dataListIterator = dataList.iterator();
			while (dataListIterator.hasNext()) {
				Object[] clientObject = (Object[]) dataListIterator.next();
				String baseEntityId = String.valueOf(clientObject[1]);
				
				if(baseEntityId.equals(memberId)){
				String birthDate = String.valueOf(clientObject[3])!=null? String.valueOf(clientObject[3]) : "";
				String phoneNumber = String.valueOf(clientObject[17])!=null? String.valueOf(clientObject[17]) : "";
				String firstName = String.valueOf(clientObject[9])!=null? String.valueOf(clientObject[9]) : "";
				String gender = String.valueOf(clientObject[10])!= null? String.valueOf(clientObject[10]) : "";
				String nid = String.valueOf(clientObject[15])!= null ? String.valueOf(clientObject[15]) : "";
				
				//String fatherName = String.valueOf(clientObject[33]);
				
		
%>	                  
                  <div class="media-body">
                    <strong><spring:message code="lbl.name"/>: </strong><%=firstName%><br>
                    <strong><spring:message code="lbl.gender"/>: </strong><%=gender%><br>
                  </div>
                  
                  <div class="media-body">
                     <strong><spring:message code="lbl.nId"/>: </strong><%=nid%><br>
                     <strong><spring:message code="lbl.phoneNumber"/>: </strong><%=phoneNumber%><br>
                  </div>
                  
                  <div class="media-body">
                    <strong><spring:message code="lbl.birthDate"/>: </strong><%=birthDate%><br>
                  </div>
<%
		}
		}
}
%>                     
                </div>
              </a>

              
            </div>
            <div class="card-footer small text-muted"></div>
          </div>
      
      
      
      
  
      

      
      
      
     
      
      
    </div>
    <!-- /.container-fluid-->
    <!-- /.content-wrapper-->

   
    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
      <i class="fa fa-angle-up"></i>
    </a>
    
    
    <jsp:include page="/WEB-INF/views/footer.jsp" />
    
    
  </div>
  
  
  	
	
</body>

</html>
	