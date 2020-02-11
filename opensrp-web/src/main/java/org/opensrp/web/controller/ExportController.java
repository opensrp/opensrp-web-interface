package org.opensrp.web.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.entity.ExportEntity;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ExportController {
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/exportlist.html", method = RequestMethod.GET)
	public String showExportList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		List<ExportEntity> exportEntity = databaseServiceImpl.findAll("ExportEntity");
		session.setAttribute("exportList", exportEntity);
		model.addAttribute("locale", locale);
		return "/export/exportList";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/add.html", method = RequestMethod.GET)
	public ModelAndView addExportConfiguration(HttpServletRequest request, Model model, HttpSession session, Locale locale) throws JSONException {
		setHouseholdAttributes(session);
		ExportEntity exportEntity = new ExportEntity();
		model.addAttribute("exportEntity", exportEntity);
		model.addAttribute("locale", locale);
		return new ModelAndView("export/add", "command", exportEntity);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/add.html", method = RequestMethod.POST)
	public ModelAndView addExportConfiguration(@ModelAttribute("exportEntity") @Valid ExportEntity exportEntity, BindingResult binding,
	                                           ModelMap model, HttpSession session, Locale locale) throws Exception {
		databaseServiceImpl.save(exportEntity);
		return new ModelAndView("redirect:/export/exportlist.html?lang=" + locale);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/{Id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editExportConfiguration(HttpServletRequest request, Model model
	                                            , HttpSession session, Locale locale
	                                            , @PathVariable("Id") String Id) throws JSONException {
		setPreselectedOptions(session, Id);
		
		setHouseholdAttributes(session);
		ExportEntity exportEntity = new ExportEntity();
		model.addAttribute("exportEntity", exportEntity);
		model.addAttribute("locale", locale);
		return new ModelAndView("export/edit", "command", exportEntity);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/{Id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editExportConfiguration(@ModelAttribute("exportEntity") @Valid ExportEntity exportEntity
	                                            , BindingResult binding
	                                            , ModelMap model, HttpSession session, Locale locale
	                                            , @PathVariable("Id") String Id) throws Exception {
		
		exportEntity.setId(Integer.parseInt(Id));
		databaseServiceImpl.update(exportEntity);
		return new ModelAndView("redirect:/export/exportlist.html?lang=" + locale);
	}


	
	private void setHouseholdAttributes(HttpSession session) throws JSONException {
		List<Object> exportAttributesForHousehold = databaseServiceImpl.executeSelectQuery("SELECT a.attname "
				+ " FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid "
				+ " WHERE a.attnum > 0 "
				+ " AND NOT a.attisdropped AND t.relname = 'viewJsonDataConversionOfClient' AND s.nspname = 'core' "
				+ " ORDER BY a.attnum");
		session.setAttribute("exportAttributesForHousehold", exportAttributesForHousehold);
		
		JSONObject exportAttributesForMother = getJsonObjectForDropDown(exportAttributesForHousehold);
		session.setAttribute("exportAttributesForMother", exportAttributesForMother);
		
		JSONObject exportAttributesForChild = getJsonObjectForDropDown(exportAttributesForHousehold);
		session.setAttribute("exportAttributesForChild", exportAttributesForChild);
	}
	
	private void setPreselectedOptions(HttpSession session, String Id) {
		ExportEntity preselectedValue = databaseServiceImpl.findById(Integer.parseInt(Id), "id", ExportEntity.class);
		List<String> preselectedOptions = null;
		if(preselectedValue.getColumn_names() != null && !preselectedValue.getColumn_names().isEmpty()) {
			preselectedOptions = Arrays.asList(preselectedValue.getColumn_names().split("\\s*,\\s*"));
		}
		session.setAttribute("preselectedOptions", preselectedOptions);
	}
	
	private JSONObject getJsonObjectForDropDown(List<Object> exportAttributesForHousehold) throws JSONException {
		JSONObject json = new JSONObject();
		for (Object object : exportAttributesForHousehold) {
			json.put(object.toString(), object.toString());
		}
		return json;
	}
}
