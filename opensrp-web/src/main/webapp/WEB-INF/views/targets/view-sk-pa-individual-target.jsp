<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
           uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>SK, PA  list</title>

<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="get_target_url" value="/target/get-target-info" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />


<div class="page-content-wrapper">
    <div class="page-content">
        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-list"></i>SK, PA  list
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="form-group">


                            <div class="row">

                                <div class="col-lg-3 form-group">
                                    <label for="date">Date:</label> <span class="text-danger"> *</span>
                                    <input type="text"	readonly name="startYear" id="startYear" class="form-control date-picker-year" />
                                    <span id="validationMessage" class="text-danger"></span>
                                </div>
                                <div class="col-lg-9 form-group text-right">
                                    <button type="submit" onclick="getTargetInfo()" class="btn btn-primary" value="confirm">Submit</button>
                                </div>

                            </div>

                        </div>
                        <h3>${name }'s target </h3>
                        <div class="table-scrollable ">
                            <form id="targetInfo"  autocomplete="off">
                                <div class="col-md-12 form-group text-al">
                                    <div class="row  form-group">
                                        <div class="col-lg-12 form-group">
                                            <div class="col-md-3">
                                                <label><strong>Item </strong></label>
                                            </div>
                                            <div class="col-md-3">
                                                <label><strong>Target</strong></label>
                                            </div>
                                            <div class="col-md-3">
                                                <label><strong>Item </strong></label>
                                            </div>
                                            <div class="col-md-3">
                                                <label><strong>Target</strong></label>
                                            </div>
                                        </div>
                                        <br />
                                        <hr />
                                        <div id="productInfoS">
                                            <c:forEach var="target" items="${ targets }">
                                                <div class="col-lg-6 form-group">
                                                    <div class="col-md-6">
                                                        <label><strong>${ target.name } </strong></label>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <input type="number" class="form-control" min="1" id="${target.id }" name ="qty[]" disabled>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <div id="errorMessage">
                                    <div class="alert-message warn">
                                        <div id="errormessageContent" class="alert alert-successs text-right"> </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/footer.jsp" />
    </div>
</div>
<!-- END CONTENT -->
<jsp:include page="/WEB-INF/views/dataTablejs.jsp" />

<script src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
    jQuery(document).ready(function() {
        Metronic.init(); // init metronic core components
        Layout.init(); // init current layout

    });

    function getTargetInfo(){
        var date = $("#startYear").val();
        if(date == "" || date ==null) {
            $("#validationMessage").html("<strong>This field is required</strong>");
            return;
        }
        $("#validationMessage").html("");
        var d = new Date(date);
        var date = d.getDate();
        var month = (d.getMonth() + 1);
        var year = d.getFullYear();


        /* var monthYearString=$('input#startYear').val();
        var splitingString = monthYearString.split("-");
        var month = parseInt(splitingString[0])-1;
        var year = parseInt(splitingString[1]); */
        if(month==0){
            console.log(month);
            month = 12;
            year = year-1;
        }
        var url = '${get_target_url}';

        url = url+"?locationOrBranchOrUserId="+'${userId}'+"&role="+'${roleId}'+"&typeName="+'USER'+"&locationTag="+'NA'+"&month="+month+"&year="+year;

        $.ajax({
            contentType : "application/json",
            type: "GET",
            url: url,
            dataType : 'html',
            timeout : 100000,
            beforeSend: function(xhr) {
                $("#loading").show();
            },
            success : function(data) {
                console.log(data);
                $("#productInfoS").html(data);
                $("#targetInfo :input").prop("disabled", true);
            },
            error : function(e) {
                console.log(e);
            },
            done : function(e) {
                console.log("DONE");
            }
        });
    }

    jQuery(function() {
        jQuery('.date-picker-year').datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'MM yy',
            maxDate: new Date,
            onClose: function(dateText, inst) {
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
            }
        });
        jQuery(".date-picker-year").focus(function () {
            $(".ui-datepicker-calendar").hide();
            $(".ui-datepicker-current").hide();
        });
    });

</script>
