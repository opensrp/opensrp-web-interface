package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.acl.entity.Permission;
import org.opensrp.acl.entity.Role;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class RegisterController {
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private PaginationUtil paginationUtil;

	@Autowired
	private LocationServiceImpl locationServiceImpl;
	
	@RequestMapping(value = "registers/{id}/motherDetails.html", method = RequestMethod.GET)
	public String showMotherDetails(HttpServletRequest request, HttpSession session, Model model,@PathVariable("id") String id) {
		System.out.println("Mother id :" + id);
		session.setAttribute("motherId", id);
		
		List<Object> data;
		data = databaseServiceImpl.getDataFromViewByBEId("viewJsonDataConversionOfEvent","mother",id);
		session.setAttribute("eventList", data);
		
		List<Object> NWMRList = new ArrayList<Object>();
		List<Object> counsellingList = new ArrayList<Object>();
		List<Object> followUpList = new ArrayList<Object>();
		Iterator dataListIterator = data.iterator();
		while (dataListIterator.hasNext()) {
			Object[] eventObject = (Object[]) dataListIterator.next();
			
			String eventType = String.valueOf(eventObject[8]);
			//System.out.println(eventType);
			
			if(eventType.equals("New Woman Member Registration")){
				//System.out.println(eventObject);
				NWMRList.add(eventObject);
				//System.out.println(NWMRList);
			}else if(eventType.equals("Pregnant Woman Counselling") || eventType.equals("Lactating Woman Counselling")){
				counsellingList.add(eventObject);
			}else if(eventType.equals("Woman Member Follow Up")){
				followUpList.add(eventObject);
			}
		}
		session.setAttribute("NWMRList", NWMRList);
		session.setAttribute("counsellingList", counsellingList);
		session.setAttribute("followUpList", followUpList);
		
		
		
		return "registers/motherDetails";
	}
	
	/*@RequestMapping(value = "registers/motherDetails.html", method = RequestMethod.GET)
	public String showMotherDetails(HttpServletRequest request, HttpSession session, Model model) {
		
		//return "/registers/mother";
		return "registers/motherDetails";
	}*/
	

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
