<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>

<c:url var="branch_url" value="/branch-list-options-by-user-ids" />
<c:url var="all_branch_url" value="/all-branch-list-options" />

<c:url var="user_list_url" value="/user-list-options-by-parent-user-ids" />
<c:url var="sk_list_url" value="/sk-list-by-branch" />


<%
    String startDate = (String) session.getAttribute("startDate");
    String endDate = (String) session.getAttribute("endDate");
%>

<head>
    <meta charset="utf-8">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name='viewport'
          content='initial-scale=1,maximum-scale=1,user-scalable=no' />

    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.46.0/mapbox-gl.js'></script>

    <jsp:include page="/WEB-INF/views/css.jsp" />

    <link href="https://fonts.googleapis.com/css?family=Open+Sans"
          rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/mapbox-gl.css"/>"
          rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/style.css"/>"
          rel="stylesheet">
    <link type="text/css" href="<c:url value="/resources/css/maps.css"/>"
          rel="stylesheet">
    <style type="text/css">
        #container {
            min-width: 310px;
            max-width: 800px;
            height: 400px;
            margin: 0 auto
        }
    </style>

    <style>
        .select2-results__option .wrap:before {
            font-family: fontAwesome;
            color: #999;
            content: "\f096";
            width: 25px;
            height: 25px;
            padding-right: 10px;
        }

        .select2-results__option[aria-selected=true] .wrap:before {
            content: "\f14a";
        }


        /* not required css */

        .row {
            padding: 10px;
        }

        .select2-multiple,
        .select2-multiple,
        .select2-multiple2 {
            width: 50%
        }

        .select2-results__group .wrap:before {
            display: none;
        }
    </style>
</head>

<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="page-content-wrapper">
    <div class="page-content">
        <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
            <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
        </div>

        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-list"></i>Map Movement
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="form-group">


                            <div class="row" id="manager">
                                <div class="col-lg-3 form-group">
                                    <label>Area manager </label>
                                    <select	onclick="getBranchListByUserId(this.value,'branchList')" name="AM"  id="AM" class="form-control">
                                        <option value="0">Please select </option>
                                        <c:forEach items="${users}" var="user">
                                            <option value="${user.getId()}">${user.getFullName()}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-lg-3 form-group">
                                    <label><spring:message code="lbl.branch"></spring:message></label>
                                    <select	name="branchList" class="form-control" id="branchList" onchange="getSk()">

                                    </select>
                                </div>

                                <div class="col-lg-3 form-group">
                                    <label><spring:message code="lbl.sk"></spring:message></label>
                                    <select	name="providerList" class="form-control" id="providerList" >

                                    </select>
                                    <label style="display: none;" class="text-danger" id="providerValidation"><small>please select a sk</small></label>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-2">
                                <label><spring:message code="lbl.startDate"/></label>
                                <input class="form-control custom-select custom-select-lg" type=text
                                       name="start" id="startDate" value="<%=startDate%>">
                                <label style="display: none;" class="text-danger" id="startDateValidation"><small>Input is not valid for date</small></label>
                            </div>
                            <div class="col-md-2">
                                <label><spring:message code="lbl.endDate"/></label>
                                <input class="form-control custom-select custom-select-lg" type="text"
                                       name="end" id="endDate" value="<%=endDate%>">
                                <label style="display: none;" class="text-danger" id="endDateValidation"><small>Input is not valid for date</small></label>
                            </div>
                            <div class="col-lg-2 form-group "><br />
                                <button type="submit" onclick="getMovements()" class="btn btn-primary" value="confirm">View</button>
                                <br>
                                <span id="errorMsg"></span>
                            </div>
                        </div>

                        <div class="row" style="margin: 0px">
                            <div class="card-body" style="height: 440px">
                                <div id='map' style="height: 400px; padding: 0"></div>
                            </div>
                            <div class="card-footer medium text-muted">
                                <span class="col-6">
                                    <img src="<c:url value="/resources/images/adequate_growth.jpg"/>" width="40"
                                         height="10"></span>visited area
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </br>
        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>

<!-- END CONTENT -->

<script src="<c:url value='/resources/assets/global/js/select2-multicheckbox.js'/>"></script>

<script>
    mapboxgl.accessToken = 'pk.eyJ1IjoibnVyc2F0aiIsImEiOiJjamp6ZDU5ZmswOG9zM3JwNTJvN3FzYWNyIn0.PLU3v5A_kNUrfkZLQq4E8w';

    var features = {
        features: [
            {
                geometry: {
                    coordinates: [
                        90.4110005,
                        23.7904958
                    ],
                    type: 'Point'
                },
                type: 'Feature',
                properties: {
                    gender: 'Male',
                    provider: 'tanzim',
                    weight: 9,
                    title: 'Vvbd',
                    age: 1
                }
            },
            {
                geometry: {
                    coordinates: [
                        90.4111344,
                        23.7905589
                    ],
                    type: 'Point'
                },
                type: 'Feature',
                properties: {
                    gender: 'Female',
                    provider: 'tanzim',
                    weight: 60,
                    title: 'July',
                    age: 12
                }
            }
        ]
    }

    var map = new mapboxgl.Map({
        container : 'map',
        style : 'mapbox://styles/mapbox/streets-v9',
        center : [ 90.399452, 23.777176 ],
        zoom : 8
    });

    // code from the next step will go here!
    function reloadMap(movements) {
        console.log(movements);
        // add markers to map
        $( ".markerGreen" ).remove();
        movements.forEach(function (marker) {
            // create a HTML element for each feature
            var el = document.createElement('div');
            el.className = 'markerGreen';

            // make a marker for each feature and add to the map
            new mapboxgl.Marker(el).setLngLat(marker.geometry.coordinates)
                .setPopup(
                    new mapboxgl.Popup({
                        offset: 25
                    }) // add popups
                        .setHTML('<h5>' + marker.properties.title
                            + '</h5><p>'
                            + 'Provider: ' + marker.properties.provider
                            + '</p>'))
                .addTo(map);
        });
    }
</script>
<script>

    jQuery(document).ready(function() {
        Metronic.init(); // init metronic core components
        Layout.init(); // init current layout

        $('#startDate').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'yy-mm-dd',
            maxDate: new Date,
            onClose: function(dateText, inst) {
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $('#mto').datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
                $(".date-picker-year").focus(function () {
                    $(".ui-datepicker-calendar").hide();
                    $(".ui-datepicker-current").hide();
                });

            }
        });

        $('#endDate').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'yy-mm-dd',
            maxDate: new Date,
            onClose: function(dateText, inst) {
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $('#mto').datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
                $(".date-picker-year").focus(function () {
                    $(".ui-datepicker-calendar").hide();
                    $(".ui-datepicker-current").hide();
                });

            }
        });

        getBranchByuserIds('${userIds}')
        $('#branchList').select2MultiCheckboxes({
            placeholder: "Select branch",
            width: "auto",
            templateSelection: function(selected, total) {
                return "Selected " + selected.length + " of " + total;
            }
        });
    });

    function getBranchListByUserId(userId,divId) {
        if(userId!=0){
            getBranchByuserIds(userId);
        }else{
            userId= $("#divM option:selected").val();
            if(userId!=0){
                getBranchByuserIds(userId);
            }else{
                getAllBranch();
            }
        }
    }

    function getBranchByuserIds(userId){
        let url = '${branch_url}';
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url+"?id="+userId,

            dataType : 'html',
            timeout : 300000,
            beforeSend: function() {},
            success : function(data) {
                $("#branchList").html(data);
                /* $("#branchList > option").prop("selected","selected");
                $("#branchList").trigger("change"); */
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {
                console.log("DONE");
                //enableSearchButton(true);
            }
        });
    }

    function getAllBranch() {
        let url = '${all_branch_url}';
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 300000,
            beforeSend: function() {},
            success : function(data) {
                $("#branchList").html(data);
                /* $("#branchList > option").prop("selected","selected");
                $("#branchList").trigger("change"); */
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {

                console.log("DONE");

            }
        });

    }

    function getSk() {
        let url = '${sk_list_url}';
        var branchList = $("#branchList").val();
        console.log(branchList);
        if(branchList == null) return;
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 300000,
            data: {
                branchIds: branchList.join(',')
            },
            beforeSend: function() {},
            success : function(data) {
                $("#providerList").html(data);
                /* $("#branchList > option").prop("selected","selected");
                $("#branchList").trigger("change"); */
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {

                console.log("DONE");

            }
        });
    }

    function getMovements() {

        if($("#providerList").val() === null || $("#providerList").val() == '') {
            $("#providerValidation").show();
            return;
        }
        else {
            $("#providerValidation").hide();
        }


        var startDate = $.datepicker.formatDate('yy-mm-dd', new Date($("#startDate").val()));
        var endDate = $.datepicker.formatDate('yy-mm-dd', new Date($("#endDate").val()));
        var url = "rest/api/v1/target/movements";
        $.ajax({
            type : "GET",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 300000,
            data: {
                username: $("#providerList").val(),
                startDate: startDate,
                endDate: endDate
            },
            beforeSend: function() {},
            success : function(data) {
                data = JSON.parse(data);
                console.log("providers coordinate", data);
                if(data.length === 0) {
                    $("#errorMsg").html('No coordinates found');
                }
                else {
                    $("#errorMsg").html('');
                }
                var movements = [];

                data.forEach(function(d) {
                    movements.push({
                        geometry: {
                            coordinates: [
                                d.longitude,
                                d.latitude
                            ],
                            type: 'Point'
                        },
                        type: 'Feature',
                        properties: {
                            provider: d.username,
                            title: 'hh visit'
                        }
                    })
                });
                reloadMap(movements);
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },
            done : function(e) {

                console.log("DONE");

            }
        });
    }

</script>

