<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.core.entity.FormUpload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>

<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/views/header.jsp" />




<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">
		
		<jsp:include page="/WEB-INF/views/form/form-link.jsp" />
		
			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.formList"/>
				</div>
				<div class="card-body">
					<div class="table-responsive">
						<div id="dataTable_wrapper"
							class="dataTables_wrapper container-fluid dt-bootstrap4">
							<div class="row">
								<div class="col-sm-12">
									<table class="table table-bordered dataTable" id="dataTable"
										style="width: 100%;">
										<thead>
											<tr>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.formId"/></th>
												    <th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.formName"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 106px;"><spring:message code="lbl.formType"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.creator"/></th>
													<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.action"/></th>
											</tr>
										</thead>
									
										<tbody>
											<%
												if (session.getAttribute("dataList") != null) {
													List<FormUpload> dataList = (List<FormUpload>)session.getAttribute("dataList");
													Iterator dataListIterator = dataList.iterator();
													while (dataListIterator.hasNext()) {
														
														
														FormUpload formUpload = (FormUpload) dataListIterator.next();
														int id = formUpload.getId();
														String name = formUpload.getFileName()!=null ? formUpload.getFileName() : "";
														String downloadFormURL = "/form/"+id+"/downloadForm.html";
											%>
											<tr>
												<td><%=id%></td>
												<td><%=name%></td>
												<td></td>
												<td></td>
												<td>
												<% if(AuthenticationManagerUtil.isPermitted("PERM_READ_FACILITY")){ %>
												<a href="<c:url value="<%= downloadFormURL%>" />"><spring:message code="lbl.downloadForm"/></a>
												<%} %>
												</td> 
											</tr>
											<%
												}
												}
											%>
										</tbody>
									</table>

								</div>
							</div>

							<jsp:include page="/WEB-INF/views/pager.jsp" />

						</div>
					</div>
				</div>
				<div class="card-footer small text-muted"></div>
			</div>
		</div>

		<jsp:include page="/WEB-INF/views/footer.jsp" />
	</div>
</body>
</html>