<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">


<title><spring:message code="lbl.addBranchTitle"/></title>
<jsp:include page="/WEB-INF/views/css.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<%
	List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
%>

<style>
	.row {
		padding-bottom: 8px;
	}
</style>

<div class="page-content-wrapper">
	<div class="page-content">
		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="caption">
					<i class="fa fa-list"></i><spring:message code="lbl.addBranchTitle"/>
				</div>
			</div>
			<div class="portlet-body">
				<div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
					<img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
				</div>
				<form:form modelAttribute="branch" id="BranchInfo" class="form-inline" autocomplete="off">

					<div class="row">
						<div class="col-md-2" align="right"><label class="label-width" for="name"> <spring:message code="lbl.branchName"/> </label></div>
						<div class="col-md-3"><form:input path="name" class="form-control mx-sm-3" required="required" /></div>
					</div>

					<div class="row">
						<div class="col-md-2" align="right"><label class="label-width" for="code"> <spring:message code="lbl.branchCode"/> </label></div>
						<div class="col-md-3"><form:input path="code" class="form-control mx-sm-3" required="required" /></div>
					</div>
					<div class="row">
						<div class="col-md-2" align="right"><label><spring:message code="lbl.division"/></label></div>
						<div class="col-md-3">
							<select required class="form-control" id="division"
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
					</div>
					<div class="row">
						<div class="col-md-2" align="right"><label><spring:message code="lbl.district"/></label></div>
						<div class="col-md-3" id="districtHide">

							<select required class="form-control" id="district"
									name="district">
								<option value="0?"><spring:message code="lbl.selectDistrict"/></option>
								<option value=""></option>
							</select>
						</div>
					</div>
					<div class="row" >
						<div class="col-md-2" align="right"><label><spring:message code="lbl.upazila"/></label></div>

						<div class="col-md-3" id="upazilaHide">
							<select required class="form-control" id="upazila"
									name="upazila">
								<option value="0?"><spring:message code="lbl.selectUpazila"/></option>
								<option value=""></option>

							</select>
						</div>

					</div>
					<div class="row">
						<div class="col-md-2" align="right"><label class="label-width" for="skPosition"> <spring:message code="lbl.skPosition"/> </label></div>
						<div class="col-md-3"><form:input path="skPosition" class="form-control mx-sm-3"/></div>
					</div>
					<div class="row">
						<div class="col-md-2" align="right"><label class="label-width" for="ssPosition"> <spring:message code="lbl.ssPosition"/> </label></div>
						<div class="col-md-3"><form:input path="ssPosition" class="form-control mx-sm-3"/></div>
					</div>
					<div class="row">
						<div class="col-md-2" align="right"><label class="label-width" for="paPosition"> <spring:message code="lbl.paPosition"/> </label></div>
						<div class="col-md-3"><form:input path="paPosition" class="form-control mx-sm-3"/></div>
					</div>
					<div class="row">
						<div class="col-md-2" align="right"><label class="label-width" for="pkPosition"> <spring:message code="lbl.pkPosition"/> </label></div>
						<div class="col-md-3"><form:input path="pkPosition" class="form-control mx-sm-3"/></div>
					</div>
					<div class="row">
						<div class="col-md-offset-2" style="padding-left: 15px">
							<div id="errorMessage" style="color: red; font-size: small; display: none; margin-left: 20px; margin-top: 5px;"></div>
							<div class="form-group">
								<input type="submit" style="padding:5px" value="<spring:message code="lbl.save"/>" class="btn btn-primary btn-block btn-center" />
							</div>
						</div>
					</div>
				</form:form>

			</div>
		</div>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>

</div>
<script>
	jQuery(document).ready(function() {
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		//TableAdvanced.init();
	});
	$("#BranchInfo").submit(function (event) {
		$("#loading").show();
		var url = "/opensrp-dashboard/rest/api/v1/branch/save";
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		var formData = {
			'name': $('input[name=name]').val(),
			'code': $('input[name=code]').val(),
			'division': $('#division').val().split("?")[0],
			'district': $('#district').val().split("?")[0],
			'upazila': $('#upazila').val().split("?")[0],
			'skPosition': parseInt($('input[name=skPosition]').val()),
			'ssPosition': parseInt($('input[name=ssPosition]').val()),
			'paPosition': parseInt($('input[name=paPosition]').val()),
			'pkPosition': parseInt($('input[name=pkPosition]').val())
		};

		event.preventDefault();
		console.log(formData);
		console.log("Header: ", header);
		console.log("Token: ", token);
		$.ajax({
			contentType : "application/json",
			type: "POST",
			url: url,
			data: JSON.stringify(formData),
			dataType : 'json',

			timeout : 100000,
			beforeSend: function(xhr) {
				$('#errorMessage').hide();
				$('#errorMessage').html("");
				xhr.setRequestHeader(header, token);
			},
			success : function(data) {
				if (data == "") {
					$('#loading').hide();
					window.location.replace("/opensrp-dashboard/branch-list.html");
				} else {
					$('#errorMessage').html(data);
					$('#errorMessage').show();
					$('#loading').hide();
				}
			},
			error : function(e) {
				$('#loading').hide();
				$('#errorMessage').html(data);
				$('#errorMessage').show();
			},
			complete : function(e) {
				$("#loading").hide();
				console.log("DONE");
			}
		});
	});
</script>
</html>
