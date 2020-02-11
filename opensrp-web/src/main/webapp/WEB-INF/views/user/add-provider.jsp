<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>

<!DOCTYPE html>
<html lang="en">
<%
String bahmniVisitURL = (String)session.getAttribute("bahmniVisitURL");
Integer selectedPersonId = (Integer)session.getAttribute("selectedPersonId");
String locationList = (String)session.getAttribute("locationList"); 
String selectedLocationList = (String)session.getAttribute("selectedLocationList"); 
Map<Integer, String> teams =  (Map<Integer, String>)session.getAttribute("teams");

String selectedPersonName = (String)session.getAttribute("personName");
Integer facilityId= (Integer)session.getAttribute("facilityId");
//Integer communityId = (Integer)session.getAttribute("communityId");
Integer selectedTeamId = (Integer)session.getAttribute("selectedTeamId");

int roleIdCHCP= -1;
int roleIdProvider= -1;

List<Object[]> wards = (List<Object[]>) session.getAttribute("wards");
%>

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" href="<c:url value="/resources/css/magicsuggest-min.css"/>" rel="stylesheet">
<meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title><spring:message code="lbl.createMHV"/></title>

<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/add.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	
   <jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		<jsp:include page="/WEB-INF/views/facility/facility-link.jsp" />
		<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
				<li class="breadcrumb-item">
				<a  href="<c:url value="/facility/${facilityId}/details.html?lang=${locale}"/>"> <strong><spring:message code="lbl.ccProfile"/></strong> </a>
				</li>		
		<%} %>
		
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<li class="breadcrumb-item">
		<a  href="<c:url value="/facility/${facilityId}/updateProfile.html?lang=${locale}"/>"> <strong><spring:message code="lbl.updateProfile"/></strong> </a>	 
		</li> 	
		<%} %>
		
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<li class="breadcrumb-item">
		<a  href="<c:url value="/facility/${facilityId}/addWorker.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addWorker"/></strong> </a>	 
		</li> 	
		<%} %>	
				
		<% if(AuthenticationManagerUtil.isPermitted("CREATE_MULTIPURPOSE_VOLUNTEER")){ %>
			<li class="breadcrumb-item">
			<a  href="<c:url value="/facility/mhv/${facilityId}/add.html?lang=${locale}"/>"> <strong><spring:message code="lbl.createMHV"/></strong> </a>	
			</li> 	
		<%} %>	
		
		<% if(AuthenticationManagerUtil.isPermitted("PERM_WRITE_FACILITY_WORKER")){ %>
		<li class="breadcrumb-item">
			<a  href="<c:url value="/facility/${facilityId}/addCgCsg.html?lang=${locale}"/>"> <strong><spring:message code="lbl.addCgCsg"/></strong> </a>	 
			</li> 	
		<%} %>	
		
		<jsp:include page="/WEB-INF/views/facility/bahmni-visit-link.jsp" />
		<%-- <% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
				<li class="breadcrumb-item">
				<a  href="https://103.247.238.36/bahmni/home/index.html#/login" target="_blank"> <strong><spring:message code="lbl.visit"/></strong> </a>
				</li>		
		<%} %> --%>
		</ol>
		</div>
			<div class="card mb-3">
				<div class="card-header" id="data">
					<spring:message code="lbl.createMHV"/>
				</div>
				<div class="card-body">
					
	                          <span class="text-red" id="usernameUniqueErrorMessage"></span>
	                    
	                 <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%"> 
							<img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>"></div>
							
					</div>
					<form:form 	modelAttribute="account" id="UserInfo" class="form-inline">	
										
						<div class="row col-12 tag-height">						 
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"> <spring:message code="lbl.firstName"/> </label>										 
								<form:input path="firstName" class="form-control mx-sm-3"
								required="required" />
							</div>							
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"> <spring:message code="lbl.lastName"/> </label>										 
								<form:input path="lastName" class="form-control mx-sm-3"
											required="required"/>								
							 </div>
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width"  for="inputPassword6"> <spring:message code="lbl.email"/> </label>
								<input type="email" class="form-control mx-sm-3" name="email" required="required">										 
															
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.mobile"/></label>										 
								<form:input path="mobile" class="form-control mx-sm-3" pattern="^01[3-9]\d{8}$"
								title="11 digit valid mobile number" required="required"/>								
							 </div>
						 </div>	
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.identifier"/></label>										 
								<form:input path="idetifier" class="form-control mx-sm-3" pattern="^[0-9]{10}|[0-9]{13}|[0-9]{17}$"
								title="10, 13 or 17 Digit"/>
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		<spring:message code="lbl.identifierMsg"/> 
	                        	</small>
							 </div>
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.username"/></label>
								<form:input path="username" class="form-control mx-sm-3"
										required="required" />
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		<spring:message code="lbl.userMessage"/> 
	                        	</small>
							 </div>							 
						 </div>
						 
						 <form:hidden path="parentUser" id="parentUser"/>
						 <%-- <div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.parentUser"/></label>										 
								<select id="combobox" class="form-control">	</select>								
							 </div>							 
						 </div> --%>
						 
						
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.password"/></label>										 
								<input type="password" class="form-control mx-sm-3" id="password" name="password"  title="" required />
								<small id="passwordHelpInline" class="text-muted text-para">
							
								<%-- <spring:message code="lbl.passwordMEssage"/> --%>
	                        	</small>
	                        	<input type="checkbox" onclick="toggleVisibilityOfPassword()">Show Password
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width"  for="inputPassword6"><spring:message code="lbl.confirmedPassword"/></label>										 
								<form:password path="retypePassword" class="form-control mx-sm-3" id="retypePassword"
										required="required" />
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		 <span class="text-red" id="passwordNotmatchedMessage"></span> <spring:message code="lbl.retypePasswordMessage"/>
	                        	</small>
							 </div>
							 
						 </div>	
						 <div class="row col-12 tag-height">						
							<div class="form-group required">
								<label class="label-width"  for="location"><spring:message code="lbl.location"/></label>
									<%																					
									    for (Object[] objects : wards) {
									    	String[] ward = objects[0].toString().split(":");
									    	int length = ward.length-1;
									%>									
										<form:checkbox 
											path="roles" class="chk" value="<%=objects[1]%>"/>
										<label class="form-control mx-sm-3" for="defaultCheck1"> <%=ward[length]%></label>									
									<%
										}
									%>
								
							</div>
						</div>					
						
						
						<div class="row col-12 tag-height">						
							<div class="form-group">
									<input type="submit" onclick="return Validate()"  value="<spring:message code="lbl.save"/>" 	class="btn btn-primary btn-block btn-center" />
							</div>
						</div>
					</form:form>
				</div>
				
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		<script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
		<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
		

	
	<script type="text/javascript">
	var locationMagicSuggest;
	var isCHCP= 0;
	var isProvider= 0;
	function roleSelect(cBox){
		//alert(cBox.checked+" - "+cBox.value);
		var roleIdOfCHCP = <%=roleIdCHCP%>;
		var roleIdOfProvider = <%=roleIdProvider%>;
		var roleIdOfClickedCheckbox = cBox.value;
		
		if(roleIdOfClickedCheckbox == roleIdOfCHCP){
			if(cBox.checked){
				isCHCP= 1;
			}else{
				isCHCP= 0;
			}
		}
		
		if(roleIdOfClickedCheckbox == roleIdOfProvider){
			if(cBox.checked){
				isProvider= 1;
			}else{
				isProvider= 0;
			}
		}
		showTeamAndLocationDiv();
	}
	
	function toggleVisibilityOfPassword() {
		  var pswrd = document.getElementById("password");
		  var retypePswrd = document.getElementById("retypePassword");
		  if (pswrd.type === "password") {
			  pswrd.type = "text";
			  retypePswrd.type = "text";
		  } else {
			  pswrd.type = "password";
			  retypePswrd.type = "password";
		  }
		}
	
	function showTeamAndLocationDiv(){
		if(isTeamMember()){
			$("#locationDiv").show();
			$("#team").prop('required',true);
			$("#team").prop('disabled', false);
			$("#teamDiv").show();
		}else{
			$("#locationDiv").hide();
			$("#team").prop('required',false);
			$("#team").prop('disabled', true);
			$("#teamDiv").hide();
		}
	}
	
	function isTeamMember(){
		if(isCHCP== 1 || isProvider== 1){
			return true;
		}
		return false;
	}
	
	$("#UserInfo").submit(function(event) { 
			$("#loading").show();
			var url = "/opensrp-dashboard/rest/api/v1/user/<%=facilityId%>/mhv";			
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			//alert(locationMagicSuggest.getValue());
			//alert($('#team').val());
			var formData;
			
				formData = {
			            'firstName': $('input[name=firstName]').val(),
			            'lastName': $('input[name=lastName]').val(),
			            'email': $('input[name=email]').val(),
			            'mobile': $('input[name=mobile]').val(),
			            'idetifier': $('input[name=idetifier]').val(),
			            'username': $('input[name=username]').val(),
			            'password': $('input[name=password]').val(),
			            'parentUser': "",
			            'locationList': getCheckboxValueUsingClass(),
			            'teamMember': ""
			        };
			
			console.log(formData)
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
				   $("#usernameUniqueErrorMessage").html(data);
				   $("#loading").hide();
				   if(data == ""){					   
					   window.location.replace("/opensrp-dashboard/facility/<%=facilityId%>/details.html");
					   
				   }
				   
				},
				error : function(e) {
				   
				},
				done : function(e) {				    
				    console.log("DONE");				    
				}
			});
		});		
		 
	
	function getCheckboxValueUsingClass(){
		/* declare an checkbox array */
		var chkArray = [];
		
		/* look for all checkboes that have a class 'chk' attached to it and check if it was checked */
		$(".chk:checked").each(function() {
			chkArray.push($(this).val());
		});
		
		/* we join the array separated by the comma */
		var selected;
		selected = chkArray.join(',') ;		
		
		return selected;
	}
	
	 function Validate() {
		 
         var password = document.getElementById("password").value;
         var confirmPassword = document.getElementById("retypePassword").value;
         if (password != confirmPassword) {
        	 $("#passwordNotmatchedMessage").html("Your password is not similar with confirm password. Please enter same password in both");
        	
        	 return false;
         }
         
         $("#passwordNotmatchedMessage").html("");
         
     }
	
		</script>
		
 <script type="text/javascript">
  
 locationMagicSuggest = $('#locationsTag').magicSuggest({ 
		 	required: true,
			//placeholder: 'Type Locations',
     		data: <%=locationList%>,
	        valueField: 'id',
	        displayField: 'value',
	        name: 'locationList',
	        inputCfg: {"class":"magicInput"},
	        value: <%=selectedLocationList%>,
	        useCommaKey: true,
	        allowFreeEntries: false,
	        maxSelection: 2,
	        maxEntryLength: 70,
	 		maxEntryRenderer: function(v) {
	 			return '<div style="color:red">Typed Word TOO LONG </div>';
	 		}
	       
	  });
  </script>
		
<script>
  $( function() {
    $.widget( "custom.combobox", {
      _create: function() {
        this.wrapper = $( "<div>" )
          .addClass( "custom-combobox" )          
          .insertAfter( this.element );
 
        this.element.hide();
        this._createAutocomplete();
       
      },
 
      _createAutocomplete: function() {
        var selected = this.element.children( ":selected" ),        
          value = selected.val() ? selected.text() : "";
         value = "";
        this.input = $( "<input>" )
          .appendTo( this.wrapper )
          .val( value )
          .attr( "title", "" )          
           .attr( "name", "parentUserName" )
          .addClass( "form-control mx-sm-3 ui-widget ui-widget-content  ui-corner-left" )
          .autocomplete({
            delay: 0,
            minLength: 1,
            source: $.proxy( this, "_source" )
          })
          .tooltip({
            classes: {
              "ui-tooltip": "ui-state-highlight"
            }
          });
 
        this._on( this.input, {
          autocompleteselect: function( event, ui ) {
            ui.item.option.selected = true;
 			$("#parentUser").val(ui.item.option.value);
            this._trigger( "select", event, {
              item: ui.item.option
            });
          },
 
          autocompletechange: "_removeIfInvalid"
        });
      },
 
      
 
      _source: function( request, response ) {
    	  
    	  $.ajax({
              type: "GET",
              dataType: 'html',
              url: "/opensrp-dashboard/user/user.html?name="+request.term,            
              success: function(res)
              {
              
                $("#combobox").html(res);
              }
          });
        var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
        response( this.element.children( "option" ).map(function() {
          var text = $( this ).text();
          if ( this.value && ( !request.term || matcher.test(text) ) )
            return {
              label: text,
              value: text,
              option: this
            };
        }) );
      },
 
      _removeIfInvalid: function( event, ui ) {
    	  
        // Selected an item, nothing to do
        if ( ui.item ) {
          return;
        }
 
        // Search for a match (case-insensitive)
        var value = this.input.val(),
          valueLowerCase = value.toLowerCase(),
          valid = false;
        this.element.children( "option" ).each(function() {
          if ( $( this ).text().toLowerCase() === valueLowerCase ) {
            this.selected = valid = true;
            return false;
          }
        });
 
        // Found a match, nothing to do
        if ( valid ) {
          return;
        }
 
        // Remove invalid value
         this.input
          .val( "" )
          .attr( "title", value + " didn't match any item" )
          .tooltip( "open" );
        $("#parentUser").val(0);
        this.element.val( "" );
        this._delay(function() {
          this.input.tooltip( "close" ).attr( "title", "" );
        }, 2500 );
        this.input.autocomplete( "instance" ).term = "";
      },
 
      _destroy: function() {
        this.wrapper.remove();
        this.element.show();
      }
    });
 
    $( "#combobox" ).combobox();
    
    $( "#toggle" ).on( "click", function() {
      $( "#combobox" ).toggle();
    });
    
    
  } );
  </script>
  
 
</body>
</html>