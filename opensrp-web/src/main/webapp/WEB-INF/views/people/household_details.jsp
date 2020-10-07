<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Households</title>



<c:url var="get_url" value="/rest/api/v1/people/household/list" />


<jsp:include page="/WEB-INF/views/header.jsp" />
<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<c:url var="get_member_url" value="/rest/api/v1/people/member/list" />


<div class="page-content-wrapper">
	<div class="page-content">
		<ul class="page-breadcrumb breadcrumb">
			<li><a href="<c:url value="/"/>">Home</a> <i
				class="fa fa-circle"></i></li>
			<li><a href="<c:url value="/people/households.html"/>">Households</a>

			</li>

		</ul>
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Households
						</div>
					</div>
					<div class="portlet-body">

						<div class="tabbable tabbable-custom tabbable-noborder">
							<ul class="nav nav-tabs">

								<li data-target="#hh_info" role="tab" data-toggle="tab"
									class="active btn btn-success btn-sm">Household
									information</li>
								<li data-target="#member_info" role="tab" data-toggle="tab"
									class="btn btn-success btn-sm">Member information</li>
								<li data-target="#reg_visit" role="tab" data-toggle="tab"
									class="btn btn-success btn-sm">Registration & visits</li>
							</ul>
							<div class="tab-content">
								<div class="tab-pane active" id="hh_info">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">
													<jsp:include page="/WEB-INF/views/dynamic_content.jsp" />
												</div>
											</div>
										</div>
									</div>
								</div>


								<div class="tab-pane" id="reg_visit">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">
													<jsp:include page="/WEB-INF/views/service_list.jsp" />
												</div>
											</div>
										</div>
									</div>
								</div>



								<div class="tab-pane" id="member_info">
									<div class="margin-top-10">
										<div class="col-md-12 form-group">

											<div class="form-group">

												<div class="row">
													<div class="table-scrollable">
														<table class="table table-striped table-bordered "
															id="memberTable">
															<thead>
																<tr>
																	<th>Member name</th>
																	<th>Member ID</th>
																	<th>Household ID</th>
																	<th>Relation with <br />household head
																	</th>
																	<th>Age</th>
																	<th>Gender</th>
																	<th>Status</th>
																	<th>Village</th>
																	<th>Branch(code)</th>

																	<th>Action</th>
																</tr>
															</thead>
															<tbody>
																<c:forEach var="member" items="${members}"
																	varStatus="loop">
																	<tr>
																		<td>${member.getMemberName() }</td>
																		<td>${member.getMemberId() }</td>
																		<td>${member.getHouseholdId() }</td>
																		<td>${member.getRelationWithHousehold() }</td>
																		<td>${member.getAge() }</td>
																		<td>${member.getGender() }</td>
																		<td>${member.getMemberType() }</td>
																		<td>${member.getVillage() }</td>
																		<td>${member.getBranchAndCode() }</td>
																		<%-- <% if(AuthenticationManagerUtil.isPermitted("PERM_UPDATE_LOCATION_TAG")){ %> --%>
																		<td><a
																			href="<c:url value="/people/member-details/${member.getBaseEntityId()}/${member.getId()}.html?lang=${locale}"/>">Details</a>
																			<%-- <%} %> --%></td>
																	</tr>
																</c:forEach>
															</tbody>

														</table>
													</div>

												</div>
											</div>
										</div>
									</div>
								</div>



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

<script
	src="<c:url value='/resources/assets/admin/js/table-advanced.js'/>"></script>

<script>
	jQuery(document).ready(function() {
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout

	});
</script>


<script>
	let
	stockList;
	$(document).ready(function() {

		stockList = $('#memberTable').DataTable({
			bFilter : false,

			columnDefs : [

			{
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 0
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 1
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 2
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 3
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 4
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 5
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 6
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 7
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 8
			}, {
				orderable : false,
				className : 'reorder',
				width : "10%",
				targets : 9
			}

			],

			bInfo : true,
			destroy : true,
			language : {
				searchPlaceholder : ""
			}
		});
	});

</script>














