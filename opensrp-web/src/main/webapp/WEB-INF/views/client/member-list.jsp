<%@page import="java.util.List"%>
<%@ page import="org.opensrp.core.entity.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<%
    List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
    String startDate = (String) session.getAttribute("startDate");
    String endDate = (String) session.getAttribute("endDate");
    String memberType = (String) session.getAttribute("memberType");
    User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta http-equiv="refresh"
          content="<%=session.getMaxInactiveInterval()%>;url=/login" />

    <title>Form Wise Report Status</title>

    <jsp:include page="/WEB-INF/views/css.jsp" />

    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/jquery.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/buttons.dataTables.css"/> ">
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/> ">
</head>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
<jsp:include page="/WEB-INF/views/navbar.jsp" />
<div class="content-wrapper">
    <div class="container-fluid">
        <div class="card mb-3">
            <div class="card-header">
                <i class="fa fa-table"></i> <spring:message code="lbl.householdMemberList"/>
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
                                <th><spring:message code="lbl.healthId"/></th>
                                <th><spring:message code="lbl.name"/></th>
                                <th><spring:message code="lbl.gender"/></th>
                                <th><spring:message code="lbl.age"/></th>
                                <th><spring:message code="lbl.status"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<Object[]> memberList = (List<Object[]>) session.getAttribute("memberList");
                                for (int i = 0; i < memberList.size(); i++) {
                                    String baseEntityId = (String) memberList.get(i)[4];
                                    if (memberList.get(i)[5] == null || memberList.get(i)[5].equals("0")) {
                            %>
                            <tr>
                                <td>
                                    <a href="<c:url value="/client/household-member.html">
                                                <c:param
                                                    name="baseEntityId"
                                                    value="<%=baseEntityId%>"/>
                                                             </c:url>">
                                        <%=memberList.get(i)[3]%>
                                    </a>
                                </td>
                                <td><%=memberList.get(i)[0]%></td>
                                <td><%=memberList.get(i)[1]%></td>
                                <td><%=memberList.get(i)[2]%></td>
                                <td>
                                    <% if (memberList.get(i)[5] == null || memberList.get(i)[5].equals("")) {%>
                                    <b>Not Yet Reviewed</b>
                                    <%}
                                    else if (memberList.get(i)[5].equals("0")) {%>
                                    <b style="color: red;">Under Review</b>
                                    <%}%>
                                </td>
                            </tr>
                            <%} }%>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/footer.jsp" />
</div>
<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
<script src="<c:url value='/resources/js/jquery-ui.js' />"></script>
<script src="<c:url value='/resources/js/datepicker.js' />"></script>
<script src="<c:url value='/resources/js/jspdf.debug.js' />"></script>
<script src="<c:url value='/resources/js/jquery.dataTables.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.buttons.js' />"></script>
<script src="<c:url value='/resources/js/buttons.flash.js' />"></script>
<script src="<c:url value='/resources/js/buttons.html5.js' />"></script>
<script src="<c:url value='/resources/js/jszip.js' />"></script>
<script src="<c:url value='/resources/js/pdfmake.js' />"></script>
<script src="<c:url value='/resources/js/vfs_fonts.js' />"></script>
<script src="<c:url value='/resources/js/dataTables.jqueryui.min.js' />"></script>
<script>
    $(document).ready(function() {
        $('#householdMemberListTable').DataTable({
            bFilter: true,
            bInfo: true,
            dom: 'Bfrtip',
            destroy: true,
            buttons: [
                'pageLength', 'csv', 'excel', 'pdf'
            ],
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]]
        });
    });
</script>
</body>
</html>