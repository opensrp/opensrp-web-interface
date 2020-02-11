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
<%@ page import="org.apache.commons.lang3.StringUtils" %>

<%
    List<UserDTO> users = (List<UserDTO>) session.getAttribute("allSS");
    List<UserDTO> ssWithoutCatchment = (List<UserDTO>) session.getAttribute("ssWithoutCatchment");
    Integer skId = (Integer) session.getAttribute("skId");
    String skUsername = (String) session.getAttribute("skUsername");
    String skName = (String) session.getAttribute("skName");
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><spring:message code="lbl.userList"/></title>
    <link type="text/css" href="<c:url value="/resources/css/jquery.toast.css"/>" rel="stylesheet">
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
		 <div class="card1 mb-3">
    	 	<div class="card-header2">
	    	 	 <div style="float: right;">
	    	 	 <a href="${back }"><strong>My SK </strong></a>  |
		            <% if(AuthenticationManagerUtil.isPermitted("PERM_ADD_SS")){ %>
		            <a class="btn btn-outline-primary btn-xs"
                       href="#" onclick="ssForm(${skId}, '${skUsername}')">
		                <strong>
		                    <spring:message code="lbl.addNew"/>
		                    <spring:message code="lbl.ss"/>
		                </strong>
		            </a> <%} %>
	    	 	 </div>
    	 	</div>
    	</div>

        <%-- <div class="form-group">
           <a href="${back }"><strong>My SK </strong></a>  |
            <% if(AuthenticationManagerUtil.isPermitted("PERM_ADD_SS")){ %>
            <a  href="#" onclick="ssForm(${skId}, '${skUsername}')">
                <strong>
                    <spring:message code="lbl.addNew"/>
                    <spring:message code="lbl.ss"/>
                </strong>
            </a> <%} %>
        </div> --%>

        <!-- Modal for add new SS -->
        <div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050; min-height: 300px;"
             id="add-ss" class="modal">
            <div id="add-ss-body">
                <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
            </div>
        </div>

        <!-- Modal for edit SS -->
        <div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050; min-height: 300px;"
             id="edit-ss" class="modal">
            <div id="edit-ss-body">
                <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
            </div>
        </div>

        <!-- Modal for change SK - start -->
        <div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050; min-height: 300px;" id="change-sk" class="modal">
            <div id="sk-change-body">
                <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
            </div>
        </div>
        <!-- Modal End-->


        <!--Modal for catchment - start-->
        <div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050"
             id="catchment-area" class="modal">
            <div id="user-info-body" class="row"></div>
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
                <div style="float: left; padding: 3px;">
                    <h5><%=skName%>'s SS List</h5>
                </div>
                <div style="float: right;">
                    <input id="myInput" class="form-control input-sm" type="text" placeholder="Search..">
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="display" id="userList">
                        <thead>
                        <tr>
                            <th><spring:message code="lbl.slNo"></spring:message></th>
                            <th><spring:message code="lbl.name"></spring:message></th>
                            <th><spring:message code="lbl.username"></spring:message></th>
                            <th><spring:message code="lbl.phoneNumber"></spring:message></th>
                            <th><spring:message code="lbl.branches"></spring:message></th>
                            <th><spring:message code="lbl.union"></spring:message></th>
                            <th><spring:message code="lbl.village"></spring:message></th>
                            <th><spring:message code="lbl.action"></spring:message></th>
                        </tr>
                        </thead>
                        <tbody id="ssTable">
                        <%
                            if (users != null){
                                int idx = 0;
                                for (UserDTO user: users) {
                                    idx++;
                                    Integer id = user.getId();
                                    session.setAttribute("ssId", id);
                                    String villages = user.getLocationList();
                                    if (StringUtils.isBlank(villages)){
                                    	villages = "Location not assigned";
                                    }
                                    String unionWards = user.getUnionList();
                                    if (StringUtils.isBlank(unionWards)){
                                        unionWards = "Location not assigned";
                                    }
                        %>
                        <tr>
                            <td><%=idx%></td>
                            <td><%=user.getFullName()%></td>
                            <td><%=user.getUsername()%></td>
                            <td><%=user.getMobile()%></td>
                            <td><%=user.getBranches()%></td>
                            <td><%=unionWards%></td>
                            <td><%=villages%></td>
                            <td>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
                                <a href="#" onclick="ssEditForm(${skId}, '${skUsername}', ${ssId}, '${locale}')"><spring:message code="lbl.edit"/></a> |  <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                <a href="#" onclick="catchmentLoad(${ssId}, ${0})"><spring:message code="lbl.catchmentArea"/></a> | <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER")){ %>
                                <a href="#" onclick="changeSK(${ssId})"><spring:message code="lbl.changeSK"/></a> <%} %>
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
<script src="<c:url value='/resources/js/jquery.toast.js'/>"></script>
<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.multi-select.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script src="<c:url value='/resources/js/user-ss.js' />"></script>
</body>
</html>
