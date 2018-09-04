package org.opensrp.web.controller;

import javax.servlet.http.HttpSession;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.facility.entity.Facility;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;


@Controller
@RequestMapping(value = "facility")
public class FacilityController {
	
	@Autowired
    private DatabaseServiceImpl databaseServiceImpl;
	
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView showDuplicateEvent(HttpSession session){
		Facility facility = new Facility();
		
		return new ModelAndView("facility/add", "command", facility);
       
	}
	
	
	/*@RequestMapping(value = "/updateDuplicateDefinition.html", method = RequestMethod.POST)
	public String updateDuplicateDefinition(@RequestParam(value = "criteriaString", required = false) String criteriaString,
			@RequestParam(value = "id", required = false) String id,
			@RequestParam(value = "viewName", required = false) String viewName,
			HttpSession session, Model model) throws JSONException {
		
		System.out.println("id >>>>> "+ id);
		System.out.println("viewName >>>>> "+ viewName);
		System.out.println("new criteriaString >>>>> "+ criteriaString);
		duplicateRecordServiceImpl.updateDuplicateMatchCriteriaForView(id, viewName, criteriaString);
		
		//duplicateRecordServiceImpl.getDuplicateRecord(session, viewName);
		//return "client/duplicate-event";
		
		if(viewName.equals("viewJsonDataConversionOfEvent")){
			return showDuplicateEvent(session, model);
		}
		return showDuplicateClient(session, model);
	}

	
	@RequestMapping(value = "/duplicateEvent.html", method = RequestMethod.GET)
	public String showDuplicateEvent(HttpSession session, Model model) throws JSONException {
		duplicateRecordServiceImpl.getDuplicateRecord(session,"viewJsonDataConversionOfEvent");
        return "client/duplicate-event";
	}
	*/
	
	
	

}
