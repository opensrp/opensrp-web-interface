package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.opensrp.common.entity.ClientEntity;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.SimilarityMatchingCriteriaDefinition;
import org.opensrp.core.service.ClientService;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.SimilarRecordService;
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
	private ClientService clientService;
	
	@Autowired
	private LocationService locationService;
	
	@Autowired
	private SimilarRecordService similarRecordService;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_CHILD')")
	@RequestMapping(value = "/child/{id}/details.html", method = RequestMethod.GET)
	public String showChildDetails(HttpServletRequest request, HttpSession session, ModelMap model,
	                               @PathVariable("id") String id, Locale locale) throws JSONException {
		clientService.getChildWeightList(session, id);
		model.addAttribute("locale", locale);
		return "client/child-details";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_CHILD')")
	@RequestMapping(value = "/child.html", method = RequestMethod.GET)
	public String showChildList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient",
		    clientService.getHouseholdEntityNamePrefix() + "child");
		model.addAttribute("locale", locale);
		return "/client/child";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_MEMBER')")
	@RequestMapping(value = "/member/{id}/details.html", method = RequestMethod.GET)
	public String showMemberDetails(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                                @PathVariable("id") String id) throws JSONException {
		session.setAttribute("memberId", id);
		model.addAttribute("locale", locale);
		return "client/member-details";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_MEMBER')")
	@RequestMapping(value = "/member.html", method = RequestMethod.GET)
	public String showMemberList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "ec_member");
		model.addAttribute("locale", locale);
		return "/client/member";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_MOTHER')")
	@RequestMapping(value = "/mother/{id}/details.html", method = RequestMethod.GET)
	public String showMotherDetails(HttpServletRequest request, HttpSession session, ModelMap model,
	                                @PathVariable("id") String id, Locale locale) {
		clientService.getMotherDetails(session, id);
		model.addAttribute("locale", locale);
		return "client/mother-details";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_MOTHER')")
	@RequestMapping(value = "/mother.html", method = RequestMethod.GET)
	public String showMotherList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient",
		    clientService.getWomanEntityName());
		model.addAttribute("locale", locale);
		return "/client/mother";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_MOTHER')")
	@RequestMapping(value = "/mother/{baseEntityId}/edit.html", method = RequestMethod.GET)
	public ModelAndView editMother(HttpServletRequest request, HttpSession session, ModelMap model,
	                               @PathVariable("baseEntityId") String baseEntityId, Locale locale) {
		List<Object> data = databaseServiceImpl.getDataFromViewByBEId("viewJsonDataConversionOfClient",
		    clientService.getWomanEntityName(), baseEntityId);
		session.setAttribute("editData", data);
		model.addAttribute("locale", locale);
		ClientEntity clientEntity = new ClientEntity();
		model.addAttribute("clientEntity", clientEntity);
		return new ModelAndView("client/edit", "command", clientEntity);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_MOTHER')")
	@RequestMapping(value = "/mother/{baseEntityId}/edit.html", method = RequestMethod.POST)
	public ModelAndView editMother(@ModelAttribute("clientEntity") @Valid ClientEntity clientEntity, BindingResult binding,
	                               ModelMap model, HttpSession session, @PathVariable("baseEntityId") String baseEntityId,
	                               Locale locale) throws JSONException {
		clientService.updateClientData(clientEntity, baseEntityId);
		model.addAttribute("locale", locale);
		return new ModelAndView("redirect:/client/mother.html?lang=" + locale);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_HOUSEHOLD')")
	@RequestMapping(value = "/household.html", method = RequestMethod.GET)
	public String showHouseholdList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient",
		    clientService.getHouseholdEntityNamePrefix() + "household");
		model.addAttribute("locale", locale);
		return "/client/household";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_LOCATION')")
	@RequestMapping(value = "/location", method = RequestMethod.GET)
	public String getChildLocationList(HttpServletRequest request, HttpSession session, ModelMap model,
	                                   @RequestParam int id, Locale locale) {
		List<Object[]> parentData = locationService.getChildData(id);
		session.setAttribute("data", parentData);
		model.addAttribute("locale", locale);
		return "/location";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/updateSimilarityDefinition.html", method = RequestMethod.POST)
	public String updateSimilarityDefinition(@RequestParam(value = "criteriaString", required = false) String criteriaString,
	                                         @RequestParam(value = "id", required = false) String id,
	                                         @RequestParam(value = "viewName", required = false) String viewName,
	                                         HttpSession session, ModelMap model, Locale locale) throws JSONException {
		similarRecordService.updateSimilarityMatchCriteriaForView(id, viewName, criteriaString);
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
		similarRecordService.getColumnNameList(session, "viewJsonDataConversionOfClient");
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = similarRecordService
		        .getSimilarityMatchingCriteriaDefinitionForView("viewJsonDataConversionOfClient");
		
		return new ModelAndView("client/similarity-definition-of-client", "command", similarityMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILARITY_DEFINITION')")
	@RequestMapping(value = "/similarityDefinitionOfEvent.html", method = RequestMethod.GET)
	public ModelAndView showSimilarityDefinitionOfEvent(HttpServletRequest request, HttpSession session, ModelMap model,
	                                                    Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		similarRecordService.getColumnNameList(session, "viewJsonDataConversionOfEvent");
		SimilarityMatchingCriteriaDefinition similarityMatchingCriteriaDefinition = similarRecordService
		        .getSimilarityMatchingCriteriaDefinitionForView("viewJsonDataConversionOfEvent");
		
		return new ModelAndView("client/similarity-definition-of-event", "command", similarityMatchingCriteriaDefinition);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILAR_EVENT_CLIENT')")
	@RequestMapping(value = "/similarEvent.html", method = RequestMethod.GET)
	public String showSimilarEvent(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		similarRecordService.getSimilarRecord(session, "viewJsonDataConversionOfEvent");
		model.addAttribute("locale", locale);
		return "client/similar-event";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_SIMILAR_EVENT_CLIENT')")
	@RequestMapping(value = "/similarClient.html", method = RequestMethod.GET)
	public String showSimilarClient(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		similarRecordService.getSimilarRecord(session, "viewJsonDataConversionOfClient");
		model.addAttribute("locale", locale);
		return "client/similar-client";
	}
	
}
