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
<html lang="en">

<jsp:include page="/WEB-INF/views/header.jsp" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<div class="form-group">				
			 <a  href="<c:url value="/client/household.html"/>"> <strong>Household</strong> 
			 </a>  |<a  href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>
			 </a>  |<a  href="<c:url value="/client/child.html"/>"> <strong>Child</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateClient.html"/>"> <strong>Duplicate Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Duplicate Event</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Duplicate Definition of Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Duplicate Definition of Event</strong>
			 </a>  		
			</div>

			<jsp:include page="/WEB-INF/views/searchPanel.jsp" />

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Child List
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
													style="width: 140px;">First Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Last Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Gender</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Birth Date</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Ward</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">NID</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">BRID</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Provider</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">First Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Last Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Gender</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Birth Date</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Ward</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">NID</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">BRID</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Provider</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</tfoot>
										<tbody>
											<%
												if (session.getAttribute("dataList") != null) {
													List<Object> dataList = (List<Object>) session
															.getAttribute("dataList");
													Iterator dataListIterator = dataList.iterator();
													while (dataListIterator.hasNext()) {
														Object[] clientObject = (Object[]) dataListIterator.next();
														String birthDate = String.valueOf(clientObject[3]);
														String firstName = String.valueOf(clientObject[9]);
														String gender = String.valueOf(clientObject[10]);
														String lastName = String.valueOf(clientObject[13]);
														String nid = String.valueOf(clientObject[15]);
														String brid = String.valueOf(clientObject[16]);
														String ward = String.valueOf(clientObject[23]);
														String provider = String.valueOf(clientObject[27]);

														if(firstName.equalsIgnoreCase("null")) {
															firstName = "";
														}
														if(birthDate.equalsIgnoreCase("null")) {
															birthDate = "";
														}
														if(lastName.equalsIgnoreCase("null")) {
															lastName = "";
														}
														if(nid.equalsIgnoreCase("null")) {
															nid = "";
														}
														if(brid.equalsIgnoreCase("null")) {
															brid = "";
														}
														if(gender.equalsIgnoreCase("null")) {
															gender = "";
														}
														if(ward.equalsIgnoreCase("null")) {
															ward = "";
														}
														if(provider.equalsIgnoreCase("null")) {
															provider = "";
														}
											%>
											<tr>
												<td><%=firstName%></td>
												<td><%=lastName%></td>
												<td><%=gender%></td>
												<td><%=birthDate%></td>
												<td><%=ward%></td>
												<td><%=nid%></td>
												<td><%=brid%></td>
												<td><%=provider%></td>
												<td>
												<a href="<c:url value="/client/child/${baseEntityId}/details.html"/>">Details</a>		
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