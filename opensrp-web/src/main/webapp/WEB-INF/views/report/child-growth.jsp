<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
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
<link type="text/css"
	href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>" rel="stylesheet">
<jsp:include page="/WEB-INF/views/header.jsp" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

			<jsp:include page="/WEB-INF/views/customSearchPanel.jsp" />

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Child Growth Report
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<table class="table table-bordered" id="dataTable">
							<thead>
								<tr>
									<th>CHW Name</th>
									<th>Adequate Growth</th>
									<th>Inadequate Growth</th>
									<th>Total</th>
									
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
										Object[] dashboardDataObject = (Object[]) dataCountListIterator.next();
										provider = String.valueOf(dashboardDataObject[0]);
										falter = Integer.parseInt(String.valueOf(dashboardDataObject[1]));
										total = Integer.parseInt(String.valueOf(dashboardDataObject[2]));
										growth = total-falter;										
										String falterInPercentage = String.format("%.2f", (double) (falter*100)/total);
										String adequateInPercentage = String.format("%.2f",(double)(growth*100)/total);
										
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
		<script src="<c:url value='/resources/js/jquery.dataTables.min.js'/>"></script>
		<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js'/>"></script>
		<script type="text/javascript">
		$(document).ready(function() {
		    $('#dataTable').DataTable();
		} );
		
		$("#bth-search").submit(function(event) {   
			$.ajax({
				type : "GET",
				contentType : "application/json",
				url : url,				 
				dataType : 'html',
				timeout : 100000,
				beforeSend: function() {
				    alert("OK");
				   
				},
				success : function(data) {				   
				   $("#"+id).html(data);
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