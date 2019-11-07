<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<%
    List<Object[]> houseHoldReports = (List<Object[]>)session.getAttribute("aggregatedReport");
%>

<%
    for( Object[] list: houseHoldReports ) {
%>
<tr>
    <td>
        <% if (list[24] != null) {%>
        <%=list[24]%>(<%=list[0]%>)
        <%} else {%>
        <%=list[0]%>
        <% } %>
    </td>
    <td><%=list[1]%></td><!--household registered-->
    <td><%=list[3]%></td><!--vo-->
    <td><%=list[2]%></td><!--nvo-->
    <td><%=list[4]%></td><!--total-->
    <td><%=list[5]%></td><!--population-3-->
    <td><%=list[6]%></td> <!--zero to six-->
    <td><%=list[7]%></td><!--seven to twelve-->
    <td><%=list[8]%></td><!--thirteen to eighteen-->
    <td><%=list[9]%></td><!--nineteen to twenty four-->
    <td><%=list[10]%></td><!--twenty five to thirty six-->
    <td><%=list[11]%></td><!--thirty seven to sixty-->
    <td><%=list[12]%></td><!--children under five years-->
    <td><%=list[13]%></td><!--children 5-10 years-->
    <td><%=list[14]%></td><!--adolescent male-->
    <td><%=list[15]%></td><!--adolescent female-->
    <td><%=list[16]%></td><!--adolescent total-->
    <td><%=list[17]%></td><!--aged 19-35 years male-->
    <td><%=list[18]%></td><!--aged 19-35 years female-->
    <td><%=list[19]%></td><!--aged 19-35 years total-->
    <td><%=list[20]%></td><!--number of population 35/35 years old-->
    <td><%=list[21]%></td><!--number of sanitary with hh-->
    <td><%=list[22]%></td><!--number of sanitary with hh-->
    <td><%=list[23]%></td><!--number of sanitary with hh-->
</tr>
<%
    }
%>
