<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    List<Object[]>  dataList = (List<Object[]>)session.getAttribute("data");
%>
    <option value=""><spring:message code="lbl.pleaseSelect"/></option>
<%
    for (Object[] objects : dataList) {%>
    <option value="<%=objects[1]%>"><%=objects[2]%>(<%=objects[1]%>)</option>
<%
    }
%>
