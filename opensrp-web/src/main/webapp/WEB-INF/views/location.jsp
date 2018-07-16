<%@page import="java.util.List"%>
<%   
   List<Object[]>  dataList = (List<Object[]>)session.getAttribute("data");
 %>
    <option value="0?">Please Select</option>
    <%   for (Object[] objects : dataList) {%>
             <option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>    <% 
         }
    %>             
