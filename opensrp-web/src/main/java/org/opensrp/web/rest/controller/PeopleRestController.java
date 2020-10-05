package org.opensrp.web.rest.controller;

import static org.springframework.http.HttpStatus.OK;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.ClientDetailsDTO;
import org.opensrp.common.util.HouseholdColumn;
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
	
	@RequestMapping(value = "/household/list", method = RequestMethod.GET)
	public ResponseEntity<String> householdList(HttpServletRequest request, HttpSession session) throws JSONException {
		Integer start = Integer.valueOf(request.getParameter("start"));
		Integer length = Integer.valueOf(request.getParameter("length"));
		//String name = request.getParameter("search[value]");
		Integer draw = Integer.valueOf(request.getParameter("draw"));
		String orderColumn = request.getParameter("order[0][column]");
		
		String orderDirection = request.getParameter("order[0][dir]");
		orderColumn = HouseholdColumn.valueOf("_" + orderColumn).getValue();
		
		String name = request.getParameter("search");
		int branchId = Integer.parseInt(request.getParameter("branchId"));
		String roleName = request.getParameter("roleName");
		String location = request.getParameter("locationId");
		
		ClientDetailsDTO households = peopleService.getHouseholdData(location, branchId, length, start, orderColumn,
		    orderDirection);
		
		JSONObject response = peopleService.drawHouseholdDataTable(draw, 0, households);
		return new ResponseEntity<>(response.toString(), OK);
	}
	
}
