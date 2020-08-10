<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.LocationTag"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%

    Map<Integer, String> tags =  (Map<Integer, String>)session.getAttribute("tags");
    Integer selectedTag = (Integer)session.getAttribute("selectedTag");

%>
<title> Add new location</title>
<jsp:include page="/WEB-INF/views/header.jsp" />

    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    

<c:url var="saveUrl" value="/location/add-new.html" />



<div class="page-content-wrapper">
		<div class="page-content">
			
			<ul class="page-breadcrumb breadcrumb">
				<li>
					<a href="<c:url value="/"/>">Home</a>
					<i class="fa fa-circle"></i>
				</li>
				<li>
					<a href="<c:url value="/location/location.html"/>">Location list</a>
					
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
								<i class="fa fa-edit"></i>Add new location
							</div>
							
							
						</div>
						
						<div class="portlet-body">
							<form autocomplete="off" id="locationInfo">
			                    <div class="form-group">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <label for="name"><spring:message code="lbl.name"/><span style="color: red;">*</span></label>
			                                <input id="name" class="form-control" name="name" required="required"/>
			                            </div>
			                        </div>
			                    </div>
			                    <div class="form-group">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <label for="code"><spring:message code="lbl.code"/><span style="color: red;">*</span></label>
			                                <input id="code" class="form-control" name="code" required="required"/>
			                            </div>
			                        </div>
			                    </div>
			                    <div class="form-group">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <label for="description"><spring:message code="lbl.description"/><span style="color: red;">*</span></label>
			                                <input id="description" class="form-control" name="description" required="required" />
			                            </div>
			                        </div>
			                    </div>
			
			                    <div class="form-group">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <label for="locationTag"> <spring:message code="lbl.tag"/><span style="color: red;">*</span></label>
			                                <select class="form-control custom-select custom-select-lg mb-3" id="locationTag" name="locationTag" required="required">
			                                    <option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
			                                    <%
			                                        for (Map.Entry<Integer, String> entry : tags.entrySet()) {
			                                            if(selectedTag==entry.getKey()){
			                                    %>
			                                    <option value="<%=entry.getKey()%>" selected><%=entry.getValue() %></option>
			                                    <%
			                                    } else{
			                                    %>
			                                    <option value="<%=entry.getKey()%>"><%=entry.getValue() %></option>
			                                    <%
			                                            }
			                                        }
			                                    %>
			                                </select>
			                            </div>
			                        </div>
			                    </div>
			
			                    <div id="division" class="form-group" style="display: none;">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <div class="ui-widget">
			                                    <label><spring:message code="lbl.division"/><span style="color: red;">*</span></label>
			                                    <select id="division-option" class="form-control" name="divisionId">
			                                    </select>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
			
			                    <div id="district" class="form-group" style="display: none;">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <div class="ui-widget">
			                                    <label><spring:message code="lbl.district"/><span style="color: red;">*</span></label>
			                                    <select id="district-option" class="form-control" name="districtId">
			                                    </select>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
			
			                    <div id="upazila" class="form-group" style="display: none;">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <div class="ui-widget">
			                                    <label><spring:message code="lbl.upazila"/><span style="color: red;">*</span></label>
			                                    <select id="upazila-option" class="form-control" name="upazilaId">
			                                    </select>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
			
			                    <div id="pourasabha" class="form-group" style="display: none;">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <div class="ui-widget">
			                                    <label><spring:message code="lbl.pourasabha"/><span style="color: red;">*</span></label>
			                                    <select id="pourasabha-option" class="form-control" name="pourasabhaId">
			                                    </select>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
			
			                    <div id="union" class="form-group" style="display: none;">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <div class="ui-widget">
			                                    <label><spring:message code="lbl.union"/><span style="color: red;">*</span></label>
			                                    <select id="union-option" class="form-control" name="unionId">
			                                    </select>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
			
			                    <input id="parentLocation" name="parentLocation" hidden/>
			
			                    <%-- <div class="form-group">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <label for="loginLocation"><spring:message code="lbl.loginLocation"/></label>
			                                <input type="checkbox" id="loginLocation" class="chk" name="loginLocation"/>
			
			                                <label for="visitLocation"><spring:message code="lbl.visitLocation"/></label>
			                                <input id="visitLocation" type="checkbox" class="chk" name="visitLocation"/>
			                            </div>
			                        </div>
			                    </div> --%>
			
			                    <div class="form-group text-right">
			                        <div class="row">
			                            <div class="col-lg-6">
			                                <input type="submit" value="<spring:message code="lbl.save"/>" class="btn btn-primary btn-block" />
			                            </div>
			                        </div>
			                    </div>
			                </form>
							
							
							
							
						</div>
					</div>
					
					
					
					
					
				</div>
			</div>
			<!-- END PAGE CONTENT-->
		</div>
	</div>
	<!-- END CONTENT -->
</div>
<script>
jQuery(document).ready(function() {       
	 Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
   //TableAdvanced.init();
});
</script>

<script src="<c:url value='/resources/js/jquery-3.3.1.js' />"></script>
    <script src="<c:url value='/resources/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>

    <script src="<c:url value='/resources/js/checkbox.js'/>"></script>
    <script src="<c:url value='/resources/js/jquery.modal.min.js'/>"></script>
    <script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>

    <script>
        $(document).ready(function () {
        });

        $('#locationInfo').submit(function(event) {
            event.preventDefault();
            var visitLocation = false, loginLocation = false;
            if ($('#visitLocation').is(":checked")) {
                loginLocation = true;
            }
            if ($('#loginLocation').is(":checked")) {
                visitLocation = true;
            }
            var url = "/opensrp-dashboard/rest/api/v1/location/save";
            var token = $("meta[name='_csrf']").attr("content");
            var header = $("meta[name='_csrf_header']").attr("content");
            var formData = {
                'name': $('#name').val(),
                'code': $('#code').val(),
                'description': $('#description').val(),
                'parent_location_id': $('#parentLocation').val(),
                'location_tag_id': $('#locationTag').val(),
                'division_id': $('#division-option').val(),
                'district_id': $('#district-option').val(),
                'upazila_id': $('#upazila-option').val(),
                'pourasabha_id': $('#pourasabha-option').val(),
                'union_id': $('#union-option').val(),
                'created_at': new Date(),
                'is_login_location': visitLocation,
                'is_visit_location': loginLocation
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
                    $("#loading").show();
                },
                success : function(data) {
                    $("#loading").hide();
                    $('#locationErrorMessage').html("");
                    if(data == ""){
                        window.location.replace("/opensrp-dashboard/location/location.html");
                    } else {
                        $('#locationErrorMessage').html(data);
                    }
                    console.log(data);
                },
                error : function(data) {
                    $('#locationErrorMessage').html("");
                    $("#loading").hide();
                    if (data.status == 0) {
                        $('#locationErrorMessage').html("Check your internet connection and try again...");
                    } else {
                        $('#locationErrorMessage').html("Something bad happened, please contact with admin...");
                    }
                    console.log("IN ERROR");
                    console.log(data);
                },
                complete : function(data) {
                    $("#loading").hide();
                    console.log("IN COMPLETE");
                    console.log(data.status);
                }
            });
        });

        function getLocationHierarchy(url, id) {
            $("#"+id).html("");
            $.ajax({
                type : "GET",
                contentType : "application/json",
                url : url,

                dataType : 'html',
                timeout : 100000,
                beforeSend: function() {},
                success : function(data) {
                    $("#"+id).html(data);
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

        function showHideOptions(nextDivId, tagOrLocationId, nextOptionId, tagOrLocation, tagId) {
            var selectedLocationTag = $("#locationTag").val();
            var parentLocationId = parseInt(tagOrLocationId.split("?")[0]);

            if (selectedLocationTag == 27) {
                parentLocationId = 0;
                $('#division').hide();
                $('#division-option').html("");
                $('#division-option').prop('required', false);
            }
            if (selectedLocationTag == 28) {
                parentLocationId = 9265;
                $('#division').hide();
                $('#division-option').html("");
                $('#division-option').prop('required', false);
            }
            $('#parentLocation').val(parentLocationId);

            if (selectedLocationTag > tagId) {
                $("#"+nextDivId).show();
                $('html, body').animate({
                    scrollTop: $("#"+nextDivId).offset().top
                }, 500);
                if (tagOrLocationId != '' && tagOrLocationId != null && tagOrLocationId != -1 && tagOrLocationId != undefined && tagOrLocationId != "0?") {
                    getLocationHierarchy("/opensrp-dashboard/"+tagOrLocation+"?id="+parentLocationId+"&title=", nextOptionId) ;
                    $("#"+nextOptionId).prop('required', true);
                }
            }
        }

        $('#locationTag').change(function (event) {
            var divisionTagId = "28";

            $('#parentLocation').val(9265);
            showHideOptions("division", divisionTagId, "division-option", "location-by-tag-id", 28);

            $('#district').hide();
            $('#upazila').hide();
            $('#pourasabha').hide();
            $('#union').hide();

            $('#district-option').html("");
            $('#upazila-option').html("");
            $('#pourasabha-option').html("");
            $('#union-option').html("");

            $('#district-option').prop('required', false);
            $('#upazila-option').prop('required', false);
            $('#pourasabha-option').prop('required', false);
            $('#union-option').prop('required', false);
        });

        $("#division-option").change(function(event) {
            var selectedDivision = $("#division-option").val();
            showHideOptions("district", selectedDivision, "district-option", "child-locations", 29);

            $('#upazila').hide();
            $('#pourasabha').hide();
            $('#union').hide();

            $('#upazila-option').html("");
            $('#pourasabha-option').html("");
            $('#union-option').html("");

            $('#upazila-option').prop('required', false);
            $('#pourasabha-option').prop('required', false);
            $('#union-option').prop('required', false);
        });

        $("#district-option").change(function(event) {
            var selectedDistrict = $("#district-option").val();
            showHideOptions("upazila", selectedDistrict, "upazila-option", "child-locations", 30);

            $('#pourasabha').hide();
            $('#union').hide();

            $('#pourasabha-option').html("");
            $('#union-option').html("");

            $('#pourasabha-option').prop('required', false);
            $('#union-option').prop('required', false);
        });

        $("#upazila-option").change(function(event) {
            var selectedUpazila = $("#upazila-option").val();
            showHideOptions("pourasabha", selectedUpazila, "pourasabha-option", "child-locations", 31);

            $('#union').hide();

            $('#union-option').html("");

            $('#union-option').prop('required', false);
        });

        $("#pourasabha-option").change(function(event) {
            var selectedPourasabha = $("#pourasabha-option").val();
            showHideOptions("union", selectedPourasabha, "union-option", "child-locations", 32);
        });

        $("#union-option").change(function(event) {
            var selectedPourasabha = $("#union-option").val();
            var parentLocationId = parseInt(selectedPourasabha.split("?")[0]);
            $('#parentLocation').val(parentLocationId);
        });
    </script>
