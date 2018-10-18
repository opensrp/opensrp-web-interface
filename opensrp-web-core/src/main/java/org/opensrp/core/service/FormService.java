package org.opensrp.core.service;

import java.io.File;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FormService {
	
	private static final Logger logger = Logger.getLogger(FormService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	public FormService() {
		
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Transactional
	public <T> int delete(T t) {
		return 0;
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
	
	public void saveToFileSystem(HttpServletRequest request, MultipartFile file) {
		try {
			String uploadsDir = "/uploads/";
			String realPathtoUploads = request.getServletContext().getRealPath(uploadsDir);
			if (!new File(realPathtoUploads).exists()) {
				new File(realPathtoUploads).mkdir();
			}
			System.out.println(realPathtoUploads);
			String orgName = file.getOriginalFilename();
			String filePath = realPathtoUploads + "/" + orgName;
			System.out.println(filePath);
			File dest = new File(filePath);
			file.transferTo(dest);
		}
		catch (Exception e) {
			System.out.println("Error while saving in file-system");
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
			System.out.println(fileParent);
			System.out.println(tmpPath.equals(fileParent));
			
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
