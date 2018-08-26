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


			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Duplicate Client List
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
													style="width: 140px;">Group Id</th>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Entity Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Event Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Event Date</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Location</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Provider</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Group Id</th>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Entity Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Event Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Event Date</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Location</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Provider</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</tfoot>
										<tbody>
											<%
												String prevGroupId = "";
												if (session.getAttribute("duplicateRecordList") != null) {
													List<Object> dataList = (List<Object>) session
															.getAttribute("duplicateRecordList");
													Iterator dataListIterator = dataList.iterator();
													while (dataListIterator.hasNext()) {
														Object[] eventObject = (Object[]) dataListIterator.next();
														String entityType = String.valueOf(eventObject[6]);
														String eventType = String.valueOf(eventObject[8]);
														String eventDate = String.valueOf(eventObject[7]);
														String locationId = String.valueOf(eventObject[9]);
														String providerId = String.valueOf(eventObject[11]);
														
														String groupId = String.valueOf(eventObject[28]);
														
														
														
														String bgColor = "#4CAF50";
														if(!prevGroupId.isEmpty() && prevGroupId!=null){
															
															if(!groupId.equals(prevGroupId)){
																bgColor="#4CAF50";
															}else{
																bgColor="#f44336";
															}
														}
														
														prevGroupId = groupId;
														

											%>
											<tr>
												<td bgcolor=<%=bgColor%>><%=groupId%></td>
												<td><%=entityType%></td>
												<td><%=eventType%></td>
												<td><%=eventDate%></td>
												<td><%=locationId%></td>
												<td><%=providerId%></td>
												<td>
												<a href="<c:url value=""/>">Details</a>		
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

							<%-- <jsp:include page="/WEB-INF/views/pager.jsp" /> --%>

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