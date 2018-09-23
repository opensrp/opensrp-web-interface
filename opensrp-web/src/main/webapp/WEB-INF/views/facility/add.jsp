<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="org.opensrp.acl.entity.Permission"%>

<%
Integer selectedLocationId = (Integer)session.getAttribute("selectedLocation");
String selectedLocationName = (String)session.getAttribute("locationName");
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Add Facility</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/facility/add.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
				   <a  href="<c:url value="/facility/add.html"/>" > <strong>Registration</strong> 
					</a>  |  <a  href="<c:url value="/facility/index.html"/>"> <strong>Community Clinic</strong>
					</a>  |  <a  href="<c:url value="/facility/upload_csv.html"/>"> <strong>Upload Facility</strong>
					</a>			
		</div>
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Community Clinic Registration
				</div>
				<div class="card-body">
					<form:form method="POST" action="${saveUrl}" >
					
					
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Name  </label>
									<form:input path="name" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Facility Name" value="${name}" />
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">HRM ID  </label>
									<form:input path="hrmId" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="HRM ID" value="${hrmId}" />
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Latitude  </label>
									<form:input path="latitude" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Latitude" value="${latitude}" />
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Longitude  </label>
									<form:input path="longitude" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Longitude" value="${longitude}" />
								</div>
							</div>
						</div>
						
						
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="Save"
										class="btn btn-primary btn-block" />
								</div>
							</div>
						</div>
					</form:form>
				</div>
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	
	<%-- <script>
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
         value = "<%=selectedLocationName%>";
        this.input = $( "<input required='required'>" )
          .appendTo( this.wrapper )
          .val( value )
          .attr( "title", "" )          
           .attr( "name", "locationName" )
          .addClass( "form-control custom-combobox-input ui-widget ui-widget-content  ui-corner-left" )
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
 			$("#location").val(ui.item.option.value);
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
              url: "/opensrp-dashboard/location/search.html?name="+request.term,            
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
        $("#location").val(0);
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
  <script src="<c:url value='/resources/js/jquery-ui.js'/>"></script> --%>
	
	
</body>
</html>
