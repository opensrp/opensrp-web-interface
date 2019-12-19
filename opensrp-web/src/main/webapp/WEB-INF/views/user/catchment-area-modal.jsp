<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%@ page import="org.opensrp.core.entity.UsersCatchmentArea" %>
<%@ page import="java.util.List" %>
<%@ page import="org.opensrp.core.entity.User" %>
<%@ page import="org.opensrp.common.dto.UserAssignedLocationDTO" %>
<%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>

<%
    JSONArray locationTreeData = (JSONArray)session.getAttribute("locationTreeData");
    Integer userId = (Integer) session.getAttribute("userId");
    User user = (User) session.getAttribute("user");
    List<Object[]> catchmentAreas = (List<Object[]>) session.getAttribute("catchmentAreaTable");
%>
<!DOCTYPE html>

<head>
    <meta charset="UTF-8">
    <link type="text/css"
          href="<c:url value="/resources/vendor/bootstrap/css/bootstrap.min.css"/>"
          rel="stylesheet"
          http-equiv="Cache-control" content="public">
    <link type="text/css"
          href="<c:url value="/resources/css/style.css"/>"
          rel="stylesheet">
    <link type="text/css"
          href="<c:url value="/resources/vendor/font-awesome/css/font-awesome.min.css"/>"
          rel="stylesheet">
    <link type="text/css"
          href="<c:url value="/resources/css/sb-admin.css"/>" rel="stylesheet">
    <link type="text/css"
          href="<c:url value="/resources/css/jquery-ui.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/multi-select.css"/>" rel="stylesheet">
</head>

<body>
    <div class="card mb-3">
        <div class="card-header">
            <spring:message code="lbl.userInfo"/>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-sm-6">
                    <h4><%=user.getFullName()%></h4>
                </div>
                <div class="col-sm-6">
                    <h5><%=user.getUsername()%></h5>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-3">
        <div class="card-header">
            <spring:message code="lbl.viewLocationsHierarchy"/>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-sm-5" style="overflow-y: auto; max-height: 350px;">
                    <div id="locationTree">
                    </div>
                </div>
                <div class="col-sm-6">
                    <select id='locations' multiple='multiple'>
                    </select>
                </div>
                <div class="col-sm-1">
                    <input id="userId" value="<%=userId%>" type="hidden">
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
            <%if (catchmentAreas != null && catchmentAreas.size() > 0) {%>
            <div class="row" style="margin-top: 60px; overflow-x: auto;">
                <table class="display">
                    <thead>
                    <tr>
                        <th><spring:message code="lbl.division"/></th>
                        <th><spring:message code="lbl.district"/></th>
                        <th><spring:message code="lbl.upazila"/></th>
                        <th><spring:message code="lbl.pourasabha"/></th>
                        <th><spring:message code="lbl.union"/></th>
                        <th><spring:message code="lbl.village"/></th>
                        <th><spring:message code="lbl.action"/></th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for(int i = 0; i < catchmentAreas.size(); i++) { %>
                    <tr>
                        <td>
                            <%if (catchmentAreas.get(i)[0] == null) {%>
                            All
                            <% } else { %>
                            <%=catchmentAreas.get(i)[0]%>
                            <% } %>
                        </td>
                        <td>
                            <%if (catchmentAreas.get(i)[1] == null) {%>
                            All
                            <% } else { %>
                            <%=catchmentAreas.get(i)[1]%>
                            <% } %>
                        </td>
                        <td>
                            <%if (catchmentAreas.get(i)[2] == null) {%>
                            All
                            <% } else { %>
                            <%=catchmentAreas.get(i)[2]%>
                            <% } %>
                        </td>
                        <td>
                            <%if (catchmentAreas.get(i)[3] == null) {%>
                            All
                            <% } else { %>
                            <%=catchmentAreas.get(i)[3]%>
                            <% } %>
                        </td>
                        <td>
                            <%if (catchmentAreas.get(i)[4] == null) {%>
                            All
                            <% } else { %>
                            <%=catchmentAreas.get(i)[4]%>
                            <% } %>
                        </td>
                        <td>
                            <%if (catchmentAreas.get(i)[5] == null) {%>
                            All
                            <% } else { %>
                            <%=catchmentAreas.get(i)[5]%>
                            <% } %>
                        </td>
                        <td>
                            <a href="#top" id="edit" onclick="editLocation(<%=catchmentAreas.get(i)[6]%>)">Edit</a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
        <div class="card-footer small text-muted"></div>
    </div>
    <a class="btn btn-sm btn-dark" href="#" rel="modal:close" style="float: right;">Close</a>
<!-- Bootstrap core JavaScript-->
<script src="<c:url value='/resources/js/jquery-1.10.2.js'/>"></script>
<script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.multi-select.js'/>"></script>
<script type="text/javascript">
    var tempEdit = false;
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
    });

    $("a[href='#top']").click(function() {
        $("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    });
</script>

</body>

</html>
