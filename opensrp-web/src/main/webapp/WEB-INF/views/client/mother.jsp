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
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/views/header.jsp">
<jsp:param name="title" value="Mother List" />
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
					<i class="fa fa-table"></i> <spring:message code="lbl.motherList"/>
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
													style="width: 140px;"><spring:message code="lbl.firstName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.nId"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.husbandName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.lmpDate"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.phoneNumber"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.provider"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.action"/></th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.firstName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.nId"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.husbandName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.lmpDate"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.phoneNumber"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.provider"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.action"/></th>
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
														String baseEntityId = String.valueOf(clientObject[1]);
														String addressType = String.valueOf(clientObject[2]);
														String birthDate = String.valueOf(clientObject[3]);
														String country = String.valueOf(clientObject[4]);
														String createdDate = String.valueOf(clientObject[5]);
														String editedDate = String.valueOf(clientObject[6]);
														String firstName = String.valueOf(clientObject[9]);
														String nid = String.valueOf(clientObject[15]);
														String phoneNumber = String.valueOf(clientObject[17]);
														String spouseName = String.valueOf(clientObject[19]);
														String lmpDate = String.valueOf(clientObject[24]);
														String provider = String.valueOf(clientObject[27]);
														
														String id = String.valueOf(clientObject[0]);
														pageContext.setAttribute("baseEntityId", baseEntityId);
														
														if(firstName.equalsIgnoreCase("null")) {
															firstName = "";
														}
														if(birthDate.equalsIgnoreCase("null")) {
															birthDate = "";
														}
														if(spouseName.equalsIgnoreCase("null")) {
															spouseName = "";
														}
														if(nid.equalsIgnoreCase("null")) {
															nid = "";
														}
														if(lmpDate.equalsIgnoreCase("null")) {
															lmpDate = "";
														}
														if(phoneNumber.equalsIgnoreCase("null")) {
															phoneNumber = "";
														}
														if(provider.equalsIgnoreCase("null")) {
															provider = "";
														}
											%>
											<tr>
												<td><%=firstName%></td>
												<td><%=nid%></td>
												<td><%=spouseName%></td>
												<td><%=lmpDate%></td>
												<td><%=phoneNumber%></td>
												<td><%=provider%></td>												
												<td>
												<a href="<c:url value="/client/mother/${baseEntityId}/details.html?lang=${locale}"/>"><spring:message code="lbl.details"/></a>
												<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_MOTHER")){ %>
												| <a href="<c:url value="/client/mother/${baseEntityId}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a>
												<%} %>
												
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