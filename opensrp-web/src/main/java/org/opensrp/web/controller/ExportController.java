package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.opensrp.common.entity.ExportEntity;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
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
		ExportEntity exportEntity = setHouseholdAttributes(model, session, locale);
		
		return new ModelAndView("export/add", "command", exportEntity);
	}

	private String getCommaSeparatedString(List<Object> exportAttributesForHousehold) {
		List<String> slist = new ArrayList<String> (exportAttributesForHousehold.size());
		for (Object object : exportAttributesForHousehold) {
			slist.add(object != null ? object.toString() : null);
		}
		String joinedString = StringUtils.join(slist, ',');
		return joinedString;
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
		ExportEntity exportEntity = setHouseholdAttributes(model, session, locale);
		setPreselectedOptions(session, Id);
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

	private ExportEntity setHouseholdAttributes(Model model,
			HttpSession session, Locale locale) {
		List<Object> exportAttributesForHousehold = databaseServiceImpl.executeSelectQuery("SELECT a.attname "
				+ " FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid "
				+ " WHERE a.attnum > 0 "
				+ " AND NOT a.attisdropped AND t.relname = 'viewJsonDataConversionOfClient' AND s.nspname = 'core' "
				+ " ORDER BY a.attnum");
		session.setAttribute("exportAttributesForHousehold", exportAttributesForHousehold);
		
		String exportAttributesForMother = getCommaSeparatedString(exportAttributesForHousehold);
		session.setAttribute("exportAttributesForMother", exportAttributesForMother);
		
		
		ExportEntity exportEntity = new ExportEntity();
		model.addAttribute("exportEntity", exportEntity);
		model.addAttribute("locale", locale);
		return exportEntity;
	}

	private void setPreselectedOptions(HttpSession session, String Id) {
		ExportEntity preselectedValue = databaseServiceImpl.findById(Integer.parseInt(Id), "id", ExportEntity.class);
		List<String> preselectedOptions = Arrays.asList(preselectedValue.getColumn_names().split("\\s*,\\s*"));
		session.setAttribute("preselectedOptions", preselectedOptions);
	}
}
