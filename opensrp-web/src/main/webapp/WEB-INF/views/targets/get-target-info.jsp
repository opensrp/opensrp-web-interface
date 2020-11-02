<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:choose>
	<c:when test="${!empty targets}">
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
	</c:when>
	<c:otherwise>
	<c:forEach var="product" items="${ productList }">
		<div class="col-lg-6 form-group">
			<div class="col-md-6">
	           	<label><strong>${ product.name } </strong></label>
	           </div>
	            <div class="col-md-6">
	           	<input type="number" class="form-control" min="1" id="${product.id }" name ="qty[]">
	           </div>
		</div>
	</c:forEach>
	</c:otherwise>
 </c:choose>  	
				       
					
						





