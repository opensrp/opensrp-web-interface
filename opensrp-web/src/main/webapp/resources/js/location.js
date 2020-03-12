
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

jQuery(document).ready(function($) {
	var currentUser = $("#currentUser").val();
	if(currentUser == "true") {
		$('#locationoptions').show();
		$('#divisionHide').hide();
		$('#districtHide').hide();
		$('#upazilaHide').hide();
	}
	
	$("#division").change(function(event) {
		__onDivisionSelection();
	});
	$("#district").change(function(event) {
		__onDistrictSelection();
	});
	$("#upazila").change(function(event) {
		__onUpazilaSelection();
	});
	$("#pourasabha").change(function(event) {
		__onPourasabhaSelection();
	});
	$("#union").change(function(event) {
		__onUnionSelection();
	});
	
	$("#locationoptions").change(function(event) {
		let location = $("#locationoptions").val();
		if (location == 'catchmentArea') {
			$('#divisionHide').hide();
			$('#districtHide').hide();
			$('#upazilaHide').hide();
			$('#branchHide').show();
		}
		if (location == 'geolocation') {
			$('#branchHide').hide();
			$('#divisionHide').show();
			$('#districtHide').show();
			$('#upazilaHide').show();
			if ($("#searched_value_id").val() == null || $("#searched_value_id").val() == '' ) $("#searched_value_id").val(9265);
		}
		if (location == "") {
			$('#branchHide').hide();
			$('#divisionHide').hide();
			$('#districtHide').hide();
			$('#upazilaHide').hide();
		}
	});

	$("#branches").change(function (event) {
		let branchId = $('#branches').val();
		let roleId = $('#role').val();
		console.log("branch id: " + branchId);
		if (roleId == 29) {
			let url = "/opensrp-dashboard/user/sk-list?branchId="+branchId;
			$.ajax({
				type : "GET",
				contentType : "application/json",
				url : url,

				dataType : 'html',
				timeout : 100000,
				beforeSend: function() {},
				success : function(data) {
					$("#parent-user").html(data);
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
	});

	function __onDivisionSelection () {
		let division = $("#division").val();
		if (division != '' && division != null && division != -1 && division != undefined && division != "0?") {
			getLocationHierarchy("/opensrp-dashboard/location?id="+$("#division").val().split("?")[0]+"&title=","district") ;
		} else {
			$("#district").html("");
			$("#district").append("<option value='0?'>Select District</option>");
		}
		division = $("#division").val().split("?")[1];
		let divisionId = $("#division").val().split("?")[0];
		$("#address_field").val(division == undefined?"division":"district");
		$("#searched_value").val(division == undefined?"empty":"division = " + "'"+ division +"'");
		$("#searched_value_id").val(division == undefined?9265:divisionId);

		$("#upazila").html("<option value='0?'>Select Upazila/City Corporation</option>");
		$("#pourasabha").html("<option value='0?'>Select Pourasabha</option>");
		$("#union").html("<option value='0?'>Select Union/Ward</option>");
		$("#village").html("<option value='0?'>Select Village</option>");
	}

	function __onDistrictSelection() {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#district").val().split("?")[0]+"&title=","upazila") ;
		let district = $("#district").val().split("?")[1];
		let districtId = $("#district").val().split("?")[0];
		$("#address_field").val(district == ''?"district":"upazila");
		$("#searched_value").val(district == ''?"empty":"district = " + "'"+ district +"'");
		$("#searched_value_id").val(district == ''?0:districtId);

		$("#pourasabha").html("<option value='0?'>Select Pourasabha</option>");
		$("#union").html("<option value='0?'>Select Union/Ward</option>");
		$("#village").html("<option value='0?'>Select Village</option>");
	}

	function __onUpazilaSelection() {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#upazila").val().split("?")[0]+"&title=","pourasabha") ;
		let upazila = $("#upazila").val().split("?")[1];
		let upazilaId = $("#upazila").val().split("?")[0];
		$("#address_field").val(upazila == ''?"upazila":"sk_id");
		$("#searched_value").val(upazila == ''?"empty":"upazila = " + "'"+ upazila +"'");
		$("#searched_value_id").val(upazila == ''?0:upazilaId);

		$("#union").html("<option value='0?'>Select Union/Ward</option>");
		$("#village").html("<option value='0?'>Select Village</option>");
	}

	function __onPourasabhaSelection() {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#pourasabha").val().split("?")[0]+"&title=","union") ;
		$("#address_field").val("sk_id");
		let concatenatingString = "pourasabha = " + "'"+$("#pourasabha").val().split("?")[1]+"'";
		$("#searched_value").val(concatenatingString);

		$("#village").html("<option value='0?'>Select Village</option>");
	}

	function __onUnionSelection() {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#union").val().split("?")[0]+"&title=","village") ;
	}
});
