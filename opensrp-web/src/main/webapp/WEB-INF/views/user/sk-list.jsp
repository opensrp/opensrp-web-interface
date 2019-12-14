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
    List<UserDTO> users = (List<UserDTO>) session.getAttribute("allSK");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><spring:message code="lbl.userList"/></title>
    <jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid">

        <div class="form-group">
            <jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />
        </div>

        <div class="form-group">
            <h5><spring:message code="lbl.skListTitle"/></h5>
            <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
            <a  href="<c:url value="/user/add.html?lang=${locale}"/>">
                <strong>
                    <spring:message code="lbl.addNew"/>
                    <spring:message code="lbl.user"/>
                </strong> </a> <%} %>
        </div>

        <!-- Example DataTables Card-->
        <div class="card mb-3">
            <div class="card-header">
                <spring:message code="lbl.userList"/>
            </div>
            <div class="card-body">
                <div class="table-responsive" style="overflow-x: auto;">
                    <table class="display" id="userList">
                        <thead>
                        <tr>
                            <th><spring:message code="lbl.fullName"></spring:message></th>
                            <th><spring:message code="lbl.userName"></spring:message></th>
                            <th><spring:message code="lbl.phoneNumber"></spring:message></th>
                            <th><spring:message code="lbl.branches"></spring:message></th>
                            <th><spring:message code="lbl.union"></spring:message></th>
                            <th><spring:message code="lbl.action"></spring:message></th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            if (users != null){
                                for (UserDTO user: users) {
                                	Integer id = user.getId();
                                	String username = user.getUsername();
                                    session.setAttribute("skId", id);
                                    session.setAttribute("skUsername", username);
                        %>
                        <tr>
                            <td><%=user.getFullName()%></td>
                            <td><%=user.getUsername()%></td>
                            <td><%=user.getMobile()%></td>
                            <td><%=user.getBranches()%></td>
                            <td><%=user.getLocationList()%></td>
                            <td>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
                                <a href="<c:url value="/user/${skId}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a> |  <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                <a href="<c:url value="/user/${skId}/catchment-area.html?lang=${locale}"/>"><spring:message code="lbl.catchmentArea"/></a> <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                | <a href="<c:url value="/user/${skId}/change-password.html?lang=${locale}"/>"><spring:message code="lbl.changePassword"/></a> <%} %>
                                | <a href="<c:url value="/user/${skId}/${skUsername}/my-ss.html?lang=${locale}"/>"><spring:message code="lbl.ssList"/></a>
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
