<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Requisition</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="center-caption">
							Requisition(AM)
						</div>


					</div>				
					<div class="portlet-body">
						<div class="form-group">
						<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.division"></spring:message> :</label> 
								    <select
										name="cars" class="form-control" id="cars">
										<option selected="selected">Select Branch</option>
										<option value="volvo">Volvo</option>
										<option value="saab">Saab</option>
										<option value="mercedes">Mercedes</option>
										<option value="audi">Audi</option>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.district"></spring:message> :</label> 
								    <select
										name="cars" class="form-control" id="cars">
										<option selected="selected">Select Branch</option>
										<option value="volvo">Volvo</option>
										<option value="saab">Saab</option>
										<option value="mercedes">Mercedes</option>
										<option value="audi">Audi</option>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.upazila"></spring:message> :</label> 
								    <select
										name="cars" class="form-control" id="cars">
										<option selected="selected">Select Branch</option>
										<option value="volvo">Volvo</option>
										<option value="saab">Saab</option>
										<option value="mercedes">Mercedes</option>
										<option value="audi">Audi</option>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.union"></spring:message> :</label> 
								    <select
										name="cars" class="form-control" id="cars">
										<option selected="selected">Select Branch</option>
										<option value="volvo">Volvo</option>
										<option value="saab">Saab</option>
										<option value="mercedes">Mercedes</option>
										<option value="audi">Audi</option>
									</select>
								</div>
								
							</div>
							<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="cars"><spring:message code="lbl.branch"></spring:message> :</label> 
								    <select
										name="cars" class="form-control" id="cars">
										<option selected="selected">Select Branch</option>
										<option value="volvo">Volvo</option>
										<option value="saab">Saab</option>
										<option value="mercedes">Mercedes</option>
										<option value="audi">Audi</option>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="designation"><spring:message code="lbl.requisitionBy"></spring:message> :</label>
									<select
										name="cars" class="form-control" id="cars">
										<option selected="selected">Select Branch</option>
										<option value="volvo">Volvo</option>
										<option value="saab">Saab</option>
										<option value="mercedes">Mercedes</option>
										<option value="audi">Audi</option>
									</select>
								</div>
								
								<div class="col-lg-3 form-group">
								    <label for="from"><spring:message code="lbl.from"></spring:message> :</label>
									<input type="date" class="form-control" id="from">
								</div>
								<div class="col-lg-3 form-group">
									<label for="to"><spring:message code="lbl.to"></spring:message>:</label>
									<input type="date" class="form-control" id="to">
								</div>
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="" class="btn btn-primary" value="confirm">View</button>
								</div>
     							</div>
							<br/>
						<h3>Stock Report : </h3>
						<table class="table table-striped table-bordered " id="requisitionListForAm">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.date"></spring:message></th>
									<th><spring:message code="lbl.requisitionId"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.requisitionBy"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>
							<tbody>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							</tbody>
						</table>
					</div>
					
				</div>		
					
			</div>
		</div>
		</br>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>
	<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		$('#requisitionListForAm').DataTable();
});


</script>



















