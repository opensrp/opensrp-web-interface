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
	public String uploadForm(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		return "form/upload-form";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_FORM')")
	@RequestMapping(value = "/uploadForm.html", method = RequestMethod.POST)
	public ModelAndView saveForm(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model, Locale locale)
	    throws Exception {
		String responseMessage = "";
		try {
			responseMessage = formService.saveForm(file, request);
		}
		catch (Exception e) {
			e.printStackTrace();
			responseMessage = "Some error occured";
		}
		model.addAttribute("msg", responseMessage);
		model.addAttribute("locale", locale);
		return new ModelAndView("form/upload-form");
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_DOWNLOAD_FORM')")
	@RequestMapping(value = "/downloadForm.html", method = RequestMethod.GET)
	public String downloadForm(HttpServletRequest request, HttpSession session, ModelMap model, Locale locale) {
		paginationUtil.createPagination(request, session, FormUpload.class);
		model.addAttribute("locale", locale);
		return "/form/download-form";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_DOWNLOAD_FORM')")
	@RequestMapping(value = "/{formId}/downloadForm.html", method = RequestMethod.GET)
	public void getAttachmentFromDatabase(@PathVariable("formId") int formId, HttpServletResponse response,
	                                      HttpServletRequest request) {
		response.setContentType("application/octet-stream");
		try {
			FormUpload attachment = formService.findById(formId, "id", FormUpload.class);
			String fileName = attachment.getFileName();
			
			//fetch file from database
			//byte[] fileContent = attachment.getFileContent();
			
			//fetch file from fileSystem
			byte[] fileContent = formService.getFileFromFileSystem(request, fileName);
			
			response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
			response.setContentLength(fileContent.length);
			
			FileCopyUtils.copy(fileContent, response.getOutputStream());
			response.flushBuffer();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_DOWNLOAD_FORM')")
	@RequestMapping(value = "/{formId}/viewForm.html", method = RequestMethod.GET)
	public String viewForm(@PathVariable("formId") int formId, HttpServletRequest request, HttpSession session,
	                       ModelMap model, Locale locale) {
		FormUpload attachment = formService.findById(formId, "id", FormUpload.class);
		String fileName = attachment.getFileName();
		
		//fetch file from database
		//byte[] fileContent = attachment.getFileContent();
		
		//fetch file from fileSystem
		byte[] fileContent = formService.getFileFromFileSystem(request, fileName);
		try {
			session.setAttribute("jsonForm", fileContent);
			session.setAttribute("formName", fileName);
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			// e.printStackTrace();
		}
		
		model.addAttribute("locale", locale);
		return "/form/view-form";
	}
	
}
