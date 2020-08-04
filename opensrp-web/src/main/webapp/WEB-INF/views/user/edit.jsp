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
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.core.entity.Role"%>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page import="java.util.Set" %>

<!DOCTYPE html>


<title><spring:message code="lbl.editUserTitle"/></title>

<c:url var="saveUrl" value="/user/${id}/edit.html" />
<c:url var="cancelUrl" value="/user.html" />

<%
	Set<Branch> selectedBranches = (Set<Branch>)session.getAttribute("selectedBranches");
	String selectedParentUser = (String)session.getAttribute("parentUserName");
	Integer selectedParentId = (Integer)session.getAttribute("parentUserId");
	String errorMessage = (String)session.getAttribute("errorMessageForSK");

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
<jsp:include page="/WEB-INF/views/header.jsp" />
<style>
	.row {
		margin: 0px;
		margin-bottom: 8px;
	}
</style>

<div class="page-content-wrapper">
	<div class="page-content">

		<div class="portlet box blue-madison">
			<div class="portlet-title">
				<div class="caption">
					<i class="fa fa-list"></i><spring:message code="lbl.editUserTitle"/>
				</div>
			</div>
			<div class="portlet-body">
				<form:form method="POST" action="${saveUrl}"
						   modelAttribute="account" class="form-inline">


					<div class="row tag-height">

						<div class="col-md-2" style="width:10%">
							<label class="label-width" for="inputPassword6"> <spring:message code="lbl.firstName"/> </label>
						</div>
						<div class="col-md-3">
							<form:input path="firstName" class="form-control"
										required="required"/>
						</div>
					</div>



					<div class="row col-12 tag-height">
						<div class="col-md-2" style="width:10%">
							<label class="label-width" ><spring:message code="lbl.lastName"/> </label>
						</div>
						<div class="col-md-3">
							<form:input path="lastName" class="form-control mx-sm-3"/>
						</div>
					</div>

					<div class="row ">
						<div class="col-md-2" style="width:10%">
							<label class="label-width"  > <spring:message code="lbl.email"/> </label>
						</div>
						<div class="col-md-3">
							<input type="email" class="form-control mx-sm-3" name="email" value="${account.getEmail()}">
						</div>
					</div>

					<div class="row">
						<div class="col-md-2" style="width:10%">
							<label class="label-width" ><spring:message code="lbl.mobile"/></label>

						</div>
						<div class="col-md-3">
							<form:input path="mobile" class="form-control mx-sm-3" />
						</div>
					</div>

					<div class="row ">
						<div class="col-md-2" style="width:10%">
							<label class="label-width" ><spring:message code="lbl.username"/></label>

						</div>
						<div class="col-md-5">
							<form:input path="username" class="form-control"
										readonly="true"	required="required"/>
							<small id="passwordHelpInline" class="text-muted text-para">
								<span class="text-red" id="usernameUniqueErrorMessage"></span> <spring:message code="lbl.userMessage"/>
							</small>
						</div>
					</div>

					<form:hidden path="uuid" />
					<form:hidden path="personUUid" />
					<form:hidden path="provider" />
					<form:hidden path="ssNo" />
					<form:hidden path="id"/>
					<form:hidden path="password" />


					<div class="row ">
						<div class="col-md-2" style="width:10%">
							<label class="label-width"  for="role">
								<spring:message code="lbl.role"/>
							</label>

						</div>
						<div class="col-md-3">
							<select onchange="isSS()"
									id="role"
									class="form-control mx-sm-3 js-example-basic-multiple"
									name="roles" required>
								<c:forEach items="${roles}" var="role">
									<option value="${role.id}">${role.name}</option>
								</c:forEach>
							</select>
						</div>
					</div>


					<div class="row " id="_enableSimprint">
						<div class="col-md-2" style="width:10%">
							<label class="label-width" for="inputPassword6"><spring:message code="lbl.enableSimprint"/></label>
						</div>
						<div class="col-md-3">
							<form:checkbox class="checkBoxClass form-check-input"
										   path="enableSimPrint" value="${account.getEnableSimPrint()}" />
						</div>
					</div>

					<!-- for location -->
					<div class="row" id="locationDiv" style="display:none">
						<div class="col-md-2" style="width:10%">
							<label class="label-width" for="inputPassword6"><spring:message code="lbl.location"/></label>
						</div>
						<div class="col-md-3">
							<div id="cm" class="ui-widget ">
								<div id="locationsTag" ></div>
								<span class="text-red">${locationSelectErrorMessage}</span>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-2" style="width:10%">
							<label class="label-width"  for="branches">
								<spring:message code="lbl.branches"/>
							</label>

						</div>
						<div class="col-md-3">
							<select
									required
									name="branches"
									id="branches"
									class="form-control mx-sm-3 js-example-basic-multiple"
									multiple="multiple">
								<c:forEach items="${branches}" var="branch">
									<option value="${branch.id}">${branch.name} (${branch.code})</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<!-- end: for location -->
					<!-- for team -->
					<%-- <div class="row col-12 tag-height" id="teamDiv" style="display:none">
                           <div class="form-group">
                               <label class="label-width" for="inputPassword6"><spring:message code="lbl.team"/></label>
                                   <select class="form-control mx-sm-3" id="team" name="team" required="required" disabled>
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

                   </div> --%>
					<!--end: for team -->



					<div class="row">
						<div class="col-md-2" style="width:10%">
							<label class="label-width" ><spring:message code="lbl.activeUser"/></label>
						</div>
						<div class="col-md-3">
							<form:checkbox class="checkBoxClass form-check-input"
										   path="enabled" value="${account.isEnabled()}"/>
						</div>
					</div>

					<div class="row ">
						<div class="col-md-offset-1 col-md-2">
							<input type="submit" value="<spring:message code="lbl.saveChanges"/>"
								   class="btn btn-primary btn-block btn-sm" style="padding: 7px"/>
						</div>
						<div class="col-md-2">
							<a href="${cancelUrl}" style="margin-left: 20px;" class="btn btn-primary btn-block btn-center">Cancel</a>
						</div>
					</div>

				</form:form>
				<div class="card-footer small text-muted"></div>
			</div>
		</div>
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	<!-- /.container-fluid-->
	<!-- /.content-wrapper-->

</div>

<script src="<c:url value='/resources/js/magicsuggest-min.js'/>"></script>
<script src="<c:url value='/resources/js/jquery-ui.js'/>"></script>
<script src="<c:url value='/resources/js/select2.js' />"></script>
<script>
	var ssId = "-<%=ssPrefix%>";

	//alert(ssId);
	function isSS() {

		var selectedRoleId = $('#role').val();
		var selectedRoleName = $('#role option:selected').text();

		if(selectedRoleName == "SK"){
			$('#_enableSimprint').show();
		}else{
			$('input[type="checkbox"][name="enableSimPrint"]').prop("checked", false).change();
			$('#_enableSimprint').hide();
		}
		if (selectedRoleName != "SS") {

			$('#ssNo').val("");
			$('#ssNo').trigger('change');
			$('#ssOption').hide();
		} else {
			//$('#ssNo').val(ssId);
			$('#ssNo').trigger('change');
			$('#ssOption').show();
		}


	}
</script>
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

	// function forRoleSelection() {
	// 	let roleId = $('#role').val();
	// 	if (roleId == 29 || roleId == 28) {
	// 		$('#branches').removeAttr("multiple");
	// 		$("#branches option:selected").prop("selected", false);
	// 		$('#branches').trigger('change');
	// 	} else {
	// 		$('#branches').attr('multiple', 'multiple');
	// 		$("#branches option:selected").prop("selected", false);
	// 		$('#branches').trigger('change');
	// 	}
	// 	if (roleId == 29) { //role for ss
	// 		$('#parentUserForSS').show();
	// 		$('#parentUserForSS').prop('required', true);
	//
	// 		$('#username-div').hide();
	// 		$('#password-div').hide();
	// 		$('#retypePassword-div').hide();
	//
	// 		$('#username').val('');
	// 		$('#password').val('');
	// 		$('#retypePassword').val('');
	//
	// 		$('#username').prop('required', false);
	// 		$('#password').prop('required', false);
	// 		$('#retypePassword').prop('required', false);
	//
	// 		$('#ssNo').prop('required', true);
	// 	} else {
	// 		$('#ssNo').val('').trigger('change');
	// 		$('#parentUserForSS').hide();
	// 		$('#parent-user').html("");
	// 		$('#parentUserForSS').prop('required', false);
	//
	// 		$('#username-div').show();
	// 		$('#password-div').show();
	// 		$('#retypePassword-div').show();
	//
	// 		$('#username').val('');
	// 		$('#password').val('');
	// 		$('#retypePassword').val('');
	//
	// 		$('#username').prop('required', true);
	// 		$('#password').prop('required', true);
	// 		$('#retypePassword').prop('required', true);
	// 		$('#ssNo').prop('required', false);
	// 	}
	// }

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
	});
</script>
<script>
	$(document).ready(function () {
		console.log("before role check");
		$('.js-example-basic-multiple').select2({dropdownAutoWidth : true});
		var selectedRole = <%=selectedRole.get(0).getId()%>;
		console.log(selectedRole);
		$('#role').val(selectedRole);
		$('#role').trigger('change');
	});
</script>
