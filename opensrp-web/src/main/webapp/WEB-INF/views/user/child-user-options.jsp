<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<option value="0">Please select</option>
<c:forEach items="${users}" var="user">

	<option value="${user.getId()}">${user.getFullName() }</option>
</c:forEach>

