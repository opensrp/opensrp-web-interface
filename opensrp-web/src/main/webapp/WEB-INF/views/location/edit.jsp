<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.editLocation"/></title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>
<%
Map<Integer, String> parentLocations =  (Map<Integer, String>)session.getAttribute("parentLocation");
Integer selectedParentLocation = (Integer)session.getAttribute("selectedParentLocation");
String selectedParentLocationName = (String)session.getAttribute("parentLocationName");

Map<Integer, String> tags =  (Map<Integer, String>)session.getAttribute("tags");
Integer selectedTag = (Integer)session.getAttribute("selectedTag");
	%>
<c:url var="saveUrl" value="/location/${id}/edit.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
			<jsp:include page="/WEB-INF/views/location/location-tag-link.jsp" />
			</div>
			<div class="card mb-3">
				<div class="card-header">
					<spring:message code="lbl.editLocation"/>
				</div>
				<div class="card-body">
				<span> ${uniqueErrorMessage}</span>
					<form:form method="POST" action="${saveUrl}" modelAttribute="location">
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.name"/></label>
									<form:input path="name" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Location Name" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.code"/></label>
									<form:input path="code" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Description" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.description"/></label>
									<form:input path="description" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Description" />
								</div>
							</div>
						</div>
						<form:hidden path="parentLocation" id="parentLocation" value="<%=selectedParentLocation %>" />
						<div class="form-group">							
								<div class="row">									
									<div class="col-5">
										<div id="cm">
											  <label><spring:message code="lbl.parentLocation"/> </label>
											  <select id="combobox" class="form-control">
											  </select>
											</div>
									</div>									
								</div>
							</div>	
						
						<div class="form-group">							
							<div class="row">
								<div class="col-5">
								<label for="exampleInputName"> <spring:message code="lbl.tag"/></label>
									<select class="custom-select custom-select-lg mb-3" id="locationTag" name="locationTag" required="required">
										<option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
											<%
											for (Map.Entry<Integer, String> entry : tags.entrySet())
											{
												if(selectedTag==entry.getKey()){ %>
													<option value="<%=entry.getKey()%>" selected><%=entry.getValue() %></option>
												<% }else{
													%>
														<option value="<%=entry.getKey()%>"><%=entry.getValue() %></option>
													<%
												}

											}
											%>
									</select>
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.loginLocation"/>  </label> 
									<form:checkbox path="loginLocation" class="chk" />
									
									<label for="exampleInputName"><spring:message code="lbl.visitLocation"/>  </label> 
									<form:checkbox path="visitLocation" class="chk" />
								</div>
							</div>
						</div>
						<form:hidden path="id" />
						<form:hidden path="uuid" />
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="<spring:message code="lbl.edit"/>"
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
         value = "<%=selectedParentLocationName%>";
        this.input = $( "<input>" )
          .appendTo( this.wrapper )
          .val( value )
          .attr( "title", "" )  
          .attr( "required", true)
           .attr( "name", "parentLocationName" )
          .addClass( "form-control custom-combobox-input ui-widget ui-widget-content ui-corner-left" )
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
           
 			$("#parentLocation").val(ui.item.option.value);
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
        $("#parentLocation").val(-0);
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
  <script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
</body>
</html>