<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<h3><strong>${serviceName }</strong></h3>
<hr/>
<c:forEach begin="0" end="${reg_info.length() -1}" var="index">
	<c:choose>
		<c:when
			test="${configs.has(reg_info.getJSONObject(index).getString('key')) ==true && reg_info.getJSONObject(index).getString('value')!='null'}">
			<div class="col-lg-12 form-group">
				<label class="control-label"><strong>${configs.getString(reg_info.getJSONObject(index).getString("key"))}
						: </strong> ${reg_info.getJSONObject(index).getString("value")} </label>

			</div>
		</c:when>
	</c:choose>
</c:forEach>
