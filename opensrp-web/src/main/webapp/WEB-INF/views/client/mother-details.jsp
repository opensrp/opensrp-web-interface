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
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <title>Mother Details</title>
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
			 <a  href="<c:url value="/client/household.html"/>"> <strong>Household</strong> 
			 </a>  |<a  href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>
			 </a>  |<a  href="<c:url value="/client/child.html"/>"> <strong>Child</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar Event</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Similarity Definition of Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Similarity Definition of Event</strong>
			 </a>  		
			</div>
    
      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">         
		 <a  href="<c:url value="/client/mother.html"/>">Mother</a>
        </li>
        <li class="breadcrumb-item">Mother Details</li>
      </ol>
      <!-- Child Register-->
      <div class= "row">
      <div class="col-lg-6">
      
      <div class="card mb-3">
            <div class="card-header">
               Mother Details</div>
            <div class="list-group list-group-flush small">
              <a class="list-group-item list-group-item-action" href="#">
                <div class="media">
                  <img class="d-flex mr-3 rounded-circle" src="/resources/img/mother.png" alt="">
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
		String firstName = (String.valueOf(clientObject[9])!= null)?String.valueOf(clientObject[9]) : "";
		String lastName = (String.valueOf(clientObject[13])!= null)?String.valueOf(clientObject[13]) : "";
		String birthDate = (String.valueOf(clientObject[3])!= null)?String.valueOf(clientObject[3]) : "";
		String spouseName = (String.valueOf(clientObject[19])!= null)?String.valueOf(clientObject[19]) : "";;
		String phoneNumber = (String.valueOf(clientObject[17])!= null)?String.valueOf(clientObject[17]) : "";

		String division = (String.valueOf(clientObject[8])!= null)?String.valueOf(clientObject[8]) : "";
		String district = (String.valueOf(clientObject[7])!= null)?String.valueOf(clientObject[7]) : "";
		String upazilla = (String.valueOf(clientObject[22])!= null)?String.valueOf(clientObject[22]) : "";
		String union = (String.valueOf(clientObject[21])!= null)?String.valueOf(clientObject[21]) : "";
		String ward = (String.valueOf(clientObject[23])!= null)?String.valueOf(clientObject[23]) : "";
		String householdId = (String.valueOf(clientObject[12])!= null)?String.valueOf(clientObject[12]) : "";
		
		
		String lmpDate = (String.valueOf(clientObject[24])!= null)?String.valueOf(clientObject[24]) : "";
		
%>
           
                  <div class="media-body">
                    <strong>Name: </strong><%=firstName%><br>
                    <strong>Birthdate: </strong><%=birthDate%><br>
                    <strong>Age: </strong><br>
                    <strong>Marital Status: </strong>Married<br>
                    <strong>Husband's Name: </strong><%=spouseName%><br>
                    <strong>Contact Number: </strong><%=phoneNumber%><br>
                    
                  </div>
                  <div class="media-body">
                    <strong>Division: </strong><%=division%><br>
                    <strong>District: </strong><%=district%><br>
                    <strong>Upazilla: </strong><%=upazilla%><br>
                    <strong>Union: </strong><%=union%><br>
                    <strong>Ward: </strong><%=ward%><br>
                    <strong>Household: </strong><%=householdId%><br>
                    
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
      
      <!-- Area Chart Example-->
      <!-- <div class="row"> -->
       
          <!-- Example Bar Chart Card-->
          <div class="col-lg-6">
          <div class="card mb-3">
            <div class="card-header">
               Pregnancy Details</div>
<%

if (session.getAttribute("NWMRList") != null) {
List<Object> dataList = (List<Object>) session
		.getAttribute("NWMRList");
Iterator dataListIterator = dataList.iterator();
while (dataListIterator.hasNext()) {
	Object[] clientObject = (Object[]) dataListIterator.next();
	String id = (String.valueOf(clientObject[0])!= null)?String.valueOf(clientObject[0]) : "";
	String isPregnant = (String.valueOf(clientObject[20])!= null)?String.valueOf(clientObject[20]) : "";
	String edd = (String.valueOf(clientObject[21])!= null)?String.valueOf(clientObject[21]) : "";
	String lmp = (String.valueOf(clientObject[22])!= null)?String.valueOf(clientObject[22]) : "";
		
%>	
            <div class="card-body">
             
              <p class="card-text small">
              <b>Pregnant : <%=isPregnant%></b>
              </p>
              
              <p class="card-text small">
              <b>EDD : <%=edd%></b>
              </p>
              
              <p class="card-text small">
              <b>LMP : <%=lmp%></b>
              </p>
              
            </div>
<%
		}
		}
%>
            <div class="card-footer small text-muted"></div>
        </div>
        </div>
          <!-- Card Columns Example Social Feed-->
          
          
          
          <!-- /Card Columns-->
        </div>
        
        
        
       <!--  <div class="col-lg-6"> -->
          <!-- Example Pie Chart Card-->
          <div class="card mb-3">
            <div class="card-header">
              Counselling</div>
              
              
              
              
              
              
              
              
               <div class="card-body">
            
            <div class="row">
            <div class="table-responsive">
    
            <table class="table table-bordered" id="counsellingTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th>Id No.</th>
                  <th>Advice</th>
                  <th>Followed Advice</th>
                </tr>
              </thead>
              <tfoot>
                <tr>
                  <th>Id No.</th>
                  <th>Advice</th>
                  <th>Followed Advice</th>
                </tr>
              </tfoot>
              <tbody> 
              
              
              
<%
 String observation = null;
 JSONArray obsArr = null;
 if (session.getAttribute("counsellingList") != null) {
	List<Object> dataList = (List<Object>) session
			.getAttribute("counsellingList");
	if(dataList.size()!=0){
	
	String prevCounsellingFollwed = null;
	for(int i=(dataList.size()-1), j=0; i>=0; i--){
		Object[] clientObject = (Object[]) dataList.get(i);
		
		String id = (String.valueOf(clientObject[0])!= null)?String.valueOf(clientObject[0]) : "";
		String counselling = (String.valueOf(clientObject[23])!= null)?String.valueOf(clientObject[23]) : "";
		String followedCounselling = (String.valueOf(clientObject[27])!= null)?String.valueOf(clientObject[27]) : "";
		
	
	
/* 	Iterator dataListIterator = dataList.iterator();
	while (dataListIterator.hasNext()) {
		Object[] clientObject = (Object[]) dataListIterator.next();
		String id = String.valueOf(clientObject[0]);
		String counselling = String.valueOf(clientObject[22]); */
		
%>	              
  
          
            
            
            <tr>
                  <td><%=id%></td>
                  <td><%=counselling%></td>

 <% 
 			if(j!= 0){
 				
 			
 
 %>            
                  <td><%=prevCounsellingFollwed%></td>
                </tr>
				
<%
 			}else{
%>
            
            <td></td>
            </tr>
            
<% 				
			 observation = (String.valueOf(clientObject[10])!= null)?String.valueOf(clientObject[10]) : "";
             obsArr = new JSONArray(observation); 
             
 			}
             j++;
             prevCounsellingFollwed = followedCounselling;
		}
	}
	}
%>            
            </tbody>
            </table>
            </div>
            
            
            <%-- <p id="obsString"><%=observation%></p> --%>
            
             <div class="table-responsive">
    
            <table class="table table-bordered" id="counsellingTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th>Particulars</th>
                  <th>Value</th>
                </tr>
              </thead>
              <tfoot>
                <tr>
                  <th>Particulars</th>
                  <th>Value</th>
                </tr>
              </tfoot>
              <tbody> 
<%
if(obsArr!=null){
 for (int i = 0; i < obsArr.length(); i++)
{
      String formSubmissionField =  (obsArr.getJSONObject(i).getString("formSubmissionField")!=null)?
    		  							obsArr.getJSONObject(i).getString("formSubmissionField"): "";
      JSONArray valArr = obsArr.getJSONObject(i).getJSONArray("values");
      //String val = valArr.getJSONObject(0).toString();
      String val = (valArr.getString(0)!=null)?valArr.getString(0):"";
 
%>
                <tr>
              	<td><%=formSubmissionField%></td>
              	<td><%=val%></td>
              	</tr> 
<%
}
 
}
 
%>
              </tbody>
              </table>
              </div>
            
            </div>
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            </div>
            <div class="card-footer small text-muted"></div>
          </div>
          <!-- Example Notifications Card-->
          
       <!--  </div> -->
      <!-- </div> -->
      
      <!-- Example DataTables Card-->
      <div class="card mb-3">
        <div class="card-header">
           Follow-up</div>
        <div class="card-body">
          <div class="table-responsive">
    
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th>Sl. No.</th>
                  <th>Date</th>
                  <th>Pregnancy Age</th>
                  <th>Next Appointment Date</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tfoot>
                <tr>
                  <th>Sl. No.</th>
                  <th>Date</th>
                  <th>Pregnancy Age</th>
                  <th>Next Appointment Date</th>
                  <th>Status</th>
                </tr>
              </tfoot>
              <tbody>

<%

 if (session.getAttribute("followUpList") != null) {
	int i=0;
	List<Object> dataList = (List<Object>) session
			.getAttribute("followUpList");
	if(dataList.size()!=0){
	Iterator dataListIterator = dataList.iterator();
	while (dataListIterator.hasNext()) {
		i++;
		Object[] clientObject = (Object[]) dataListIterator.next();
		String id = (String.valueOf(clientObject[0])!= null)?String.valueOf(clientObject[0]) : "";;
		String followUpDate = (String.valueOf(clientObject[24])!= null)?String.valueOf(clientObject[24]) : "";;
		String nextAppointmentDate = (String.valueOf(clientObject[25])!= null)?String.valueOf(clientObject[25]) : "";;
		 
%>	          
                <tr>
                  <td><%=i%></td>
                  <td><%=followUpDate%></td>
                  <td></td>
                  <td><%=nextAppointmentDate%></td>
                  <td>Good</td>
                </tr> 
                
<%
	 }	
	i=0;
 }
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
              <span aria-hidden="true">�</span>
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