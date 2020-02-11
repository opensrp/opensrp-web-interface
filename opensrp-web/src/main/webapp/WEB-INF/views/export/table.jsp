<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: nahid
  Date: ৫/১১/১৯
  Time: ১১:৫১ AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div>
    <div class="card mb-3">
        <div class="card-header">
            <i class="fa fa-table"></i>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <div id="dataTable_wrapper"
                     class="dataTables_wrapper container-fluid dt-bootstrap4">
                    <div class="row">
                        <div class="col-sm-12">
                            <table class="table table-bordered dataTable" id="dataTable"
                                   style="width: 100%;">
                                <thead>
                                <tr>
                                    <th> Filename </th>
                                    <th> Status </th>
                                </tr>
                                </thead>
                                <tfoot>

                                </tfoot>
                                <tbody>
                                <%  List<Object[]> allClientInfo = (List<Object[]>) session.getAttribute("exportData");
                                    for(Object[] object: allClientInfo){
                                %>
                                <tr>
                                    <td> <a href="http://mhealthtest.brac.net:8080/opt/multimedia/export/<%=object[0]%>" > <%=object[0]%></a> </td>
                                    <td><%=object[1]%></td>
                                </tr>
                                <%  } %>

                                </tbody>
                            </table>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

