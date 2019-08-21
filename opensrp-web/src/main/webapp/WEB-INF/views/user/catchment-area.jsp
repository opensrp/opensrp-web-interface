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
    <link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/multi-select.css"/>" rel="stylesheet">
    <title><spring:message code="lbl.viewLocationsHierarchy"/> </title>
    <%@page import="org.json.JSONObject" %>
    <%@page import="org.json.JSONArray" %>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<%
    JSONArray locationTreeData = (JSONArray)session.getAttribute("locationTreeData");
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
                        <button
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
            var i, j, r = [], z = [];
            var id = data.selected[0];
            r = data.instance.get_node(id).children;

            for (i = 0; i < r.length; i++) {
                z.push({
                    name: data.instance.get_node(r[i]).text,
                    id: data.instance.get_node(r[i]).id,
                });
            }
            for (i = 0; i < z.length; i++) {
                console.log(data.instance.get_node(z[i].id).icon);
                $('#locations').multiSelect('addOption', {
                    value: z[i].id,
                    text: z[i].name,
                    index: i
                });
            }
        }).jstree();
    });
</script>
</body>
</html>

