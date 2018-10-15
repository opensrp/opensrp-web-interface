<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<%@page import="java.util.List"%>
<%@page import="org.opensrp.core.entity.Role"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.editUserTitle"/></title>

<link type="text/css"
	href="<c:url value="/resources/css/bootstrap.min.css"/>"
	rel="stylesheet">
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/user/${id}/edit.html" />
<%
String selectedParentUser = (String)session.getAttribute("parentUserName");
Integer selectedParentId = (Integer)session.getAttribute("parentUserId");

%>

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />

	<div class="content-wrapper">
		<div class="container-fluid">
		<div class="form-group">				
			<jsp:include page="/WEB-INF/views/user/user-role-link.jsp" />			
		</div>
			<div class="card mb-3">
				<div class="card-header">					
					<spring:message code="lbl.editUserTitle"/>				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}"
						modelAttribute="account" class="form-inline">						
						
								
						<div class="row col-12 tag-height">						 
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"> <spring:message code="lbl.firstName"/> </label>										 
								<form:input path="firstName" class="form-control mx-sm-3"
								required="required"/>
							</div>							
						 </div>
						 
						<div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.lastName"/> </label>										 
								<form:input path="lastName" class="form-control mx-sm-3"
											required="required"/>								
							 </div>
						 </div>
						 
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width"  for="inputPassword6"> <spring:message code="lbl.email"/> </label>								
								<input type="email" class="form-control mx-sm-3" name="email" value="${account.getEmail()}" required="required">										 
															
							 </div>
						 </div>
						
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.mobile"/></label>										 
								<form:input path="mobile" class="form-control mx-sm-3" />								
							 </div>
						 </div>	
						
						<div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.identifier"/></label>										 
								<form:input path="idetifier" class="form-control mx-sm-3" />
								
							 </div>
						 </div>
						
						
						
						 <div class="row col-12 tag-height">						
							<div class="form-group required">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.userName"/></label>										 
								<form:input path="username" class="form-control mx-sm-3"
									readonly="true"	required="required"/>
								<small id="passwordHelpInline" class="text-muted text-para">
	                          		<span class="text-red" id="usernameUniqueErrorMessage"></span> <spring:message code="lbl.userMessage"/> 
	                        	</small>
							 </div>							 
						 </div>
						 <form:hidden path="parentUser" id="parentUser" value="<%=selectedParentId %>"/>
						 <div class="row col-12 tag-height">						
							<div class="form-group">														
								<label class="label-width" for="inputPassword6"><spring:message code="lbl.parentUser"/></label>										 
								<select id="combobox" class="form-control">	</select>								
							 </div>							 
						 </div>
						
						
						<form:hidden path="uuid" />
						<form:hidden path="personUUid" />
						<form:hidden path="provider" />
						
						
						<form:hidden path="id" />
						<form:hidden path="password" />
						<div class="row col-12 tag-height">	
							<div class="form-group required">
							<label class="label-width"  for="inputPassword6"><spring:message code="lbl.role"/></label>								
								<%
									List<Role> roles = (List<Role>) session.getAttribute("roles");
									int[] selectedRoles = (int[]) session.getAttribute("selectedRoles");
									for (Role role : roles) {
								%>
									
										<form:checkbox class="checkBoxClass form-check-input"
											path="roles" value="<%=role.getId()%>"
											checked="<%=CheckboxHelperUtil.checkCheckedBox(selectedRoles,role.getId())%>" />
										<label class="form-control mx-sm-3" for="defaultCheck1"> <%=role.getName()%>
										</label>
									
									<%
										}
									%>
							</div>
						</div>
						
						<div class="row col-12 tag-height">	
							<div class="form-group">								
								<input type="submit" value="<spring:message code="lbl.edit"/>"
										class="btn btn-primary btn-block" />
							</div>
						</div>
					</form:form>

				</div>
				<div class="card-footer small text-muted"></div>
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
		<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
	</div>
</body>

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
          value = "<%=selectedParentUser%>";
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
</html>