<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@ page import="org.opensrp.common.dto.UserDTO" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%
    List<Object[]> catchmentAreaTable = (List<Object[]>) session.getAttribute("catchmentAreaTable");
    Integer userId = (Integer) session.getAttribute("userIdFromCatchment");
%>

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

<script>
    function deleteLocation(locationId, row, userId) {
        ssWithUCAId = [];
        currentSS = ssId;
        currentLocation = locationId;
        currentRow = row;
        console.log(locationId + " " + row);
        $('#delete-modal').modal({
            escapeClose: false,
            clickClose: false,
            showClose: false,
            closeExisting: false,
            show: true
        });
    }

    function deleteConfirm() {
        console.log("in delete confirm");
        let ssWithLocation = {
            ss_id: currentSS,
            ss_location_id: currentLocation
        };
        console.log(ssWithLocation);
        let url = "/opensrp-dashboard/rest/api/v1/user/delete-ss-location";
        let token = $("meta[name='_csrf']").attr("content");
        let header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            contentType : "application/json",
            type: "DELETE",
            url: url,
            dataType : 'json',
            data: JSON.stringify(ssWithLocation),
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(e, data) {
                catchmentLoad(currentSS, 1); // sending 1 as if modal does not close in catchment load method
                $.modal.getCurrent().close();
            },
            error : function(e) {
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