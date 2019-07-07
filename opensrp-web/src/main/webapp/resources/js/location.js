
function getLocationHierarchy(url,id) {
  $.ajax({
   type : "GET",
   contentType : "application/json",
   url : url,
 
   dataType : 'html',
   timeout : 100000,
   beforeSend: function() {
    
   
   },
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
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#division").val().split("?")[0]+"&title=","district") ;
		$("#upazila").html("");		
		$("#union").html("");
		$("#ward").html("");
		$("#cc").html("");
		$("#subunit").html("");
		$("#mauzapara").html("");
  	});
  
  	$("#district").change(function(event) {
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#district").val().split("?")[0]+"&title=","upazila") ;
		$("#union").html("");		
		$("#ward").html("");
		$("#cc").html("");
		$("#subunit").html("");
		$("#mauzapara").html("");
	});
  	$("#upazila").change(function(event) { 
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#upazila").val().split("?")[0]+"&title=","union") ;
		$("#ward").html("");
		$("#cc").html("");
		$("#subunit").html("");
		$("#mauzapara").html("");
	});
  	$("#union").change(function(event) { 
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#union").val().split("?")[0]+"&title=","ward") ;
		$("#cc").html("");
		// $("#subunit").html("");
		// $("#mauzapara").html("");
	});
  	$("#ward").change(function(event) { 
		// getLocationHierarchy("/opensrp-dashboard/location?id="+$("#ward").val().split("?")[0]+"&title=","subunit") ;
		getLocationHierarchy("/opensrp-dashboard/location?id="+$("#ward").val().split("?")[0]+"&title="+$("#ward").val().split("?")[1],"cc") ;
		// $("#mauzapara").html("");
	});
  	// $("#subunit").change(function(event) {
	// 	getLocationHierarchy("/opensrp-dashboard/location?id="+$("#subunit").val().split("?")[0]+"&title=","mauzapara") ;
	// });

 });