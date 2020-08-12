<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Current Inventory List</title>
	
	


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
							<i class="fa fa-list"></i><spring:message code="lbl.inventory"/>
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							<div class="row">
							<!-- <div class="col-lg-1 form-group" style="margin-top: 5px;">
									<label for="designation">Designation:</label>
								</div> -->
								<div class="col-lg-3 form-group">
								<select class="form-control" name="designation" id="designation">
								<option selected="selected">Select Designation</option>
								  <option value="volvo">SK</option>
								  <option value="saab">PS</option>
								  <option value="mercedes">SS</option>
								  
								</select>
								</div>
								<div class="col-lg-3 form-group">
									<button type="submit" onclick=""
										class="btn btn-primary">
										<spring:message code="lbl.viewStock" />
									</button>
								</div>
							</div>
						</div>
						<table class="table table-striped table-bordered " id="passStockInventoryList">
							<thead>
								<tr>
									<th><spring:message code="lbl.serialNo"></spring:message></th>
									<th><spring:message code="lbl.date"></spring:message></th>
									<th><spring:message code="lbl.invoiceNo"></spring:message></th>
									<th><spring:message code="lbl.stockInId"></spring:message></th>
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
							<td><a class="btn btn-primary" id="passStock" href="<c:url value="/inventoryam/individual-stock/${id}/321.html?lang=${locale}"/>">
					<strong>
					Pass Stock
				</strong></a></td>
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
		$('#passStockInventoryList').DataTable();
});
</script>



















