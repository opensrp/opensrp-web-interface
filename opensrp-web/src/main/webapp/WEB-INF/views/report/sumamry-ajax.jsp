<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>


<%	String indicator = "";
	int count = 0;
	int total = 0;
	int growth=0;
	int size=0;
	int counter=0;						
									
	if(session.getAttribute("data") != null){
		List<Object> data = (List<Object>) session.getAttribute("data");
		Iterator dataCountListIterator = data.iterator();
		while (dataCountListIterator.hasNext()) {
			Object[] DataObject = (Object[]) dataCountListIterator.next();
			indicator = String.valueOf(DataObject[0]);
			count = Integer.parseInt(String.valueOf(DataObject[1]));
			total = Integer.parseInt(String.valueOf(DataObject[2]));																				
			String falterInPercentage = String.format("%.2f", (double) (count*100)/total);
										
		%>
			<div class="row">
			<div class="col-6"><%=indicator %> </div>
			<div class="col-3"><%=falterInPercentage%> %</div>
			</div>
		<% 
									   } 
		}									
	%>				