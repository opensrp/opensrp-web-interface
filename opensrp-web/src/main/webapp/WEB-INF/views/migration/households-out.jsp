<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<title>Migrated household list(Out)</title>
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

.select2-multiple, .select2-multiple2 {
	width: 50%
}

.select2-results__group .wrap:before {
	display: none;
}
</style>


<c:url var="get_url" value="/rest/api/v1/migration/household-in/list" />

<jsp:include page="/WEB-INF/views/dataTablecss.jsp" />
<jsp:include page="/WEB-INF/views/header.jsp" />

<jsp:include page="/WEB-INF/views/modal_content_migration.jsp" />
<div class="page-content-wrapper">
	<div class="page-content">
		<div class="row">
			<div class="col-md-12">

				<!-- BEGIN EXAMPLE TABLE PORTLET-->
				<div class="portlet box blue-madison">
					<div class="portlet-title">
						<div class="caption">
							<i class="fa fa-list"></i>Migrated household list(Out)
						</div>
					</div>
					<div class="portlet-body">
						<div class="row">
							<jsp:include page="/WEB-INF/views/migration-search-option.jsp" />
							<div class="col-lg-2 form-group">
								<label for="from"><spring:message code="lbl.from"></spring:message><span
									class="text-danger"> </span> </label> <input readonly="readonly"
									type="text" class="form-control date" id="from"> <span
									class="text-danger" id="startDateValidation"></span>
							</div>
							<div class="col-lg-2 form-group">
								<label for="to"><spring:message code="lbl.to"></spring:message><span
									class="text-danger"> </span> </label> <input readonly="readonly"
									type="text" class="form-control date" id="to"> <span
									class="text-danger" id="endDateValidation"></span>
							</div>
							<div class="col-lg-3 form-group" style="padding-top: 0px">
								<label for="cars">Search key </label> <input name="search"
									class="form-control" id="search"
									placeholder="Household ID,contact number" />
							</div>

							<div class="col-lg-2 form-group" style="padding-top: 22px">
								<button type="submit" onclick="filter()" class="btn btn-primary"
									value="confirm">Search</button>
							</div>

						</div>

						<div class="row" style="margin: 0px">


							<div id="report">
								<table style="width: 100%;"
									class="display table table-bordered table-striped"
									id="dataTableId">
									<thead>
										<tr>
											<th rowspan="2">Date of migration</th>
											<th rowspan="2">HH head</th>
											<th rowspan="2">HH ID</th>
											<th rowspan="2">HH head contact</th>
											<th rowspan="2">#Member</th>
											<th colspan="2">From</th>
											<th colspan="2">To</th>

											<th rowspan="2">Status</th>
											<th rowspan="2">Action</th>
										</tr>
										<tr>
											<th>SS</th>
											<th>Village</th>
											<th>Branch</th>
											<th>District</th>
										</tr>
									</thead>

								</table>
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
<script
	src="<c:url value='/resources/js/dataTables.fixedColumns.min.js'/>"></script>
<script
	src="<c:url value='/resources/assets/global/js/select2-multicheckbox.js'/>"></script>

<script>
	jQuery(document).ready(function() {
		$('#branchList').select2MultiCheckboxes({
			placeholder: "Select branch",
			width: "auto",
			templateSelection: function(selected, total) {
				return "Selected " + selected.length + " of " + total;
			}
		});
		Metronic.init(); // init metronic core components
		Layout.init(); // init current layout
		$("#branchList > option").prop("selected", "selected");
		$("#branchList").trigger("change");
	});
</script>
<script type="text/javascript">
	var dateToday = new Date();
	var dates = $(".date").datepicker({
		dateFormat : 'yy-mm-dd',
	/* maxDate: dateToday,
	 onSelect: function(selectedDate) {
	 var option = this.id == "from" ? "minDate" : "maxDate",
	 instance = $(this).data("datepicker"),
	 date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
	 dates.not(this).datepicker("option", option, date);
	 } */
	});
	var d = new Date();
	var startDate = $.datepicker.formatDate('yy-mm-dd', new Date(d
			.getFullYear(), d.getMonth(), 1));

	$("#from").datepicker('setDate', startDate);
	$("#to").datepicker('setDate', new Date());
</script>
<script>
	let
	stockList;
	$(document).ready(function() {

		stockList = $('#dataTableId').DataTable({
			bFilter : false,
			serverSide : true,
			processing : true,
			scrollY : "300px",
			scrollX : true,
			scrollCollapse : true,
			fixedColumns : {
				leftColumns : 2
			},
			"ordering" : false,
			ajax : {
				url : "${get_url}",
				timeout : 300000,
				data : function(data) {
					var branchIds = $("#branchList").val();
					if (branchIds == null || typeof branchIds == 'undefined') {
						branchIds = ''
					} else {
						branchIds = $("#branchList").val().join();
					}
					data.branchIdIn ="";
					data.branchIdOut=branchIds,
					data.searchKeyOut = "";
					data.searchKeyIn = "";
					data.startDate = $('#from').val();
					data.endDate = $('#to').val();
					data.migrateType='out';

				},
				dataSrc : function(json) {
					if (json.data) {
						return json.data;
					} else {
						return [];
					}
				},
				complete : function() {
				},
				type : 'GET'
			},
			bInfo : true,
			destroy : true,
			language : {
				searchPlaceholder : ""
			}
		});
	});

	function filter() {	

		var branchIds = $("#branchList").val();
		if (branchIds == null || typeof branchIds == 'undefined') {
			branchIds = ''
		} else {
			branchIds = $("#branchList").val().join();
		}

		if (branchIds == "" || typeof branchIds == 'undefined') {
			$("#errMsg").html("Please select branch");
			return false;
		} else {
			$("#errMsg").html("");
		}

		
		stockList = $('#dataTableId').DataTable({
			bFilter : false,
			serverSide : true,
			processing : true,
			scrollY : "300px",
			scrollX : true,
			scrollCollapse : true,
			fixedColumns : {
				leftColumns : 2
			},
			"ordering" : false,
			
			ajax : {
				url : "${get_url}",
				timeout : 300000,
				data : function(data) {
					data.branchIdIn = "",
					data.branchIdOut=branchIds,
					data.searchKeyIn = "",
					data.searchKeyOut= $('#search').val(),
					data.startDate = $('#from').val();
					data.endDate = $('#to').val();	
					data.migrateType='out';},
				dataSrc : function(json) {
					if (json.data) {
						
						return json.data;
					} else {
						return [];
					}
				},
				complete : function() {
				},
				type : 'GET'
			},
			bInfo : true,
			destroy : true,
			language : {
				searchPlaceholder : ""
			}
		});
	}
</script>
















