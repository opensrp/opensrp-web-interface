<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title><spring:message code="lbl.exportTitle" /></title>

<jsp:include page="/WEB-INF/views/css.jsp" />

</head>

<c:url var="saveUrl" value="/export/add.html?lang=${locale}" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<%
		String items = "{ ValueA : \"Household 1\", ValueB : 'Household 2', ValueC : 'Household 3' }";
		JSONObject exportAttributesForMother = new JSONObject();
		if (session.getAttribute("exportAttributesForMother") != null) {
			exportAttributesForMother = (JSONObject) session.getAttribute("exportAttributesForMother");
		}
		JSONObject exportAttributesForChild = new JSONObject();
		if (session.getAttribute("exportAttributesForChild") != null) {
			exportAttributesForChild = (JSONObject) session.getAttribute("exportAttributesForChild");
		}
	%>
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

			<!-- <div class="form-group">
				<a href="<c:url value="/client/household.html"/>"> <strong>Household</strong>
				</a> |<a href="<c:url value="/client/mother.html"/>"> <strong>Mother</strong>
				</a> |<a href="<c:url value="/client/child.html"/>"> <strong>Child</strong>
				</a> |<a href="<c:url value="/client/duplicateClient.html"/>"> <strong>Similar
						Client</strong>
				</a> |<a href="<c:url value="/client/duplicateEvent.html"/>"> <strong>Similar
						Event</strong>
				</a> |<a
					href="<c:url value="/client/duplicateDefinitionOfClient.html"/>">
					<strong>Similarity Definition of Client</strong>
				</a> |<a href="<c:url value="/client/duplicateDefinitionOfEvent.html"/>">
					<strong>Similarity Definition of Event</strong>
				</a>
			</div>

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> Export List
				</div>
				<div class="card-body"> -->






			<form:form method="POST" action="${saveUrl}"
				modelAttribute="exportEntity">
				<div class="form-group">
					<div class="row">
						<div class="col-sm-5">
							Source: <form:select path="entity_type" id="source" name="source">
								<option>Household</option>
								<option>Mother</option>
								<option>Child</option>
							</form:select>
						</div>
					</div>

					<div class="row">
						<div class="col-sm-5">
							<select name="from[]" id="multiselect" class="form-control"
								size="8" multiple="multiple">
								<%
									if (session.getAttribute("exportAttributesForHousehold") != null) {
										List<Object> exportAttributesForHousehold = (List<Object>) session.getAttribute("exportAttributesForHousehold");
										Iterator exportAttributesIterator = exportAttributesForHousehold.iterator();
										while (exportAttributesIterator.hasNext()) {
										    String item = String.valueOf(exportAttributesIterator.next());
								%>
								<option value="<%=item%>"><%=item%></option>
								<%
									    }
								    }
								%>
							</select>
						</div>

						<div class="col-sm-2">
							<button type="button" id="multiselect_rightAll"
								class="btn btn-block">
								<i class="glyphicon glyphicon-forward"></i>
							</button>
							<button type="button" id="multiselect_rightSelected"
								class="btn btn-block">
								<i class="glyphicon glyphicon-chevron-right"></i>
							</button>
							<button type="button" id="multiselect_leftSelected"
								class="btn btn-block">
								<i class="glyphicon glyphicon-chevron-left"></i>
							</button>
							<button type="button" id="multiselect_leftAll"
								class="btn btn-block">
								<i class="glyphicon glyphicon-backward"></i>
							</button>
						</div>

						<div class="col-sm-5">
							<form:select path="column_names" name="to[]" id="multiselect_to"
								class="form-control" size="8" multiple="multiple">
							</form:select>

							<div class="row">
								<div class="col-sm-6">
									<button type="button" id="multiselect_move_up"
										class="btn btn-block">
										<img src="<c:url value='/resources/img/move_up.png'/>" />
									</button>
								</div>
								<div class="col-sm-6">
									<button type="button" id="multiselect_move_down"
										class="btn btn-block col-sm-6">
										<img src="<c:url value='/resources/img/move_down.png'/>" />
									</button>
								</div>
							</div>
						</div>
					</div>

				</div>

				<form:hidden path="id" />
				<div class="form-group">
					<div class="row">
						<div class="col-3">
							<input type="submit" value="Save"
								class="btn btn-primary btn-block" />
						</div>
					</div>
				</div>
			</form:form>

			<!-- </div>
				<div class="card-footer small text-muted"></div>
			</div>
		    </div> -->

			<jsp:include page="/WEB-INF/views/footer.jsp" />
		</div>
	</div>

	<script src="<c:url value='/resources/js/multiselect.min.js'/>"></script>
	<script src="https://unpkg.com/vue@2.4.2"></script>
	<script type="text/javascript">
		jQuery(document).ready(function($) {
			$('#multiselect').multiselect();
		});
	</script>
	
	
	<script type="text/javascript">
	    $(document).ready(function() {

		  $("#source").change(function() {

		    var el = $(this) ;
		    
		    var changedHtml = document.getElementById('multiselect');

		    if(el.val() === "Household" ) {
		    	$("#multiselect option").remove();
		    	var myobject = <%=items%>;
		    	for(index in myobject) {
		    		changedHtml.options[changedHtml.options.length] = new Option(myobject[index], index);
		    	}
		    }
		    else if(el.val() === "Mother" ) {
		        $("#multiselect option").remove();
		        var myobject = <%=exportAttributesForMother%>;
		    	for(index in myobject) {
		    		changedHtml.options[changedHtml.options.length] = new Option(myobject[index], index);
		    	}
		    }
		    else if(el.val() === "Child" ) {
		        $("#multiselect option").remove();
		        var myobject = <%=exportAttributesForChild%>;
		    	for(index in myobject) {
		    		changedHtml.options[changedHtml.options.length] = new Option(myobject[index], index);
		    	}
		    }
		  });

		});
	</script>
</body>
</html>