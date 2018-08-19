package org.opensrp.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.common.service.impl.ClientServiceImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "client")
public class ClientController {
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private PaginationUtil paginationUtil;

	@Autowired
	private LocationServiceImpl locationServiceImpl;
	
	@Autowired
	private ClientServiceImpl clientServiceImpl;
	
	
	@RequestMapping(value = "/duplicateClient.html", method = RequestMethod.GET)
	public String showDuplicateRecord(HttpServletRequest request, HttpSession session, Model model) throws JSONException {
        clientServiceImpl.getDuplicateRecord(session,"viewJsonDataConversionOfClient");
        return "client/duplicate-client";
	}
	
	@RequestMapping(value = "/child/{id}/details.html", method = RequestMethod.GET)
	public String showChildDetails(HttpServletRequest request, HttpSession session, Model model,@PathVariable("id") String id) throws JSONException {
		clientServiceImpl.getChildWeightList(session,id);
		return "client/child-details";
	}
	
	
	@RequestMapping(value = "/mother/{id}/details.html", method = RequestMethod.GET)
	public String showMotherDetails(HttpServletRequest request, HttpSession session, Model model,@PathVariable("id") String id) {
		clientServiceImpl.getMotherDetails(session, id);
		return "client/mother-details";
	}

	@RequestMapping(value = "/household.html", method = RequestMethod.GET)
	public String showHouseholdList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "household");
		return "/client/household";
	}

	@RequestMapping(value = "/mother.html", method = RequestMethod.GET)
	public String showMotherList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "mother");
		return "/client/mother";
	}

	@RequestMapping(value = "/child.html", method = RequestMethod.GET)
	public String showChildList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "child");
		return "/client/child";
	}

	@RequestMapping(value = "/location", method = RequestMethod.GET)
	public String getChildLocationList(HttpServletRequest request, HttpSession session, Model model, @RequestParam int id) {
		List<Object[]> parentData = locationServiceImpl.getChildData(id);
		System.out.println("child data size: " + parentData.size());
		session.setAttribute("data", parentData);
		return "/location";
	}

}
