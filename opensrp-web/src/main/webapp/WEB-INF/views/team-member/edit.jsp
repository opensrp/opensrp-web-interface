<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Location"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%
Integer selectedPersonId = (Integer)session.getAttribute("selectedPersonId");
String locationList = (String)session.getAttribute("locationList"); 
String selectedLocationList = (String)session.getAttribute("selectedLocationList"); 

Map<Integer, String> teams =  (Map<Integer, String>)session.getAttribute("teams");

String selectedPersonName = (String)session.getAttribute("personName");

Integer selectedTeamId = (Integer)session.getAttribute("selectedTeamId");


	%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.editTeamMember"/></title>
<jsp:include page="/WEB-INF/views/css.jsp" />
<link type="text/css" href="<c:url value="/resources/css/jqx.base.css"/>" rel="stylesheet">
<link type="text/css" href="<c:url value="/resources/css/magicsuggest-min.css"/>" rel="stylesheet">
</head>

<c:url var="saveUrl" value="/team/teammember/${id}/edit.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
			<div class="form-group">				
			<jsp:include page="/WEB-INF/views/team/team-member-link.jsp" />		
			</div>
			<div class="card mb-3">
				<div class="card-header">
					<spring:message code="lbl.editTeamMember"/>
				</div>
				<div class="card-body">
				
					<form:form method="POST" action="${saveUrl}" modelAttribute="teamMember">					
					<form:hidden path="person" id="person" value="<%=selectedPersonId %>" />	
					<div class="form-group">							
							<div class="row">									
								<div class="col-5">
									<div id="cm" class="ui-widget">
										<label><spring:message code="lbl.person"/> </label>
										<select id="combobox" class="form-control">											  
										</select>
										<span class="text-red">${uniqueNameErrorMessage}</span> 
									</div>
								</div>									
							</div>
						</div>
						
						<div class="form-group">							
							<div class="row">									
								<div class="col-5">
									<div id="cm" class="ui-widget">
										<label><spring:message code="lbl.location"/> </label>
										<div id="locationsTag">                          					
                          				</div>
										<span class="text-red">${locationSelectErrorMessage}</span>
									</div>
								</div>									
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.identifier"/></label>
									<form:input path="identifier" class="form-control"
										required="required"  />
									<span class="text-red">${uniqueIdetifierErrorMessage}</span>
								</div>
							</div>
						</div>
						
						
						<div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName"><spring:message code="lbl.team"/></label>
										<select class="custom-select custom-select-lg mb-3" id="team" name="team" required="required">
									 		<option value="" selected><spring:message code="lbl.pleaseSelect"/></option>
												<%
												for (Map.Entry<Integer, String> entry : teams.entrySet())
												{
													if(selectedTeamId==entry.getKey()){ %>
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
							
						<form:hidden path="id" />
						<form:hidden path="uuid" />
						<form:label path="uuid"> uuid:${teamMember.getUuid()}</form:label>
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
		<script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
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
         value = "<%=selectedPersonName%>";
        this.input = $( "<input required='required'>" )
          .appendTo( this.wrapper )
          .val( value )
          .attr( "title", "" )          
           .attr( "name", "personName" )
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
 			$("#person").val(ui.item.option.value);
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
              url: "/opensrp-dashboard/user/provider.html?name="+request.term,            
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
        $("#person").val(0);
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
  <script type="text/javascript">
  
  
	 $('#locationsTag').magicSuggest({ 
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
	        maxSelection: 5,
	        maxEntryLength: 70,
	 		maxEntryRenderer: function(v) {search
	 			return '<div style="color:red">Typed Word TOO LONG </div>';
	 		}
	       
	  });
  </script>
  
 <!--  <script>
  $( function() {
 var availableTags = [{ label: 'nina', id: '5' }, {label: 'sylvie' , id: '9'}];
    
    function split( val ) {
      return val.split( /,\s*/ );
    }
    function extractLast( term ) {
      return split( term ).pop();
    }
 
    $( "#locations" )
      // don't navigate away from the field on tab when selecting an item
      .on( "keydown", function( event ) {
        if ( event.keyCode === $.ui.keyCode.TAB &&
            $( this ).autocomplete( "instance" ).menu.active ) {
        	
          event.preventDefault();
        }
      })
      .autocomplete({
        minLength: 3,
        source: function( request, response ) {
          // delegate back to autocomplete, but extract the last term;
          
           var inputs = split(request.term);
           var searchName = inputs[inputs.length-1];
           console.log(searchName);
        	$.getJSON( "/opensrp-dashboard/rest/api/v1/location/search?name="+extractLast( request.term ), response );
        },
        focus: function() {
          // prevent value inserted on focus
         
          return false;
        },
        select: function( event, ui ) {
          var terms = split( this.value );
          var ids = $('#locationIds').val();
          // remove the current input
          terms.pop();          
          // add the selected item		 
          terms.push( ui.item.label );
          // add placeholder to get the comma-and-space at the end
          terms.push( "" );
          if(ids==""){
        	  ids = ui.item.id;
          }else{
          	  ids = ids+","+ui.item.id;
          }
          $("#locationIds").val(ids);
          this.value = terms.join( ", " );
          return false;
        },
        change: function(event, ui) {
           
        }
      });
  } );
  </script> -->
 
  <script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
        
</body>
</html>