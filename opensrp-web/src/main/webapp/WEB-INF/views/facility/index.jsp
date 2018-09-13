<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.facility.entity.Facility"%>
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

<jsp:include page="/WEB-INF/views/header.jsp" />




<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<div class="form-group">				
				   <a  href="<c:url value="/facility/add.html"/>" > <strong>Registration</strong> 
				   </a>  |  <a  href="<c:url value="/facility/index.html"/>"> <strong>Community Clinic</strong>
				   </a>		
		</div>
			

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Facility List
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<div id="dataTable_wrapper"
							class="dataTables_wrapper container-fluid dt-bootstrap4">
							<div class="row">
								<div class="col-sm-12">
									<table class="table table-bordered dataTable" id="dataTable"
										style="width: 100%;">
										<thead>
											<tr>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">HRM ID</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Latitude</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Longitude</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Location</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">HRM ID</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Latitude</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Longitude</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Location</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</tfoot>
										<tbody>
											<%
												if (session.getAttribute("dataList") != null) {
													List<Facility> dataList = (List<Facility>)session.getAttribute("dataList");
													Iterator dataListIterator = dataList.iterator();
													while (dataListIterator.hasNext()) {
														
														
														Facility facility = (Facility) dataListIterator.next();
														int id = facility.getId();
														String name = facility.getName();
														String hrmId = facility.getHrmId();
														String latitude = facility.getLatitude();
														String longitude = facility.getLongitude();
														
														//String location = facility.getLocation().getName();
														String addWorkerURL = "/facility/"+id+"/addWorker.html";
											%>
											<tr>
												<td><%=name%></td>
												<td><%=hrmId%></td>
												<td><%=latitude%></td>
												<td><%=longitude%></td>
												<td></td>
												<td>
												<a href="<c:url value="/client/child/${baseEntityId}/details.html"/>">Details</a>
												| 	
												<a href="<c:url value="<%= addWorkerURL%>" />">Add Worker</a>	
												</td> 
											</tr>
											<%
												}
												}
											%>
										</tbody>
									</table>

								</div>
							</div>

							<jsp:include page="/WEB-INF/views/pager.jsp" />

						</div>
					</div>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
		</div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>
</html>