package org.opensrp.web.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

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
		List<Object> exportAttributes = databaseServiceImpl.executeSelectQuery("SELECT a.attname "
				+ " FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid "
				+ " WHERE a.attnum > 0 "
				+ " AND NOT a.attisdropped AND t.relname = 'viewJsonDataConversionOfClient' AND s.nspname = 'core' "
				+ " ORDER BY a.attnum");
		session.setAttribute("exportAttributes", exportAttributes);
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
		List<ExportEntity> exportEntitylist = databaseServiceImpl.findAll("ExportEntity");
		session.setAttribute("exportList", exportEntitylist);
		model.addAttribute("locale", locale);
		return new ModelAndView("redirect:/export/exportlist.html?lang=" + locale);
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/{Id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editExportConfiguration(HttpServletRequest request, Model model
			, HttpSession session, Locale locale
			, @PathVariable("Id") String Id) throws JSONException {
		List<Object> exportAttributes = databaseServiceImpl.executeSelectQuery("SELECT a.attname "
				+ " FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid "
				+ " WHERE a.attnum > 0 "
				+ " AND NOT a.attisdropped AND t.relname = 'viewJsonDataConversionOfClient' AND s.nspname = 'core' "
				+ " ORDER BY a.attnum");
		session.setAttribute("exportAttributes", exportAttributes);
		
		ExportEntity preselectedValue = databaseServiceImpl.findById(Integer.parseInt(Id), "id", ExportEntity.class);
		List<String> preselectedOptions = Arrays.asList(preselectedValue.getColumn_names().split("\\s*,\\s*"));
		session.setAttribute("preselectedOptions", preselectedOptions);
		
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
		model.addAttribute("locale", locale);
		return new ModelAndView("redirect:/export/exportlist.html?lang=" + locale);
	}
}
