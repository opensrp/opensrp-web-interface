<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page import="java.util.Set" %>
<title><spring:message code="lbl.addUserTitle"/></title>



<meta name="_csrf" content="${_csrf.token}"/>
<!-- default header name is X-CSRF-TOKEN -->
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<c:url var="cancelUrl" value="/user/sk-list.html" />
<style>
.page-content-wrapper .page-content {
    margin-left: 0px; 
    margin-top: 0px;
    /* min-height: 600px; */
    padding: 0 /* 10px */ 0 0 20px;
}
</style>
<c:url var="cancelUrl" value="/user/sk-list.html" />

<c:url var="saveUrl" value="/user/${id}/edit-SK.html" />
<%
	Set<Branch> selectedBranches = (Set<Branch>)session.getAttribute("selectedBranches");
	String selectedParentUser = (String)session.getAttribute("parentUserName");
	Integer selectedParentId = (Integer)session.getAttribute("parentUserId");

//for teamMember
	Integer selectedPersonId = (Integer)session.getAttribute("selectedPersonId");
	String locationList = (String)session.getAttribute("locationList");
	String selectedLocationList = (String)session.getAttribute("selectedLocationList");

	Map<Integer, String> teams =  (Map<Integer, String>)session.getAttribute("teams");

	String selectedPersonName = (String)session.getAttribute("personName");

	Integer selectedTeamId = (Integer)session.getAttribute("selectedTeamId");
	int roleIdCHCP= -1;
	int roleIdProvider= -1;
	List<Role> selectedRole = (List<Role>) session.getAttribute("selectedRoles");
	String ssPrefix = (String)session.getAttribute("ssPrefix");
%>
<div class="page-content-wrapper">
    <div class="page-content">
        <div class="row">
            <div class="col-md-12">

                <!-- BEGIN EXAMPLE TABLE PORTLET-->
                <div class="portlet box blue-madison">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-add"></i><b>Edit ${account.fullName}'s Information</b>
                        </div>


                    </div>
                    <span class="text-red" id="usernameUniqueErrorMessage"></span>
                    <div id="loading" style="display: none;position: absolute; z-index: 1000;margin-left:45%">
                        <img width="50px" height="50px" src="<c:url value="/resources/images/ajax-loading.gif"/>">
                    </div>
                    <div class="portlet-body">
                        <form:form id="update-sk-information"   modelAttribute="account" autocomplete="off">
                            <div class="form-group row">
                                <div class="col-sm-6">
                                   <label class="control-label" for="firstName"> <spring:message code="lbl.firstName"/>  <span class="required">* </span></label>
                        			<form:input path="firstName" class="form-control mx-sm-3"
										required="required"/>
                                </div>

                                <div class="col-sm-6"> 
                                    <label class="control-label" for="lastName"> <spring:message code="lbl.lastName"/></label>
                                     <form:input path="lastName" class="form-control mx-sm-3"/>
                                    
                                </div>
                            </div>
							
                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class="control-label" for="email"> <spring:message code="lbl.email"/> </label>
                                    <input type="email" class="form-control mx-sm-3" name="email" value="${account.getEmail()}">
                                </div>

                                <div class="col-sm-6">
                                    <label class="control-label" for="mobile"> <spring:message code="lbl.mobile"/>	</label>
                                    <form:input path="mobile" class="form-control mx-sm-3" />
                                </div>
                            </div>

                           <form:hidden path="uuid" />
							<form:hidden path="personUUid" />
							<form:hidden path="provider" />
							<form:hidden path="ssNo" />
							<form:hidden path="id"/>
							<form:hidden path="password" />
							<input type="hidden" name="am" id="am" value="${amId }">

                            <div class="form-group row">
                                <div class="col-sm-6">
                                    <label class="control-label" for="nId"> <spring:message code="lbl.username"/> <span class="required">* </span>	</label>
                                   <form:input path="username" class="form-control mx-sm-3"
										readonly="true"	required="required"/>
									<small id="passwordHelpInline" class="text-muted text-para">
										<span class="text-red" id="usernameUniqueErrorMessage"></span> <spring:message code="lbl.userMessage"/>
									</small>
                                </div>
							 <div class="col-sm-6">
                                    <label class="control-label" for="username"> <spring:message code="lbl.branches"/> <span class="required">* </span>	</label>
                                   <select
									required
									name="branches"
									id="branches"
									class="form-control mx-sm-3 ">
									<c:forEach items="${branches}" var="branch">
										<option value="${branch.id}">${branch.name} (${branch.code})</option>
									</c:forEach>
									</select>
                                </div>
                                
                            </div>
                            
                            <div class="form-group row" id="_enableSimPrint">
			                     <div class="col-sm-6">
			                        <label class="control-label" for="enableSimPrint"><spring:message code="lbl.enableSimprint"/></label>
                                     <form:checkbox class="checkBoxClass form-check-input"
                                                    path="enableSimPrint" value="${account.getEnableSimPrint()}"/>
			                   </div>
			                </div>
			                
			                <div class="form-group row" >
								<div class="col-sm-6">
									<label class="label-width" for="inputPassword6"><spring:message code="lbl.activeUser"/></label>
									<form:checkbox class="checkBoxClass form-check-input" onclick="buttonUpdate(${account.isEnabled()})"
												   path="enabled" value="${account.isEnabled()}"/>
								</div>
								<div id="inactivity-message" style="margin-left: 150px;display: none; color: red; font-weight: bold;">Inactivating the user will completely remove the catchment area assigned to the user</div>
							</div>

                            <hr class="dotted">
                            <div class="form-group text-right row" style="margin-top: 50px">
                                <input type="submit" id="updateContinue" name="updateContinue" value="Update & Continue To Edit Catchment Area"
								  class="btn btn-primary col-md-offset-6 col-md-3 col-xs-12"  style="margin-bottom: 5px"/>

                                <input type="submit" id="update" name="update"  value="Update"
								  class="btn btn-primary col-md-1 col-xs-12" style=" margin-left: 5px;margin-bottom: 5px" />
                               
                                
                                <a class="btn btn-primary col-md-1 col-xs-12 " href="${cancelUrl}" style=" margin-left: 5px;margin-bottom: 5px">Cancel</a>
                            </div>
                            <div id="errorMessage" style="display:none">
                                <div class="alert-message warning">
                                    <div id="errormessageContent" class="alert alert-danger" role="alert"> </div>
                                </div>
                            </div>
                       </form:form>




                    </div>
                </div>





            </div>
        </div>
        <!-- END PAGE CONTENT-->
    </div>
</div>
<!-- END CONTENT -->
</div>
<script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>

<script>
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
<%-- <script type="text/javascript">

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
</script> --%>

<script src="<c:url value='/resources/js/user.js'/>"></script>

<script>
	$(document).ready(function() {
		$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
		var selectedBranchList = [];
		<%if (selectedBranches != null) {
			for (Branch branch: selectedBranches) {%>
				selectedBranchList.push(<%=branch.getId()%>);
			<%}
		}%>
		$('#branches').val(selectedBranchList);
		$('#branches').trigger('change');
		if ($('#enabled1').is(':checked') == true) {
			$('#update-continue').show();
		} else {
			$('#update-continue').hide();
		}
	});
	
	function buttonUpdate(presentValue) {
		if ($('#enabled1').is(':checked') == true) {
			$('#update-continue').show();
		} else {
			$('#update-continue').hide();
		}
		if ($('#enabled1').is(':checked') == false && presentValue == true) {
			$('#inactivity-message').show();
		} else {
			$('#inactivity-message').hide();
		}
	}
</script>
<%-- <script>
	$(document).ready(function () {
		console.log("before role check");
		$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
		var selectedRole = <%=selectedRole.get(0).getId()%>;
		console.log(selectedRole);
		$('#role').val(selectedRole);
		$('#role').trigger('change');
	});
</script> --%>

