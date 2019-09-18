/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.json.JSONException;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.LocationTag;
import org.opensrp.core.entity.User;
import org.opensrp.core.openmrs.service.OpenMRSServiceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class LocationTagService {
	
	private static final Logger logger = Logger.getLogger(LocationTagService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	private OpenMRSServiceFactory openMRSServiceFactory;
	
	public LocationTagService() {
		
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		LocationTag locationTag = (LocationTag) t;
		locationTag = (LocationTag) openMRSServiceFactory.getOpenMRSConnector("tag").add(locationTag);
		long createdTag = 0;
		if (!locationTag.getUuid().isEmpty()) {
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			User creator = (User) repository.findByKey(auth.getName(), "username", User.class);
			locationTag.setCreator(creator);
			createdTag = repository.save(t);
		} else {
			logger.error("No uuid found for user:" + locationTag.getName());
			// TODO
		}
		
		return createdTag;
	}
	
	@Transactional
	public <T> int update(T t) throws Exception {
		LocationTag locationTag = (LocationTag) t;
		int updatedTag = 0;
		String uuid = openMRSServiceFactory.getOpenMRSConnector("tag").update(locationTag, locationTag.getUuid(), null);
		if (!uuid.isEmpty()) {
			updatedTag = repository.update(locationTag);
		} else {
			logger.error("No uuid found for user:" + locationTag.getName());
			// TODO
		}
		return updatedTag;
	}
	
	@Transactional
	public <T> boolean delete(T t) {
		return repository.delete(t);
	}
	
	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}
	
	public Map<Integer, String> getLocationTagListAsMap() {
		List<LocationTag> locationTags = findAll("LocationTag");
		Map<Integer, String> locationsTagMap = new HashMap<Integer, String>();
		for (LocationTag locationTag : locationTags) {
			locationsTagMap.put(locationTag.getId(), locationTag.getName());
			
		}
		
		return locationsTagMap;
	}
	
	public boolean locationTagExists(LocationTag locationTag) {
		boolean exists = false;
		if (locationTag != null) {
			exists = repository.entityExistsNotEualThisId(locationTag.getId(), locationTag.getName(), "name",
			    LocationTag.class);
		}
		return exists;
	}
	
	public void setModelAttribute(ModelMap model, LocationTag locationTag) {
		model.addAttribute("name", locationTag.getName());
		model.addAttribute("uniqueErrorMessage", "Specified LocationTag name already exists, please specify another");
		
	}
	
	public boolean sameEditedNameAndActualName(int id, String editedName) {
		boolean sameName = false;
		LocationTag location = repository.findById(id, "id", LocationTag.class);
		String actualName = location.getName();
		if (actualName.equalsIgnoreCase(editedName)) {
			sameName = true;
		}
		return sameName;
	}
}
