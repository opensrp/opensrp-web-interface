<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="java.util.List"%>
<%@ page import="org.opensrp.core.entity.User" %>
<%@ page import="org.opensrp.common.dto.UserDTO" %>

<%
    List<UserDTO> users = (List<UserDTO>) session.getAttribute("allSS");
    List<UserDTO> ssWithoutCatchment = (List<UserDTO>) session.getAttribute("ssWithoutCatchment");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><spring:message code="lbl.userList"/></title>
    <link type="text/css" href="<c:url value="/resources/css/jquery.toast.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/multi-select.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid">

      <c:url var="back" value="/user/sk-list.html" />


        <div class="form-group">
           <a href="${back }"><strong>My SK </strong></a>  |
            <% if(AuthenticationManagerUtil.isPermitted("PERM_ADD_SS")){ %>
            <a  href="<c:url value="/user/add-SS.html?skId=${skId}&skUsername=${skUsername}&lang=${locale}"/>">
                <strong>
                    <spring:message code="lbl.addNew"/>
                    <spring:message code="lbl.ss"/>
                </strong> </a> <%} %>
        </div>

        <!-- Modal for change SK - start -->
        <div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050"
             id="change-sk" class="modal">
            <div id="modal-sk-body" class="row">
                <div class="col-6 tag-height">
                    <div class="form-group required">
                        <label class="label-width"  for="branches">
                            <spring:message code="lbl.branches"/>
                        </label>
                        <select id="branches"
                                class="form-control mx-sm-3 js-example-basic-multiple"
                                name="branches" required>
                            <c:forEach items="${branches}" var="branch">
                                <option value="${branch.id}">${branch.name} (${branch.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="col-6 tag-height">
                    <label><spring:message code="lbl.sk"/></label>
                    <select class="custom-select custom-select-lg mb-3" id="skList" name="sk">
                    </select>
                </div>

                </div>
            <a class="btn btn-sm btn-dark" href="#" rel="modal:close" style="float: right; bottom: 0px">Close</a>
        </div>
        <!-- Modal End-->


        <!--Modal for catchment - start-->
        <div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050"
             id="catchment-area" class="modal">
            <div id ="modal-body" class="row">
                <div class="col-sm-5" style="overflow-y: auto; height: 350px;">
                    <div id="locationTree">
                    </div>
                </div>
                <div class="col-sm-6" style="height: 350px;">
                    <select id='locations' multiple='multiple'>
                    </select>
                </div>
                <div class="col-sm-1" style="height: 350px;">
                    <div class="row">
                        <button id="saveCatchmentArea"
                                disabled = true
                                class="btn btn-primary btn-sm"
                                style="position: absolute; top: 50%;
                                transform: translateY(-50%);">
                            Save
                        </button>
                        <p id="pleaseWait" style="display: none; color: red;">Please wait...</p>
                    </div>
                </div>
            </div>
            <div id="table-body" class="row" style="overflow-x: auto; margin-bottom: 10px;">
            </div>
            <a class="btn btn-sm btn-dark" href="#" onclick="closeMainModal()" style="float: right; bottom: 0px">Close</a>
            <div class="modal" id="delete-modal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 70%;">
                <h4>Do you really want to delete this location from this SS?</h4>
                <a class="btn btn-sm btn-danger" href="#" onclick="deleteConfirm()" style="float: right; bottom: 0px; margin-left: 5px;">Yes</a>
                <a class="btn btn-sm btn-dark" href="#" rel="modal:close" style="float: right; bottom: 0px">Close</a>
            </div>

        </div>
        <!--Modal start-->


        <!-- Example DataTables Card-->
        <div class="card mb-3">
            <div class="card-header">
                SS List
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="display" id="userList">
                        <thead>
                        <tr>
                            <th><spring:message code="lbl.fullName"></spring:message></th>
                            <th><spring:message code="lbl.userName"></spring:message></th>
                            <th><spring:message code="lbl.phoneNumber"></spring:message></th>
                            <th><spring:message code="lbl.branches"></spring:message></th>
                            <th><spring:message code="lbl.village"></spring:message></th>
                            <th><spring:message code="lbl.action"></spring:message></th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (users != null){
                                for (UserDTO user: users) {
                                    Integer id = user.getId();
                                    session.setAttribute("ssId", id);
                        %>
                        <tr>
                            <td><%=user.getFullName()%></td>
                            <td><%=user.getUsername()%></td>
                            <td><%=user.getMobile()%></td>
                            <td><%=user.getBranches()%></td>
                            <td><%=user.getLocationList()%></td>
                            <td>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
                                <a href="<c:url value="/user/${skUsername}/${skId}/${ssId}/edit-SS.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> |  <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                <a href="#" onclick="catchmentLoad(${ssId})"><spring:message code="lbl.catchmentArea"/></a> | <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                <a href="#" onclick="changeSK(${ssId})"><spring:message code="lbl.changeSK"/></a> <%} %>

                            <%--                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>--%>
<%--                                <a href="<c:url value="/user/${ssId}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>--%>
                               
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>

        <br>
        <br>
<%--        <!-- Example DataTables Card-->--%>
<%--        <div class="card mb-3">--%>
<%--            <div class="card-header">--%>
<%--                <spring:message code="lbl.ssWithoutCatchment"/>--%>
<%--            </div>--%>
<%--            <div class="card-body">--%>
<%--                <div class="table-responsive">--%>
<%--                    <table class="display">--%>
<%--                        <thead>--%>
<%--                        <tr>--%>
<%--                            <th><spring:message code="lbl.fullName"></spring:message></th>--%>
<%--                            <th><spring:message code="lbl.userName"></spring:message></th>--%>
<%--                            <th><spring:message code="lbl.phoneNumber"></spring:message></th>--%>
<%--                            <th><spring:message code="lbl.branches"></spring:message></th>--%>
<%--                            <th><spring:message code="lbl.action"></spring:message></th>--%>
<%--                        </tr>--%>
<%--                        </thead>--%>
<%--                        <tbody>--%>
<%--                        <%--%>
<%--                            if (users != null){--%>
<%--                                for (UserDTO user: ssWithoutCatchment) {--%>
<%--                                    Integer id = user.getId();--%>
<%--                                    session.setAttribute("ssId", id);--%>
<%--                        %>--%>
<%--                        <tr>--%>
<%--                            <td><%=user.getFullName()%></td>--%>
<%--                            <td><%=user.getUsername()%></td>--%>
<%--                            <td><%=user.getMobile()%></td>--%>
<%--                            <td><%=user.getBranches()%></td>--%>
<%--                            <td>--%>
<%--                                <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>--%>
<%--                                <a href="<c:url value="/user/${skUsername}/${skId}/${ssId}/edit-SS.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> |  <%} %>--%>
<%--                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>--%>
<%--                                <a href="<c:url value="/user/${ssId}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>--%>
<%--                               --%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <%--%>
<%--                                }--%>
<%--                            }--%>
<%--                        %>--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="card-footer small text-muted"></div>--%>
<%--        </div>--%>
    </div>
</div>
<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>
<script src="<c:url value='/resources/js/jquery.toast.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.modal.min.js'/>"></script>
<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.multi-select.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script>
    var isTeamMember = false;
    var currentSK = -1;
    var currentSS = -1;
    var currentLocation = -1;
    var currentRow = -1;
    $(document).ready(function () {
        var heading = "<%=(String) session.getAttribute("heading")%>";
        var toastMessage = "<%=(String) session.getAttribute("toastMessage")%>";
        var icon = "<%=(String) session.getAttribute("icon")%>";
        console.log("heading: "+ toastMessage);
        if (heading != null && heading != "" && heading != 'null') {
            $.toast({
                heading: heading,
                text: toastMessage,
                icon: icon,
                position: 'top-right',
                loader: false
            });
        }
        <%
            session.setAttribute("heading", "");
            session.setAttribute("toastMessage", "");
            session.setAttribute("icon", "");
        %>
        $('#locationTree').jstree();
        $('#locations').multiSelect();
    });

    $('#locations').change(function(){
        if ($('#locations').val() != null) {
            $('#saveCatchmentArea').prop('disabled', false);
        } else {
            if (tempEdit == true) {
                $('#saveCatchmentArea').prop('disabled', false);
            } else {
                $('#saveCatchmentArea').prop('disabled', true);
            }
        }
    });

    function catchmentLoad(ssId) {
        currentSS = ssId;
        $('#locationTree').jstree(true).destroy();
        $('#table-body').html("");
        $('#locations option').remove();
        $('#locations').multiSelect('refresh');
        $('#catchment-area').modal({
            escapeClose: false,
            clickClose: false,
            show: true
        });

        var url = "/opensrp-dashboard/rest/api/v1/user/"+ssId+"/catchment-area";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            contentType : "application/json",
            type: "GET",
            url: url,
            dataType : 'json',

            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(e, data) {
                isTeamMember = e["isTeamMember"];
                var locationData = e["locationTree"];
                var assignedLocation = e["assignedLocation"];
                var catchmentAreas = e["catchmentAreas"];
                var catchmentAreaTable = e["catchmentAreaTable"];
                console.log(catchmentAreaTable[0]);
                $('#locationTree').jstree({
                    'core' : {
                        'data' : locationData
                    },
                    'checkbox' : {
                        'keep_selected_style' : false
                    },
                    'plugins': [
                        'sort', 'wholerow'
                    ]
                });
                $('#locationTree').on("changed.jstree", function (e, data) {
                    tempEdit = false;
                    $('#saveCatchmentArea').prop('disabled', true);
                    $('#locations option').remove();
                    $('#locations').multiSelect('refresh');
                    var selectedAreas = [];
                    var i, j, r = [], z = [];
                    for (var i = 0; i < catchmentAreas.length; i++) {
                        selectedAreas[i] = catchmentAreas[i];
                    }
                    var id = data.selected[0];
                    var ids = [];
                    r = data.instance.get_node(id).children;

                    for (i = 0; i < r.length; i++) {
                        z.push({
                            name: data.instance.get_node(r[i]).icon,
                            id: data.instance.get_node(r[i]).id,
                        });
                    }

                    for (i = 0; i < z.length; i++) {
                        if (selectedAreas.indexOf(parseInt(z[i].id)) >= 0) {
                            ids.push(z[i].id);
                        }
                        $('#locations').multiSelect('addOption',{
                            value: z[i].id,
                            text: z[i].name,
                            index: i
                        });
                    }

                    for (i = 0; i < assignedLocation.length; i++) {
                        var locationId = assignedLocation[i]["locationId"];
                        if (assignedLocation[i]["userId"] != ssId) {
                            $("#locations option[value="+locationId+"]").attr("disabled", 'disabled');
                        }
                    }
                    $('#locations').val(ids);
                    $('#locations').multiSelect('refresh');
                }).jstree();

                //create catchment area table
                var content = "<table id='catchment-table' class='display'>";
                content += '<thead><tr><th>Division</th><th>District</th><th>City Corporation/Upazila</th><th>Pourashabha</th>' +
                    '<th>Union</th><th>Village</th><th>Action</th></tr></thead><tbody>';
                for(var y = 0; y < catchmentAreaTable.length; y++){
                    content += '<tr id="row'+y+'"><td>'+catchmentAreaTable[y][0]+'</td><td>'+catchmentAreaTable[y][1]+'</td>' +
                        '<td>'+catchmentAreaTable[y][2]+'</td><td>'+catchmentAreaTable[y][3]+'</td>' +
                        '<td>'+catchmentAreaTable[y][4]+'</td><td>'+catchmentAreaTable[y][5]+'</td>' +
                        '<td><button class="btn btn-sm btn-danger" onclick="deleteLocation('+catchmentAreaTable[y][6]+','+y+','+ssId+')">Delete</button></td></tr>';
                }
                content += "</tbody></table>";

                $('#table-body').append(content);
            },
            error : function(e) {
                console.log("ERROR OCCURRED");
                $('#locationTree').jstree();
            },
            done : function(e) {
                console.log("DONE");
                $('#locationTree').jstree();
            }
        });
    }

    function deleteLocation(locationId, row, ssId) {
        ssWithUCAId = [];
        currentSS = ssId;
        currentLocation = locationId;
        currentRow = row;
        console.log(locationId + " " + row);
        $('#delete-modal').modal({
            escapeClose: false,
            clickClose: false,
            closeExisting: false,
            show: true
        });
    }

    function deleteConfirm() {
        console.log("in delete confirm");
        var ssWithLocation = {
            ss_id: currentSS,
            ss_location_id: currentLocation
        };
        console.log(ssWithLocation);
        var url = "/opensrp-dashboard/rest/api/v1/user/delete-ss-location";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
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
                console.log(e);
                console.log("in success delete confirm");
                console.log(data);
                $('#row'+currentRow).remove();
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

    $('#saveCatchmentArea').unbind().click(function () {
        $('#saveCatchmentArea').prop('disabled', true);
        $('#pleaseWait').show();
        var url = "";
        if (isTeamMember == true) {
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/update";
        } else {
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/save";
        }
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var allLocation = [];
        $("#locations option").each(function() {
            allLocation.push($(this).val());
        });
        var ssId = currentSS;
        var formData = {
            allLocation: allLocation,
            locations: $('#locations').val(),
            userId: ssId
        };

        $.ajax({
            contentType : "application/json",
            type: "POST",
            url: url,
            data: JSON.stringify(formData),
            dataType : 'json',

            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(e, data) {
                $('#table-body').html("");
                var catchmentAreaTable = e["catchmentAreaTable"];
                $('#locations option').remove();
                $('#locations').multiSelect('refresh');
                $('#pleaseWait').hide();
                //create catchment area table
                var content = "<table id='catchment-table' class='display'>";
                content += '<thead><tr><th>Division</th><th>District</th><th>City Corporation/Upazila</th><th>Pourashabha</th>' +
                    '<th>Union</th><th>Village</th><th>Action</th></tr></thead><tbody>';
                for(var y = 0; y < catchmentAreaTable.length; y++){
                    content += '<tr id="row'+y+'"><td>'+catchmentAreaTable[y][0]+'</td><td>'+catchmentAreaTable[y][1]+'</td>' +
                        '<td>'+catchmentAreaTable[y][2]+'</td><td>'+catchmentAreaTable[y][3]+'</td>' +
                        '<td>'+catchmentAreaTable[y][4]+'</td><td>'+catchmentAreaTable[y][5]+'</td>' +
                        '<td><button class="btn btn-sm btn-danger" onclick="deleteLocation('+catchmentAreaTable[y][6]+','+y+','+ssId+')">Delete</button></td></tr>';
                }
                content += "</tbody></table>";

                $('#table-body').append(content);
            },
            error : function(e) {
                $('#saveCatchmentArea').prop('disabled', false);
                $('#pleaseWait').hide();
            },
            done : function(e) {
                $('#saveCatchmentArea').prop('disabled', false);
                $('#pleaseWait').hide();
            }
        });
    });

    function closeMainModal() {
        window.location.reload();
        $.modal.getCurrent.close();
    }

    function changeSK(ssId) {
        currentSS = ssId;
        console.log("Present value");
        $('#change-sk').modal({
            escapeClose: false,
            clickClose: false,
            show: true
        });

        var url = "/opensrp-dashboard/branches/sk?branchId="+$("#branch").val();
        $("#skList").html("");
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function() {},
            success : function(e, data) {
                console.log(e);
                console.log(data);
                $("#skList").html(e);
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {

                console.log("DONE");
                //enableSearchButton(true);
            }
        });
    }

    $('#branches').change(function (e) {
       e.preventDefault();

    });
</script>
