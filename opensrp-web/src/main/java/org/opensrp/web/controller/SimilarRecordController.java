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
@RequestMapping(value = "similarRecord")
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
	private SimilarRecordServiceImpl similarRecordServiceImpl;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/updateSimilarityDefinition.html", method = RequestMethod.POST)
	public String updateSimilarityDefinition(@RequestParam(value = "criteriaString", required = false) String criteriaString,
	                                        @RequestParam(value = "id", required = false) String id,
	                                        @RequestParam(value = "viewName", required = false) String viewName,
	                                        HttpSession session, ModelMap model, Locale locale) throws JSONException {
		similarRecordServiceImpl.updateSimilarityMatchCriteriaForView(id, viewName, criteriaString);
		if (viewName.equals("viewJsonDataConversionOfEvent")) {
			return showSimilarEvent(session, model, locale);
		}
		return showSimilarClient(session, model, locale);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/similarityDefinitionOfClient.html", method = RequestMethod.GET)
	public ModelAndView showSimilarityDefinitionOfClient(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                    Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		similarRecordServiceImpl.getColumnNameList(session, "viewJsonDataConversionOfClient");
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = similarRecordServiceImpl
		        .getSimilarityMatchingCriteriaDefinitionForView("viewJsonDataConversionOfClient");
		
		return new ModelAndView("similar-record/similarity-definition-of-client", "command", similarityMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/similarityDefinitionOfEvent.html", method = RequestMethod.GET)
	public ModelAndView showSimilarityDefinitionOfEvent(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                   Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		similarRecordServiceImpl.getColumnNameList(session, "viewJsonDataConversionOfEvent");
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = similarRecordServiceImpl
		        .getSimilarityMatchingCriteriaDefinitionForView("viewJsonDataConversionOfEvent");
		
		return new ModelAndView("similar-record/similarity-definition-of-event", "command", similarityMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILAR_EVENT_CLIENT')")
	@RequestMapping(value = "/similarEvent.html", method = RequestMethod.GET)
	public String showSimilarEvent(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		similarRecordServiceImpl.getSimilarRecord(session, "viewJsonDataConversionOfEvent");
		model.addAttribute("locale", locale);
		return "similar-record/similar-event";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILAR_EVENT_CLIENT')")
	@RequestMapping(value = "/similarClient.html", method = RequestMethod.GET)
	public String showSimilarClient(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		similarRecordServiceImpl.getSimilarRecord(session, "viewJsonDataConversionOfClient");
		model.addAttribute("locale", locale);
		return "similar-record/similar-client";
	}

	
}
