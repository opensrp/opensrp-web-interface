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
		
		<jsp:include page="/WEB-INF/views/facility-url.jsp" />
			

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Community Clinic List
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
													style="width: 140px;">HRM ID</th>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">CC Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Division</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">District</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Upazilla</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Union</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Ward</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</thead>
									
										<tbody>
											<%
												if (session.getAttribute("dataList") != null) {
													List<Facility> dataList = (List<Facility>)session.getAttribute("dataList");
													Iterator dataListIterator = dataList.iterator();
													while (dataListIterator.hasNext()) {
														
														
														Facility facility = (Facility) dataListIterator.next();
														int id = facility.getId();
														String name = facility.getName()!=null ? facility.getName() : "";
														String hrmId = facility.getHrmId()!=null ? facility.getHrmId() : "";
														String latitude = facility.getLatitude()!=null? facility.getLatitude() : "";
														String longitude = facility.getLongitude()!=null? facility.getLongitude() : "";
														String division = facility.getDivision()!= null? facility.getDivision() : "";
														String district = facility.getDistrict()!= null? facility.getDistrict() : "";
														String upazilla = facility.getUpazilla()!= null? facility.getUpazilla() : "";
														String union = facility.getUnion()!= null? facility.getUnion() : "";
														String ward = facility.getWard() != null? facility.getWard() : "";
														
														//String location = facility.getLocation().getName();
														String addWorkerURL = "/facility/"+id+"/addWorker.html";
														String detailsURL = "/facility/"+id+"/details.html";
											%>
											<tr>
												<td><%=hrmId%></td>
												<td><%=name%></td>
												<td><%=division%></td>
												<td><%=district%></td>
												<td><%=upazilla%></td>
												<td><%=union%></td>
												<td><%=ward%></td>
												<td>
												<a href="<c:url value="<%= detailsURL%>" />">CC Profile</a>
												| 	
												<a href="<c:url value="<%= addWorkerURL%>" />">Add Worker/Training</a>	
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