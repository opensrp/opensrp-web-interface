<%@page import="java.util.List"%>
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

<jsp:include page="/WEB-INF/views/header.jsp">
<jsp:param name="title" value="Household List" />
</jsp:include>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

		<div class="form-group">				
			 <jsp:include page="/WEB-INF/views/client/client-link.jsp" /> 		
			</div>


			<jsp:include page="/WEB-INF/views/searchPanel.jsp" />

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.householdList"/>
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
													style="width: 140px;"><spring:message code="lbl.createdDate"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.ward"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;"><spring:message code="lbl.hhId"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;"><spring:message code="lbl.householdCode"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.firstName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.phoneNumber"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.provider"/></th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.createdDate"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.ward"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;"><spring:message code="lbl.hhId"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 43px;"><spring:message code="lbl.householdCode"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.firstName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.phoneNumber"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.provider"/></th>
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

														String created_date = String.valueOf(clientObject[5]);
														String firstName = String.valueOf(clientObject[9]);
														String gobhhid = String.valueOf(clientObject[11]);
														String household_code = String.valueOf(clientObject[12]);
														String phone_number = String.valueOf(clientObject[17]);
														String ward = String.valueOf(clientObject[23]);
														String provider = String.valueOf(clientObject[27]);

														if(firstName.equalsIgnoreCase("null")) {
															firstName = "";
														}
														if(created_date.equalsIgnoreCase("null")) {
															created_date = "";
														}
														if(household_code.equalsIgnoreCase("null")) {
															household_code = "";
														}
														if(gobhhid.equalsIgnoreCase("null")) {
															gobhhid = "";
														}
														if(phone_number.equalsIgnoreCase("null")) {
															phone_number = "";
														}
														if(ward.equalsIgnoreCase("null")) {
															ward = "";
														}
														if(provider.equalsIgnoreCase("null")) {
															provider = "";
														}
											%>
											<tr>
												<td><%=created_date%></td>
												<td><%=ward%></td>
												<td><%=gobhhid%></td>
												<td><%=household_code%></td>
												<td><%=firstName%></td>
												<td><%=phone_number%></td>
												<td><%=provider%></td>
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