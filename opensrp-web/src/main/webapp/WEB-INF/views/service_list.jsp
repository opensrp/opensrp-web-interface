<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<c:url var="get_service_url" value="/people/activity-details" />

<div class="table-scrollable">
	<table class="table table-striped table-bordered " id="serviceTable">
		<thead>
			<tr>
				<th>SI</th>
				<th>Date</th>
				<th>Activity</th>
				<th>Action</th>
			</tr>
		</thead>
		<tbody>

			<c:forEach var="service" items="${services}" varStatus="loop">
				<tr>
					<td>0</td>
					<td>${service.getEventDate() }</td>
					<td>${service.getServiceName() }</td>
					<td><div class="btn btn-primary"
						onclick="loadContent('${service.getServiceName() }','${service.getId()}','${service.getTableName()}','${get_service_url}')">Details</div>


					</td>
				</tr>
			</c:forEach>
		</tbody>

	</table>
</div>

<script>
	$(document).ready(function() {

		var table = $('#serviceTable').DataTable({     
           scrollCollapse: true
        }
		);
		table.on( 'order.dt search.dt', function () {
 	        table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
 	            cell.innerHTML = i+1;
 	        } );
 	    } ).draw();
		
	});
	
	
</script>
