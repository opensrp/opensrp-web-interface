<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ page import="org.opensrp.core.entity.Branch" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<%
    List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
    String startDate = (String) session.getAttribute("startDate");
    String endDate = (String) session.getAttribute("endDate");
%>

<style>
    .form-control {
        display: inline-block;
        width: 100%;
        height: calc(2.25rem + 2px);
        padding: .375rem 1.75rem .375rem .75rem;
        line-height: 1.5;
        color: #495057;
        vertical-align: middle;
        background-size: 8px 10px;
        border: 1px solid #ced4da;
        border-radius: .25rem;
        -webkit-appearance: none;
        background: #fff;
    }
</style>


<div class="portlet box blue-madison">
    <div class="portlet-title">
        <div class="caption">
            <i class="fa fa-table"></i><spring:message code="lbl.searchArea"/>
        </div>
    </div>
    <div class="portlet-body">
        <div class="row"></div>
        <form autocomplete="off">
            <div class="row">
                <div class="col-md-2">
                    <label>Start Month</label>
                    <input class="form-control " type=text
                           name="start" id="startDate" value="<%=startDate%>">
                    <label style="display: none;" class="text-danger" id="startDateValidation"><small>Input is not valid for date</small></label>
                </div>
                <div class="col-md-2">
                    <label>End Month</label>
                    <input class="form-control " type="text"
                           name="end" id="endDate" value="<%=endDate%>">
                    <label style="display: none;" class="text-danger" id="endDateValidation"><small> Difference between date can not be more than 12 months</small></label>
                </div>
                <div class="col-md-2" id="divisionHide">
                    <label><spring:message code="lbl.division"/></label>
                    <select required class="form-control  mb-3" id="division"
                            name="division">
                        <option value=""><spring:message code="lbl.selectDivision"/>
                        </option>
                        <%
                            for (Object[] objects : divisions) {
                        %>
                        <option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="col-md-2" id="districtHide">
                    <label><spring:message code="lbl.district"/></label>
                    <select class="form-control  mb-3" id="district"
                            name="district">
                        <option value="0?"><spring:message code="lbl.selectDistrict"/></option>
                        <option value=""></option>
                    </select>
                </div>
<%--                <div class="col-md-3" id="upazilaHide">--%>
<%--                    <label><spring:message code="lbl.upazila"/></label>--%>
<%--                    <select class="form-control  mb-3" id="upazila"--%>
<%--                            name="upazila">--%>
<%--                        <option value="0?"><spring:message code="lbl.selectUpazila"/></option>--%>
<%--                        <option value=""></option>--%>

<%--                    </select>--%>
<%--                </div>--%>
            </div>
        </form>
        <input type="hidden" id ="address_field" name="address_field"/>
        <input type="hidden" id ="searched_value" name="searched_value"/>
        <input type="hidden" id ="searched_value_id" name="searched_value_id"/>
        <br/>
        <div class="row">
            <div class="col-md-3">
                <label> Services </label><br>
                    <select class="form-control form-control" id="serviceItem" style="width: 95%" >
                        <option value="hhVisit"> Household Visit</option>
                        <option value="elcoRegistration"> Elco Registration</option>
                        <option value="methodUsers"> Method Users</option>
                        <option value="adolescentMethodUser"> Adolescent Method User</option>
                        <option value="pregnancy"> Pregnancy Identified</option>
                        <option value="delivery"> Delivery</option>
                        <option value="instituteDelivery"> Institutionalized Delivery</option>
                        <option value="child0To6"> Child 0 To 6</option>
                        <option value="child7To24"> Child 7 To 24</option>
                        <option value="child18To36"> Child 18 To 36</option>
                        <option value="immunization"> Immunization</option>
                        <option value="anc"> ANC Service </option>
                        <option value="pnc"> PNC Service </option>
                        <option value="adolescent"> Adolescent Service</option>
                        <option value="women"> Women Service </option>
                        <option value="ncd"> NCD Service </option>
                        <option value="iycf"> IYCF Service </option>
                        <option value="forumIycf"> IYCF Forum </option>
                        <option value="forumIycfParticipant"> IYCF Forum Participant</option>
                        <option value="forumAdolescent"> Adolescent Forum</option>
                        <option value="forumAdolescentParticipant"> Adolescent Forum Participant</option>
                        <option value="forumWomen"> Women Forum</option>
                        <option value="forumWomenParticipant"> Women Forum Participant</option>
                        <option value="forumAdult"> Adult Forum</option>
                        <option value="forumAdultParticipant"> Adult Forum Participant</option>
                        <option value="forumNcd"> NCD Forum</option>
                        <option value="forumNcdParticipant"> NCD Forum Participant </option>
                    </select>

            </div>
        </div>
        <br/>
        <div class="row">

            <div class="col-md-6">
                <button id="search-button"
                        onclick="loadPerformanceMap()"
                        type="submit"
                        class="btn btn-primary">
                    <spring:message code="lbl.search"/>
                </button>
            </div>
        </div>
    </div>
    <div class="card-footer small text-muted"></div>
</div>
<script>

    var fromDate = new Date();
    fromDate.setMonth(fromDate.getMonth() - 12);
    var dtPickerFrom = $('#startDate').datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        maxDate: new Date(),
        onClose: function(dateText, inst)
        {
            var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
            $('#startDate').datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
            $(".date-picker-year").focus(function () {
                $(".ui-datepicker-calendar").hide();
                $(".ui-datepicker-current").hide();
            });

        }
    });

    dtPickerFrom.datepicker('setDate', fromDate);
    var dtPickerTo = $('#endDate').datepicker({
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        maxDate: new Date(),

        onClose: function(dateText, inst)
        {
            $('#endDate').datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
            $(".date-picker-year").focus(function () {
                $(".ui-datepicker-calendar").hide();
                $(".ui-datepicker-current").hide();
            });

        }
    });
    dtPickerTo.datepicker('setDate', new Date());
</script>
