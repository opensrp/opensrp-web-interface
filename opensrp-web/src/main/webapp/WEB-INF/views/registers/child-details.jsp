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
  <title>Child Details</title>
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
      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="/client/child.html">Child</a>
        </li>
        <li class="breadcrumb-item active">Child Details</li>
      </ol>
      <!-- Child Register-->
      <div class="card mb-3">
            <div class="card-header">
               Child Details</div>
            <div class="list-group list-group-flush small">
              <a class="list-group-item list-group-item-action" href="#">
                <div class="media">
                  <img class="d-flex mr-3 rounded-circle" src="http://placehold.it/45x45" alt="">
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
				String baseEntityId = String.valueOf(clientObject[1]);
				
				if(baseEntityId.equals(childId)){
				String addressType = String.valueOf(clientObject[2]);
				String birthDate = String.valueOf(clientObject[3]);
				String country = String.valueOf(clientObject[4]);
				String createdDate = String.valueOf(clientObject[5]);
				String editedDate = String.valueOf(clientObject[6]);
				String firstName = String.valueOf(clientObject[9]);
				String gender = String.valueOf(clientObject[10]);
				String nid = String.valueOf(clientObject[15]);
				String birthWeight = String.valueOf(clientObject[31]);
				String motherName = String.valueOf(clientObject[32]);
				String fatherName = "";
				//String fatherName = String.valueOf(clientObject[33]);
				
		
%>	                  
                  <div class="media-body">
                    <strong>Name: </strong><%=firstName%><br>
                    <strong>Age: </strong><br>
                    <strong>Gender: </strong><%=gender%><br>
                  </div>
                  
                  <div class="media-body">
                     <strong>Birth-date: </strong><%=birthDate%><br>
                     <strong>Birth-weight: </strong><%=birthWeight%><br>
                  </div>
                  
                  <div class="media-body">
                    <strong>Father's Name: </strong><%=fatherName%><br>
                    <strong>Mother's Name: </strong><br>
                    <strong>Care-giver's Name: </strong><br>
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
      
      
      
      <!-- Area Chart Example-->
      <!-- <div class="row">
        <div class="col-lg-6">
          Example Bar Chart Card
          <div class="card mb-3">
            <div class="card-header">
               Siblings</div>
            <div class="card-body">
              <p class="card-text small">1. These waves are looking pretty good today!
                  <a href="#">#surfsup</a>
                </p>
                <p class="card-text small">2. These waves are looking pretty good today!
                  <a href="#">#surfsup</a>
                </p>
            </div>
            <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
          </div>
          Card Columns Example Social Feed
          
          
          
          /Card Columns
        </div>
        <div class="col-lg-6">
          Example Pie Chart Card
          <div class="card mb-3">
            <div class="card-header">
              Counseling</div>
            <div class="card-body">
             <p class="card-text small">These waves are looking pretty good today!
                  <a href="#">#surfsup</a>
                </p>
                <p class="card-text small">These waves are looking pretty good today!
                  <a href="#">#surfsup</a>
                </p>
            </div>
            <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
          </div>
          Example Notifications Card
          
        </div>
      </div> -->
      
      <!-- Example DataTables Card-->
      <div class="card mb-3">
        <div class="card-header">
           Growth</div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th>Sl. No.</th>
                  <th>Visit Date</th>
                  <th>Weight</th>
                  <th>Growth/month</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tfoot>
                <tr>
                  <th>Sl. No.</th>
                  <th>Visit Date</th>
                  <th>Weight</th>
                  <th>Growth/month</th>
                  <th>Status</th>
                </tr>
              </tfoot>
              <tbody>
              
              
<%
 if (session.getAttribute("weightList") != null) {
	int i=0;
	List<Object> dataList = (List<Object>) session
			.getAttribute("weightList");
	Iterator dataListIterator = dataList.iterator();
	while (dataListIterator.hasNext()) {
		i++;
		Object[] weightObject = (Object[]) dataListIterator.next();
		String id = String.valueOf(weightObject[0]);
		String eventDate = String.valueOf(weightObject[8]);
		String currentWeight = String.valueOf(weightObject[13]);
		
		String growthStatus = String.valueOf(weightObject[5]);
		String growth = String.valueOf(weightObject[17]);
		
		double growthGram = Double.parseDouble(growth);
		double growthKg = growthGram / 1000.00;
		
		String gStatusDecoded = null;
		if(growthStatus.equals("true")){
			gStatusDecoded = "Adequate";
		}else{
			gStatusDecoded = "Inadequate";
		}
		
%>	          
                <tr>
                  <td><%=i%></td>
                  <td><%=eventDate%></td>
                  <td><%=currentWeight%></td>
                  <td><%=growthKg%></td>
                  <td><%=gStatusDecoded%></td>
                </tr>
                
<%
		}
	i=0;
		}
%>
                
                
              </tbody>
            </table>
          </div>
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
</body>

</html>
	