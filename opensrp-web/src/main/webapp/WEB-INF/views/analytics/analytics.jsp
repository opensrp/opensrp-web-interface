<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
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

/* 	Integer[] ancRate = (Integer[]) session.getAttribute("ancRate");
	Integer[] pncRate = (Integer[]) session.getAttribute("pncRate");
	Integer[] ancReferred = (Integer[]) session.getAttribute("ancReferred");
	Integer[] pncReferred = (Integer[]) session.getAttribute("pncReferred");
	Integer[] serviceRate = (Integer[]) session.getAttribute("serviceRate");
	Integer[] ancCCAccess = (Integer[]) session.getAttribute("ancCCAccess");
	Integer[] pncCCAccess = (Integer[]) session.getAttribute("pncCCAccess");
	Integer[] serviceAccess = (Integer[]) session.getAttribute("serviceAccess"); */
%>

<!DOCTYPE html>
<html lang="en">

	<head>
		<meta charset="utf-8">
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title><spring:message code="lbl.viewRefresh"/></title>
		<style>
			td.large-font {
				font-size: 18px;
				font-weight: bolder;
				color: maroon;
			}
			td, th {
				text-align: center !important;
			}
		</style>
		<link type="text/css"
			  href="<c:url value="/resources/css/dataTables.jqueryui.min.css"/>" rel="stylesheet">
		<jsp:include page="/WEB-INF/views/header.jsp" />
		<script src="<c:url value='/resources/chart/highcharts.js'/>"></script>
		<script src="<c:url value='/resources/chart/data.js'/>"></script>
		<script src="<c:url value='/resources/chart/drilldown.js'/>"></script>
		<script src="<c:url value='/resources/chart/series-label.js'/>"></script>

	<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

			<form id="search-form" autocomplete="off">
				<div class="row">
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="division"
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

					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="district"
								name="district">
							<option value="0?"><spring:message code="lbl.selectDistrict"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="upazila"
								name="upazila">
							<option value="0?"><spring:message code="lbl.selectUpazila"/></option>
							<option value=""></option>

						</select>
					</div>
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="union"
								name="union">
							<option value="0?"><spring:message code="lbl.selectUnion"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-1">
						<select class="custom-select custom-select-lg mb-3" id="ward"
								name="ward">
							<option value="0?"><spring:message code="lbl.selectWard"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-2">
						<select class="custom-select custom-select-lg mb-3" id="cc"
								name="cc">
							<option value="0?"><spring:message code="lbl.selectCC"/></option>
							<option value=""></option>
						</select>
					</div>
					<div class="col-1">
						<button name="search" type="submit" id="bth-search"
								class="btn btn-primary btn-sm" value="search"><spring:message code="lbl.search"/></button>
					</div>
				</div>
			</form>

			<br>
			<div class="bs-example">
				<ul class="nav nav-tabs">
					<li class="nav-item">
						<a href="#home" class="nav-link active" data-toggle="tab">
							<spring:message code="lbl.ancUtilization"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#profile" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.pncUtilization"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#messages" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.serviceUtilization"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#nenonatalservice" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.nenonatalServiceUtilization"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#serviceutilizationunderfive" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.serviceUtilizationUnderFive"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#serviceutilizationFamily" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.serviceUtilizationFamilyPlanning"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#lccutilization" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.utilizationOfLcc"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#utilizationcatchment" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.utilizationOfCatchmentArea"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#serviceseekertotal" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.totalServiceSeekerDistribution"/>
						</a>
					</li>
					<li class="nav-item">
						<a href="#nvdcatchmentarea" class="nav-link" data-toggle="tab">
							<spring:message code="lbl.nvdInCatchmentArea"/>
						</a>
					</li>
				</ul>
				<br>
				<div class="tab-content">
				
					<div class="tab-pane fade show active" id="home">
					<jsp:include page="/WEB-INF/views/analytics/ancUtilizationTab.jsp" />
					</div>
					
					<div class="tab-pane fade show" id="profile">
					<jsp:include page="/WEB-INF/views/analytics/pncUtilizationTab.jsp" />
					</div>
					
					<div class="tab-pane fade show" id="messages">
					<jsp:include page="/WEB-INF/views/analytics/serviceUtilizationTab.jsp" />
					</div>
					<div class="tab-pane fade show" id="nenonatalservice">
					<jsp:include page="/WEB-INF/views/analytics/neoNatalUtilizationTab.jsp" />
					</div>
					<div class="tab-pane fade show" id="serviceutilizationunderfive">
					<jsp:include page="/WEB-INF/views/analytics/serviceUtilizationUnderFiveTab.jsp" />
					</div>
					<div class="tab-pane fade show" id="serviceutilizationFamily">
					<jsp:include page="/WEB-INF/views/analytics/familyPlanningUtilization.jsp" />
					</div>
					<div class="tab-pane fade show" id="lccutilization">
					<jsp:include page="/WEB-INF/views/analytics/utilizationOfLcc.jsp" />
					</div>
					<div class="tab-pane fade show" id="utilizationcatchment">
					<jsp:include page="/WEB-INF/views/analytics/utilizationOfCatchmentArea.jsp" />
					</div>
					<div class="tab-pane fade show" id="serviceseekertotal">
					<jsp:include page="/WEB-INF/views/analytics/totalServiceSeekerDistribution.jsp" />
					</div>
					<div class="tab-pane fade show" id="nvdcatchmentarea">
					<jsp:include page="/WEB-INF/views/analytics/catchmentAreaNVD.jsp" />
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	</body>

</html>