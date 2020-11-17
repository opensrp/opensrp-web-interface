<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Requistion Details</title>
	
	

<c:url var="backUrl" value="/inventoryam/requisition-list/${branchid }.html" />
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<a class="btn btn-primary" href="<c:url value="/"/>">Home</a>
					<i class="fa fa-arrow-right"></i>
				</li>
				<li>
					<a class="btn btn-primary" href="${backUrl }">Back</a>
				</li>
		</ul>
		<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class=center-caption>${branchInfo}</div>
						</div>
			<div class="portlet-body">
			<div class="col-sm-12 text-center"><h4><u>Requisition - ${requisitionId}</u></h4></div>
				
				<table class="table table-striped table-bordered"
					id="requisitionDetails">
					<thead>
						<tr>
							<th><spring:message code="lbl.date"></spring:message></th>
							<th><spring:message code="lbl.productName"></spring:message></th>
							<th><spring:message code="lbl.description"></spring:message></th>
							<th><spring:message code="lbl.quantity"></spring:message></th>
							<th><spring:message code="lbl.buyingPrice"></spring:message></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="requisition" items="${ requisitionList }">
							<tr>
								<td>${ requisition.requisition_date }</td>
								<td>${ requisition.product_name }</td>
								<td>${ requisition.description }</td>
								<td>${ requisition.quantity }</td>
								<td>${ requisition.buying_price }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
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
		$('#requisitionDetails').DataTable();
});
</script>



















