<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.common.util.NumberToDigit"%>
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

<title>OPENSRP Dashboard Home</title>

<jsp:include page="/WEB-INF/views/css.jsp" />
<link type="text/css"
	href="<c:url value="/resources/css/style.css"/>"
	rel="stylesheet">
</head>
<c:url var="saveUrl" value="/role/add" />
<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />


	<div class="content-wrapper">
		<div class="container-fluid">
					
		
			<div class="row">
				<%	
					String registerType="";
					int totalCount=0;
					String thisMonthCount="";
					String lastSevenDays="";
					String todaysCount="";
					int size=0;
					int counter=0;
					if(session.getAttribute("dashboardDataCount") != null){
					List<Object> dashboardDataCount = (List<Object>) session.getAttribute("dashboardDataCount");
					Iterator dashboardDataCountListIterator = dashboardDataCount.iterator();
					while (dashboardDataCountListIterator.hasNext()) {
						Object[] dashboardDataObject = (Object[]) dashboardDataCountListIterator.next();
						registerType = String.valueOf(dashboardDataObject[0]);
						totalCount = Integer.parseInt(String.valueOf(dashboardDataObject[1]));
						thisMonthCount = String.valueOf(dashboardDataObject[2]);
						lastSevenDays = String.valueOf(dashboardDataObject[3]);
						todaysCount = String.valueOf(dashboardDataObject[4]);
						List<Integer> digits = NumberToDigit.getDigitFromNumber(totalCount);
						size = digits.size();
						counter++;
						pageContext.setAttribute("registerType", registerType);
					%>
			
				<div class="col-lg-4 col-xs-4">					
					<div class="box<%=counter%>">
						<a class="imgs" alt="image" href="<c:url value="/visualize/${registerType}.html"/>">
						<img src="<c:url value="/resources/img/${registerType}.png"/>"></a>						
							<div class="counter">
							<% if(size == 0){
								
							}else if(size == 1){ %>
								<div class="counter_left"><%=digits.get(0) %></div>
								<div class="counter_right"> </div>
								
							<%}else { %>
								<div class="counter_left"><%=digits.get(0) %></div>
								<%
								
								for (int i = 1; i < size - 1; i++) {%>
									<div class="counter_mid"><%=digits.get(i) %></div>
								<%}
								%>
								<div class="counter_right"> <%=digits.get(size-1) %></div>
							<%}							
							%>
								
							</div>
					</div>
					
					<div class="count_box">
						<div class="box_inner1">
							<div class="box_top2">  TODAY  </div>
							<div class="box_buttom2">  <%=todaysCount %>  </div>
						</div>
						<div class="box_inner1">
							<div class="box_top2">   LAST 7 DAYS  </div>
							<div class="box_buttom2">  <%=lastSevenDays %>  </div>
						</div>
						<div class="box_inner1">
							<div class="box_top2">  THIS MONTH  </div>
								<div class="box_buttom2"> <%=thisMonthCount %> </div>
						</div>
					</div>					
				</div>	
			
			<%
				}
			}
				
		%>
			</div> <!-- row -->
				
		</div>
		<br />
		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>

</body>
</html>