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
                <div class="row">
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[1]%></h3>
                                    <h5>Total Registered Household</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[2]%></h3>
                                    <h5>Total Population</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[4]%></h3>
                                    <h5>Total Female</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-sm-6 mb-4">
                        <div class="card text-white o-hidden h-100 bg-primary">
                            <div class="card-body">
                                <div class="card-body-icon">
                                    <!-- <i class="fa fa-fw fa-female"></i>  -->
                                </div>
                                <div class="mr-5">
                                    <h3><%=upazilaList.get(0)[3]%></h3>
                                    <h5>Total Male</h5>
                                </div>
                            </div>
                        </div>
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
