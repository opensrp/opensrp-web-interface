<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.acl.entity.LocationTag"%>
<%@page import="org.json.JSONObject" %>
<%@page import="org.json.JSONArray" %>
<%
Map<Integer, String> parentLocations =  (Map<Integer, String>)session.getAttribute("parentLocation");
Integer selectedParentLocation = (Integer)session.getAttribute("selectedParentLocation");

Map<Integer, String> tags =  (Map<Integer, String>)session.getAttribute("tags");

String selectedParentLocationName = (String)session.getAttribute("parentLocationName");

Integer selectedTtag = (Integer)session.getAttribute("selectedTtag");

JSONArray locatationTreeData = (JSONArray)session.getAttribute("locatationTreeData");	

	%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" href="<c:url value="/resources/css/jqx.base.css"/>" rel="stylesheet">

<title>Add Location</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="saveUrl" value="/location/add.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		<div class="form-group">				
				   <a  href="<c:url value="/location/tag/list.html"/>"> <strong> Manage Tags</strong> 
					</a>  |  <a  href="<c:url value="/location/location.html"/>"> <strong>Manage Locations</strong>
					</a>|  <a  href="<c:url value="/location/hierarchy.html"/>"> <strong>View Hierarchy</strong>
					</a>		
		</div>
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Add Location
				</div>
				<div class="card-body">
				<span> ${uniqueErrorMessage}</span>
					<form:form method="POST" action="${saveUrl}" modelAttribute="location">
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Location Name  </label>
									<form:input path="name" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Location Name" value="${name}" />
										
								</div>
							</div>
						</div>
						<div class="form-group">
							<div class="row">
								<div class="col-5">
									<label for="exampleInputName">Description</label>
									<form:input path="description" class="form-control"
										required="required" aria-describedby="nameHelp"
										placeholder="Description" />
								</div>
							</div>
						</div>
						<form:hidden path="parentLocation" id="parentLocation" value="<%=selectedParentLocation %>" />
						<%-- <div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName">Parent Location </label>
										<select class="custom-select custom-select-lg mb-3" id="parentLocation" name="parentLocation">
										 	<option value="0" selected>Please Select</option>
											<%
											for (Map.Entry<Integer, String> entry : parentLocations.entrySet())
											{
												if(selectedParentLocation==entry.getKey()){ %>
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
							</div> --%>
								<div class="form-group">							
								<div class="row">									
									<div class="col-5">
										<div id="cm" class="ui-widget">
											  <label>Search Parent Location </label>
											  <select id="combobox" class="form-control">
											  
											    </select>
											</div>
									</div>									
								</div>
							</div>	
									
							
						
						
						<!-- <div class="form-group">							
								<div class="row">									
									<div class="col-5">
										 <div class="custom-select custom-select-lg mb-3" id="dropDownButton">
								            <div  id='jqxTree' style="border: none;">
								            </div>
								         </div>
									</div>									
								</div>
							
						</div> -->
						
						<div class="form-group">							
								<div class="row">									
									<div class="col-5">
									<label for="exampleInputName"> Location Tag</label>
										<select class="custom-select custom-select-lg mb-3" id="locationTag" name="locationTag" required="required">
									 		<option value="" selected>Please Select</option>
												<%
												for (Map.Entry<Integer, String> entry : tags.entrySet())
												{
													if(selectedTtag==entry.getKey()){ %>
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
           .attr( "name", "parentLocationName" )
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
        $("#parentLocation").val(0);
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
  
	<%-- <script src="<c:url value='/resources/jqwidgets/jqxcore.js'/>"></script>
	<script src="<c:url value='/resources/jqwidgets/jqxdata.js'/>"></script>
	<script src="<c:url value='/resources/jqwidgets/jqxbuttons.js'/>"></script>
	<script src="<c:url value='/resources/jqwidgets/jqxscrollbar.js'/>"></script>
	<script src="<c:url value='/resources/jqwidgets/jqxpanel.js'/>"></script>
	<script src="<c:url value='/resources/jqwidgets/jqxtree.js'/>"></script>
	<script src="<c:url value='/resources/jqwidgets/jqxdropdownbutton.js'/>"></script>
	
	<script type="text/javascript">
            $(document).ready(function () {
                $("#dropDownButton").jqxDropDownButton({ width: 200, height: 25 });
		var dropDownContent1 = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + "Please select" + '</div>';
		 $("#dropDownButton").jqxDropDownButton('setContent', dropDownContent1);

                $('#jqxTree').on('select', function (event) {
                    var args = event.args;
                    var item = $('#jqxTree').jqxTree('getItem', args.element);

                    var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + item.label + '</div>';
 			$("#ContentPanel").html("<div style='margin: 10px;'>" + item.element.id + "</div>");
                    $("#dropDownButton").jqxDropDownButton('setContent', dropDownContent);
 
                });

                var data = <%=locatationTreeData%>

                // prepare the data
                var source =
                {
                    datatype: "json",
                    datafields: [
                        { name: 'id' },
                        { name: 'parentid' },
                        { name: 'text' },
                        { name: 'value' }
                    ],
                    id: 'id',
                    localdata: data
                };

                // create data adapter.
                var dataAdapter = new $.jqx.dataAdapter(source);
                // perform Data Binding.
                dataAdapter.dataBind();
                // get the tree items. The first parameter is the item's id. The second parameter is the parent item's id. The 'items' parameter represents 
                // the sub items collection name. Each jqxTree item has a 'label' property, but in the JSON data, we have a 'text' field. The last parameter 
                // specifies the mapping between the 'text' and 'label' fields.  
                var records = dataAdapter.getRecordsHierarchy('id', 'parentid', 'items', [{ name: 'text', map: 'label'}]);
                $('#jqxTree').jqxTree({ source: records, width: '600px' });
            });--%>
        </script>
        
</body>
</html>
