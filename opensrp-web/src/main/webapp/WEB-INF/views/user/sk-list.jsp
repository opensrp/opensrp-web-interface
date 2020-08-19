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
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.opensrp.common.dto.UserAssignedLocationDTO" %>
<%@ page import="org.opensrp.core.entity.UsersCatchmentArea" %>

<%
    List<UserDTO> users = (List<UserDTO>) session.getAttribute("allSK");
%>
<title>SK List</title>
<link type="text/css" href="<c:url value="/resources/css/jquery.modal.min.css"/>" rel="stylesheet">

<link type="text/css" href="<c:url value="/resources/css/jquery.toast.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/jtree.min.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/multi-select.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/select2.css"/>" rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/bootstrap4-toggle.min.css"/>" rel="stylesheet">

<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />

<style>

    /*for computers*/
    @media screen and (min-width: 992px) {
        .modal-margin {
            margin-top: 5%;
        }
    }
    /*for mobile devices*/
    @media screen and (max-width: 992px) {
        .modal-margin {
            margin-top: 40%;
        }
    }
</style>

<div class="page-content-wrapper">
	<div class="page-content">


		<ul class="page-breadcrumb breadcrumb text-right">
			<li>
				<% if(AuthenticationManagerUtil.isPermitted("PERM_ADD_SK")){ %>
				<a class="btn btn-primary" href="#" onclick="addSK()">
                <strong>
                    <spring:message code="lbl.addNew"/>
                    <spring:message code="lbl.sk"/>
                </strong> </a>
				<%} %>
			</li>
		</ul>
		<!-- END PAGE BREADCRUMB -->
		<!-- END PAGE HEADER-->
		<!-- BEGIN PAGE CONTENT-->
		<div style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1050; min-height: 300px;"
             id="change-password-modal" class="modal">
            <div id="change-password-body">
                <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
            </div>
        </div>

        <!--Modal start-->
        <div style="overflow: unset;display: none;top:30px; max-width: none; position: relative; z-index: 1050"
             id="catchment-area" class="modal modal-margin">
            <div id="user-info-body" class="row"></div>
            
                 <div class="form-group row" id ="modal-body">
	                <div class="col-sm-5">
	                    <div id="locationTree">
	                    </div>
	                </div>
	                <div class="col-sm-5">
	                    <select id='locations' multiple='multiple'>
	                    </select>
	                </div>
	                <div class="col-sm-2">
	                    <input id="userId" value="${skId}" type="hidden">
	                    <br />
	                   
	                        <button id="saveCatchmentArea"
	                                disabled = true
	                                class="btn btn-primary btn-lg"
	                                >
	                            Save
	                        </button>
	                        <p id="pleaseWait" style="display: none; color: red;">Please wait...</p>
	                </div>
                </div>
                
           
            <div id="table-body" class="row" style="overflow-x: auto; margin-bottom: 10px;">
            </div>
            <a class="btn btn-sm btn-dark" href="#" onclick="closeMainModal()" style="float: right; bottom: 0px">Close</a>
            <div class="modal" id="delete-modal" style="overflow: unset;display: none; max-width: none; position: relative; z-index: 1150; max-width: 70%;">
                <h4>Do you really want to delete this location from this SK?</h4>
                <p style="display: none;" id="delete-ss-validation"></p>
                <a class="btn btn-sm btn-danger" href="#" onclick="deleteConfirm()" style="float: right; bottom: 0px; margin-left: 5px;">Yes</a>
                <a class="btn btn-sm btn-dark" href="#" rel="modal:close" style="float: right; bottom: 0px">Close</a>
            </div>
        </div>
        
        <div style="overflow: unset;display: none; max-width: none; position: relative;min-height: 300px; z-index: 1050"
             id="update-user" class="modal modal-margin" >
            <div id="userInfo"> <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div> 
            </div>
        </div>
        
         <div style="overflow: unset;display: none; max-width: none;min-height: 300px; position: relative; z-index: 1050"
             id="add-sk-modal" class="modal modal-margin" >
            <div id="add-sk-form"> 
            	 <div style="position: absolute; margin-left:45%; margin-top: 105px;">
                    <img width="90px" height="90px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                </div>
            
            </div>
        </div>

		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>SK List
						</div>
						<!-- <div style="float: right;">
	                    <input id="myInput" class="form-control caption" type="text" placeholder="Search..">
	                	</div>
 -->

					</div>
					
					<div class="portlet-body">
						
					
						<table class="table table-striped table-bordered" id="sample_1">
							 <thead>
                        <tr>
                            <%-- <th><spring:message code="lbl.slNo"></spring:message></th> --%>
                            <th><spring:message code="lbl.name"></spring:message></th>
                            <th><spring:message code="lbl.username"></spring:message></th>
                            <%-- <th><spring:message code="lbl.phoneNumber"></spring:message></th> --%>
                            <th><spring:message code="lbl.branches"></spring:message></th>
                            <%-- <th><spring:message code="lbl.upazila"></spring:message></th> --%>
                            <th>City Corporation / <br/> Upazila</th>

                            <th><spring:message code="lbl.union"></spring:message></th>
                            <th><spring:message code="lbl.status"></spring:message></th>
                            <th><spring:message code="lbl.simprintStatus"></spring:message></th>
                            <th><spring:message code="lbl.appVersion"></spring:message></th>
                            <th><spring:message code="lbl.action"></spring:message></th>
                        </tr>
                        </thead>
                        <tbody id="skTable">
                        <%
                            if (users != null){
                                int idx = 0;
                                for (UserDTO user: users) {
                                    idx++;
                                	Integer id = user.getId();
                                	String username = user.getUsername();
                                	String appVersion = user.getAppVersion();
                                	String activeStatus = "Inactive";
                                	String enableSimprint = user.getEnableSimPrint()?"Yes":"No";
                                	String textColor = "color: red;";
                                	if (user.getLocationList() == null) {
                                		user.setLocationList("Location not assigned");
                                    }
                                	if (user.getUpazilaList() == null) {
                                		user.setUpazilaList("Location not assigned");
                                    }
                                	if (user.getAppVersion() == null) {
                                		appVersion = "N/A";
                                    }
                                	if (user.isStatus() == true) {
                                		activeStatus = "Active";
                                        textColor = "color: green;";
                                    }
                                    session.setAttribute("skId", id);
                                    session.setAttribute("skUsername", username);
                        %>
                        <tr>
                           <%--  <td><%=idx%></td> --%>
                            <td><%=user.getFullName()%></td>
                            <td><%=user.getUsername()%></td>
                            <%-- <td><%=user.getMobile()%></td> --%>
                            <td><%=user.getBranches()%></td>
                            <td><%=user.getUpazilaList()%></td>
                            <td><%=user.getLocationList()%></td>
                            <td style="<%=textColor%>"><%=activeStatus%></td>
                            <td><%=enableSimprint%></td>
                            <td><%=appVersion%></td>
                            <td>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_USER")){ %>
                                <a href="#" onclick="userLoad(${skId})" ><spring:message code="lbl.edit"/></a> <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER") && activeStatus.equalsIgnoreCase("Active")){ %>
                                | <a href="#" onclick="catchmentLoad(${skId}, ${0})" id = "catchment-modal"><spring:message code="lbl.catchmentArea"/></a> <%} %>
                                <% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_USER") && activeStatus.equalsIgnoreCase("Active")){ %>
                                | <a href="#" onclick="changePassword(${skId}, '${locale}')"><spring:message code="lbl.changePassword"/></a> <%} %>
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
				


			</div>
		</div>
		<!-- END PAGE CONTENT-->
	</div>
</div>
<!-- END CONTENT -->
</div>



<jsp:include page="/WEB-INF/views/footer.jsp" />
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/js/user.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.toast.js'/>"></script>
<script src="<c:url value='/resources/js/jstree.min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery.multi-select.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap4-toggle.min.js'/>"></script>
<script>
    var isTeamMember = false;
    var ssWithUCAId = [];
    var currentSK = -1;
    var currentLocation = -1;
    var currentRow = -1;
    var selectedLocation = [];
    $(document).ready(function () {
        <%
            session.setAttribute("heading", "");
            session.setAttribute("toastMessage", "");
            session.setAttribute("icon", "");
        %>
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
        $('#locationTree').jstree();
        $('#locations').multiSelect();

        $("#myInput").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            $("#skTable tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    });

    function userLoad(skId) {
    	userInfo(skId);    	
    	$('#update-user').modal({
            escapeClose: false,
            clickClose: false,
            showClose: false,
            show: true
        });
    }

    function changePassword(skId, locale) {
        var url = "/opensrp-dashboard/user/"+skId+"/change-password-ajax.html?lang="+locale;
        $.ajax({
            type: "GET",
            contentType : "application/json",
            url: url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function(xhr) {
            },
            success : function(data) {
                $("#change-password-body").html(data);
            },
            error : function(e) {
            },
            done : function(e) {
            }
        });
        $('#change-password-modal').modal({
            escapeClose: false,
            clickClose: false,
            showClose: false,
            show: true
        });
    }

    function addSK() {
    	userForm();    	
    	$('#add-sk-modal').modal({
            escapeClose: false,
            clickClose: false,
            showClose: false,
            show: true
        });
    }

    function catchmentLoad(skId, term) {
        currentSK = skId;
        $('#locationTree').jstree(true).destroy();
        $('#table-body').html("");
        $('#locations option').remove();
        $('#locations').multiSelect('refresh');
        if (term == 0) {
            $('#catchment-area').modal({
                escapeClose: false,
                clickClose: false,
                showClose: false,
                show: true
            });
        }

        var url = "/opensrp-dashboard/rest/api/v1/user/"+skId+"/catchment-area";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            contentType : "application/json",
            type: "GET",
            url: url,
            dataType : 'json',

            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(e, data) {
                isTeamMember = e["isTeamMember"];
                var locationData = e["locationTree"];
                var assignedLocation = e["assignedLocation"];
                var catchmentAreas = e["catchmentAreas"];
                var catchmentAreaTable = e["catchmentAreaTable"];
                var userFullName = e["userFullName"].trim();
                var userInfoHtml = '<h5>'+userFullName+'\'s Location Info</h5>';
                $('#user-info-body').html(userInfoHtml);
                console.log(catchmentAreaTable[0]);
                $('#locationTree').jstree({
                    'core' : {
                        'data' : locationData
                    },
                    'checkbox' : {
                        'keep_selected_style' : false
                    },
                    'plugins': [
                        'sort', 'wholerow'
                    ]
                });
                $('#locationTree').on("changed.jstree", function (e, data) {
                    console.log("CHANGES OCCURRED");
                    tempEdit = false;
                    $('#saveCatchmentArea').prop('disabled', true);
                    $('#locations option').remove();
                    $('#locations').multiSelect('refresh');
                    var selectedAreas = [];
                    var i, j, r = [], z = [];
                    for (var i = 0; i < catchmentAreas.length; i++) {
                        selectedAreas[i] = catchmentAreas[i];
                    }
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
                        if (z[i].text != "Village") continue;
                        if (selectedAreas.indexOf(parseInt(z[i].id)) >= 0) {
                            ids.push(z[i].id);
                        }
                        $('#locations').multiSelect('addOption',{
                            value: z[i].id,
                            text: z[i].name,
                            index: i
                        });
                    }

                    for (i = 0; i < assignedLocation.length; i++) {
                        var locationId = assignedLocation[i]["locationId"];
                        $("#locations option[value="+locationId+"]").attr("disabled", 'disabled');
                    }
                    $('#locations').val(ids);
                    $('#locations').multiSelect('refresh');
                    selectedLocation = ids;
                }).jstree();

                //create catchment area table
                var content = "<table id='catchment-table' class='table table-striped table-bordered'>";
                content += '<thead><tr><th>Division</th><th>District</th><th>City Corporation/Upazila</th><th>Pourashabha</th>' +
                    '<th>Union</th><th>Village</th><th>Action</th></tr></thead><tbody>';
                for(var y = 0; y < catchmentAreaTable.length; y++){
                    content += '<tr id="row'+y+'"><td>'+catchmentAreaTable[y][0]+'</td><td>'+catchmentAreaTable[y][1]+'</td>' +
                        '<td>'+catchmentAreaTable[y][2]+'</td><td>'+catchmentAreaTable[y][3]+'</td>' +
                        '<td>'+catchmentAreaTable[y][4]+'</td><td>'+catchmentAreaTable[y][5]+'</td>' +
                        '<td><button class="btn btn-sm btn-danger" onclick="deleteLocation('+catchmentAreaTable[y][6]+','+y+','+skId+')">Delete</button></td></tr>';
                }
                content += "</tbody></table>";

                $('#table-body').append(content);
            },
            error : function(e) {
                console.log("ERROR OCCURRED");
                $('#locationTree').jstree();
            },
            done : function(e) {
                console.log("DONE");
                $('#locationTree').jstree();
            }
        });
    }

    function deleteLocation(locationId, row, skId) {
        ssWithUCAId = [];
        currentSK = skId;
        currentLocation = locationId;
        currentRow = row;
        console.log(locationId + " " + row);
        $('#delete-ss-validation').html();
        var url = "/opensrp-dashboard/rest/api/v1/user/ss-by-location?locationId="+locationId;
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            contentType : "application/json",
            type: "GET",
            url: url,
            dataType : 'json',

            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(data) {
                ssWithUCAId = data;
                var ssInfos = data.map(function(ss) {
                    return ss["ss_name"];
                }).join(', ');
                $('#delete-ss-validation').html("If you release this location from this SK - <b>" +ssInfos+ "</b> also be released from those location..");
                if (ssInfos.length > 0) $('#delete-ss-validation').show();
            },
            error : function(e) {
                console.log(e);
            },
            done : function(e) {
                console.log(e);
            }
        });
        $('#delete-modal').modal({
            escapeClose: false,
            clickClose: false,
            closeExisting: false,
            show: true
        });
    }

    function deleteConfirm() {
        console.log("in delete confirm");
        var skWithLocation = {
            sk_id: currentSK,
            sk_location_id: currentLocation,
            ss_of_sk: ssWithUCAId
        };
        console.log(skWithLocation);
        var url = "/opensrp-dashboard/rest/api/v1/user/delete-sk-location";
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            contentType : "application/json",
            type: "DELETE",
            url: url,
            dataType : 'json',
            data: JSON.stringify(skWithLocation),
            timeout : 100000,
            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
            },
            success : function(e, data) {
                console.log(e);
                console.log("in success delete confirm");
                console.log(data);
                catchmentLoad(currentSK, 1);  // sending 1 as if modal does not close in catchment load method
                // $('#row'+currentRow).remove();
                $.modal.getCurrent().close();
            },
            error : function(e) {
                console.log(e);
                console.log("In error");
            },
            done : function(e) {
                console.log(e);
                console.log("In done");
            }
        });
    }

    $('#locations').change(function(){
        if ($('#locations').val() != null) {
            $('#saveCatchmentArea').prop('disabled', false);
        } else {
            if (tempEdit == true) {
                $('#saveCatchmentArea').prop('disabled', false);
            } else {
                $('#saveCatchmentArea').prop('disabled', true);
            }
        }
    });

    $('#saveCatchmentArea').unbind().click(function () {
        $('#saveCatchmentArea').prop('disabled', true);
        $('#pleaseWait').show();
        var url = "";
        if (isTeamMember == true) {
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/update";
        } else {
            url = "/opensrp-dashboard/rest/api/v1/user/catchment-area/save";
        }
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        var allLocation = [];
        $("#locations option").each(function() {
            allLocation.push($(this).val());
        });
        var skId = currentSK;

        var enabled = [];
        if ($('#locations').val() != undefined && $('#locations').val() != null) {
            var enableArray = [];
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

        var formData = {
            allLocation: allLocation,
            locations: enabled,
            userId: skId
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
            success : function(e, data) {
                $('#pleaseWait').hide();
                catchmentLoad(currentSK, 0);
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

    function closeMainModal() {
        console.log("IN CLOSE");
        window.location.reload();
        $.modal.getCurrent.close();
    }
</script>
<script>
	jQuery(document).ready(function() {
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		//TableAdvanced.init();
		$('#sample_1').DataTable();
		$('#catchment-table').DataTable();
	});
</script>