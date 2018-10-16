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
			<jsp:include page="/WEB-INF/views/client/client-link.jsp" />  		
			</div>

    
      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">         
		 <a  href="<c:url value="/client/mother.html?lang=${locale}"/>"><spring:message code="lbl.mother"/></a>
        </li>
        <li class="breadcrumb-item"><spring:message code="lbl.motherDetails"/></li>
      </ol>
      <!-- Child Register-->
      <div class= "row">
      <div class="col-lg-6">
      
      <div class="card mb-3">
            <div class="card-header">
               <spring:message code="lbl.motherDetails"/></div>
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
                    <strong><spring:message code="lbl.name"/>: </strong><%=firstName%><br>
                    <strong><spring:message code="lbl.birthDate"/>: </strong><%=birthDate%><br>
                    <strong><spring:message code="lbl.age"/>: </strong><br>
                    <strong><spring:message code="lbl.maritalStatus"/>: </strong>Married<br>
                    <strong><spring:message code="lbl.husbandName"/>: </strong><%=spouseName%><br>
                    <strong><spring:message code="lbl.phoneNumber"/>: </strong><%=phoneNumber%><br>
                    
                  </div>
                  <div class="media-body">
                    <strong><spring:message code="lbl.division"/>: </strong><%=division%><br>
                    <strong><spring:message code="lbl.district"/>: </strong><%=district%><br>
                    <strong><spring:message code="lbl.upazila"/>: </strong><%=upazilla%><br>
                    <strong><spring:message code="lbl.union"/>: </strong><%=union%><br>
                    <strong><spring:message code="lbl.ward"/>: </strong><%=ward%><br>
                    <strong><spring:message code="lbl.household"/>: </strong><%=householdId%><br>
                    
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
               <spring:message code="lbl.pregnancyDetails"/></div>
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
              <b><spring:message code="lbl.pregnant"/> : <%=isPregnant%></b>
              </p>
              
              <p class="card-text small">
              <b><spring:message code="lbl.edd"/> : <%=edd%></b>
              </p>
              
              <p class="card-text small">
              <b><spring:message code="lbl.lmp"/> : <%=lmp%></b>
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
              <spring:message code="lbl.counselling"/></div>
         
              
               <div class="card-body">
            
            <div class="row">
            <div class="table-responsive">
    
            <table class="table table-bordered" id="counsellingTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th><spring:message code="lbl.idNo"/></th>
                  <th><spring:message code="lbl.advice"/></th>
                  <th><spring:message code="lbl.followedAdvice"/></th>
                </tr>
              </thead>
              <tfoot>
                 <tr>
                  <th><spring:message code="lbl.idNo"/></th>
                  <th><spring:message code="lbl.advice"/></th>
                  <th><spring:message code="lbl.followedAdvice"/></th>
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
            
             <div class="table-responsive">
    
            <table class="table table-bordered" id="counsellingTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th><spring:message code="lbl.particulars"/></th>
                  <th><spring:message code="lbl.value"/></th>
                </tr>
              </thead>
              <tfoot>
                <tr>
                  <th><spring:message code="lbl.particulars"/></th>
                  <th><spring:message code="lbl.value"/></th>
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
           <spring:message code="lbl.followUp"/></div>
        <div class="card-body">
          <div class="table-responsive">
    
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th><spring:message code="lbl.slNo"/></th>
                  <th><spring:message code="lbl.date"/></th>
                  <th><spring:message code="lbl.pregnancyAge"/></th>
                  <th><spring:message code="lbl.nextAppointmentDate"/></th>
                  <th><spring:message code="lbl.status"/></th>
                </tr>
              </thead>
              <tfoot>
               <tr>
                  <th><spring:message code="lbl.slNo"/></th>
                  <th><spring:message code="lbl.date"/></th>
                  <th><spring:message code="lbl.pregnancyAge"/></th>
                  <th><spring:message code="lbl.nextAppointmentDate"/></th>
                  <th><spring:message code="lbl.status"/></th>
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

    <jsp:include page="/WEB-INF/views/footer.jsp" />
    
  </div>
	
</body>
</html>