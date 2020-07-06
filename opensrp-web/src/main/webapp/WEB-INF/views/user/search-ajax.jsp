<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.opensrp.web.util.AuthenticationManagerUtil"%>
<%@ page import="org.opensrp.core.entity.Branch" %>
<%@ page import="org.opensrp.core.entity.Role" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<%
    List<Object[]> divisions = (List<Object[]>) session.getAttribute("divisions");
    List<Branch> branches = (List<Branch>) session.getAttribute("branches");
    List<Role> roles = (List<Role>) session.getAttribute("roles");
%>

   
    

      <div class="form-group">
        <div class="row">
            <div class="col-lg-3 form-group">
                <select  class="form-control" id="division"
                        name="division">
                    <option value=""><spring:message code="lbl.selectDivision"/>
                    </option>
                    <%
                        for (Object[] objects : divisions) {
                    %>
                    <option value="<%=objects[1]%>?<%=objects[0]%>"><%=objects[0]%></option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div class="col-lg-3 form-group">
                <select  class="form-control" id="district"
                        name="district">
                    <option value="0?"><spring:message code="lbl.selectDistrict"/></option>
                    <option value=""></option>
                </select>
            </div>

            <div class="col-lg-3 form-group">
                <select  class="form-control" id="upazila"
                        name="upazila">
                    <option value="0?"><spring:message code="lbl.selectUpazila"/></option>
                    <option value=""></option>

                </select>
            </div>

            <div class="col-lg-3 form-group">
                <select  class="form-control" id="pourasabha"
                        name="pourasabha">
                    <option value="0?"><spring:message code="lbl.selectPourasabha"/></option>
                    <option value=""></option>

                </select>
            </div>
            </div>
          </div>
          <div class="form-group">
        	<div class="row">
            <div class="col-lg-3 form-group">
                <select class="form-control" id="union"
                        name="union">
                    <option value="0?"><spring:message code="lbl.selectUnion"/></option>
                    <option value=""></option>

                </select>
            </div>

            <div class="col-lg-3 form-group">
                <select class="form-control" id="village"
                        name="village">
                    <option value="0?"><spring:message code="lbl.selectVillage"/></option>
                    <option value=""></option>

                </select>
            </div>
       
       
            <div class="col-lg-3 form-group">
                <select class="form-control" id="role"
                        name="role">
                    <option value=""><spring:message code="lbl.selectRole"/></option>
                    <%
                        for(Role role: roles) {

                    %>
                    <option value="<%=role.getId()%>"><%=role.getName()%></option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div class="col-lg-3 form-group">
                <select class="form-control js-example-basic-multiple" id="branch" name="branch">
                    <option value=""><spring:message code="lbl.selectBranch"/></option>
                    <%
                        for(Branch branch: branches) {

                    %>
                    <option value="<%=branch.getId()%>"><%=branch.getName()%></option>
                    <%
                        }
                    %>
                </select>
            </div>

        </div>
        </div>
        <!-- end: location info -->
		<div class="form-group">
        	<div class="row">

	            <div class="col-lg-12 form-group text-right">
	                <button type="submit" onclick="drawDataTables()"
	                        class="btn btn-primary" value="search"><spring:message code="lbl.search"/></button>
	            </div>
        	</div>
      </div>
  
    <div class="card-footer small text-muted"></div>


