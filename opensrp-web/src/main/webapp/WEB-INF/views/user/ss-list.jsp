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
                                <a href="<c:url value="/user/${ssId}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>
                               
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
        <!-- Example DataTables Card-->
        <div class="card mb-3">
            <div class="card-header">
                <spring:message code="lbl.ssWithoutCatchment"/>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="display">
                        <thead>
                        <tr>
                            <th><spring:message code="lbl.fullName"></spring:message></th>
                            <th><spring:message code="lbl.userName"></spring:message></th>
                            <th><spring:message code="lbl.phoneNumber"></spring:message></th>
                            <th><spring:message code="lbl.branches"></spring:message></th>
                            <th><spring:message code="lbl.action"></spring:message></th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (users != null){
                                for (UserDTO user: ssWithoutCatchment) {
                                    Integer id = user.getId();
                                    session.setAttribute("ssId", id);
                        %>
                        <tr>
                            <td><%=user.getFullName()%></td>
                            <td><%=user.getUsername()%></td>
                            <td><%=user.getMobile()%></td>
                            <td><%=user.getBranches()%></td>
                            <td>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
                                <a href="<c:url value="/user/${skUsername}/${skId}/${ssId}/edit-SS.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> |  <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                <a href="<c:url value="/user/${ssId}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>
                               
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
    </div>
</div>
<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>

<script src="<c:url value='/resources/js/jquery.toast.js'/>"></script>
<script>
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
    });
</script>
