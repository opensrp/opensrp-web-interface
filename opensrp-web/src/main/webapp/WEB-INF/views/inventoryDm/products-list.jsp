<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Product List</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title"></div>

			<div class="portlet-body">
				<div class="col-lg-12  requisition-add">
					<div class="col-lg-12  form-group ">
					<a class="btn btn-primary pull-right " id="addRequisition"
						href="<c:url value="/inventorydm/add-product.html?lang=${locale}"/>">
						<strong> Add Product </strong>
					</a>
					</div>
				</div>
					<table class="table table-striped table-bordered" id="productListDm">
						<thead>
							<tr>
								
								<th><spring:message code="lbl.serialNo"></spring:message></th>
								<th><spring:message code="lbl.productName"></spring:message></th>
								<th><spring:message code="lbl.description"></spring:message></th>
								<th><spring:message code="lbl.purchasePrice"></spring:message></th>
								<th><spring:message code="lbl.sellingPrice"></spring:message></th>
								<th><spring:message code="lbl.seller"></spring:message></th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="product" items="${ productList }">
									<tr>
										<td>${ product.id }</td>
										<td>${ product.name }</td>
										<td>${ product.description }</td>
										<td>${ product.purchasePrice }</td>
										<td>${ product.sellingPrice }</td>
										<td>${ product.buyers }</td>
										<td><a href="<c:url value="/inventorydm/${product.id}/edit-product.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a></td>
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
<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
		var table =$('#productListDm').DataTable({
			  "pageLength": 10,
			  scrollY:        "300px",
              scrollX:        true,
              scrollCollapse: true,
              fixedColumns:   {
                  leftColumns: 2/* ,
               rightColumns: 1 */
              }
		});
		
		table.on( 'order.dt search.dt', function () {
	        table.column(0, {search:'applied', order:'applied'}).nodes().each( function (cell, i) {
	            cell.innerHTML = i+1;
	        } );
	    } ).draw();
});
</script>



















