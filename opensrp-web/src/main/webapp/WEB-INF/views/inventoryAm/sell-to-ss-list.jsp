<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Sell To SS</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Sell To SS
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="designation">Sk :</label>
									<input type="text" class="form-control" id="designation" readonly>
								</div>
								<div class="col-lg-3 form-group">
									<label for="date">Date:</label> <input
										type="date" class="form-control" id="date">
								</div>
							
							</div>
							<div class = "row">
							<div class="col-lg-8 form-group text-right">
									<button type="submit" onclick="" class="btn btn-primary"
										value="confirm">Sell To Many</button>
								</div>
								<div class="col-lg-2 form-group text-right">
									<button type="submit" onclick="" class="btn btn-primary"
										value="confirm">View SS List</button>
								</div></div>
						</div>
						
						<div style="overflow-x: auto">
						<h3>Inventory : </h3>
						<table class="table table-striped table-bordered " id="passStockInventoryList">
							<thead>
								<tr>
								    <th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.name"></spring:message></th>
									<th><spring:message code="lbl.designation"></spring:message></th>
									<th><spring:message code="lbl.skname"></spring:message></th>
									<th><spring:message code="lbl.branchNameCode"></spring:message></th>
									<th><spring:message code="lbl.saleinMonth"></spring:message></th>
									<th><spring:message code="lbl.actionRequisition"></spring:message></th>
								</tr>
							</thead>

						</table>
						</div>
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
		$('#sample_1').DataTable();
});
</script>



















