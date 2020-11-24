<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
		   uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Households</title>
	
	

<c:url var="get_url" value="/rest/api/v1/people/household/list" />


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
							<i class="fa fa-list"></i>Households
						</div>
					</div>					
					<div class="portlet-body">
						<div class="form-group">
							
							<jsp:include page="/WEB-INF/views/search-oprions-with-branch.jsp" />
							
							
							<div class="row">
								
								<div class="col-lg-3 form-group">
								    <label for="designation"></label>
									<input name="search" class="form-control"id="search" placeholder="Search Key"/> 
								</div>
								
								
							</div>
							<div class="row">
								<div class="col-lg-12 form-group text-right">
									<button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
								</div>
     						</div>
     						
     						
						</div>
						
						<div class="row" style="margin: 0px">
		                    <div class="col-sm-12" id="content" style="overflow-x: auto;">
		                   
		                        <div id="report">
		                        	<table class="table table-striped table-bordered " id="householdTable" style="width: 100%;">
							<thead>
								<tr>
								 	<th>HH ID</th>
									<th>HH head name</th>
									<th>#Members</th>
									<th>Registration date</th>
									<th>Last visit date</th>
									<th>Village</th>
									<th>Branch(code)</th>
									<th>Contact</th>
									<th>Action</th>
								</tr>
								
							</thead>
							<tbody>
								<c:forEach items="${households}" var="household">
									<tr>
										<%-- <c:forEach items='${households.get("exampleMap ").entrySet()}' var="category">
										      <a:dropdownOption value="${category.key}">${category.key} </a:dropdownOption>
										</c:forEach> --%>
										<td> ${household.getHouseholdId() }</td>
										<td> ${household.getHouseholdHead() }</td>
										<td> ${household.getNumberOfMember() }</td>
										<td> ${household.getRegistrationDate() }</td>
										<td> ${household.getLastVisitDate() }</td>
										<td> ${household.getVillage() }</td>
										<td> ${household.getBranchName() }(${ household.getBranchCode()})</td>
										<td> ${household.getContact() }</td>
										<td> <a href="<c:url value="/people/household-details/${household.getBaseEntityId()}/${household.getId() }.html?lang=${locale}"/>">Details</a></td>
									</tr>
								</c:forEach>
							</tbody>
							
						</table>
		                        </div>
		                        
		                    </div>
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
<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		
});




</script>
<script>
    let stockList;
    
    $(document).ready(function() {
    	$('#householdTable').DataTable({
    		scrollY:        "300px",
    	    scrollX:        true,
    	    scrollCollapse: true,                
    		 fixedColumns:   {
    	         leftColumns: 2
    	     }
    	})
    });


</script>
















