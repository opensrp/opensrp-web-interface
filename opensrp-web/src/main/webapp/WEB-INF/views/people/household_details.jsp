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
						
						<div class="tabbable tabbable-custom tabbable-noborder">
							<ul class="nav nav-tabs">
							
								<li data-target="#hh_info" role="tab" data-toggle="tab" class="active btn btn-success btn-sm">
									
									Household information
									
								</li>
								<li data-target="#member_info" role="tab" data-toggle="tab" class="btn btn-success btn-sm">
									
									Member information 
								</li>
								<li data-target="#reg_visit" role="tab" data-toggle="tab" class="btn btn-success btn-sm">
									
									Registration & visits
								</li>
							</ul>
							<div class="tab-content">
								<div class="tab-pane active" id="hh_info">								
									<div class="margin-top-10">
										<div class="col-md-12 form-group">						
							
								            <div class="form-group">
									           
								              <div class="row">
								                 <div class="col-lg-4 form-group"> 
								                	<label class="control-label"><strong>Patient name : </strong> lajsjsd	</label>
								                  	
								                 </div>
								                  <div class="col-lg-4 form-group">
								                    <label class="control-label"><strong>Patient phone number </strong><span class="required">* </span>	</label> 
								                       <input  type="text" disabled pattern="^(?:\+88|01)?\d{11}\r?$"  class="form-control validate" name="mobileNumber" id ="callerMobile"  value="${patient.getMobileNumber()}">    
								                  </div>
								                  
								                  
								                  
								              </div>
								            </div> 
								        </div>
									</div>								
								</div>
								
								
								<div class="tab-pane" id="member_info">								
									<div class="margin-top-10">
										<div class="col-md-12 form-group">						
							
								            <div class="form-group">
									           
								              <div class="row">
								                 <div class="col-lg-4 form-group"> 
								                	<label class="control-label"><strong>Patient name : </strong> lajsjsd	</label>
								                  	
								                 </div>
								                  <div class="col-lg-4 form-group">
								                    <label class="control-label"><strong>Patient phone number </strong><span class="required">* </span>	</label> 
								                       <input  type="text" disabled pattern="^(?:\+88|01)?\d{11}\r?$"  class="form-control validate" name="mobileNumber" id ="callerMobile"  value="${patient.getMobileNumber()}">    
								                  </div>
								                  
								                  
								                  
								              </div>
								            </div> 
								        </div>
									</div>								
								</div>
								
								
								
								<div class="tab-pane" id="reg_visit">								
									<div class="margin-top-10">
										<div class="col-md-12 form-group">						
							
								            <div class="form-group">
									           
								              <div class="row">
								                 <div class="col-lg-4 form-group"> 
								                	<label class="control-label"><strong>Patient name : </strong> lajsjsd	</label>
								                  	
								                 </div>
								                  <div class="col-lg-4 form-group">
								                    <label class="control-label"><strong>Patient phone number </strong><span class="required">* </span>	</label> 
								                       <input  type="text" disabled pattern="^(?:\+88|01)?\d{11}\r?$"  class="form-control validate" name="mobileNumber" id ="callerMobile"  value="${patient.getMobileNumber()}">    
								                  </div>
								                  
								                  
								                  
								              </div>
								            </div> 
								        </div>
									</div>								
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

<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		
});




</script>

















