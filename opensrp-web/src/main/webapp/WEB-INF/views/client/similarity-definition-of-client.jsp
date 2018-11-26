<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="org.opensrp.common.util.CheckboxHelperUtil"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8">
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Similarity Client Rule Definition</title>
<jsp:include page="/WEB-INF/views/css.jsp" />
</head>

<c:url var="updateSimilarityDefinitionUrl" value="/client/updateSimilarityDefinition.html" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

			<div class="form-group">				
			<jsp:include page="/WEB-INF/views/client/client-link.jsp" />		
			</div>

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.similarclientRuleDefination"/>
				</div>
				<div class="card-body">
					<form:form method="POST" action="${updateSimilarityDefinitionUrl}">
					
    				<input type="text" id= "criteriaString" name="criteriaString" value="" readonly>
    
						<div class="form-group">
							<div class="form-check">
								<div class="row">

									<%
									if (session.getAttribute("columnNameList") != null) {
									 List<String> columnNameList = (List<String>) session.getAttribute("columnNameList");
									 for(int i=0; i<columnNameList.size();i++){
											String columnName = columnNameList.get(i);
										%>
									<div class="col-5">
										<input type="checkbox" value=<%=columnName%> onclick="check()">
												
										<label class="form-check-label" for="defaultCheck1"> <%=columnName%>
										</label>
									</div>
									<%
											}
									}
										%>


								</div>
							</div>
							
						</div>
			
						<form:hidden path="id"/>
						<form:hidden path="viewName"/>
						<form:hidden path="matchingKeys" id="matchingKeys"/>
						
						<%
									if (session.getAttribute("columnNameList") != null) {
						%>
						<div class="form-group">
							<div class="row">
								<div class="col-3">
									<input type="submit" value="<spring:message code="lbl.save"/>"
										class="btn btn-primary btn-block" />
								</div>
							</div>
						</div>
						<%} %>
					</form:form>
					
				</div>
			</div>
		</div>
		<!-- /.container-fluid-->
		<!-- /.content-wrapper-->
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
	
	
<script type="text/javascript">   

var submitValue = 0;
var checkedViewNames = [];

$(document).ready(function() {
	$("#criteriaString").hide();
	var prevMatchingCriteria = stringTOArray($("#matchingKeys").val());
	checkBoxesAccordingToPrevMatchingCriteria(prevMatchingCriteria);
});

function stringTOArray(inputString){
	var array = inputString.split(",");
	return array;
}

function checkBoxesAccordingToPrevMatchingCriteria(prevMatchingCriteria){
	for( var i=0; i<prevMatchingCriteria.length; i++){
		$('input[type=checkbox]').each(function () {
	           if ($(this).val() === prevMatchingCriteria[i].trim()) {
	               $(this).prop('checked', true);
	           }
	});
		
	}
}

function check(){
	var allVals = [];
	$('input:checked').each(function () {
		allVals.push($(this).val());
	});
	checkedViewNames = allVals;
	$("#criteriaString").val(checkedViewNames.toString());
}

</script>
</body>
</html>