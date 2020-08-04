<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>
<title>Catchment Area </title>
  <link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/multi-select.css"/>" rel="stylesheet">
   <link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">
    <%@page import="org.json.JSONObject" %>
    <%@page import="org.json.JSONArray" %>
    <%@ page import="org.opensrp.core.entity.UsersCatchmentArea" %>
    <%@ page import="java.util.List" %>
    <%@ page import="org.opensrp.core.entity.User" %>
    <%@ page import="org.opensrp.common.dto.UserAssignedLocationDTO" %>
    <%@ page import="org.opensrp.web.util.AuthenticationManagerUtil" %>
    <%@ page import="org.opensrp.common.util.Roles" %>
<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />


<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="saveUrl" value="/user/add.html" />
<c:url var="saveRestUrl" value="/rest/api/v1/user/add" />
<c:url var="cancelUrl" value="/user.html" />
<c:url var="userList" value="/user.html" />

<%
    JSONArray locationTreeData = (JSONArray)session.getAttribute("locationTreeData");
    Integer userId = (Integer) session.getAttribute("userId");
    User user = (User) session.getAttribute("user");
    List<UsersCatchmentArea> usersCatchmentAreas = (List<UsersCatchmentArea>) session.getAttribute("usersCatchmentAreas");
    List<UserAssignedLocationDTO> userAssignedLocationDTOS = (List<UserAssignedLocationDTO>) session.getAttribute("assignedLocation");
    Boolean isTeamMember = (Boolean) session.getAttribute("isTeamMember");
    Integer roleId = (Integer) session.getAttribute("roleId");
%>
<div class="page-content-wrapper">
    <div class="page-content">


        <ul class="page-breadcrumb breadcrumb">
            <li>
                <a href="<c:url value="/user.html"/>">Home</a>
                <i class="fa fa-circle"></i>
            </li>
            <li>
                <a href="<c:url value="/user.html"/>">User list</a>
                <i class="fa fa-circle"></i>
            </li>

        </ul>
        <!-- END PAGE BREADCRUMB -->
        <!-- END PAGE HEADER-->
        <!-- BEGIN PAGE CONTENT-->


        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <%=user.getFullName()%> (<%=user.getUsername()%> )
                        </div>


                    </div>
                    
                    <div class="portlet-body">
                        	<div class="form-group row" id="no-data" style="display: none;">
			                    <div class="col-sm-12">
			                        <p>This user doesn't have parent user or user's branch is't assigned to a higher rank user.</p>
			                    </div>
			                </div>
                            <div class="form-group row">
                                
	                                <div class="col-sm-5">
					                    <div id="locationTree">
                        				</div>
					                 </div>
				                    <div class="col-sm-5">
				                        <select id='locations' multiple='multiple'>
				                        </select>
				                    </div>
				                    <div class="col-sm-2">
				                        <input id="userId" value="<%=userId%>" type="hidden">
				                       
				                            <button id="saveCatchmentArea"
				                                    disabled = true
				                                    class="btn btn-primary btn-lg">
				                                Save
				                            </button>
				                            <p id="pleaseWait" style="display: none; color: red;">Please wait...</p>
				                        
				                    </div>                               
                                   
                                                          
                            </div> 
                                                         
                    </div>
                </div>
                
                
                <div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							 <spring:message code="lbl.catchmentArea"/>
						</div>


					</div>
					 
					<div class="portlet-body" id="assigned-areas">
						
						
					</div>
					
				</div>
                
                
                
                
                
            </div>
        </div>
        <!-- END PAGE CONTENT-->
    </div>
</div>
<!-- END CONTENT -->
</div>

<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.multi-select.js'/>"></script>
<script type="text/javascript">
    var tempEdit = false;
    var selectedLocation = [];
    $(document).ready(function () {
        let locationTreeData = <%=locationTreeData%>;
        if (locationTreeData.length == 0) $('#no-data').show();
        else $('#no-data').hide();
        console.log("length: "+ locationTreeData.length);
        $('#locationTree').jstree({
            'core' : {
                'data' : locationTreeData
            },
            'checkbox' : {
                'keep_selected_style' : false
            },
            'plugins': [
                'sort', 'wholerow'
            ]
        });

        $('#locations').multiSelect();

        $('#locations').change(function(){
            if ($('#locations').val() != null) {
                $('#saveCatchmentArea').prop('disabled', false);
            } else {
                console.log(tempEdit);
                if (tempEdit == true) {
                    $('#saveCatchmentArea').prop('disabled', false);
                } else {
                    $('#saveCatchmentArea').prop('disabled', true);
                }
            }
        });

        $('#locationTree').on('changed.jstree', function (e, data) {
            tempEdit = false;
            $('#saveCatchmentArea').prop('disabled', true);
            $('#locations option').remove();
            $('#locations').multiSelect('refresh');
            var selectedAreas = [];
            <% if (usersCatchmentAreas != null) {
                for (int i = 0; i < usersCatchmentAreas.size(); i++) {%>
                    selectedAreas[<%=i%>] = <%=usersCatchmentAreas.get(i).getLocationId()%>
                <%}
            }%>
            var i, j, r = [], z = [];
            var id = data.selected[0];
            var ids = [];
            r = data.instance.get_node(id).children;

            for (i = 0; i < r.length; i++) {
                let splitted = data.instance.get_node(r[i]).text.split("(");
                let size = splitted.length-1;
                let splittedText = splitted[size].replace(")", "");
                z.push({
                    name: data.instance.get_node(r[i]).icon,
                    id: data.instance.get_node(r[i]).id,
                    text: splittedText
                });
            }

            for (i = 0; i < z.length; i++) {
                console.log("text: "+ z[i].text);
                console.log("name: "+ z[i].name);
                if (z[i].text != "Village") {
                    <%if ( (roleId == Roles.SK.getId() || roleId == Roles.SS.getId())) { %>
                    continue;
                    <%}%>
                }
                if (selectedAreas.indexOf(parseInt(z[i].id)) >= 0) {
                    ids.push(z[i].id);
                }
                $('#locations').multiSelect('addOption',{
                    value: z[i].id,
                    text: z[i].name,
                    index: i
                });
            }

            <%for (UserAssignedLocationDTO dto: userAssignedLocationDTOS) {
                if (roleId == Roles.AM.getId()) {
                    continue;
                }%>
                $('#locations option[value=<%=dto.getLocationId()%>]').attr("disabled", 'disabled');
            <%}%>
            $('#locations').val(ids);
            $('#locations').multiSelect('refresh');

            selectedLocation = ids;
        }).jstree();

        $('#saveCatchmentArea').unbind().click(function () {
            $('#saveCatchmentArea').prop('disabled', true);
            $('#pleaseWait').show();
            let url = "";
            <% if (isTeamMember) {%>
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/update";
            <%} else {%>
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/save";
            <% } %>
            let token = $("meta[name='_csrf']").attr("content");
            let header = $("meta[name='_csrf_header']").attr("content");
            let allLocation = [];
            $("#locations option").each(function() {
                allLocation.push($(this).val());
            });

            let enabled = [];
            if ($('#locations').val() != undefined && $('#locations').val() != null) {
                let enableArray = [];
                enableArray = $('#locations').val();
                if (Array.isArray(enableArray)) {
                    enableArray.forEach(function (val) {
                        enabled.push(val);
                    });
                } else {
                    enabled.push(enableArray);
                }
            }

            if (selectedLocation.length > 0) {
                selectedLocation.forEach(function (value) {
                    enabled.push(value);
                });
            }

            let formData = {
                allLocation: allLocation,
                locations: enabled,
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
                    window.location.reload();
                    // window.location.replace(redirectUrl);
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
        loadCatchmentTable();
    });

    function loadCatchmentTable() {
        let url = "/opensrp-dashboard/"+$('#userId').val()+"/catchment-area-table.html";
        $.ajax({
            type: "GET",
            contentType : "application/json",
            url: url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function(xhr) {
            },
            success : function(data) {
                $("#assigned-areas").html(data);
            },
            error : function(e) {
            },
            done : function(e) {
            }
        });
    }
</script>
