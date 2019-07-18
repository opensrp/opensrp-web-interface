<%

Integer refreshCount = (Integer) session
.getAttribute("refreshCount");

%>

	<div>
	<center><%
	 if(refreshCount!=0){ %>
		<h1> Successfully View Refreshed, Thank You</h1>
	<%  } else{ %>
		<h1> Something wrong, please contact with administrator</h1>
		
	<% }
	%>
	</center>
	</div>