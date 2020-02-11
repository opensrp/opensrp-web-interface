<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.opensrp.common.entity.ExportEntity"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%
	boolean PERM_WRITE_EXPORT_LIST = AuthenticationManagerUtil
			.isPermitted("PERM_WRITE_EXPORT_LIST");
%>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="/WEB-INF/views/header.jsp" />

<body class="fixed-nav sticky-footer bg-dark" id="page-top">
	<jsp:include page="/WEB-INF/views/navbar.jsp" />
	<div class="content-wrapper">
		<div class="container-fluid">

			<div class="form-group">
				<jsp:include page="/WEB-INF/views/client/client-link.jsp" />
			</div>


			<div class="form-group">
				<%
					if (AuthenticationManagerUtil.isPermitted("PERM_WRITE_EXPORT_LIST")) {
				%>
				<a href="<c:url value="/export/add.html?lang=${locale}"/>"> <strong><spring:message
							code="lbl.addNew" /></strong></a>
				<%
					}
				%>
			</div>

			<div class="card mb-3">
				<div class="card-header">
					<i class="fa fa-table"></i> <spring:message code="lbl.exportList"/>
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
													style="width: 140px;"><spring:message code="lbl.entityType"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.columnName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.action"/></th>
											</tr>
										</thead>
										<tfoot>
											<tr>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 140px;"><spring:message code="lbl.entityType"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.columnName"/></th>
												<th tabindex="0" rowspan="1" colspan="1"
													style="width: 225px;"><spring:message code="lbl.action"/></th>
											</tr>
										</tfoot>
										<tbody>
											<%
												if (session.getAttribute("exportList") != null) {
													List<ExportEntity> exportEntity = (List<ExportEntity>) session.getAttribute("exportList");
													for(ExportEntity e: exportEntity) {
														String Id = String.valueOf(e.getId());
														session.setAttribute("Id", Id);
											%>
											<tr>
												<td><%=e.getEntity_type()%></td>
												<td><%=e.getColumn_names()%></td>
												<td>
													<%
														if (AuthenticationManagerUtil
																	.isPermitted("PERM_WRITE_EXPORT_LIST")) {
													%>
													<a
													href="<c:url value="/export/${Id}/edit.html?lang=${locale}"/>"><spring:message code="lbl.edit"/></a>
													<%
														    }
													    }
													%>
												</td>
											</tr>
											<%
												}
											%>
										</tbody>
									</table>

								</div>
							</div>

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