package org.opensrp.core.service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.FormUpload;
import org.opensrp.core.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Service
public class FormService {
	
	private static final Logger logger = Logger.getLogger(FormService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	FormUpload formUpload;
	
	public FormService() {
		
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Transactional
	public <T> int delete(T t) {
		int i = 0;
		if (repository.delete(t)) {
			i = 1;
		} else {
			i = -1;
		}
		return i;
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return (List<T>) repository.findAll(tableClass);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> long update(T t) throws Exception {
		return repository.update(t);
	}
	
	public String saveForm(MultipartFile file, HttpServletRequest request) throws Exception {
		String responseMessage = "";
		if (file.isEmpty()) {
			responseMessage = "Failed to upload the file because it is empty";
		} else if (!("text/csv".equalsIgnoreCase(file.getContentType())
		        || "application/json".equalsIgnoreCase(file.getContentType()) || "text/xml".equalsIgnoreCase(file
		        .getContentType()))) {
			responseMessage = "File type should be '.csv/.xml/.json'";
		} else {
			byte[] bytes = file.getBytes();
			formUpload = new FormUpload();
			formUpload.setFileName(file.getOriginalFilename().toString());
			formUpload.setFileContent(bytes);
			//get logged-in-user 
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			User creator = (User) auth.getPrincipal();
			formUpload.setCreator(creator);
			save(formUpload);
			//for saving in file system
			saveToFileSystem(request, file);
			//end 
			responseMessage = "Form saved successfully";
		}
		return responseMessage;
	}
	
	public void saveToFileSystem(HttpServletRequest request, MultipartFile file) {
		try {
			String uploadsDir = "/uploads/";
			String realPathtoUploads = request.getServletContext().getRealPath(uploadsDir);
			if (!new File(realPathtoUploads).exists()) {
				new File(realPathtoUploads).mkdir();
			}
			String orgName = file.getOriginalFilename();
			String filePath = realPathtoUploads + "/" + orgName;
			File dest = new File(filePath);
			file.transferTo(dest);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public byte[] getFileFromFileSystem(HttpServletRequest request, String fileName) {
		byte[] data = null;
		try {
			String uploadsDir = "/uploads/";
			String realPathtoUploads = request.getServletContext().getRealPath(uploadsDir);
			Path tmpPath = Paths.get(realPathtoUploads); //valid directory
			Path filePath = tmpPath.resolve(fileName); //add fileName to path
			Path fileParent = filePath.getParent(); //get parent directory
			
			if (tmpPath.equals(fileParent)) {
				data = Files.readAllBytes(filePath);
			}
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return data;
	}
	
}
