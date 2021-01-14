<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>My Inventory</title>
<c:url var="backUrl" value="/inventoryam/myinventory.html" />
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
				<li>
					<i class="fa fa-star" id="size_star" aria-hidden="true"></i> <span class="sub-menu-title"><strong>My inventory</strong> </span>  <a  href="<c:url value="/"/>">Home</a>
					 
				</li>				
				
				<li>
					/ Inventory  
				</li>
				
		</ul>
		
		<div class="row">
			<c:forEach items="${branches}" var="branch">
				<div class="col-sm myinventory-box" onclick="">
					<a
						href="<c:url value="/inventoryam/myinventory-list/${branch.id}.html?lang=${locale}"/>">${branch.name}
						(${branch.code})</a>
				</div>
			</c:forEach>
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
		var table =$('#sample_1').DataTable({
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



















