<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:url var="url" value="/rest/api/v1/migration/accept-reject" />
<h3>
	<strong>Member migration details</strong>
</h3>
<hr />
<h3> <strong>Name:</strong> ${data.getString("member_name")}, <strong>Age:</strong> ${data.getString("member_age")},<strong>Contact:</strong> ${data.getString("member_contact")}</h3>

<table style="width: 100%;"
	class="display table table-bordered table-striped">
	<thead>
		<tr>
			<th rowspan="2">Item</th>
			<th rowspan="2">From</th>
			<th rowspan="2">To</th>
		</tr>
		
	</thead>
	<tbody>
		<tr>
			<th>HH head</th>
			<th>${data.getString("hh_name_out")}</th>
			<th>${data.getString("hh_name_in")}</th>			
		</tr>
		<tr>
			<th>HH head contact</th>
			<th>${data.getString("hh_contact_out")}</th>
			<th>${data.getString("hh_contact_in")}</th>			
		</tr>
		<tr>
			<th>Branch</th>
			<th>${data.getString("bout_name")}</th>
			<th>${data.getString("bin_name")}</th>			
		</tr>
		<tr>
			<th>SK</th>
			<th>${data.getString("sk_out")}</th>
			<th>${data.getString("sk_in")}</th>			
		</tr>
		<tr>
			<th>SS</th>
			<th>${data.getString("ss_out")}</th>
			<th>${data.getString("ss_in")}</th>			
		</tr>
		<tr>
			<th>Village</th>
			<th>${data.getString("village_out")}</th>
			<th>${data.getString("village_in")}</th>			
		</tr>
		<tr>
			<th>Union/Ward</th>
			<th>${data.getString("union_out")}</th>
			<th>${data.getString("union_in")}</th>			
		</tr>
		<tr>
			<th>Pourasava</th>
			<th>${data.getString("pourasava_out")}</th>
			<th>${data.getString("pourasava_in")}</th>			
		</tr>
		<tr>
			<th>Upazila</th>
			<th>${data.getString("upazila_out")}</th>
			<th>${data.getString("upazila_in")}</th>			
		</tr>
		<tr>
			<th>District</th>
			<th>${data.getString("district_out")}</th>
			<th>${data.getString("district_in")}</th>			
		</tr>
		<tr>
			<th>Division</th>
			<th>${data.getString("division_out")}</th>
			<th>${data.getString("division_in")}</th>			
		</tr>
	</tbody>

</table>
<div class="row">
	<div class="col-lg-12">
		
		<div id="errorMessage" style="display: none;">
              <div class="col-lg-12 text-center" id="msgContent" style="font-weight: bold;"> </div>
                      
        </div>
	</div>
</div>
<c:choose>
	<c:when test="${migratedType=='out' && data.getString('status')=='PENDING' }">
		<div class="form-group" id="afterSuccess" style="display: block;">
			<div class="row">
				<div class="col-lg-12 text-center">
				<button class="bt btn-success  btn-sm ACCEPTREJECT" id=ACCEPT name="ACCEPT" value="ACCEPT" type="submit">ACCEPT</button>
				<button class="bt btn-danger  btn-sm ACCEPTREJECT" id=REJECT name="REJECT" value="REJECT" type="submit">REJECT</button>
				</div>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<div class="form-group">
			<div class="row">
				<div class="col-lg-12 text-center">
					<strong>Status: ${data.getString("status")} </strong>
				</div>
			</div>
		</div>
	</c:otherwise>

</c:choose>

<script>
$(".ACCEPTREJECT").on('click', function() { 	
 	val = $(this).val();
 	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
 	$.ajax({
		contentType : "application/json",
		type: "POST",
        url: "${url}"+"?id=${data.getString('id')}&type=member&relationalId=0&status="+val,
        data: "", 
        dataType : 'json',        
        timeout : 300000,
		beforeSend: function(xhr) {				    
			 xhr.setRequestHeader(header, token);
			 $("#loading").show();
		},
		success : function(data) {
		   var response = JSON.parse(data);
		   $("#loading").hide();
		   $("#errorMessage").show();
		   $("#msgContent").html("Please wait...");
		   
	       if(response.status == "OK"){	  
	    	   var responseMsg = "Request success with status "+val;
	    	   $("#msgContent").html(responseMsg);
	    	   $("#msgContent").html(responseMsg);
	    	   $("#afterSuccess").hide();
		   }else{
			   var responseMsg = "Request failed with status "+val;
			   $("#msgContent").html(responseMsg);
			 
		   }
		   
		},
		error : function(e) {
		   
		},
		done : function(e) {				    
		    console.log("DONE");				    
		}
	});
 	
 	
     
  });
 

</script>

