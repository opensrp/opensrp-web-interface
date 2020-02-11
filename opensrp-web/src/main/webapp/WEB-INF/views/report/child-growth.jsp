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
<title><spring:message code="lbl.childGrowthReport"/></title>
<link type="text/css"
	href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>" rel="stylesheet">
<jsp:include page="/WEB-INF/views/header.jsp" />

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
					<i class="fa fa-table"></i> <spring:message code="lbl.childGrowthReport"/>
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th><spring:message code="lbl.chwName"/></th>
									<th><spring:message code="lbl.adequateGrowth"/></th>
									<th><spring:message code="lbl.inadequateGrowth"/></th>
									<th><spring:message code="lbl.total"/></th>
									
								</tr>
							</thead>
							
							
							<tbody id="tableBody">	
								
								<%	String provider = "";
									int falter = 0;
									int total = 0;
									int growth=0;
									int size=0;
									int counter=0;						
									
									if(session.getAttribute("data") != null){
									List<Object> data = (List<Object>) session.getAttribute("data");
									Iterator dataCountListIterator = data.iterator();
									while (dataCountListIterator.hasNext()) {
										Object[] DataObject = (Object[]) dataCountListIterator.next();
										provider = String.valueOf(DataObject[0]);
										falter = Integer.parseInt(String.valueOf(DataObject[1]));
										growth = Integer.parseInt(String.valueOf(DataObject[2]));
										total = falter+growth;
										String falterInPercentage = "";
										String adequateInPercentage = "";									
										if(total>0){
										 	falterInPercentage = String.format("%.2f", (double) (falter*100)/total);			
										 	adequateInPercentage = String.format("%.2f",(double)(growth*100)/total);
										}else{
											falterInPercentage = "0.0";
											adequateInPercentage = "0.0";
										}
										
									%>
									<tr>
									<td><%=provider %></td>
									<td><%=growth %>  ( <%=adequateInPercentage %> % )</td>
									<td><%=falter %>  ( <%= falterInPercentage %> % )</td>									
									<td><%=total %></td>
									</tr>
									<% 
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

		<jsp:include page="/WEB-INF/views/footer.jsp" />
		
		<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
		
		<script src="<c:url value='/resources/js/jquery.dataTables.min.js'/>"></script>
		<script src="<c:url value='/resources/js/datepicker.js'/>"></script>
		<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js'/>"></script>
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
			event.preventDefault();
			$.ajax({
				type : "GET",
				contentType : "application/json",				
				url : "/opensrp-dashboard/report/child-growth-ajax.html?"+params,				 
				dataType : 'html',
				timeout : 100000,
				beforeSend: function() {
				    
				   
				},
				success : function(data) {
					$("#loading").hide();
					$("#tableBody").html(data);
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
</body>
</html>