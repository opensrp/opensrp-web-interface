<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.facility.entity.FacilityWorker"%>
<%@page import="org.opensrp.facility.entity.FacilityTraining"%>
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
               Facility Details</div>
            <div class="list-group list-group-flush small">
              <a class="list-group-item list-group-item-action" href="#">
                <div class="media">
           
                  <div class="media-body">
                    <strong>Name: </strong>${facility.name}<br>
                    <strong>HRM ID: </strong>${facility.hrmId}<br>
                  </div>
                  <div class="media-body">
                   <strong>Latitude: </strong>${facility.latitude}<br>
                    <strong>Longitude: </strong>${facility.longitude}<br>
                  </div>


                </div>
              </a>
              
              
              
              
            </div>
            <div class="card-footer small text-muted"></div>
          </div>
			
			
			
			

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Worker List
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
													style="width: 140px;">Worker Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Identifier</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Organization</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Training</th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Worker Type</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Name</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;">Identifier</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;">Organization</th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 79px;">Training</th>
											</tr>
										</tfoot>
										<tbody>
											<%
												if (session.getAttribute("facilityWorkerList") != null) {
													FacilityWorker prevFacilityWorker = null;
													List<FacilityWorker> dataList = (List<FacilityWorker>)session.getAttribute("facilityWorkerList");
													Iterator dataListIterator = dataList.iterator();
													while (dataListIterator.hasNext()) {
														
														
														FacilityWorker facilityWorker = (FacilityWorker) dataListIterator.next();
														if(prevFacilityWorker != facilityWorker){
														int id = facilityWorker.getId();
														String name = facilityWorker.getName();
														String facilityWorkerType = facilityWorker.getFacilityWorkerType().getName();
														String identifier = facilityWorker.getIdentifier();
														String organization = facilityWorker.getOrganization();
											%>
											<tr>
												<td><%=facilityWorkerType%></td>
												<td><%=name%></td>
												<td><%=identifier%></td>
												<td><%=organization%></td>
												<td>
												<% 
												if(facilityWorker.getFacilityWorkerType().getId()==1){

													Set<FacilityTraining> trainings = facilityWorker.getFacilityTrainings();
													//for(FacilityTraining training : trainings){
													Iterator<FacilityTraining> iterator = trainings.iterator();
													int i =1;
												    while(iterator.hasNext()) {
												    	FacilityTraining training = iterator.next();
												    	String trainingString = i+".  " +training.getName();
												    	i++;
												      
												%>
												<%=trainingString%><br>
												<%
													
												    }
													}
												%>
												</td>
											</tr>
											<%
												prevFacilityWorker = facilityWorker;
												}
												}
												}
											%>
										</tbody>
									</table>

								</div>
							</div>

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