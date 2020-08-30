<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<c:forEach var="target" items="${ targets }">
	<div class="col-lg-6 form-group">
		<div class="col-md-6">
	          	<label><strong>${ target.getProductName() } </strong></label>
	     </div>
	     <div class="col-md-6">
	        	<input type="number" value="${target.getQuantity() }" class="form-control" min="1" id="${target.getProductId() }" name ="qty[]">
	      </div>
	</div>
</c:forEach>
   	
				       
					
						





