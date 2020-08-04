<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: nahid
  Date: ৫/১১/১৯
  Time: ১১:৫১ AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer recordSize = (Integer) session.getAttribute("recordSize");
%>
<style>
    .table-bordered>tbody>tr>td {
        font-size: 13px;
    }
</style>
<div class="row">
    <div class="col-md-12">
        <div class="portlet box blue-madison">
            <div class="portlet-title">
                <div class="caption">
                    <i class="fa fa-table"></i><spring:message code="lbl.clientDataTable"/>
                </div>
            </div>
            <div class="portlet-body">
                <div class="table-responsive">
                    <div id="dataTable_wrapper"
                         class="dataTables_wrapper container-fluid dt-bootstrap4">
                        <div class="row">
                            <div class="col-sm-12">
                                <table class="table table-bordered table-striped dataTable" id="dataTable"
                                       style="width: 100%;">
                                    <thead>
                                    <tr>
                                        <% List<String> ths = (List<String>) session.getAttribute("headerList"); %>
                                        <% for(String str: ths) {%>
                                        <th><%=str%></th>
                                        <% } %>

                                </tr>
                                </thead>
                                <tfoot>

                                </tfoot>
                                <tbody>
                                <%  List<Object[]> allClientInfo = (List<Object[]>) session.getAttribute("clientInfoList");
                                    for(Object[] object: allClientInfo){
                                %>
                                <tr>
                                    <% for(Object obj: object){
                                        if (obj == null) {
                                    %>
                                    <td>N/A</td>
                                    <%} else { %>
                                    <td><%=obj%></td>
                                    <% } } %>
                                </tr>
                                <%  } %>

                                </tbody>
                            </table>
                        </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="/WEB-INF/views/pager.jsp" />
                <div style="margin: auto;">
                    <b style="text-align: center;">Total Number of Records: <%=recordSize%></b>
                </div>
            </div>
        </div>
    </div>
</div>

