<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/multi-select.css"/>" rel="stylesheet">
    <title><spring:message code="lbl.viewLocationsHierarchy"/> </title>
    <%@page import="org.json.JSONObject" %>
    <%@page import="org.json.JSONArray" %>
    <%@ page import="org.opensrp.core.entity.UsersCatchmentArea" %>
    <%@ page import="java.util.List" %>
    <%@ page import="org.opensrp.core.entity.User" %>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<%
    JSONArray locationTreeData = (JSONArray)session.getAttribute("locationTreeData");
    int userId = (int)session.getAttribute("userId");
    boolean isTeamMember = (boolean) session.getAttribute("isTeamMember");
    List<UsersCatchmentArea> usersCatchmentAreas = (List<UsersCatchmentArea>) session.getAttribute("usersCatchmentAreas");

%>
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid">
        <!-- Example DataTables Card-->
        <div class="form-group">
            <jsp:include page="/WEB-INF/views/location/location-tag-link.jsp" />
        </div>

        <div class="card mb-3">
            <div class="card-header">
                <spring:message code="lbl.viewLocationsHierarchy"/>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-sm-4">
                        <div id="locationTree">
                        </div>
                    </div>
                    <div class="col-sm-7">
                        <select id='locations' multiple='multiple'>
                        </select>
                    </div>
                    <div class="col-sm-1">
                        <input id="catchment-areas" value="<%=usersCatchmentAreas%>" type="hidden">
                        <input id="userId" value="<%=userId%>" type="hidden">
                        <button id="saveCatchmentArea"
                                class="btn btn-primary btn-sm"
                                style="position: absolute; top: 50%;
                                transform: translateY(-50%);">
                            Save
                        </button>
                    </div>
                </div>
            </div>
            <div class="card-footer small text-muted"></div>
        </div>
    </div>
    <!-- /.container-fluid-->
    <!-- /.content-wrapper-->
    <jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.multi-select.js'/>"></script>
<script type="text/javascript">
    $(document).ready(function () {

        $('#locationTree').jstree({
            'core' : {
                'data' : <%=locationTreeData %>
            },
            'checkbox' : {
                'keep_selected_style' : false
            },
            'plugins': [
                'sort', 'wholerow'
            ]
        });

        $('#locations').multiSelect();

        $('#locationTree').on('changed.jstree', function (e, data) {
            $('#locations option').remove();
            $('#locations').multiSelect('refresh');
            var selectedAreas = [];
            <% for (int i = 0; i < usersCatchmentAreas.size(); i++) {%>
            selectedAreas[<%=i%>] = <%=usersCatchmentAreas.get(i).getLocationId()%>
            <%}%>
            console.log(selectedAreas);
            var i, j, r = [], z = [];
            var id = data.selected[0];
            var ids = [];
            r = data.instance.get_node(id).children;

            for (i = 0; i < r.length; i++) {
                z.push({
                    name: data.instance.get_node(r[i]).text,
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

            $('#locations').val(ids);
            $('#locations').multiSelect('refresh');
            console.log($('#locations').val());
        }).jstree();

        $('#saveCatchmentArea').unbind().click(function () {
            var url = "";
            <% if (isTeamMember) {%>
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/update";
            <%} else {%>
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/save";
            <% } %>
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");
            var formData = {
                locations: $('#locations').val(),
                userId: $('#userId').val()
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
                success : function(data) {
                    if(data == ""){
                        window.location.replace("/opensrp-dashboard/user.html");
                    }

                },
                error : function(e) {
                    console.log(data);
                },
                done : function(e) {
                    console.log("DONE");
                }
            });
        });
    });
</script>
</body>
</html>

