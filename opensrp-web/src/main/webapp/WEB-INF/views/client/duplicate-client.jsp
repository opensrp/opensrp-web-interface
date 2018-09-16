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
			 </a>  |<a  href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar Event</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfClient.html"/>"> <strong>Similarity Definition of Client</strong>
			 </a>  |<a  href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>"> <strong>Similarity Definition of Event</strong>
			 </a>  		
			</div>

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Similar Client List
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
													style="width: 140px;">First Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Gender</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Address Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Provider</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Action</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Group Id</th>
												   <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">First Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Gender</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Address Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Provider</th>
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
														Object[] clientObject = (Object[]) dataListIterator.next();
														String baseEntityId = String.valueOf(clientObject[1]);
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
														
														String latest_growth_status = String.valueOf(clientObject[34]);
														String provider = String.valueOf(clientObject[27]);
														pageContext.setAttribute("baseEntityId", baseEntityId);
														
														String groupId = String.valueOf(clientObject[35]);
														
														
														
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
												<td bgcolor=<%=bgColor%>><%=firstName%></td>
												<td bgcolor=<%=bgColor%>><%=gender%></td>
												<td bgcolor=<%=bgColor%>><%=addressType%></td>
												<td bgcolor=<%=bgColor%>><%=provider%></td>
												<td bgcolor=<%=bgColor%>>
												<%-- 
												<a href="<c:url value="/client/child/${baseEntityId}/details.html"/>">Details</a>
												 --%>		
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