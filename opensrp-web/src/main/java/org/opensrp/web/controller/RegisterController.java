package org.opensrp.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class RegisterController {
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private PaginationUtil paginationUtil;

	@Autowired
	private LocationServiceImpl locationServiceImpl;

	@RequestMapping(value = "/registers/household.html", method = RequestMethod.GET)
	public String showHouseholdList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "household");
		return "/registers/household";
	}

	@RequestMapping(value = "/registers/mother.html", method = RequestMethod.GET)
	public String showMotherList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "mother");
		return "/registers/mother";
	}

	@RequestMapping(value = "/registers/child.html", method = RequestMethod.GET)
	public String showChildList(HttpServletRequest request, HttpSession session, Model model) {
        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "child");
		return "/registers/child";
	}

	@RequestMapping(value = "/location", method = RequestMethod.GET)
	public String getChildLocationList(HttpServletRequest request, HttpSession session, Model model, @RequestParam int id) {
		List<Object[]> parentData = locationServiceImpl.getChildData(id);
		System.out.println("child data size: " + parentData.size());
		session.setAttribute("data", parentData);
		return "/location";
	}

	@RequestMapping(value = "/registers/details.html", method = RequestMethod.GET)
	public String motherDetails(HttpServletRequest request, HttpSession session, Model model) {
		return "/registers/details";
	}

}