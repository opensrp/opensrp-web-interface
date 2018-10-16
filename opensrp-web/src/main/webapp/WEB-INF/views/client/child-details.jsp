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

    <div class="form-group">				
		<jsp:include page="/WEB-INF/views/client/client-link.jsp" />		
	</div>

    
      <!-- Breadcrumbs-->
      <ol class="breadcrumb">
        <li class="breadcrumb-item">
          <a href="/opensrp-dashboard/client/child.html"><spring:message code="lbl.child"/></a>
        </li>
        <li class="breadcrumb-item"><spring:message code="lbl.childDetails"/></li>
      </ol>
      <!-- Child Register-->
      <div class="card mb-3">
            <div class="card-header">
               <spring:message code="lbl.childDetails"/></div>
            <div class="list-group list-group-flush small">
              <a class="list-group-item list-group-item-action" href="#">
                <div class="media">
                  <img class="d-flex mr-3 rounded-circle" src="/resources/img/child.png" alt="">
<%
String childId = null;
JSONArray lineChartWeightData = (JSONArray)session.getAttribute("lineChartWeightData");
JSONArray lineChartGrowthData = (JSONArray)session.getAttribute("lineChartGrowthData");
lineChartWeightData.put(lineChartGrowthData.getJSONObject(0));
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
%>	                  
                  <div class="media-body">
                    <strong><spring:message code="lbl.name"/>: </strong><%=firstName%><br>
                    <strong><spring:message code="lbl.age"/>: </strong><br>
                    <strong><spring:message code="lbl.gender"/>: </strong><%=gender%><br>
                  </div>
                  
                  <div class="media-body">
                     <strong><spring:message code="lbl.birthDate"/>: </strong><%=birthDate%><br>
                     <strong><spring:message code="lbl.birthWeight"/>: </strong><%=birthWeight%><br>
                  </div>
                  
                  <div class="media-body">
                    <strong><spring:message code="lbl.fatherName"/>: </strong><%=fatherName%><br>
                    <strong><spring:message code="lbl.motherName"/>: </strong><br>
                    <strong><spring:message code="lbl.caregiverName"/>: </strong><br>
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
			<div class="card mb-3">
				<div id="lineChart" class="card-body"></div>
			</div>
      
      
      <!-- Example DataTables Card-->
      <div class="card mb-3">
        <div class="card-header">
           <spring:message code="lbl.growth"/></div>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
              <thead>
                <tr>
                  <th><spring:message code="lbl.slNo"/></th>
                  <th><spring:message code="lbl.visitDate"/></th>
                  <th><spring:message code="lbl.weight"/></th>
                  <th><spring:message code="lbl.growthPerMonth"/></th>
                  <th><spring:message code="lbl.status"/></th>
                </tr>
              </thead>
              <tfoot>
                 <tr>
                  <th><spring:message code="lbl.slNo"/></th>
                  <th><spring:message code="lbl.visitDate"/></th>
                  <th><spring:message code="lbl.weight"/></th>
                  <th><spring:message code="lbl.growthPerMonth"/></th>
                  <th><spring:message code="lbl.status"/></th>
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
		
		Object[] weightObject = (Object[]) dataListIterator.next();
		String id = String.valueOf(weightObject[0]);
		String eventDate = String.valueOf(weightObject[8]);
		String currentWeight = String.valueOf(weightObject[13]);
		
		String growthStatus = String.valueOf(weightObject[5]);
		String growth = String.valueOf(weightObject[17]);
		
		double growthGram = Double.parseDouble(growth);
		double growthKg = growthGram / 1000.00;
		
		String gStatusDecoded = "No data found";
		String bgColor = "#ff9800";
		if(!growthStatus.isEmpty() && growthStatus!=null){
			
			if(growthStatus.equals("true")){
				gStatusDecoded = "Adequate";
				bgColor="#4CAF50";
			}else if(growthStatus.equals("false")){
				gStatusDecoded = "Inadequate";
				bgColor="#f44336";
			}
		}
		
%>	          
                <tr>
                  <td><%=i%></td>
                  <td><%=eventDate%></td>
                  <td><%=currentWeight%></td>
                  <td><%=growthKg%></td>
                  <td bgcolor=<%=bgColor%>><%=gStatusDecoded%></td>
                </tr>
                
<%
	i++;
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

    <jsp:include page="/WEB-INF/views/footer.jsp" />
  

  	<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
	<script src="<c:url value='/resources/chart/data.js'/>"></script>
	<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
	<script src="<c:url value='/resources/chart/series-label.js'/>"></script>
	<script type="text/javascript">
		Highcharts.chart('lineChart', {
			chart : {
				type : 'line'
			},
			title : {
				text : 'Growth'
			},
			subtitle : {
				text : ''
			},
			credits : {
				enabled : false
			},
			xAxis : {
				allowDecimals: false
			},
			yAxis : {
				title : {
					text : 'Kg'
				}
			},

			legend : {
				layout : 'vertical',
				align : 'right',
				verticalAlign : 'middle'
			},

			plotOptions : {
				line : {
					dataLabels : {
						enabled : true
					},
					enableMouseTracking : true
				}
			},

			responsive : {
				rules : [ {
					condition : {
						maxWidth : 500
					},
					chartOptions : {
						legend : {
							layout : 'horizontal',
							align : 'center',
							verticalAlign : 'bottom'
						}
					}
				} ]
			},

			series :
	<%=lineChartWeightData%>
		});
	</script>
</body>

</html>
	