
function userInfo(id) {
	
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : "/opensrp-dashboard/sk/"+id+"/edit-SK-ajax.html",
		dataType : 'html',
		timeout : 100000,
		beforeSend: function() {},
		success : function(data) {
			$("#userInfo").html(data);
		},
		error : function(e) {			
		},
		done : function(e) {
		}
	});

}

function userForm() {
	
	$.ajax({
		type : "GET",
		contentType : "application/json",
		url : "/opensrp-dashboard/user/add-SK-ajax.html",
		dataType : 'html',
		timeout : 100000,
		beforeSend: function() {},
		success : function(data) {
			$("#add-sk-modal").html(data);
		},
		error : function(e) {			
		},
		done : function(e) {
		}
	});

}

function getBranches() {
    var branches = $('#branches').val();        
    return branches;
}
$("#update-sk-information submit").click(function (ev) {
	alert($(this).attr("value"));
	if ($(this).attr("value") == "update") {  
		
	}
	return false;
});
var btn = "";
$('#updateContinue').click(function() {
    buttonpressed = $(this).attr('name');   
    btn = "UC";
    
});
$('#update').click(function() {
    buttonpressed = $(this).attr('name');    
    btn = "U";
});

$("#update-sk-information").submit(function(event) {
	
    $("#loading").show();
    var url = "/opensrp-dashboard/rest/api/v1/user/update-sk";
    var token = $("meta[name='_csrf']").attr("content");
    var header = $("meta[name='_csrf_header']").attr("content");
    var buttonpressed ;  
   
    var formData;
    var enableSimPrint = false;   
    if ($('#enableSimPrint1').is(":checked"))
    {
    	enableSimPrint = true;
    }
    var status = false;   
    if ($('#enabled1').is(":checked"))
    {
    	status = true;
    }
  
    $('#update-user').modal({
        escapeClose: false,
        clickClose: false,
        showClose: false,
        show: false
    });
   /// catchmentLoad(1086,0);
    var amId = $('input[name=am]').val();
    var skId =  $('input[name=id]').val();
    var username = $('input[name=username]').val();
    var update = $('input[name=update]').val();
    var updateContinue = $('input[name=updateContinue]').val();
    
    formData = {
        'firstName': $('input[name=firstName]').val(),
        'lastName': $('input[name=lastName]').val(),
        'email': $('input[name=email]').val(),
        'mobile': $('input[name=mobile]').val(),        
        'branches': getBranches(),
        'enableSimPrint': enableSimPrint,
        'status': status,
        'id': skId
    };
    
   event.preventDefault();
    $.ajax({
        contentType : "application/json",
        type: "POST",
        url: url,
        data: JSON.stringify(formData),
        dataType : 'json',

        timeout : 100000,
        beforeSend: function(xhr) {
            xhr.setRequestHeader(header, token);
        },
        success : function(data) {
        	if(data!=""){
        		$("#error-msg").html(data);
        	}           
            $("#loading").hide();
            if(data == ""){
            	if(btn == "UC"){
            		catchmentLoad(skId,0);
            	}else{
            		window.location.reload();
            	}
            	              
            }
        },
        error : function(e) {

        },
        done : function(e) {
            console.log("DONE");
        }
    });
});