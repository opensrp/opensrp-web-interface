package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.core.service.PeopleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("rest/api/v1/people")
@RestController
public class PeopleRestController {
	
	@Autowired
	private PeopleService peopleService;
	
	/*
	@RequestMapping(value = "/household/list", method = RequestMethod.GET)
	public ResponseEntity<String> householdList(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = HouseholdColumn.valueOf("_" + orderColumn).getValue();
		
		String searchKey = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		
		String location = request.getParameter("locationId");
		JSONObject jo = new JSONObject();
		jo.put("branch_id", 2);
		jo.put("division", "DHAKA");
		jo.put("offset", 0);
		jo.put("limit", 10);
		ClientCommonDTO households = new ClientCommonDTO();
		try {
			households = peopleService.getHouseholdData(jo);
		}
		catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//JSONObject response = peopleService.drawHouseholdDataTable(draw, 0, households);
		return new ResponseEntity<>(response.toString(), OK);
	}*/
	@RequestMapping(headers = { "Accept=application/json;charset=UTF-8" }, value = "/member/list", method = RequestMethod.GET)
	public ResponseEntity<String> memberList(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		
		String orderDirection = request.getParameter("order[0][dir]");
		
		String searchKey = request.getParameter("searchKey");
		String village = request.getParameter("village");
		Integer startAge = Integer.valueOf(request.getParameter("startAge"));
		Integer endAge = Integer.valueOf(request.getParameter("endAge"));
		String gender = request.getParameter("gender");
		JSONObject jo = new JSONObject();
		jo.put("village", village);
		jo.put("gender", gender);
		jo.put("startAge", startAge);
		jo.put("endAge", endAge);
		jo.put("searchKey", searchKey);
		jo.put("offset", start);
		jo.put("limit", length);
		int totalRecords = Integer.parseInt(request.getParameter("totalRecords"));
		List<String> data = peopleService.getMemberList(jo, startAge, endAge);
		
		int total = 0;
		if (start == 0) {
			
			total = peopleService.getMemberListCount(jo, startAge, endAge);
		} else {
			
			total = totalRecords;
		}
		
		JSONObject response = peopleService.drawMemberDataTable(draw, total, data, start);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
}
