<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page import="org.opensrp.core.entity.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<%
    Object[] member = (Object[]) session.getAttribute("member");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="refresh"
              content="<%=session.getMaxInactiveInterval()%>;url=/login" />

        <title>Form Wise Report Status</title>

        <jsp:include page="/WEB-INF/views/css.jsp" />
        <link type="text/css"
              href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>"
              rel="stylesheet">
        <style>
            td{
                font-size: 14px;
                font-weight: bold;
            }
        </style>
    </head>

    <body class="fixed-nav sticky-footer bg-dark" id="page-top">
        <jsp:include page="/WEB-INF/views/navbar.jsp" />
        <div class="content-wrapper">
            <div class="container-fluid">
                <div class="card mb-3">
                    <div class="card-header">
                        <i class="fa fa-table"></i> Member Information
                    </div>
                    <div class="card-body">
                        <div>
                            <div>

                            </div>
                        </div>
                        <div class="row" style="margin-top: 30px;">
                            <div class="col-sm-12" id="content">
                                <table>
                                    <tr>
                                        <td>Name:</td>
                                        <td><%=member[9]%> <%=member[13]%></td>
                                    </tr>
                                    <tr>
                                        <td>Father Name:</td>
                                        <td><%=member[33]%></td>
                                    </tr>
                                    <tr>
                                        <td>Mother Name:</td>
                                        <td><%=member[32]%></td>
                                    </tr>
                                    <tr>
                                        <td>Husband Name:</td>
                                        <td><%=member[19]%></td>
                                    </tr>
                                    <tr>
                                        <td>Date of Birth:</td>
                                        <td><%=member[3]%></td>
                                    </tr>

                                    <tr>
                                        <td>Gender:</td>
                                        <td>
                                            <%
                                                if (member[10].equals("M")){
                                                    %>
                                            Male
                                            <%
                                                } else {
                                                    %>
                                            Female
                                            <%
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Religion:</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Division:</td>
                                        <td><%=member[8]%></td>
                                    </tr>
                                    <tr>
                                        <td>District:</td>
                                        <td><%=member[7]%></td>
                                    </tr>
                                    <tr>
                                        <td>Upazila:</td>
                                        <td><%=member[22]%></td>
                                    </tr>
                                    <tr>
                                        <td>Union:</td>
                                        <td><%=member[21]%></td>
                                    </tr>
                                    <tr>
                                        <td>Ward:</td>
                                        <td><%=member[23]%></td>
                                    </tr>

                                </table>
                            </div>
                        </div>

                        <div class="row">
                            <div class="btn-group" role="group" aria-label="Basic example" align="center">
                                <button type="button" class="btn btn-danger">Review</button>
                                <button type="button" class="btn btn-success">Approve</button>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <jsp:include page="/WEB-INF/views/footer.jsp" />
        </div>
    </body>
</html>