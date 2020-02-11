<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.UserDTO" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    List<UserDTO>  skList = (List<UserDTO>)session.getAttribute("skList");
    for (UserDTO sk : skList) {
%>
    <option value="<%=sk.getId()%>"><%=sk.getFullName()%>(<%=sk.getUsername()%>)</option>
<%  } %>
