<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.UserDTO" %>
<%@ page import="antlr.StringUtils" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    List<Object[]> catchmentAreaTable = (List<Object[]>) session.getAttribute("catchmentAreaTable");
    Integer userId = (Integer) session.getAttribute("userIdFromCatchment");
%>
<head>
<%--    <link type="text/css"--%>
<%--          href="<c:url value="/resources/vendor/bootstrap/css/bootstrap.min.css"/>"--%>
<%--          rel="stylesheet"--%>
<%--          http-equiv="Cache-control" content="public">--%>
<%--    <link type="text/css"--%>
<%--          href="<c:url value="/resources/css/style.css"/>"--%>
<%--          rel="stylesheet">--%>
<%--    <link type="text/css"--%>
<%--          href="<c:url value="/resources/vendor/font-awesome/css/font-awesome.min.css"/>"--%>
<%--          rel="stylesheet">--%>
<%--    <link type="text/css"--%>
<%--          href="<c:url value="/resources/css/jquery-ui.css"/>" rel="stylesheet">--%>
    <link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">
</head>
<div>

    <div class="modal" id="delete-modal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 70%;">
        <h4>Do you really want to delete this location from this user?</h4>
        <p style="display: none;" id="delete-ss-validation"></p>
        <span id="delete-failed" style="color: red; font-weight: bold; display: none;">Something went wrong. Please try again...</span>
        <a class="btn btn-sm btn-danger" href="#" onclick="deleteConfirm()" style="float: right; bottom: 0px; margin-left: 5px;">Yes</a>
        <a class="btn btn-sm btn-dark" href="#" onclick="window.location.reload()" style="float: right; bottom: 0px">Close</a>
    </div>
    <table id='catchment-table' class='display'>
        <thead>
        <tr>
            <th>Division</th>
            <th>District</th>
            <th>City Corporation/Upazila</th>
            <th>Pourasabha</th>
            <th>Union</th>
            <th>Village</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            Integer idx = 0;
            for(Object[] c: catchmentAreaTable){
                for (int i = 0; i < 6; i++) {
                    if (org.apache.commons.lang3.StringUtils.isBlank((CharSequence) c[i])) c[i] = "All";
                }
        %>
        <tr id="row"<%=idx%>>
            <td><%=c[0]%></td>
            <td><%=c[1]%></td>
            <td><%=c[2]%></td>
            <td><%=c[3]%></td>
            <td><%=c[4]%></td>
            <td><%=c[5]%></td>
            <td>
                <button class="btn btn-sm btn-danger" onclick="deleteLocation(<%=c[6]%>,<%=idx%>,<%=userId%>)">Delete</button>
            </td>
        </tr>;
        <% idx++; } %>
        </tbody>
    </table>

</div>
<%--<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>--%>
<%--<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>--%>
<script src="<c:url value='/resources/js/jquery.modal.min.js'/>"></script>
<script>
    let currentUser, currentLocation;
    function deleteLocation(locationId, row, userId) {
        console.log(locationId + " " +row + " " + userId);
        currentUser = userId;
        currentLocation = locationId;
        $('#delete-modal').modal({
            escapeClose: false,
            clickClose: false,
            showClose: false,
            show: true
        });
    }

    function deleteConfirm() {
        console.log("in delete confirm");
        let userWithLocation = {
            ss_id: currentUser,
            ss_location_id: currentLocation
        };
        console.log(userWithLocation);
        let url = "/opensrp-dashboard/rest/api/v1/user/delete-ss-location";
        let token = $("meta[name='_csrf']").attr("content");
        let header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            contentType : "application/json",
            type: "DELETE",
            url: url,
            dataType : 'json',
            data: JSON.stringify(userWithLocation),
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(e, data) {
                window.location.reload();
            },
            error : function(e) {
                $('#delete-failed').show();
                console.log(e);
                console.log("In error");
            },
            done : function(e) {
                console.log(e);
                console.log("In done");
            }
        });
    }
</script>