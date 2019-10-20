
function getLocationHierarchy(url, id) {
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
  	$("#division").change(function(event) {   
		//event.preventDefault();	
  		// var a = $("#division").val().split("?")[1];
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#division").val().split("?")[0]+"&title=","district") ;
		$("#upazila").html("");
		$("#pourasabha").html("");
		$("#address_field").val("district");
		var concatingString = "division = " + "'"+ $("#division").val().split("?")[1]+"'";
		$("#searched_value").val(concatingString);
		$("#union").html("");
		$("#village").html("");
  	});
  
  	$("#district").change(function(event) {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#district").val().split("?")[0]+"&title=","upazila") ;
		$("#address_field").val("upazila");
		var concatingString = "district = " + "'"+$("#district").val().split("?")[1]+"'";
		$("#searched_value").val(concatingString);
		$("#pourasabha").html("");
		$("#union").html("");		
		$("#village").html("");
	});
  	$("#upazila").change(function(event) { 
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#upazila").val().split("?")[0]+"&title=","pourasabha") ;
		$("#address_field").val("sk_id");
		var concatingString = "upazila = " + "'"+$("#upazila").val().split("?")[1]+"'";
		$("#searched_value").val(concatingString);
		$("#ward").html("");
	});
	$("#pourasabha").change(function(event) {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#pourasabha").val().split("?")[0]+"&title=","union") ;
		$("#address_field").val("sk_id");
		var concatingString = "pourasabha = " + "'"+$("#pourasabha").val().split("?")[1]+"'";
		$("#searched_value").val(concatingString);
		$("#village").html("");
	});
  	$("#union").change(function(event) { 
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#union").val().split("?")[0]+"&title=","village") ;
	});
	$("#branch").change(function(event) {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#union").val().split("?")[0]+"&title=","village") ;
	});
 });
