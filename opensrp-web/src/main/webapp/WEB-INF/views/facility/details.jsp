<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.facility.entity.FacilityWorker"%>
<%@page import="org.opensrp.facility.entity.FacilityTraining"%>


<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<!DOCTYPE html>
<html> 

<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> -->
<title>CC Profile</title>
</head>
<style>
td{ padding:5px;}

</style>
<jsp:include page="/WEB-INF/views/header.jsp" />
<%
List<Integer> trainingIdList = new ArrayList<Integer>();
List<FacilityWorker> multipurposeHealthVolunteerList = new ArrayList<FacilityWorker>();
List<FacilityWorker> otherHealthWorkerList = new ArrayList<FacilityWorker>();
List<FacilityWorker> communityGroupMemberList = new ArrayList<FacilityWorker>();
List<FacilityWorker> communitySupportGroupMemberList = new ArrayList<FacilityWorker>();
String[][] coreWorkers = new String[6][2];

if (session.getAttribute("facilityWorkerList") != null) {
	FacilityWorker prevFacilityWorker = null;
	List<FacilityWorker> dataList = (List<FacilityWorker>)session.getAttribute("facilityWorkerList");
	Iterator dataListIterator = dataList.iterator();
	while (dataListIterator.hasNext()) {
		
		FacilityWorker facilityWorker = (FacilityWorker) dataListIterator.next();
		int id = facilityWorker.getId();
		String name = facilityWorker.getName();
		String facilityWorkerType = facilityWorker.getFacilityWorkerType().getName();
		String identifier = facilityWorker.getIdentifier();
		String organization = facilityWorker.getOrganization();
		int workerTypeId = facilityWorker.getFacilityWorkerType().getId();
		if(workerTypeId<6){
			coreWorkers[workerTypeId][0] = (name != null)? name : "";
			coreWorkers[workerTypeId][1] = (identifier != null)? identifier : "";
		}else if(workerTypeId == 6){
			multipurposeHealthVolunteerList.add(facilityWorker);
		}else if(workerTypeId == 7){
			otherHealthWorkerList.add(facilityWorker);
		}else if(workerTypeId == 8){
			communityGroupMemberList.add(facilityWorker);
		}else if(workerTypeId == 9){
			communitySupportGroupMemberList.add(facilityWorker);
		}
		
		if(workerTypeId==1){
			Set<FacilityTraining> trainings = facilityWorker.getFacilityTrainings();
			List<Integer> trainingListOfLatestChcp = new ArrayList<Integer>();
			for(FacilityTraining training : trainings){
		    	//trainingIdList.add(training.getId());
		    	trainingListOfLatestChcp.add(training.getId());
		    	}
			trainingIdList = trainingListOfLatestChcp;
		}
		
	}
}
%>



<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<jsp:include page="/WEB-INF/views/facility-url.jsp" />
		
		<div class="form-group">
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<a  href="<c:url value="/facility/${facility.id}/addWorker.html"/>"> <strong>Add Worker/Training</strong> </a>		
		<%} %>
		</div>
		
		
			
  <div class="row">
           	
<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="left" valign="top"><h2>কমিউনিটি ক্লিনিকের সেবা প্রদানকারী এবং সেবার তথ্য সমূহ: </h2></td>
  </tr>
  <tr>
    <td>      	
  <table width="100%" border="0" align="center" cellpadding="1" cellspacing="1">
  <tr>
  	<td>1.</td>
    <td>কমিউনিটি ক্লিনিকের নাম: </td>
    <td colspan="3">${facility.name}</td>
  </tr>
  <tr>
  	<td>2.</td>
    <td>এইচ আরএম আইডি:</td>
    <td colspan="3">${facility.hrmId}</td>
  </tr>
  <tr>
 	<td>3.</td>
    <td>ভৌগোলিক অবস্থা: </td>
    <td colspan="3"><table width="100%" border="0">
    <tr>
    	<td>বিভাগ :</td>
    	<td> ${facility.division}</td>
    </tr>
    <tr>
    	<td>জেলা :</td>
    	<td> ${facility.district}</td>
    </tr>
    <tr>
    	<td>উপজেলা :</td>
    	<td> ${facility.upazila}</td>
    </tr>
     <tr>
    	<td>ইউনিয়ন :</td>
    	<td> ${facility.union}</td>
    </tr>
    <tr>
    	<td>ওয়ার্ড :</td>
    	<td> ${facility.ward}</td>
    </tr>
     <tr>
    	<td>অক্ষাংশ :</td>
    	<td> ${facility.latitude}</td>
    </tr>
    <tr>
    	<td>দ্রাঘিমা :</td>
    	<td> ${facility.longitude}</td>
    </tr>
    </table>
   	
  </tr>
  <tr>
  	<td>4.</td>
    <td>সিএইচসিপির নাম:	</td>
    <td><%=(coreWorkers[1][0]!= null)? coreWorkers[1][0] : ""%></td>
    <td>মোবাইল নাম্বার:</td>
    <td><%=(coreWorkers[1][1]!= null)? coreWorkers[1][1] : ""%></td>
  </tr>
  <tr>
  	<td>5.</td>
    <td>স্বাস্থ্য সহকারীর নাম:</td>
    <td><%=(coreWorkers[2][0]!= null)? coreWorkers[2][0] : ""%></td>
    <td>মোবাইল নাম্বার:</td>
    <td><%=(coreWorkers[2][1]!= null)? coreWorkers[2][1] : ""%></td>
  </tr>
  <tr>
    <td>6.</td>
    <td>সহকারীর স্বাস্থ্য পরিদর্শকের  নাম:</td>
    <td><%=(coreWorkers[3][0]!= null)? coreWorkers[3][0] : ""%></td>
    <td>মোবাইল নাম্বার:</td>
    <td><%=(coreWorkers[3][1]!= null)? coreWorkers[3][1] : ""%></td>
  </tr>
  <tr>
    <td>7.</td>
    <td>পরিবার পরিকল্পনা সহকারীর নাম :</td>
    <td><%=(coreWorkers[4][0]!= null)? coreWorkers[4][0] : ""%></td>
    <td>মোবাইল নাম্বার:</td>
    <td><%=(coreWorkers[4][1]!= null)? coreWorkers[4][1] : ""%></td>
  </tr>
  <tr>
    <td>8.</td>
    <td>পরিবার পরিকল্পনা পরিদর্শকের নাম:</td>
     <td><%=(coreWorkers[5][0]!= null)? coreWorkers[5][0] : ""%></td>
    <td>মোবাইল নাম্বার:</td>
     <td><%=(coreWorkers[5][1]!= null)? coreWorkers[5][1] : ""%></td>
  </tr>
  <tr>
    <td>9. </td>
    <td colspan="4">মাল্টিপারপাস হেলথ ভলেন্টিয়ারের নাম ও মোবাইল নাম্বার: </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4"><table width="100%" border="0">
 <%
 	for(FacilityWorker worker : multipurposeHealthVolunteerList){
 		String workerName = worker.getName();
 		String workerIdentifier = worker.getIdentifier();
 		workerName = (workerName != null) ? workerName : "";
 		workerIdentifier = (workerIdentifier != null) ? workerIdentifier : "";
 %>     
      <tr>
      	<td>নাম: </td>
        <td><%=workerName %></td>
        <td>মোবাইল নাম্বার:</td>
        <td><%=workerIdentifier %></td>
      </tr>
 <%
 	}
 %>    
     
    </table></td>
  </tr>
  
  <tr>
    <td>10. </td>
    <td colspan="4">অনন্যা স্বাস্থ্য কর্মীর নাম: </td>
  </tr>
 <tr>
    <td>&nbsp;</td>
    <td colspan="4"><table width="100%" border="0">
 <%
 	for(FacilityWorker worker : otherHealthWorkerList){
 		String workerName = worker.getName();
 		String workerIdentifier = worker.getIdentifier();
 		workerName = (workerName != null) ? workerName : "";
 		workerIdentifier = (workerIdentifier != null) ? workerIdentifier : "";
 %>     
      <tr>
      	<td>নাম: </td>
        <td><%=workerName %></td>
        <td>মোবাইল নাম্বার:</td>
        <td><%=workerIdentifier %></td>
      </tr>
 <%
 	}
 %>    
     
    </table></td>
  </tr>
  <!-- <tr>
  	<td>10.</td>
    <td>অনন্যা স্বাস্থ্য কর্মীর নাম (যদি থাকে):</td>
    <td>..................................................</td>
    <td>মোবাইল নাম্বার:</td>
    <td>.....................................................</td>
  </tr> -->
  <tr>
  	<td>11.</td>
    <td colspan="4">সিএইচসিপির প্রাপ্ত প্রশিক্ষণ সমূহ:</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4"><table width="100%" border="0">
<%
	int i=1;
	if(trainingIdList.contains(1)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>মৈলিক প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(2)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>রিফ্রেসার প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(3)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>সিএসবিএ প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(4)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>এমআইএস বিষয়ক প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(5)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>এনসিডি প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(6)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>দুর্যোগ ব্যবস্থাপনা প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(7)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>যক্ষা ও কুষ্ঠ নিয়ন্ত্রন  প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(8)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>স্বাস্থ্য শিক্ষা প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(9)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>ভিটামিন এ প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(10)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>পুষ্টি বিষয়ক প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(11)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>নবজাতকের অত্যাবশ্যকীয় সেবা বিষয়ক প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(12)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>ই লার্নিং প্রশিক্ষণ</td>
      </tr>
<%
	} 
	if(trainingIdList.contains(13)){
%>
      <tr>
        <td><%=i++ %>.</td>
        <td>অন্যান্য (উল্লেখ করুন)</td>
      </tr>
<%
	} 
%>      
      
    </table></td>
    <tr>
  	<td>12.</td>
    <td colspan="4">কমিউনিটি গ্রূপের সদস্যদের তালিকা -১৭ জন (আইডি অনুসারে)</td>
  </tr>
   <!--  <tr>
      <td>&nbsp;</td>
      <td colspan="4"><table width="100%" border="0">
      <tr>
        <td>কমিউনিটি সাপোর্ট গ্রূপ </td>
      
      </tr>
      <tr>
        <td>কমিউনিটি সাপোর্ট গ্রূপ </td>
       
      </tr>
      <tr>
        <td>কমিউনিটি সাপোর্ট গ্রূপ </td>
       
      </tr>
      
      
    </table></td>
    </tr> -->
     <tr>
    <td>&nbsp;</td>
    <td colspan="4"><table width="100%" border="0">
 <%
 	for(FacilityWorker worker : communityGroupMemberList){
 		String workerName = worker.getName();
 		String workerIdentifier = worker.getIdentifier();
 		workerName = (workerName != null) ? workerName : "";
 		workerIdentifier = (workerIdentifier != null) ? workerIdentifier : "";
 %>     
      <tr>
      	<td>নাম: </td>
        <td><%=workerName %></td>
        <td>মোবাইল নাম্বার:</td>
        <td><%=workerIdentifier %></td>
      </tr>
 <%
 	}
 %>    
     
    </table></td>
  </tr>
  
  
  <tr>
  	<td>13.</td>
    <td colspan="4">কমিউনিটি সাপোর্ট গ্রূপের সদস্যদের তালিকা -১৭ জন (আইডি অনুসারে)</td>
  </tr>
  
     <tr>
    <td>&nbsp;</td>
    <td colspan="4"><table width="100%" border="0">
 <%
 	for(FacilityWorker worker : communitySupportGroupMemberList){
 		String workerName = worker.getName();
 		String workerIdentifier = worker.getIdentifier();
 		workerName = (workerName != null) ? workerName : "";
 		workerIdentifier = (workerIdentifier != null) ? workerIdentifier : "";
 %>     
      <tr>
      	<td>নাম: </td>
        <td><%=workerName %></td>
        <td>মোবাইল নাম্বার:</td>
        <td><%=workerIdentifier %></td>
      </tr>
 <%
 	}
 %>    
     
    </table></td>
  </tr>
</table></td>
  </tr>
</table>
           	
           	
           	
           	</div>
           
			
			
			
			

			
		</div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>
</html>