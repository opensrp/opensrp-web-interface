/**
 * @author proshanto
 * */

package org.opensrp.acl.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.entity.LocationTag;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.openmrs.service.impl.OpenMRSLocationAPIService;
import org.opensrp.acl.service.AclService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.TreeNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class LocationServiceImpl implements AclService {
	
	private static final Logger logger = Logger.getLogger(LocationServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	private OpenMRSLocationAPIService openMRSLocationAPIService;
	
	@Autowired
	private LocationTagServiceImpl locationTagServiceImpl;
	
	public LocationServiceImpl() {
		
	}
	
	@Transactional
	public List<Object[]> getLocationByTagId(int tagId) {
		String sqlQuery = "SELECT location.name,location.id from core.location "
				+ " WHERE location_tag_id=:location_tag_id";
		return databaseRepositoryImpl.executeSelectQuery(sqlQuery, "location_tag_id", tagId);
	}
	
	@Transactional
	public List<Object[]> getChildData(int parentId) {
		String sqlQuery = "SELECT location.name,location.id from core.location where parent_location_id=:parentId";
		return databaseRepositoryImpl.executeSelectQuery(sqlQuery, "parentId", parentId);
	}
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		Location location = (Location) t;
		location = openMRSLocationAPIService.add(location);
		long createdLocation = 0;
		if (!location.getUuid().isEmpty()) {
			createdLocation = databaseRepositoryImpl.save(location);
		} else {
			logger.error("No uuid found for user:" + location.getName());
			// TODO
		}
		return createdLocation;
	}
	
	@Transactional
	@Override
	public <T> int update(T t) throws JSONException {
		Location location = (Location) t;
		int updatedLocation = 0;
		String uuid = openMRSLocationAPIService.update(location, location.getUuid());
		if (!uuid.isEmpty()) {
			location.setUuid(uuid);
			updatedLocation = databaseRepositoryImpl.update(location);
		} else {
			logger.error("No uuid found for user:" + location.getName());
			// TODO
		}
		return updatedLocation;
	}
	
	@Transactional
	@Override
	public <T> boolean delete(T t) {
		return databaseRepositoryImpl.delete(t);
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}
	
	public Location setCreatorParentLocationTagAttributeInLocation(Location location, int parentLocationId, int tagId) {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User creator = (User) databaseRepositoryImpl.findByKey(auth.getName(), "username", User.class);
		Location parentLocation = (Location) databaseRepositoryImpl.findById(parentLocationId, "id", Location.class);
		LocationTag locationTag = (LocationTag) databaseRepositoryImpl.findById(tagId, "id", LocationTag.class);
		location.setCreator(creator);
		location.setParentLocation(parentLocation);
		location.setLocationTag(locationTag);
		
		return location;
	}
	
	public Map<Integer, String> getLocationTreeAsMap() {
		List<Location> locations = findAll("Location");
		Map<Integer, String> locationTreeAsMap = new HashMap<Integer, String>();
		for (Location location : locations) {
			locationTreeAsMap.put(location.getId(), location.getName());
			
		}
		return locationTreeAsMap;
	}
	
	public boolean locationExists(Location location) {
		boolean exists = false;
		if (location != null) {
			exists = databaseRepositoryImpl.entityExists(location.getId(), location.getName(), "name", Location.class);
		}
		return exists;
	}
	
	public void setSessionAttribute(HttpSession session, Location location, String parentLocationName) {
		
		Map<Integer, String> parentLocationMap = getLocationTreeAsMap();
		Map<Integer, String> tags = locationTagServiceImpl.getLocationTagListAsMap();
		
		session.setAttribute("parentLocation", parentLocationMap);
		if (location.getParentLocation() != null) {
			session.setAttribute("selectedParentLocation", location.getParentLocation().getId());
		} else {
			session.setAttribute("selectedParentLocation", 0);
		}
		session.setAttribute("tags", tags);
		if (location.getLocationTag() != null) {
			session.setAttribute("selectedTtag", location.getLocationTag().getId());
		} else {
			session.setAttribute("selectedTtag", 0);
		}
		
		session.setAttribute("parentLocationName", parentLocationName);
		
	}
	
	public void setModelAttribute(ModelMap model, Location location) {
		model.addAttribute("name", location.getName());
		model.addAttribute("uniqueErrorMessage", "Specified Location name already exists, please specify another");
		
	}
	
	public boolean sameEditedNameAndActualName(int id, String editedName) {
		boolean sameName = false;
		Location location = databaseRepositoryImpl.findById(id, "id", Location.class);
		String actualName = location.getName();
		if (actualName.equalsIgnoreCase(editedName)) {
			sameName = true;
		}
		return sameName;
	}
	
	public static void treeTraverse(Map<String, TreeNode<String, Location>> lotree) {
		TreeNode<String, Location> treeNode = null;
		int i = 0;
		String div = "";
		for (Map.Entry<String, TreeNode<String, Location>> entry : lotree.entrySet()) {
			i++;
			treeNode = entry.getValue();
			Map<String, TreeNode<String, Location>> children = treeNode.getChildren();
			div = "</div>" + treeNode.getNode().getName() + "</div>";
			//System.err.println("Parent" + treeNode.getParent() + "child: " + i + "->" + treeNode.getNode().getName());
			System.err.println("I;" + div);
			if (children != null) {
				treeTraverse(children);
			} else {
				i = 0;
				System.err.println("-----------------------");
			}
		}
		
	}
	
	public JSONArray getLocationDataAsJson(String parentIndication, String parentKey) throws JSONException {
		JSONArray dataArray = new JSONArray();
		
		List<Location> locations = findAll("Location");
		for (Location location : locations) {
			JSONObject dataObject = new JSONObject();
			dataObject.put("id", location.getId());
			Location parentLocation = location.getParentLocation();
			if (parentLocation != null) {
				dataObject.put(parentKey, parentLocation.getId());
			} else {
				dataObject.put(parentKey, parentIndication);
			}
			dataObject.put("text", location.getName());
			dataArray.put(dataObject);
		}
		
		return dataArray;
		
	}
	
	@Transactional
	public List<Location> getAllByKeysWithALlMatches(String name) {
		Map<String, String> fielaValues = new HashMap<String, String>();
		fielaValues.put("name", name);
		boolean isProvider = false;
		return databaseRepositoryImpl.findAllByKeysWithALlMatches(isProvider, fielaValues, Location.class);
	}
	
	public String makeParentLocationName(Location location) {
		String parentLocationName = "";
		String tagNme = "";
		String locationName = "";
		if (location.getParentLocation() != null) {
			location = databaseRepositoryImpl.findById(location.getParentLocation().getId(), "id", Location.class);
			if (location.getParentLocation() != null) {
				parentLocationName = location.getParentLocation().getName() + " -> ";
			}
			
			if (location.getLocationTag() != null) {
				tagNme = "  (" + location.getLocationTag().getName() + ")";
			}
			locationName = location.getName();
		}
		return parentLocationName + locationName + tagNme;
	}
	
	public String makeLocationName(Location location) {
		String parentLocationName = "";
		String tagNme = "";
		String locationName = "";
		if (location.getParentLocation() != null) {
			if (location.getParentLocation() != null) {
				parentLocationName = location.getParentLocation().getName() + " -> ";
			}
			
			if (location.getLocationTag() != null) {
				tagNme = "  (" + location.getLocationTag().getName() + ")";
			}
			locationName = location.getName();
		}
		return parentLocationName + locationName + tagNme;
	}
	
	public JSONArray search(String name) throws JSONException {
		JSONArray locationJsonArray = new JSONArray();
		String locationName = "";
		String parentLocationName = "";
		List<Location> locations = getAllByKeysWithALlMatches(name);
		if (locations != null) {
			for (Location location : locations) {
				
				JSONObject locationJsonObject = new JSONObject();
				if (location.getParentLocation() != null) {
					parentLocationName = location.getParentLocation().getName() + " > ";
				} else {
					parentLocationName = "";
				}
				locationName = parentLocationName + location.getName();
				locationJsonObject.put("label", locationName);
				locationJsonObject.put("id", location.getId());
				locationJsonArray.put(locationJsonObject);
			}
		}
		return locationJsonArray;
	}
	
	public JSONArray list() throws JSONException {
		JSONArray locationJsonArray = new JSONArray();
		String locationName = "";
		String parentLocationName = "";
		List<Location> locations = findAll("Location");
		if (locations != null) {
			for (Location location : locations) {
				
				JSONObject locationJsonObject = new JSONObject();
				if (location.getParentLocation() != null) {
					parentLocationName = location.getParentLocation().getName() + " > ";
				} else {
					parentLocationName = "";
				}
				locationName = parentLocationName + location.getName();
				locationJsonObject.put("value", locationName);
				locationJsonObject.put("id", location.getId());
				locationJsonArray.put(locationJsonObject);
			}
		}
		return locationJsonArray;
	}
}
