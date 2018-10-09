package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.opensrp.common.entity.SimilarityMatchingCriteriaDefinition;
import org.opensrp.common.service.impl.SimilarRecordServiceImpl;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.common.service.impl.ClientServiceImpl;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value = "client")
public class SimilarRecordController {
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@Autowired
	private LocationServiceImpl locationServiceImpl;
	
	@Autowired
	private ClientServiceImpl clientServiceImpl;
	
	@Autowired
	private SimilarRecordServiceImpl duplicateRecordServiceImpl;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/updateDuplicateDefinition.html", method = RequestMethod.POST)
	public String updateDuplicateDefinition(@RequestParam(value = "criteriaString", required = false) String criteriaString,
	                                        @RequestParam(value = "id", required = false) String id,
	                                        @RequestParam(value = "viewName", required = false) String viewName,
	                                        HttpSession session, ModelMap model, Locale locale) throws JSONException {
		duplicateRecordServiceImpl.updateDuplicateMatchCriteriaForView(id, viewName, criteriaString);
		if (viewName.equals("viewJsonDataConversionOfEvent")) {
			return showDuplicateEvent(session, model, locale);
		}
		return showDuplicateClient(session, model, locale);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/duplicateDefinitionOfClient.html", method = RequestMethod.GET)
	public ModelAndView showDuplicateDefinitionOfClient(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                    Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		duplicateRecordServiceImpl.getColumnNameList(session, "viewJsonDataConversionOfClient");
		SimilarityMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = duplicateRecordServiceImpl
		        .getDuplicateMatchingCriteriaDefinitionForView("viewJsonDataConversionOfClient");
		
		return new ModelAndView("similar-record/duplicate-definition-of-client", "command", duplicateMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/duplicateDefinitionOfEvent.html", method = RequestMethod.GET)
	public ModelAndView showDuplicateDefinitionOfEvent(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                   Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		duplicateRecordServiceImpl.getColumnNameList(session, "viewJsonDataConversionOfEvent");
		SimilarityMatchingCriteriaDefinition duplicateMatchingCriteriaDefinition = duplicateRecordServiceImpl
		        .getDuplicateMatchingCriteriaDefinitionForView("viewJsonDataConversionOfEvent");
		
		return new ModelAndView("similar-record/duplicate-definition-of-event", "command", duplicateMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILAR_EVENT_CLIENT')")
	@RequestMapping(value = "/duplicateEvent.html", method = RequestMethod.GET)
	public String showDuplicateEvent(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		duplicateRecordServiceImpl.getDuplicateRecord(session, "viewJsonDataConversionOfEvent");
		model.addAttribute("locale", locale);
		return "similar-record/duplicate-event";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILAR_EVENT_CLIENT')")
	@RequestMapping(value = "/duplicateClient.html", method = RequestMethod.GET)
	public String showDuplicateClient(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		duplicateRecordServiceImpl.getDuplicateRecord(session, "viewJsonDataConversionOfClient");
		model.addAttribute("locale", locale);
		return "similar-record/duplicate-client";
	}

	
}
