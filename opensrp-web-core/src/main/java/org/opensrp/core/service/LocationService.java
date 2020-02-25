/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.LocationTreeDTO;
import org.opensrp.common.dto.UserAssignedLocationDTO;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.util.Roles;
import org.opensrp.common.util.TreeNode;
import org.opensrp.common.dto.LocationDTO;
import org.opensrp.core.dto.LocationHierarchyDTO;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.LocationTag;
import org.opensrp.core.entity.User;
import org.opensrp.core.openmrs.service.OpenMRSServiceFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class LocationService {
	
	private static final Logger logger = Logger.getLogger(LocationService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	private OpenMRSServiceFactory openMRSServiceFactory;
	
	@Autowired
	private LocationTagService locationTagServiceImpl;
	
	public LocationService() {
		
	}
	
	@Transactional
	public List<Object[]> getLocationByTagId(int tagId) {
		String sqlQuery = "SELECT split_part(location.name, ':', 1), location.id from core.location " + " WHERE location_tag_id=:location_tag_id";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("location_tag_id", tagId);
		return repository.executeSelectQuery(sqlQuery, params);
	}
	
	@Transactional
	public List<Object[]> getChildData(int parentId) {
		String sqlQuery = "SELECT split_part(location.name, ':', 1), location.id from core.location where parent_location_id=:parentId";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parentId", parentId);
		return repository.executeSelectQuery(sqlQuery, params);
	}
	
	@Transactional
	public List<Object[]> executeSelectQuery(String sqlQuery, Map<String, Object> params) {
		return repository.executeSelectQuery(sqlQuery, params);
	}
	
	@Transactional
	public <T> long save(T t) throws Exception {
		Location location = (Location) t;
		location = (Location) openMRSServiceFactory.getOpenMRSConnector("location").add(location);
		long createdLocation = 0;
		if (!location.getUuid().isEmpty()) {
			createdLocation = repository.save(location);
		} else {
			logger.error("No uuid found for location:" + location.getName());
			// TODO
		}
		return createdLocation;
	}

	@Transactional
	public <T> long saveToOpenSRP(T t) throws Exception {
		Location location = (Location) t;
		long createdLocation = repository.save(location);
		return createdLocation;
	}
	
	@Transactional
	public <T> int update(T t) throws JSONException {
		Location location = (Location) t;
		int updatedLocation = 0;
		String uuid = openMRSServiceFactory.getOpenMRSConnector("location").update(location, location.getUuid(), null);
		if (!uuid.isEmpty()) {
			location.setUuid(uuid);
			updatedLocation = repository.update(location);
		} else {
			logger.error("No uuid found for user:" + location.getName());
			// TODO
		}
		return updatedLocation;
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
	public <T> List<T> findAllById(List<Integer> ids, String fieldName, String className) {
		return repository.findAllById(ids, fieldName, className);
	}
	
	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}

	@Transactional
	public <T> List<T> findAllLocation(String tableClass) {
		return repository.findAllLocation(tableClass);
	}

	@Transactional
	public <T> List<T> findAllLocationPartialProperty(Integer roleId) {
		return repository.findAllLocationPartialProperty(roleId);
	}

	@Transactional
	public <T> List<T> findAllLocationByAM(Integer userId, Integer roleId) {
		return repository.getLocationByAM(userId, roleId);
	}


	public Location setCreatorParentLocationTagAttributeInLocation(Location location, int parentLocationId, int tagId) {
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User creator = (User) repository.findByKey(auth.getName(), "username", User.class);
		Location parentLocation = (Location) repository.findById(parentLocationId, "id", Location.class);
		LocationTag locationTag = (LocationTag) repository.findById(tagId, "id", LocationTag.class);
		location.setCreator(creator);
		location.setParentLocation(parentLocation);
		location.setLocationTag(locationTag);
		
		return location;
	}

	@Transactional
	public <T> List<T> getVillageIdByProvider(int memberId, int childRoleId, int locationTagId) {
		return repository.getVillageIdByProvider(memberId, childRoleId, locationTagId);
	}
	
	public Map<Integer, String> getLocationTreeAsMap() {
		List<Location> locations = findAll("Location");
		Map<Integer, String> locationTreeAsMap = new HashMap<Integer, String>();
		if (locations != null) {
			for (Location location : locations) {
				locationTreeAsMap.put(location.getId(), location.getName());
				
			}
		}
		return locationTreeAsMap;
	}
	
	public boolean locationExistsForUpdate(Location location, boolean isOpenMRSCheck) throws JSONException {
		boolean exists = false;
		boolean isExistsInOpenMRS = false;
		JSONArray existinglocation = new JSONArray();
		String query = "";
		if (location != null) {
			exists = repository.entityExistsNotEqualThisId(location.getId(), location.getName(), "name", Location.class);
			
			if (isOpenMRSCheck) {
				Location findLocation = findById(location.getId(), "id", Location.class);
				if (!findLocation.getName().equalsIgnoreCase(location.getName())) {
					query = "q=" + location.getName();
					existinglocation = openMRSServiceFactory.getOpenMRSConnector("location").getByQuery(query);
					
					if (existinglocation.length() != 0) {
						isExistsInOpenMRS = true;
					}
					if (!exists) { // if false then alter 
						exists = isExistsInOpenMRS;
					}
				}
				
			}
		}
		
		return exists;
	}

	public boolean locationExists(Location location) {
		boolean exists = false;
		if (location != null) {
			int parentLocationId = location.getParentLocation().getId();
			exists = repository.isLocationExists(parentLocationId, location.getName(), location.getCode(), Location.class);
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
			session.setAttribute("selectedTag", location.getLocationTag().getId());
		} else {
			session.setAttribute("selectedTag", 0);
		}
		
		session.setAttribute("parentLocationName", parentLocationName);
		
	}
	
	public void setModelAttribute(ModelMap model, Location location) {
		model.addAttribute("name", location.getName());
		model.addAttribute("uniqueErrorMessage", "Specified Location name already exists, please specify another");
		
	}
	
	public boolean sameEditedNameAndActualName(int id, String editedName) {
		boolean sameName = false;
		Location location = repository.findById(id, "id", Location.class);
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
			}
		}
		
	}
	
	public JSONArray getLocationDataAsJson(String parentIndication, String parentKey) throws JSONException {
		JSONArray dataArray = new JSONArray();
		
		List<Location> locations = findAll("Location");
		for (Location location : locations) {
			JSONObject dataObject = new JSONObject();
            Location parentLocation = location.getParentLocation();
            if (parentLocation != null) {
                dataObject.put(parentKey, parentLocation.getId());
            } else {
                dataObject.put(parentKey, parentIndication);
            }
			dataObject.put("id", location.getId());
			dataObject.put("text", location.getName());
			dataObject.put("icon", location.getLocationTag().getName());
			dataArray.put(dataObject);
		}
		
		return dataArray;
		
	}

	public JSONArray getLocationWithDisableFacility(HttpSession session, String parentIndication, String parentKey, List<UserAssignedLocationDTO> userAssignedLocationDTOS, Integer userId, String role, Integer loggedInUserId, Integer roleId) throws JSONException {
		JSONArray dataArray = new JSONArray();

		Map<Integer, Integer> locationMap = new HashMap<>();
		if (roleId != Roles.AM.getId()) {
			for (UserAssignedLocationDTO dto : userAssignedLocationDTOS) {
				locationMap.put(dto.getLocationId(), dto.getId());
			}
		}
		List<LocationDTO> locations = new ArrayList<>();

		if (role.equalsIgnoreCase(Roles.AM.getName()) || (roleId == Roles.SS.getId() || roleId == Roles.SK.getId())) {
			locations = findAllLocationByAM(loggedInUserId, roleId);
		} else {
			locations = findAllLocationPartialProperty(roleId);
		}

		for (LocationDTO location : locations) {
			JSONObject dataObject = new JSONObject();
			if (location.getParentLocationId() != null) {
				dataObject.put(parentKey, location.getParentLocationId());
			} else {
				dataObject.put(parentKey, parentIndication);
			}
			JSONObject state = new JSONObject();

			if (locationMap.get(location.getId())!=null && !locationMap.get(location.getId()).equals(userId) ) {

				if (locationMap.containsKey(location.getId())) {
					state.put("disabled", true);
				} else if (locationMap.get(location.getId()) != null && location.getParentLocationId() != null
						&& !locationMap.get(location.getParentLocationId()).equals(userId)) {

					if (locationMap.containsKey(location.getParentLocationId())) {
						locationMap.put(location.getId(), locationMap.get(location.getParentLocationId()));
						state.put("disabled", true);
					}
					else state.put("disabled", false);
				} else {
					state.put("disabled", false);
				}
			} else {
				state.put("disabled", false);
			}

			dataObject.put("id", location.getId());
			dataObject.put("text", location.getLocationName()+"("+location.getLocationTagName()+")");
			dataObject.put("icon", location.getUsers()==null?
					location.getLocationName():location.getLocationName()+"("+location.getUsers()+")");
			dataObject.put("state", state);
			dataArray.put(dataObject);
		}

		return dataArray;

	}
	
	@Transactional
	public List<Location> getAllByKeysWithALlMatches(String name) {
		Map<String, String> fieldValues = new HashMap<String, String>();
		fieldValues.put("name", name);
		boolean isProvider = false;
		return repository.findAllByKeysWithALlMatches(isProvider, fieldValues, Location.class);
	}
	
	public String makeParentLocationName(Location location) {
		String parentLocationName = "";
		String tagNme = "";
		String locationName = "";
		if (location.getParentLocation() != null) {
			location = repository.findById(location.getParentLocation().getId(), "id", Location.class);
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
	
	@SuppressWarnings({ "resource", "unused" })
	public String uploadLocation(File csvFile) throws Exception {
		String msg = "";
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ";";
		
		int position = 0;
		String[] tags = null;
		try {
			br = new BufferedReader(new FileReader(csvFile));
			while ((line = br.readLine()) != null) {
				String tag = "";
				String code = "";
				String name = "";
				String parent = "";
				String[] locations = line.split(cvsSplitBy);
				if (position == 0) {
					tags = locations;
				} else {
					for (int i = 0; i < locations.length; i = i + 2) {
						Long start = System.currentTimeMillis();
						System.err.println("start timestamp request->>>>>>>>>>>>>>>>>>>>>>"+start);
						tag = tags[i + 1];
						code = locations[i];
						name = locations[i + 1];
						if (i != 0) {
							parent = locations[i - 1];
						}
						LocationTag locationTag = findByKey(tag, "name", LocationTag.class);
						Location parentLocation = findByKey(parent.toUpperCase().trim(), "name", Location.class);
						if (!tag.equalsIgnoreCase("country")
								&& !tag.equalsIgnoreCase("division")) {
							name += ":" + parentLocation.getId();
							locations[i+1] = name;
						}
						Location isExists = findByKey(name.toUpperCase().trim(), "name", Location.class);
						Location location = new Location();
						if(isExists == null){							
							location.setCode(code);
							location.setName(name.toUpperCase().trim());
							location.setLocationTag(locationTag);
							location.setParentLocation(parentLocation);
							location.setDescription(name);
//							location = (Location) openMRSServiceFactory.getOpenMRSConnector("location").add(location);
//							if (!location.getUuid().isEmpty()) {
							repository.save(location);
//							} else {
//								logger.info("No uuid found for location:" + location.getName());
//
//							}
							
						}else{
							logger.info("already exists location:" + location.getName());
						}

						Long end = System.currentTimeMillis();
						Long dif = end-start;
						System.err.println("End timestamp:"+end+" time difference.>>>>>>>>>>>>>>>>>>>>>>>>>>>:"+dif);
						
					}
				}
				position++;
			}
			
		}
		catch (Exception e) {
			e.printStackTrace();
			logger.info("Some problem occurred, please contact with admin..");
			msg = "Some problem occurred, at position:" + position;
		}
		return msg;
	}

	public Set<Location> getLocationByIds(int[] locations) {
		Set<Location> locationSet = new HashSet<Location>();
		if (locations != null && locations.length != 0) {
			for (int locationId : locations) {
				Location location = repository.findById(locationId, "id", Location.class);
				if (location != null) {
					locationSet.add(location);
				}
			}
		}
		return locationSet;
	}

	public JSONArray convertLocationTreeToJSON(List<LocationTreeDTO> treeDTOS, boolean enableSimPrint) throws JSONException {
		JSONArray locationTree = new JSONArray();

		Map<String, Boolean> mp = new HashMap<>();
		JSONObject object = new JSONObject();
		JSONArray locations = new JSONArray();
		JSONObject fullLocation = new JSONObject();

		int counter = 0;
		String username = "";

		for (LocationTreeDTO treeDTO: treeDTOS) {
			counter++;
			if (mp.get(treeDTO.getUsername()) == null || !mp.get(treeDTO.getUsername())) {
				if (counter > 1) {
					object.put("username", username);
					object.put("locations", locations);
					object.put("simprints_enable", enableSimPrint);
					locationTree.put(object);
					locations = new JSONArray();
					object = new JSONObject();
				}
				mp.put(treeDTO.getUsername(), true);
			}

			username = treeDTO.getUsername();

			if (treeDTO.getLoc_tag_name().equalsIgnoreCase("country")) {
				if (counter > 1) {
					fullLocation = setEmptyValues(fullLocation);
					locations.put(fullLocation);
					fullLocation = new JSONObject();
				}
			}

			JSONObject location = new JSONObject();
			location.put("code", treeDTO.getCode());
			location.put("id", treeDTO.getId());
			location.put("name", treeDTO.getName());
			fullLocation.put(treeDTO.getLoc_tag_name().toLowerCase().replaceAll(" ", "_"), location);

			if (counter == treeDTOS.size()) {
				locations.put(fullLocation);
				object.put("username", username);
				object.put("locations", locations);
				object.put("simprints_enable", enableSimPrint);
				locationTree.put(object);
				object = new JSONObject();
				locations = new JSONArray();
			}
		}
		return locationTree;
	}

	private JSONObject getLocationProperty() throws JSONException {
		JSONObject property = new JSONObject();
		property.put("name", "");
		property.put("id", 0);
		property.put("code", "00");
		return property;
	}

	private JSONObject setEmptyValues(JSONObject fullLocation) throws JSONException {
		if (!fullLocation.has("country")) {
			fullLocation.put("country", getLocationProperty());
		}
		if (!fullLocation.has("division")) {
			fullLocation.put("division", getLocationProperty());
		}
		if (!fullLocation.has("district")) {
			fullLocation.put("district", getLocationProperty());
		}
		if (!fullLocation.has("city_corporation_upazila")) {
			fullLocation.put("city_corporation_upazila", getLocationProperty());
		}
		if (!fullLocation.has("pourasabha")) {
			fullLocation.put("pourasabha", getLocationProperty());
		}
		if (!fullLocation.has("union_ward")) {
			fullLocation.put("union_ward", getLocationProperty());
		}
		if (!fullLocation.has("village")) {
			fullLocation.put("village", getLocationProperty());
		}
		return fullLocation;
	}

	public int getLocationId(HttpServletRequest request) {
		Location country = repository.findByKey("BANGLADESH", "name", Location.class);
		int locationId = country.getId();
		if (request.getParameterMap().containsKey("division")) {
			String division = (String) request.getParameter("division");
			if (division != null && division.length() > 0) {
				String[] location = division.split("\\?");
				if (!location[0].trim().equalsIgnoreCase("0") && !StringUtils.isBlank(location[0].trim()))
					locationId = Integer.parseInt(location[0].trim());
			}
		}
		if (request.getParameterMap().containsKey("district")) {
			String district = (String) request.getParameter("district");
			if (district != null) {
				String[] location = district.split("\\?");
				if (!location[0].trim().equalsIgnoreCase("0") && !StringUtils.isBlank(location[0].trim()))
					locationId = Integer.parseInt(location[0].trim());
			}
		}
		if (request.getParameterMap().containsKey("upazila")) {
			String upazila = (String) request.getParameter("upazila");
			if (upazila != null) {
				String[] location = upazila.split("\\?");
				if (!location[0].trim().equalsIgnoreCase("0") && !StringUtils.isBlank(location[0].trim()))
					locationId = Integer.parseInt(location[0].trim());
			}
		}
		if (request.getParameterMap().containsKey("pourasabha")) {
			String pourasabha = (String) request.getParameter("pourasabha");
			if (pourasabha != null) {
				String[] location = pourasabha.split("\\?");
				if (!location[0].trim().equalsIgnoreCase("0") && !StringUtils.isBlank(location[0].trim()))
					locationId = Integer.parseInt(location[0].trim());
			}
		}
		if (request.getParameterMap().containsKey("union")) {
			String union = (String) request.getParameter("union");
			if (union != null) {
				String[] location = union.split("\\?");
				if (!location[0].trim().equalsIgnoreCase("0") && !StringUtils.isBlank(location[0].trim()))
					locationId = Integer.parseInt(location[0].trim());
			}
		}
		if (request.getParameterMap().containsKey("village")) {
			String village = (String) request.getParameter("village");
			if (village != null) {
				String[] location = village.split("\\?");
				if (!location[0].trim().equalsIgnoreCase("0") && !StringUtils.isBlank(location[0].trim()))
					locationId = Integer.parseInt(location[0].trim());
			}
		}
		return locationId;
	}

	@Transactional
	public LocationHierarchyDTO getLocationHierarchy(Integer locationId) {
		Session session = sessionFactory.openSession();
		LocationHierarchyDTO dto = new LocationHierarchyDTO();
		try {
			String hql = "select * from core.single_location_tree(:locationId);";
			Query query = session.createSQLQuery(hql)
					.addScalar("villageId", StandardBasicTypes.INTEGER)
					.addScalar("unionId", StandardBasicTypes.INTEGER)
					.addScalar("pourasabhaId", StandardBasicTypes.INTEGER)
					.addScalar("upazilaId", StandardBasicTypes.INTEGER)
					.addScalar("districtId", StandardBasicTypes.INTEGER)
					.addScalar("divisionId", StandardBasicTypes.INTEGER)
					.setInteger("locationId", locationId)
					.setResultTransformer(new AliasToBeanResultTransformer(LocationHierarchyDTO.class));
			dto = (LocationHierarchyDTO) query.list().get(0);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return dto;
	}

	public List<LocationDTO> getLocations(String name, Integer length, Integer start, String orderColumn, String orderDirection) {
		return repository.getLocations(name, length, start, orderColumn, orderDirection);
	}

	public Integer getLocationCount(String name) {
		return repository.getLocationCount(name);
	}

	public JSONObject getLocationDataOfDataTable(Integer draw, Integer totalLocation,
											 List<LocationDTO> locations) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("draw", draw+1);
		response.put("recordsTotal", totalLocation);
		response.put("recordsFiltered", totalLocation);
		JSONArray array = new JSONArray();
		for (LocationDTO dto: locations) {
			JSONArray location = new JSONArray();
			location.put(dto.getName());
			location.put(dto.getDescription());
			location.put(dto.getCode());
			location.put(dto.getLocationTagName());
			array.put(location);
		}
		response.put("data", array);
		return response;
	}

}
