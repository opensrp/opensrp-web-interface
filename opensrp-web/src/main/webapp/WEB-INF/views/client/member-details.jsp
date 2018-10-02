<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
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
          <a href="/opensrp-dashboard/client/member.html">Member</a>
        </li>
        <li class="breadcrumb-item">Member Details</li>
      </ol>
      <!-- Child Register-->
      <div class="card mb-3">
            <div class="card-header">
               Member Details</div>
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
                    <strong>Name: </strong><%=firstName%><br>
                    <strong>Gender: </strong><%=gender%><br>
                  </div>
                  
                  <div class="media-body">
                     <strong>NID: </strong><%=nid%><br>
                     <strong>Phone Number: </strong><%=phoneNumber%><br>
                  </div>
                  
                  <div class="media-body">
                    <strong>Birth-date: </strong><%=birthDate%><br>
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
    <!-- Logout Modal-->
    <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
            <button class="close" type="button" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
          </div>
          <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
          <div class="modal-footer">
            <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
            <a class="btn btn-primary" href="login.html">Logout</a>
          </div>
        </div>
      </div>
    </div>
    
    <jsp:include page="/WEB-INF/views/footer.jsp" />
    
    <!-- Bootstrap core JavaScript-->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>
    <script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Core plugin JavaScript-->
    <script src="/resources/vendor/jquery-easing/jquery.easing.min.js"></script>
    <!-- Page level plugin JavaScript-->
    <script src="/resources/vendor/chart.js/Chart.min.js"></script>
    <script src="/resources/vendor/datatables/jquery.dataTables.js"></script>
    <script src="/resources/vendor/datatables/dataTables.bootstrap4.js"></script>
    <!-- Custom scripts for all pages-->
    <script src="/resources/js/sb-admin.min.js"></script>
    <!-- Custom scripts for this page-->
    <script src="/resources/js/sb-admin-datatables.min.js"></script>
    <script src="/resources/js/sb-admin-charts.min.js"></script>
  </div>
  
  
  	<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
	<script src="<c:url value='/resources/chart/data.js'/>"></script>
	<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
	<script src="<c:url value='/resources/chart/series-label.js'/>"></script>
	
</body>

</html>
	