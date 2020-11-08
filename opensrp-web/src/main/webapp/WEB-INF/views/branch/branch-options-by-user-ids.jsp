<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<c:forEach items="${branches}" var="branch">
	<option value="${branch.id}">${branch.name}(${branch.code })</option>
</c:forEach>

