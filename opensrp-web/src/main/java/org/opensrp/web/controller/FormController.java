package org.opensrp.web.controller;

import java.io.IOException;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.opensrp.core.entity.FormUpload;
import org.opensrp.core.service.FormService;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value = "form")
public class FormController {
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@Autowired
	FormUpload formUpload;
	
	@Autowired
	FormService formService;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_FORM')")
	@RequestMapping(value = "/uploadForm.html", method = RequestMethod.GET)
	public String csvUpload(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		return "form/upload-form";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_FORM')")
	@RequestMapping(value = "/uploadForm.html", method = RequestMethod.POST)
	public ModelAndView csvUpload(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model, Locale locale)
	    throws Exception {
		if (file.isEmpty()) {
			model.put("msg", "failed to upload file because its empty");
			model.addAttribute("msg", "failed to upload file because its empty");
			return new ModelAndView("form/upload-form");
		} else if (!("text/csv".equalsIgnoreCase(file.getContentType())
		        || "application/json".equalsIgnoreCase(file.getContentType()) || "text/xml".equalsIgnoreCase(file
		        .getContentType()))) {
			model.addAttribute("msg", "file type should be '.csv/.xml/.json'");
			return new ModelAndView("form/upload-form");
		} else {
			System.out.println(file.getContentType());
		}
		
		byte[] bytes = file.getBytes();
		formUpload = new FormUpload();
		formUpload.setFileName(file.getOriginalFilename().toString());
		formUpload.setFileContent(bytes);
		
		try {
			formService.save(formUpload);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("msg", "Form saved successfully");
		return new ModelAndView("form/upload-form");
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_DOWNLOAD_FORM')")
	@RequestMapping(value = "/downloadForm.html", method = RequestMethod.GET)
	public String showFacilityList(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, FormUpload.class);
		model.addAttribute("locale", locale);
		return "/form/download-form";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_DOWNLOAD_FORM')")
	@RequestMapping(value = "/{formId}/downloadForm.html", method = RequestMethod.GET)
	public void getAttachmenFromDatabase(@PathVariable("formId") int formId, HttpServletResponse response) {
		System.out.println("in controller " + formId);
		response.setContentType("application/octet-stream");
		try {
			FormUpload attachment = formService.findById(formId, "id", FormUpload.class);
			response.setHeader("Content-Disposition", "inline; filename=\"" + attachment.getFileName() + "\"");
			response.setContentLength(attachment.getFileContent().length);
			
			FileCopyUtils.copy(attachment.getFileContent(), response.getOutputStream());
			response.flushBuffer();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
