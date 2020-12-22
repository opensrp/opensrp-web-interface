<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>HR report</title>

<c:url var="branch_url" value="/branch-list-options-by-user-ids" />
<c:url var="all_branch_url" value="/all-branch-list-options" />

<c:url var="user_list_url" value="/user-list-options-by-parent-user-ids" />

<c:url var="dm_wise_hr_report" value="/report/dm-table" />
<c:url var="am_wise_hr_report" value="/report/am-table" />
<c:url var="branch_wise_hr_report" value="/report/branch-table" />

<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />


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
    .select2-multiple2 {
        width: 50%
    }

    .select2-results__group .wrap:before {
        display: none;
    }
</style>


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />


<div class="page-content-wrapper">
    <div class="page-content">
        <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
            <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
        </div>
        <div class="row">
            <div class="col-sm-6">
                <div class="dashboard-stat blue-madison">
                    <div class="visual">
                    </div>
                    <div class="details">
                        <div class="number" id="totalSK">
                            0
                        </div>
                        <div class="desc">
                            Active Provider
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="dashboard-stat blue-madison">
                    <div class="visual">
                    </div>
                    <div class="details">
                        <div class="number" id="skPosition">
                            0
                        </div>
                        <div class="desc">
                            Total Sk Position
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-list"></i> HR report
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="form-group">
                            <div class="row" id="manager">

                                <div class="col-lg-3 form-group">
                                    <label> Designation </label>
                                    <select	name="designation"  id="designation" class="form-control">
                                        <option value="sk">SK</option>
                                        <option value="pa">PA</option>
                                    </select>
                                </div>
                                <div class="col-lg-2 form-group "><br />
                                    <button type="submit" onclick="filter()" class="btn btn-primary" value="confirm">View</button>
                                </div>
                            </div>

                        </div>

                        <div class="row" style="margin: 0px">
                            <div class="col-sm-12" id="content" style="overflow-x: auto;">
                                <h3 id="reportTile" style="font-weight: bold;">Divisional manager wise hr report</h3>
                                <div id="report"></div>

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
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>
<script src="<c:url value='/resources/assets/global/js/select2-multicheckbox.js'/>"></script>

<script src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>
<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
<script>
    jQuery(document).ready(function() {
        Metronic.init(); // init metronic core components
        Layout.init(); // init current layout

        getReportData('${branch_wise_hr_report}',"Branch Wise HR Report");

    });



    function getReportData(url,title){
        var token = $("meta[name='_csrf']").attr("content");
        var header = $("meta[name='_csrf_header']").attr("content");
        $.ajax({
            type : "POST",
            contentType : "application/json",
            url : url,
            dataType : 'html',
            timeout : 300000,
            data:  JSON.stringify(getParamsData()),

            beforeSend: function(xhr) {
                xhr.setRequestHeader(header, token);
                $('#loading').show();
                $('#search-button').attr("disabled", true);
            },
            success : function(data) {
                //let managerOrLocation =$("input[name='managerOrLocation']:checked").val();
                let managerOrLocation ="managerWise";

                $('#loading').hide();
                $("#report").html(data);
                $('#search-button').attr("disabled", false);
                $('#reportTile').html(title);
                $('#reportDataTable').DataTable({
                    scrollY:        "300px",
                    scrollX:        true,
                    scrollCollapse: true,
                    fixedColumns:   {
                        leftColumns: 1
                    }
                });
            },
            error : function(e) {
                $('#loading').hide();
                $('#search-button').attr("disabled", false);
            },
            complete : function(e) {
                $('#loading').hide();
                $('#search-button').attr("disabled", false);
            }
        });
    }
</script>
<script>



    function getParamsData(){

        let AM = '${userIds}';
        let designation = $("#designation option:selected").val();

        let formData = {
            userRole: designation,
            am:AM,
        };
        return formData;
    }
    function filter(){
        var title = "Branch Wise HR Report";
        let url = '${branch_wise_hr_report}';

        getReportData(url,title);
    }
</script>

<script>
    function getAm(userId,divId) {

        let url = '${user_list_url}';
        if(userId != 0){
            // getBranchListByUserId(userId,'branchList');
            $.ajax({
                type : "GET",
                contentType : "application/json",
                url : url+"?id="+userId+"&roleId=32",
                dataType : 'html',
                timeout : 300000,
                beforeSend: function() {},
                success : function(data) {
                    $("#"+divId).html(data);
                },
                error : function(e) {
                    console.log("ERROR: ", e);
                    display(e);
                },
                done : function(e) {
                    console.log("DONE");
                }
            });
        }else{

            $("#AM").html('<option value="0">Please select </option>');
        }

    }

</script>
