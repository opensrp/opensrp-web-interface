/**
 * @author proshanto
 * */

package org.opensrp.acl.service.impl;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.Role;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.openmrs.service.OpenMRSServiceFactory;
import org.opensrp.acl.service.AclService;
import org.opensrp.common.dto.UserDTO;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements AclService {
	
	private static final Logger logger = Logger.getLogger(UserServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl repository;
	
	@Autowired
	private OpenMRSServiceFactory openMRSServiceFactory;
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		User user = (User) t;
		long createdUser = 0;
		Set<Role> roles = user.getRoles();
		boolean isProvider = roleServiceImpl.isOpenMRSRole(roles);
		JSONArray existingOpenMRSUser = new JSONArray();
		String query = "";
		String existingUserUUid = "";
		String existingUserPersonUUid = "";
		query = "v=full&username=" + user.getUsername();
		if (isProvider) {
			existingOpenMRSUser = openMRSServiceFactory.getOpenMRSConnector("user").getByQuery(query);
			if (existingOpenMRSUser.length() == 0) {
				user = (User) openMRSServiceFactory.getOpenMRSConnector("user").add(user);
				if (!user.getUuid().isEmpty()) {
					user.setPassword(passwordEncoder.encode(user.getPassword()));
					user.setProvider(true);
					createdUser = repository.save(user);
				} else {
					logger.error("No uuid found for user:" + user.getUsername());
				}
			} else {
				JSONObject userOb = new JSONObject();
				userOb = (JSONObject) existingOpenMRSUser.get(0);
				existingUserUUid = (String) userOb.get("uuid");
				JSONObject person = new JSONObject();
				person = (JSONObject) userOb.get("person");
				existingUserPersonUUid = (String) person.get("uuid");
				user.setProvider(true);
				user.setUuid(existingUserUUid);
				user.setPersonUUid(existingUserPersonUUid);
				openMRSServiceFactory.getOpenMRSConnector("user").update(user, existingUserUUid, userOb);
				user.setPassword(passwordEncoder.encode(user.getPassword()));
				createdUser = repository.save(user);
			}
			
		} else {
			user.setProvider(false);
			user.setPassword(passwordEncoder.encode(user.getPassword()));
			createdUser = repository.save(user);
		}
		
		return createdUser;
	}
	
	@Transactional
	@Override
	public <T> int update(T t) throws Exception {
		User user = (User) t;
		boolean isProvider = roleServiceImpl.isOpenMRSRole(user.getRoles());
		if (isProvider) {
			user.setProvider(true);
			save(user);
		} else {
			user.setProvider(false);
		}
		return repository.update(user);
	}
	
	@Transactional
	@Override
	public <T> boolean delete(T t) {
		return repository.delete(t);
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
		
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}
	
	@Transactional
	public Set<Role> setRoles(String[] selectedRoles) {
		Set<Role> roles = new HashSet<Role>();
		if (selectedRoles != null) {
			for (String roleId : selectedRoles) {
				Role role = repository.findById(Integer.parseInt(roleId), "id", Role.class);
				roles.add(role);
			}
		}
		return roles;
	}
	
	public boolean isPasswordMatched(User account) {
		return passwordEncoder.matches(account.getRetypePassword(), passwordEncoder.encode(account.getPassword()));
	}
	
	public boolean isUserExist(String userName) {
		return repository.findByUserName(userName, "username", User.class);
	}
	
	public User convert(UserDTO userDTO) {
		User user = new User();
		String[] roles = userDTO.getRoles().split(",");
		user.setUsername(userDTO.getUsername());
		user.setEmail(userDTO.getEmail());
		user.setEnabled(true);
		user.setFirstName(userDTO.getFirstName());
		user.setGender("");
		user.setIdetifier(userDTO.getIdetifier());
		user.setLastName(userDTO.getLastName());
		user.setMobile(userDTO.getMobile());
		user.setPassword(userDTO.getPassword());
		user.setRoles(setRoles(roles));
		User parentUser = findById(userDTO.getParentUser(), "id", User.class);
		user.setParentUser(parentUser);
		
		return user;
		
	}
	
	public int[] getSelectedRoles(User account) {
		int[] selectedRoles = new int[200];
		Set<Role> getRoles = account.getRoles();
		int i = 0;
		for (Role role : getRoles) {
			selectedRoles[i] = role.getId();
			i++;
		}
		return selectedRoles;
	}
	
	@Transactional
	public <T> int updatePassword(T t) throws Exception {
		int updatedUser = 0;
		User user = (User) t;
		Set<Role> roles = user.getRoles();
		
		boolean isProvider = roleServiceImpl.isOpenMRSRole(roles);
		if (isProvider) {
			String uuid = openMRSServiceFactory.getOpenMRSConnector("user").update(user, user.getUuid(), null);
			user.setPassword(passwordEncoder.encode(user.getPassword()));
			user.setProvider(true);
			updatedUser = repository.update(user);
		} else {
			user.setPassword(passwordEncoder.encode(user.getPassword()));
			updatedUser = repository.update(user);
			user.setProvider(false);
		}
		return updatedUser;
	}
	
	public Map<Integer, String> getUserListAsMap() {
		List<User> users = findAll("User");
		Map<Integer, String> usersMap = new HashMap<Integer, String>();
		for (User user : users) {
			usersMap.put(user.getId(), user.getUsername());
			
		}
		return usersMap;
	}
	
	@Transactional
	public List<User> findAllByKeysWithALlMatches(String name, boolean isProvider) {
		Map<String, String> fielaValues = new HashMap<String, String>();
		fielaValues.put("username", name);
		return repository.findAllByKeysWithALlMatches(isProvider, fielaValues, User.class);
	}
	
	@Transactional
	public Map<Integer, String> getProviderListAsMap() {
		Map<String, String> fielaValues = new HashMap<String, String>();
		boolean isProvider = true;
		List<User> users = repository.findAllByKeysWithALlMatches(isProvider, fielaValues, User.class);
		Map<Integer, String> usersMap = new HashMap<Integer, String>();
		if (users != null) {
			for (User user : users) {
				usersMap.put(user.getId(), user.getUsername());
				
			}
		}
		return usersMap;
	}
	
	/**
	 * <p>This method set roles attribute to session, all roles and selected roles.</p>
	 * @param roles list of selected roles.
	 * @param session is an argument to the HttpSession's session .
	 * */
	@Transactional
	public void setRolesAttributes(int[] roles, HttpSession session) {
		session.setAttribute("roles", repository.findAll("Role"));
		session.setAttribute("selectedRoles", roles);
	}
	
	public JSONArray getUserDataAsJson(String parentIndication, String parentKey) throws JSONException {
		JSONArray dataArray = new JSONArray();
		
		List<User> users = findAll("User");
		for (User user : users) {
			JSONObject dataObject = new JSONObject();
			dataObject.put("id", user.getId());
			User parentUser = user.getParentUser();
			if (parentUser != null) {
				dataObject.put(parentKey, parentUser.getId());
			} else {
				dataObject.put(parentKey, parentIndication);
			}
			dataObject.put("text", user.getFullName());
			dataArray.put(dataObject);
		}
		
		return dataArray;
		
	}
}
