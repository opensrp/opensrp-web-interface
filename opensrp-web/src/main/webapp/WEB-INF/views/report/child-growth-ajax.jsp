<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>


<%	
String provider = "";
int falter = 0;
int total = 0;
int growth=0;
int size=0;
int counter=0;					
	if(session.getAttribute("data") != null){
		List<Object> data = (List<Object>) session.getAttribute("data");
		Iterator dataCountListIterator = data.iterator();
		while (dataCountListIterator.hasNext()) {
			Object[] DataObject = (Object[]) dataCountListIterator.next();
			provider = String.valueOf(DataObject[0]);
			falter = Integer.parseInt(String.valueOf(DataObject[1]));
			growth = Integer.parseInt(String.valueOf(DataObject[2]));
			total = falter+growth;
			String falterInPercentage = "";
			String adequateInPercentage = "";
			if(total>0){
			 	falterInPercentage = String.format("%.2f", (double) (falter*100)/total);			
			 	adequateInPercentage = String.format("%.2f",(double)(growth*100)/total);
			}else{
				falterInPercentage = "0.0";
				adequateInPercentage = "0.0";
			}
										
			%>
			<tr>
				<td><%=provider %></td>
				<td><%=growth %>  ( <%=adequateInPercentage %> % )</td>
				<td><%=falter %>  ( <%= falterInPercentage %> % )</td>									
				<td><%=total %></td>
			</tr>
			<% 
			} 
		}									
%>
							