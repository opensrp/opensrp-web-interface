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
													style="width: 140px;">Base Entity Id</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Address Type</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Birth Date</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Country</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">First Name</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Gender</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Birth Weight</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Mother Name</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Base Entity Id</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Address Type</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Birth Date</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;">Country</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">First Name</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Gender</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Birth Weight</th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Mother Name</th>
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
														String base_entity_id = String.valueOf(clientObject[1]);
														String address_type = String.valueOf(clientObject[2]);
														String birth_date = String.valueOf(clientObject[3]);
														String country = String.valueOf(clientObject[4]);
														String created_date = String.valueOf(clientObject[5]);
														String edited_date = String.valueOf(clientObject[6]);
														String first_name = String.valueOf(clientObject[9]);
														String gender = String.valueOf(clientObject[10]);
														String nid = String.valueOf(clientObject[15]);
														String birth_weight = String.valueOf(clientObject[31]);
														String mother_name = String.valueOf(clientObject[32]);
											%>
											<tr>
												<td><%=base_entity_id%></td>
												<td><%=address_type%></td>
												<td><%=birth_date%></td>
												<td><%=country%></td>
												<td><%=first_name%></td>
												<td><%=gender%></td>
												<td><%=birth_weight%></td>
												<td><%=mother_name%></td>
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