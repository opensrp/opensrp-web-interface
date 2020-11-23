<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page import="java.util.List" %>

<title>Stock Report</title>
	
	


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
	

<div class="page-content-wrapper">
		<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							<div class="row">
								<div class="col-lg-3 form-group">
								    <label for="branchList">Branch :</label>
								    <select
										name="branch" class="form-control" id="branchList">
										<option value="">All Branch</option>
										<%
											List<Branch> ret = (List<Branch>) session.getAttribute("branchList");
											for (Branch str : ret) {
										%>
										<option value="<%=str.getId()%>"><%=str.getName()%></option>
										<%}%>
									</select>
								</div>
								<div class="col-lg-3 form-group">
								    <label for="month">Month</label>

									<select class="form-control" id="month">
										<option value="">Select Month</option>
										<option value="1">January</option>
										<option value="2">February</option>
										<option value="3">March</option>
										<option value="4">April</option>
										<option value="5">May</option>
										<option value="6">June</option>
										<option value="7">July</option>
										<option value="8">August</option>
										<option value="9">September</option>
										<option value="10">October</option>
										<option value="11">November</option>
										<option value="12">December</option>
									</select>
								</div>
								<div class="col-lg-3 form-group">
									<label for="year">Year:</label>
									<select id="year" class="form-control" >
										<option value="">Select Year</option>
										<option value="2020">2020</option>
										<option value="2021">2021</option>
									</select>
								</div>
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="getStockReportForAm()" class="btn btn-primary" value="confirm">Submit</button>
								</div>
							</div>
							<br/>
						<h3>Stock Report : </h3>
						<table class="table table-striped table-bordered " id="stockReportforAm">
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

	getStockReportForAm();

});

function getStockReportForAm() {
	var url = "/opensrp-dashboard/inventoryam/stock-report-table";
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : url,
		dataType : 'html',
		timeout : 100000,
		data: {
			month: '09',
			year: '2020'
		},
		beforeSend: function() {
			$('#loading').show();
			$('#search-button').attr("disabled", true);
		},
		success : function(data) {
			$("#stockReportforAm").html(data);
		},
		error : function(e) {
			$('#loading').hide();
			$('#search-button').attr("disabled", false);
		},
		complete : function(e) {
			$('#loading').hide();
			$('#search-button').attr("disabled", false);
		}
	});
}

</script>



















