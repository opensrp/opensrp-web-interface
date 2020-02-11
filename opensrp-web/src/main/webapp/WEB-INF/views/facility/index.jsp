<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.core.entity.Facility"%>
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
<jsp:param name="title" value="Community Clinic List" />
</jsp:include>




<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<jsp:include page="/WEB-INF/views/facility/facility-link.jsp" />
		</ol>
		<jsp:include page="/WEB-INF/views/searchPanel.jsp" />
		
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.communityClinicList"/>
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
													style="width: 140px;"><spring:message code="lbl.hrmId"/></th>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.communityClinicName"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;"><spring:message code="lbl.division"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.district"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.upazila"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.union"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;"><spring:message code="lbl.ward"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.action"/></th>
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
														String upazila = facility.getUpazila()!= null? facility.getUpazila() : "";
														String union = facility.getUnion()!= null? facility.getUnion() : "";
														String ward = facility.getWard() != null? facility.getWard() : "";
														
														//String location = facility.getLocation().getName();
														String addWorkerURL = "/facility/"+id+"/addWorker.html";
														String updateProfileURL = "/facility/"+id+"/updateProfile.html";
														String detailsURL = "/facility/"+id+"/details.html";
											%>
											<tr>
												<td><%=hrmId%></td>
												<td><%=name%></td>
												<td><%=division%></td>
												<td><%=district%></td>
												<td><%=upazila%></td>
												<td><%=union%></td>
												<td><%=ward%></td>
												<td>
												<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
												<a href="<c:url value="<%= detailsURL%>" />"><spring:message code="lbl.ccProfile"/></a>
												| 	
												<%} %>
												<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
												<a href="<c:url value="<%= addWorkerURL%>" />"><spring:message code="lbl.addWorker"/></a>	
												<%} %>
												
												<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
												| <a href="<c:url value="<%= updateProfileURL%>" />"><spring:message code="lbl.updateProfile"/></a>	
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