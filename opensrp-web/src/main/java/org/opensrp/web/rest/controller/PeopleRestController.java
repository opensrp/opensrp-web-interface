package org.opensrp.web.rest.controller;

import org.opensrp.core.service.PeopleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
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
	
	/*@RequestMapping(value = "/member/list", method = RequestMethod.GET)
	public ResponseEntity<String> memberList(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = MemberColumn.valueOf("_" + orderColumn).getValue();
		
		String searchKey = request.getParameter("search");
		String baseEntityId = request.getParameter("baseEntityId");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		
		String location = request.getParameter("locationId");
		
		List<ClientListDTO> data = peopleService.getMemberData(baseEntityId);
		
		JSONObject response = peopleService.drawMemberDataTable(draw, 0, data);
		return new ResponseEntity<>(response.toString(), OK);
	}
	*/
}
