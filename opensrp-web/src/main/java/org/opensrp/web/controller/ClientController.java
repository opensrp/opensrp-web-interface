package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.opensrp.acl.entity.DuplicateMatchingCriteriaDefinition;
import org.opensrp.acl.service.impl.DuplicateRecordServiceImpl;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.common.entity.ClientEntity;
import org.opensrp.common.service.impl.ClientServiceImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

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
	
	@Autowired
	private DuplicateRecordServiceImpl duplicateRecordServiceImpl;
	
	@PostAuthorize("hasPermission(returnObject, 'UPDATEDUPLICATEDEFINATION')")
	@RequestMapping(value = "/updateDuplicateDefinition.html", method = RequestMethod.POST)
	public String updateDuplicateDefinition(@RequestParam(value = "criteriaString", required = false) String criteriaString,
	                                        @RequestParam(value = "id", required = false) String id,
	                                        @RequestParam(value = "viewName", required = false) String viewName,
	                                        HttpSession session, ModelMap model, Locale locale) throws JSONException {
		
		System.out.println("id >>>>> " + id);
		System.out.println("viewName >>>>> " + viewName);
		System.out.println("new criteriaString >>>>> " + criteriaString);
		duplicateRecordServiceImpl.updateDuplicateMatchCriteriaForView(id, viewName, criteriaString);
		
		//duplicateRecordServiceImpl.getDuplicateRecord(session, viewName);
		//return "client/duplicate-event";
		model.addAttribute("locale", locale);
		if (viewName.equals("viewJsonDataConversionOfEvent")) {
			return showDuplicateEvent(session, model, locale);
		}
		return showDuplicateClient(session, model, locale);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/duplicateDefinitionOfClient.html", method = RequestMethod.GET)
	public ModelAndView showDuplicateDefinitionOfClient(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                    Locale locale) throws JSONException {
		duplicateRecordServiceImpl.getColumnNameList(session, "viewJsonDataConversionOfClient");
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = duplicateRecordServiceImpl
		        .getDuplicateMatchingCriteriaDefinitionForView("viewJsonDataConversionOfClient");
		model.addAttribute("locale", locale);
		return new ModelAndView("client/duplicate-definition-of-client", "command", duplicateMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/duplicateDefinitionOfEvent.html", method = RequestMethod.GET)
	public ModelAndView showDuplicateDefinitionOfEvent(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                   Locale locale) throws JSONException {
		duplicateRecordServiceImpl.getColumnNameList(session, "viewJsonDataConversionOfEvent");
		DuplicateMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = duplicateRecordServiceImpl
		        .getDuplicateMatchingCriteriaDefinitionForView("viewJsonDataConversionOfEvent");
		model.addAttribute("locale", locale);
		return new ModelAndView("client/duplicate-definition-of-event", "command", duplicateMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/duplicateEvent.html", method = RequestMethod.GET)
	public String showDuplicateEvent(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		duplicateRecordServiceImpl.getDuplicateRecord(session, "viewJsonDataConversionOfEvent");
		model.addAttribute("locale", locale);
		return "client/duplicate-event";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/duplicateClient.html", method = RequestMethod.GET)
	public String showDuplicateClient(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		duplicateRecordServiceImpl.getDuplicateRecord(session, "viewJsonDataConversionOfClient");
		return "client/duplicate-client";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/child/{id}/details.html", method = RequestMethod.GET)
	public String showChildDetails(HttpServletRequest request, HttpSession session, ModelMap model,
	                               @PathVariable("id") String id, Locale locale) throws JSONException {
		clientServiceImpl.getChildWeightList(session, id);
		model.addAttribute("locale", locale);
		return "client/child-details";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/mother/{id}/details.html", method = RequestMethod.GET)
	public String showMotherDetails(HttpServletRequest request, HttpSession session, ModelMap model,
	                                @PathVariable("id") String id, Locale locale) {
		clientServiceImpl.getMotherDetails(session, id);
		model.addAttribute("locale", locale);
		return "client/mother-details";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/mother/{baseEntityId}/edit.html", method = RequestMethod.GET)
	public ModelAndView editMother(HttpServletRequest request, HttpSession session, ModelMap model,
	                               @PathVariable("baseEntityId") String baseEntityId, Locale locale) {
		List<Object> data = databaseServiceImpl.getDataFromViewByBEId("viewJsonDataConversionOfClient",
		    clientServiceImpl.getWomanEntityName(), baseEntityId);
		session.setAttribute("editData", data);
		model.addAttribute("locale", locale);
		ClientEntity clientEntity = new ClientEntity();
		model.addAttribute("clientEntity", clientEntity);
		return new ModelAndView("client/edit", "command", clientEntity);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/mother/{baseEntityId}/edit.html", method = RequestMethod.POST)
	public ModelAndView editMother(@ModelAttribute("clientEntity") @Valid ClientEntity clientEntity, BindingResult binding,
	                               ModelMap model, HttpSession session, @PathVariable("baseEntityId") String baseEntityId,
	                               Locale locale) throws JSONException {
		System.out.println("submit clientEntity: " + baseEntityId);
		clientServiceImpl.updateClientData(clientEntity, baseEntityId);
		model.addAttribute("locale", locale);
		return new ModelAndView("redirect:/client/mother.html");
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/household.html", method = RequestMethod.GET)
	public String showHouseholdList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient",
		    clientServiceImpl.getHouseholdEntityNamePrefix() + "household");
		model.addAttribute("locale", locale);
		return "/client/household";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/mother.html", method = RequestMethod.GET)
	public String showMotherList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient",
		    clientServiceImpl.getWomanEntityName());
		model.addAttribute("locale", locale);
		return "/client/mother";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/child.html", method = RequestMethod.GET)
	public String showChildList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient",
		    clientServiceImpl.getHouseholdEntityNamePrefix() + "child");
		model.addAttribute("locale", locale);
		return "/client/child";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/member.html", method = RequestMethod.GET)
	public String showMemberList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "ec_member");
		model.addAttribute("locale", locale);
		return "/client/member";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/location", method = RequestMethod.GET)
	public String getChildLocationList(HttpServletRequest request, HttpSession session, ModelMap model,
	                                   @RequestParam int id, Locale locale) {
		List<Object[]> parentData = locationServiceImpl.getChildData(id);
		System.out.println("child data size: " + parentData.size());
		session.setAttribute("data", parentData);
		model.addAttribute("locale", locale);
		return "/location";
	}
	
}
