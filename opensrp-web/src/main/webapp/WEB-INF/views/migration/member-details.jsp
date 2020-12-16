<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<h3>
	<strong>Member migration details</strong>
</h3>
<hr />
<h3> <strong>Name:</strong> ${data.getString("member_name")}, <strong>Age:</strong> ${data.getString("member_age")},<strong>Contact:</strong> ${data.getString("member_contact")}</h3>

<table style="width: 100%;"
	class="display table table-bordered table-striped">
	<thead>
		<tr>
			<th rowspan="2">Item</th>
			<th rowspan="2">From</th>
			<th rowspan="2">To</th>
			
		</tr>
		
	</thead>
	<tbody>
		<tr>
			<th>HH head</th>
			<th>${data.getString("hh_name_out")}</th>
			<th>${data.getString("hh_name_in")}</th>			
		</tr>
		<tr>
			<th>HH head contact</th>
			<th>${data.getString("hh_contact_out")}</th>
			<th>${data.getString("hh_contact_in")}</th>			
		</tr>
		<tr>
			<th>Branch</th>
			<th>${data.getString("bout_name")}</th>
			<th>${data.getString("bin_name")}</th>			
		</tr>
		<tr>
			<th>SK</th>
			<th>${data.getString("sk_out")}</th>
			<th>${data.getString("sk_in")}</th>			
		</tr>
		<tr>
			<th>SS</th>
			<th>${data.getString("ss_out")}</th>
			<th>${data.getString("ss_in")}</th>			
		</tr>
		<tr>
			<th>Village</th>
			<th>${data.getString("village_out")}</th>
			<th>${data.getString("village_in")}</th>			
		</tr>
		<tr>
			<th>Union/Ward</th>
			<th>${data.getString("union_out")}</th>
			<th>${data.getString("union_in")}</th>			
		</tr>
		<tr>
			<th>Upazila</th>
			<th>${data.getString("upazila_out")}</th>
			<th>${data.getString("upazila_in")}</th>			
		</tr>
		<tr>
			<th>District</th>
			<th>${data.getString("district_out")}</th>
			<th>${data.getString("district_in")}</th>			
		</tr>
	</tbody>

</table>

