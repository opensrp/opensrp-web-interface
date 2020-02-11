<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
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
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Child Growth Summary Report</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
<link type="text/css"
	href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>" rel="stylesheet">
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
				  <jsp:include page="/WEB-INF/views/report/report-link.jsp" />		
	
			</div>
			<jsp:include page="/WEB-INF/views/report-search-panel.jsp" />
			<div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%"> 
							<img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>"></div>
							
			<div class="card mb-3">
				<div class="card-header">
					<spring:message code="lbl.childGrowthSummaryReport"/>
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<tbody id="tableBody">	
						
							<%	String indicator = "";
									int count = 0;
									int total = 0;
									int growth=0;
									int size=0;
									int counter=0;						
									
									if(session.getAttribute("data") != null){
										List<Object> data = (List<Object>) session.getAttribute("data");
										Iterator dataCountListIterator = data.iterator();
										while (dataCountListIterator.hasNext()) {
											String falterInPercentage = "";
											Object[] DataObject = (Object[]) dataCountListIterator.next();
											indicator = String.valueOf(DataObject[0]);
											count = Integer.parseInt(String.valueOf(DataObject[1]));
											total = Integer.parseInt(String.valueOf(DataObject[2]));
											if(count > 0){
											 falterInPercentage = String.format("%.2f", (double) (count*100)/total);
											}else{
												falterInPercentage = String.format("%.2f", 0.000);
											}
																		
										%>
											<tr>
											<td><%=indicator %></td>
											<td><%=falterInPercentage%> %</td>
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

		<jsp:include page="/WEB-INF/views/footer.jsp" />
		
		<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
		
		
		<script src="<c:url value='/resources/js/datepicker.js'/>"></script>
		
		<script type="text/javascript">
		
		$(document).ready(function() {
		    $('#dataTable').DataTable();
		} );
		
		$("#search-form").submit(function(event) { 
			$("#loading").show();
			 
			var division = "";
			var district = "";
			var upazila = "";
			var union = "";
			var ward = "";
			var subunit = "";
			var mauzapara = "";
			var params = "" ;
			var start_date = "" ;
			var end_date = "" ;
			
			division = $('#division').val();
			district = $('#district').val();
			upazila = $('#upazila').val();
			union = $('#union').val();
			ward = $('#ward').val();
			subunit = $('#subunit').val();
			mauzapara = $('#mauzapara').val();
			start_date = $('#start').val();
			end_date = $('#end').val();
			if(division != "" && division != "0?" && division != null ){
				params ="&division="+division;
			}
			if(district != "0?" &&  district != "" && district != null){
				params +="&district="+district;
				
			}
			if(upazila != "0?" && upazila != "" && upazila != null){
				params +="&upazila="+upazila;
			}
			if(union != "0?" && union != "" && union != null){
				params +="&union="+union;
				console.log(union);
			}
			if(ward != "0?" && ward != "" && ward != null){
				params +="&ward="+ward;
			}
			if(subunit != "0?" && subunit != "" && subunit != null){
				params +="&subunit="+subunit;
			}
			if(mauzapara != "0?" && mauzapara != "" && mauzapara != null){
				params +="&mauzapara="+mauzapara;
			}
			if( start_date != "" && start_date != null){
				params +="&start_date="+start_date;
			}
			if( end_date != "" && end_date != null){
				params +="&end_date="+end_date;
			}
			console.log(params);
			event.preventDefault();
			$.ajax({
				type : "GET",
				contentType : "application/json",				
				url : "/opensrp-dashboard/report/summary-ajax.html?"+params,				 
				dataType : 'html',
				timeout : 100000,
				beforeSend: function() {
				    
				   
				},
				success : function(data) {	
					$("#loading").hide();
				   $("#dataTable").html(data);
				},
				error : function(e) {
				    console.log("ERROR: ", e);
				    display(e);
				},
				done : function(e) {				    
				    console.log("DONE");				    
				}
			});
		});		
		 
		</script>
	</div>
	</div>
</body>
</html>