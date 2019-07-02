<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@page import="org.opensrp.core.entity.Permission"%>

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

		<jsp:include page="/WEB-INF/views/facility/facility-link.jsp" />
		</ol>
		<div class="card mb-3">
			<div class="card-header">
				<i class="fa fa-table"></i> <spring:message code="lbl.communityClinicRegistration"/>
			</div>
			<div class="card-body">
				<form:form method="POST" action="${saveUrl}" >





					<!-- for location -->
					<%
						Map<String, String> paginationAtributes = (Map<String, String>) session
								.getAttribute("paginationAtributes");
						String division = "";
						int divId = 0;
						if (paginationAtributes.containsKey("divId")) {
							divId = Integer.parseInt(paginationAtributes.get("divId"));
						}

						int distId = 0;
						if (paginationAtributes.containsKey("distId")) {
							distId = Integer.parseInt(paginationAtributes.get("distId"));
						}

						int upzilaId = 0;
						if (paginationAtributes.containsKey("upzilaId")) {
							upzilaId = Integer
									.parseInt(paginationAtributes.get("upzilaId"));
						}
						String union = "";
						int unionId = 0;
						if (paginationAtributes.containsKey("unionId")) {
							unionId = Integer.parseInt(paginationAtributes.get("unionId"));
						}

						int wardId = 0;
						if (paginationAtributes.containsKey("wardId")) {
							wardId = Integer.parseInt(paginationAtributes.get("wardId"));
						}

						int subunitId = 0;
						if (paginationAtributes.containsKey("subunitId")) {
							subunitId = Integer.parseInt(paginationAtributes
									.get("subunitId"));
						}

						int mauzaparaId = 0;
						if (paginationAtributes.containsKey("mauzaparaId")) {
							mauzaparaId = Integer.parseInt(paginationAtributes
									.get("mauzaparaId"));
						}

						String name = "";
						if (paginationAtributes.containsKey("name")) {
							name = paginationAtributes.get("name");
						}

						List<Object[]> divisions = (List<Object[]>) session
								.getAttribute("divisions");
						List<Object[]> districts = (List<Object[]>) session
								.getAttribute("districtListByParent");
						List<Object[]> upazilas = (List<Object[]>) session
								.getAttribute("upazilasListByParent");
						List<Object[]> unions = (List<Object[]>) session
								.getAttribute("unionsListByParent");
						List<Object[]> wards = (List<Object[]>) session
								.getAttribute("wardsListByParent");
						List<Object[]> subuits = (List<Object[]>) session
								.getAttribute("subunitListByParent");
						List<Object[]> mauzaparas = (List<Object[]>) session
								.getAttribute("mauzaparaListByParent");
					%>
					<div class="form-group">
						<div class="row">
							<div class="col-5">
								<label for="exampleInputName"><spring:message code="lbl.division"/>  </label>
								<select class="custom-select custom-select-lg mb-3" id="division"
										name="division">
									<option value="0?"><spring:message code="lbl.selectDivision"/></option>
									<%
										for (Object[] objects : divisions) {
											if (divId == ((Integer) objects[1]).intValue()) {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
									<%
									} else {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
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
								<label for="exampleInputName"><spring:message code="lbl.district"/>  </label>
								<select class="custom-select custom-select-lg mb-3" id="district"
										name="district">
									<option value="0?"><spring:message code="lbl.selectDistrict"/></option>
									<%
										if (districts != null) {
											for (Object[] objects : districts) {
												if (distId == ((Integer) objects[1]).intValue()) {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
									<%
									} else {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
									<%
												}
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
								<label for="exampleInputName"><spring:message code="lbl.upazila"/>  </label>
								<select class="custom-select custom-select-lg mb-3" id="upazila"
										name="upazilla">
									<option value="0?"><spring:message code="lbl.selectUpazila"/></option>
									<%
										if (upazilas != null) {
											for (Object[] objects : upazilas) {
												if (upzilaId == ((Integer) objects[1]).intValue()) {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
									<%
									} else {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
									<%
												}
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
								<label for="exampleInputName"><spring:message code="lbl.union"/>  </label>
								<select class="custom-select custom-select-lg mb-3" id="union"
										name="union">
									<option value="0?"><spring:message code="lbl.selectUnion"/></option>
									<%
										if (unions != null) {
											for (Object[] objects : unions) {
												if (unionId == ((Integer) objects[1]).intValue()) {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
									<%
									} else {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
									<%
												}
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
								<label for="exampleInputName"><spring:message code="lbl.ward"/>  </label>
								<select class="custom-select custom-select-lg mb-3" id="ward"
										name="ward">
									<option value="0?"><spring:message code="lbl.selectWard"/></option>
									<%
										if (wards != null) {
											for (Object[] objects : wards) {
												if (wardId == ((Integer) objects[1]).intValue()) {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>" selected><%=objects[0]%></option>
									<%
									} else {
									%>
									<option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
									<%
												}
											}
										}
									%>
								</select>
							</div>
						</div>
					</div>



					<!-- end of location -->






					<div class="form-group">
						<div class="row">
							<div class="col-5">
								<label for="exampleInputName"><spring:message code="lbl.communityClinicName"/></label>
								<form:input path="name" class="form-control"
											required="required" aria-describedby="nameHelp"
											value="${name}" />
							</div>
						</div>
					</div>

					<div class="form-group">
						<div class="row">
							<div class="col-5">
								<label for="exampleInputName"><spring:message code="lbl.hrmId"/></label>
								<form:input path="hrmId" class="form-control"
											required="required" aria-describedby="nameHelp"
											value="${hrmId}" />
							</div>
						</div>
					</div>

					<div class="form-group">
						<div class="row">
							<div class="col-5">
								<label for="exampleInputName"><spring:message code="lbl.latitude"/></label>
								<form:input path="latitude" class="form-control"
											aria-describedby="nameHelp"
											value="${latitude}" />
							</div>
						</div>
					</div>

					<div class="form-group">
						<div class="row">
							<div class="col-5">
								<label for="exampleInputName"><spring:message code="lbl.longitude"/></label>
								<form:input path="longitude" class="form-control"
											aria-describedby="nameHelp"
											value="${longitude}" />
							</div>
						</div>
					</div>







					<div class="form-group">
						<div class="row">
							<div class="col-3">
								<input type="submit" value="<spring:message code="lbl.save"/>"
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
