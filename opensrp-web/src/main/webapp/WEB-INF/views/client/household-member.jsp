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
        <meta name="_csrf" content="${_csrf.token}"/>
        <!-- default header name is X-CSRF-TOKEN -->
        <meta name="_csrf_header" content="${_csrf.headerName}"/>
        <title>Form Wise Report Status</title>

        <jsp:include page="/WEB-INF/views/css.jsp" />
        <link type="text/css"
              href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>"
              rel="stylesheet">
        <style>
            .modal {
                display: none; /* Hidden by default */
                position: fixed; /* Stay in place */
                z-index: 1; /* Sit on top */
                padding-top: 100px; /* Location of the box */
                left: 0;
                top: 0;
                width: 100%; /* Full width */
                height: 100%; /* Full height */
                overflow: auto; /* Enable scroll if needed */
                background-color: rgb(0,0,0); /* Fallback color */
                background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            }

            /* Modal Content */
            .modal-content {
                background-color: #fefefe;
                margin: auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
            }

            /* The Close Button */
            .close {
                color: #aaaaaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }

            .close:hover,
            .close:focus {
                color: #000;
                text-decoration: none;
                cursor: pointer;
            }
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
                            <div style="margin: auto;">
                                <img style="height: 300px; width: 300px;" src="http://103.247.238.37:8080/opt/multimedia/images/<%=member[1]%>.jpg"/>
                            </div>
                        </div>
                        <div class="row" style="margin-top: 30px;">
                            <div class="col-sm-12" id="content">
                                <table>
                                    <tr>
                                        <td>Name</td>
                                        <td><%=member[9]%> <%=member[13]%></td>
                                    </tr>
                                    <tr>
                                        <td>Name (Bangla)</td>
                                        <td><%=member[41]%></td>
                                    </tr>
                                    <tr>
                                        <td>Father Name</td>
                                        <td><%=member[33]%></td>
                                    </tr>
                                    <tr>
                                        <td>Father Name (Bangla)</td>
                                        <td><%=member[39]%></td>
                                    </tr>
                                    <tr>
                                        <td>Mother Name</td>
                                        <td><%=member[32]%></td>
                                    </tr>
                                    <tr>
                                        <td>Mother Name (Bangla)</td>
                                        <td><%=member[40]%></td>
                                    </tr>
                                    <tr>
                                        <td>Husband Name</td>
                                        <td><%=member[19]%></td>
                                    </tr>
                                    <tr>
                                        <td>Husband Name (Bangla)</td>
                                        <td><%=member[38]%></td>
                                    </tr>
                                    <tr>
                                        <td>Date of Birth</td>
                                        <td><%=member[3]%></td>
                                    </tr>

                                    <tr>
                                        <td>Gender</td>
                                        <td>
                                            <%if (member[10].equals("M")){%>
                                            Male
                                            <%} else {%>
                                            Female
                                            <%}%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Religion</td>
                                        <td><%=member[37]%></td>
                                    </tr>
                                    <tr>
                                        <td>Division</td>
                                        <td><%=member[8]%></td>
                                    </tr>
                                    <tr>
                                        <td>District</td>
                                        <td><%=member[7]%></td>
                                    </tr>
                                    <tr>
                                        <td>Upazila</td>
                                        <td><%=member[22]%></td>
                                    </tr>
                                    <tr>
                                        <td>Union</td>
                                        <td><%=member[21]%></td>
                                    </tr>
                                    <tr>
                                        <td>Ward</td>
                                        <td><%=member[23]%></td>
                                    </tr>

                                </table>
                            </div>
                        </div>

                        <br>

                        <div class="row">
                            <div class="btn-group" role="group" aria-label="Basic example" valign="center" style="margin: auto;">
                                <button id="review" type="button" class="btn btn-danger">Review</button>
                                <button id="approve" type="button" class="btn btn-success">Approve</button>
                            </div>
                        </div>

                        <div id="reviewModal" class="modal">

                            <!-- Modal content -->
                            <div class="modal-content">
                                <span class="close">&times;</span>
                                <input type="hidden" id="baseEntityId" name="baseEntityId" value=<%=member[1]%>>
                                <h4>Comment: </h4>
                                <textarea id="comment" rows="7" name="comment"></textarea>

                                <br>
                                <div class="btn-group" role="group" aria-label="Basic example" valign="center" style="margin: auto;">
                                    <button id="closeModal" type="button" class="btn btn-danger">Cancel</button>
                                    <button id="reviewSubmit" type="button" class="btn btn-success">Submit</button>
                                </div>

                            </div>

                        </div>

                    </div>
                </div>
            </div>
            <jsp:include page="/WEB-INF/views/footer.jsp" />
        </div>
    </body>
    <script>
        // Get the modal
        var modal = document.getElementById("reviewModal");

        // Get the button that opens the modal
        var btn = document.getElementById("review");

        var submit = document.getElementById("reviewSubmit");

        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

        // When the user clicks the button, open the modal
        btn.onclick = function() {
            modal.style.display = "block";
        };

        $("#closeModal").click(function () {
            modal.style.display = "none";
        });

        // When the user clicks on <span> (x), close the modal
        span.onclick = function() {
            modal.style.display = "none";
        };

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        };

        $("#reviewSubmit").click(function () {
            var url = "/opensrp-dashboard/rest/api/v1/client/approval";
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");

            var formData = {
                baseEntityId: $("#baseEntityId").val(),
                comment: $("#comment").val(),
                status: "0"

            };

            console.log(formData);

            $.ajax({
                contentType : "application/json",
                type: "POST",
                url: url,
                data: JSON.stringify(formData),
                dataType : 'json',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(header, token);
                },
                timeout : 100000,
                success : function(data) {
                    modal.style.display = "none";
                    window.location.replace("/opensrp-dashboard/client/household-member-list.html");
                },
                error : function(e) {
                    console.log("in error");
                    console.log(e);
                },
                done : function(e) {
                    console.log("DONE");
                }
            });
        });
        $("#approve").click(function () {
            var url = "/opensrp-dashboard/rest/api/v1/client/approval";
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");

            var formData = {
                baseEntityId: $("#baseEntityId").val(),
                comment: "",
                status: "1"

            };

            console.log(formData);

            $.ajax({
                contentType : "application/json",
                type: "POST",
                url: url,
                data: JSON.stringify(formData),
                dataType : 'json',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(header, token);
                },
                timeout : 100000,
                success : function(data) {
                    window.location.replace("/opensrp-dashboard/client/household-member-list.html");
                },
                error : function(e) {
                    console.log("in error");
                    console.log(e);
                },
                done : function(e) {
                    console.log("DONE");
                }
            });
        });
    </script>

</html>