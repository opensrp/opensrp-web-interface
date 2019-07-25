<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.core.entity.FacilityWorker"%>
<%@page import="org.opensrp.core.entity.FacilityTraining"%>


<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<%
    List<Object[]> upazilaList = (List<Object[]>) session.getAttribute("upazilaList");
%>

<!DOCTYPE html>
<html>

<head>
    <title>CC Profile</title>
</head>
<style>
    td{ padding:5px;
        font-size: 20px;
        font-family: ShonarBangla;}
</style>
<jsp:include page="/WEB-INF/views/header.jsp" />


<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
    <div class="container-fluid">
        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i> <spring:message code="lbl.upazilaWiseDataStatus"/>
            </div>
            <div class="card-body">
                <div>
                    <div>

                    </div>
                </div>
                <div class="row" style="margin-top: 30px;">
                    <div class="col-sm-12" id="content">
                        <table class="display" id="householdMemberListTable"
                               style="width: 100%;">
                            <thead>
                            <tr>
                                <th><spring:message code="lbl.upazila"/></th>
                                <th><spring:message code="lbl.householdCount"/></th>
                                <th><spring:message code="lbl.population"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (int i = 0; i < upazilaList.size(); i++) {%>
                            <tr>
                                <td><%=upazilaList.get(i)[0]%></td>
                                <td><%=upazilaList.get(i)[1]%></td>
                                <td><%=upazilaList.get(i)[2]%></td>
                            </tr>
                            <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>


</div>

<jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
</body>
</html>