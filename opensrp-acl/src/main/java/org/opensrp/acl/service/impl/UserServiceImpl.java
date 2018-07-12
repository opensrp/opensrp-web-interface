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
import org.opensrp.acl.entity.Role;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.openmrs.service.impl.OpenMRSUserAPIService;
import org.opensrp.acl.service.AclService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class UserServiceImpl implements AclService {
	
	private static final Logger logger = Logger.getLogger(UserServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl repository;
	
	@Autowired
	private OpenMRSUserAPIService openMRSUserAPIService;
	
	@Autowired
	private RoleServiceImpl roleServiceImpl;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	private static final String ATTRIBUTE_PASSWORD_NOT_MATCH = "passwordNotMatch";
	
	private static final String ATTRIBUTE_UNIQUE_USER = "unique";
	
	private static final String MESSAGE_PASSWORD_NOT_MATCHED = "Password Does not match";
	
	private static final String MESSAGE_DUPLICATE_USER_NAME = "User name alreday taken";
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		User user = (User) t;
		long createdUser = 0;
		Set<Role> roles = user.getRoles();
		boolean isProvider = roleServiceImpl.isProvider(roles);
		if (isProvider) {
			user = openMRSUserAPIService.add(user);
			if (!user.getUuid().isEmpty()) {
				user.setPassword(passwordEncoder.encode(user.getPassword()));
				user.setProvider(true);
				createdUser = repository.save(user);
			} else {
				logger.error("No uuid found for user:" + user.getUsername());
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
		boolean isProvider = roleServiceImpl.isProvider(user.getRoles());
		if (isProvider) {
			user.setProvider(true);
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
	public Set<Role> setRoles(int[] selectedRoles) {
		Set<Role> roles = new HashSet<Role>();
		if (selectedRoles != null) {
			for (int roleId : selectedRoles) {
				Role role = repository.findById(roleId, "id", Role.class);
				roles.add(role);
			}
		}
		return roles;
	}
	
	public boolean isPasswordMatched(User account) {
		return passwordEncoder.matches(account.getRetypePassword(), passwordEncoder.encode(account.getPassword()));
	}
	
	public boolean isUserAlreadyExist(User account) {
		return repository.findByUserName(account.getUsername(), "username", User.class);
	}
	
	public boolean checkValidationsAndSave(User account, int[] roles, HttpSession session, ModelMap model) {
		try {
			if (isPasswordMatched(account) && !isUserAlreadyExist(account)) {
				account.setEnabled(true);
				account.setRoles(setRoles(roles));
				save(account);
				return true;
			} else {
				setSelectedRolesAttributes(roles, session);
				if (!isPasswordMatched(account) && isUserAlreadyExist(account)) {
					setPasswordNotMatchedAttribute(model);
					setUniqueUserAttribute(model);
				} else if (isUserAlreadyExist(account)) {
					setUniqueUserAttribute(model);
				} else {
					setPasswordNotMatchedAttribute(model);
				}
				return false;
			}
		}
		catch (Exception e) {
			return false;
		}
	}
	
	public void setSelectedRolesAttributes(int[] roles, HttpSession session) {
		session.setAttribute("roles", repository.findAll("Role"));
		session.setAttribute("selectedRoles", roles);
	}
	
	public void setPasswordNotMatchedAttribute(ModelMap model) {
		model.addAttribute(ATTRIBUTE_PASSWORD_NOT_MATCH, MESSAGE_PASSWORD_NOT_MATCHED);
	}
	
	private void setUniqueUserAttribute(ModelMap model) {
		model.addAttribute(ATTRIBUTE_UNIQUE_USER, MESSAGE_DUPLICATE_USER_NAME);
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
		
		boolean isProvider = roleServiceImpl.isProvider(roles);
		if (isProvider) {
			String uuid = openMRSUserAPIService.update(user, user.getUuid());
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
	public List<User> getAllProviderByKeysWithALlMatches(String name) {
		Map<String, String> fielaValues = new HashMap<String, String>();
		fielaValues.put("username", name);
		boolean isProvider = true;
		return repository.findAllByKeysWithALlMatches(isProvider, fielaValues, User.class);
	}
	
	@Transactional
	public Map<Integer, String> getProviderListAsMap() {
		Map<String, String> fielaValues = new HashMap<String, String>();
		boolean isProvider = true;
		List<User> users = repository.findAllByKeysWithALlMatches(isProvider, fielaValues, User.class);
		Map<Integer, String> usersMap = new HashMap<Integer, String>();
		for (User user : users) {
			usersMap.put(user.getId(), user.getUsername());
			
		}
		return usersMap;
	}
}
