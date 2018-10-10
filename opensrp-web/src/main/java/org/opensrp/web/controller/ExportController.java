package org.opensrp.web.controller;

import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.entity.ExportEntity;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ExportController {

	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;

	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/export.html", method = RequestMethod.GET)
	public ModelAndView showHome(HttpServletRequest request, Model model, HttpSession session, Locale locale) throws JSONException {
		List<Object> exportAttributes = databaseServiceImpl.executeSelectQuery("SELECT a.attname "
				+ " FROM pg_attribute a JOIN pg_class t on a.attrelid = t.oid JOIN pg_namespace s on t.relnamespace = s.oid "
				+ " WHERE a.attnum > 0 "
				+ " AND NOT a.attisdropped AND t.relname = 'viewJsonDataConversionOfClient' AND s.nspname = 'core' "
				+ " ORDER BY a.attnum");
		System.out.println("exportAttributes size: " + exportAttributes.size());		
		session.setAttribute("exportAttributes", exportAttributes);
		model.addAttribute("locale", locale);

		ExportEntity exportEntity = new ExportEntity();
		model.addAttribute("exportEntity", exportEntity);
		return new ModelAndView("export/export", "command", exportEntity);
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/export.html", method = RequestMethod.POST)
	public ModelAndView editMother(@ModelAttribute("exportEntity") @Valid ExportEntity exportEntity, BindingResult binding,
			ModelMap model, HttpSession session) throws Exception {

		System.out.println("submit exportEntity: " + exportEntity.getColumn_names());
		databaseServiceImpl.save(exportEntity);
		session.setAttribute("exportList", exportEntity);

		return new ModelAndView("redirect:/export/exportlist.html");
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_EXPORT_LIST')")
	@RequestMapping(value = "/export/exportlist.html", method = RequestMethod.GET)
	public String showExportList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		return "/export/exportList";
	}
}
