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
import org.json.JSONException;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.entity.LocationTag;
import org.opensrp.acl.entity.Team;
import org.opensrp.acl.entity.User;
import org.opensrp.acl.openmrs.service.OpenMRSServiceFactory;
import org.opensrp.acl.service.AclService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service
public class TeamServiceImpl implements AclService {
	
	private static final Logger logger = Logger.getLogger(TeamServiceImpl.class);
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	private OpenMRSServiceFactory openMRSServiceFactory;
	
	@Autowired
	private UserServiceImpl userServiceImpl;
	
	public TeamServiceImpl() {
		
	}
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		Team team = (Team) t;
		team = (Team) openMRSServiceFactory.getOpenMRSConnector("team").add(team);
		long createdTeam = 0;
		if (!team.getUuid().isEmpty()) {
			createdTeam = databaseRepositoryImpl.save(team);
		} else {
			logger.error("No uuid found for user:" + team.getName());
			// TODO
		}
		
		return createdTeam;
	}
	
	@Transactional
	@Override
	public <T> int update(T t) throws JSONException {
		Team team = (Team) t;
		int updatedTag = 0;
		String uuid = openMRSServiceFactory.getOpenMRSConnector("team").update(team, team.getUuid(), null);
		if (!uuid.isEmpty()) {
			updatedTag = databaseRepositoryImpl.update(team);
		} else {
			logger.error("No uuid found for team:" + team.getName());
			// TODO
		}
		return updatedTag;
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
	
	public Map<Integer, String> getLocationTagListAsMap() {
		List<LocationTag> locationTags = findAll("LocationTag");
		Map<Integer, String> locationsTagMap = new HashMap<Integer, String>();
		for (LocationTag locationTag : locationTags) {
			locationsTagMap.put(locationTag.getId(), locationTag.getName());
			
		}
		
		return locationsTagMap;
	}
	
	public void setModelAttribute(ModelMap model, Team team) {
		model.addAttribute("name", team.getName());
		model.addAttribute("uniqueErrorMessage", "Specified Name already exists, please specify another");
		
	}
	
	public boolean isTeamNameAndIdentifierExists(ModelMap model, Team team) {
		boolean isExists = false;
		boolean isNameExists = false;
		boolean isIdentifierExists = false;
		if (team != null) {
			isNameExists = databaseRepositoryImpl.entityExists(team.getId(), team.getName(), "name", Team.class);
		}
		if (team != null) {
			isIdentifierExists = databaseRepositoryImpl.entityExists(team.getId(), team.getIdentifier(), "identifier",
			    Team.class);
		}
		if (isNameExists) {
			model.addAttribute("uniqueNameErrorMessage", "Specified Name already exists, please specify another");
		}
		if (isIdentifierExists) {
			model.addAttribute("uniqueIdetifierErrorMessage", "Specified Identifier already exists, please specify another");
		}
		
		if (isNameExists || isIdentifierExists) {
			isExists = true;
		}
		model.addAttribute("name", team.getName());
		return isExists;
	}
	
	public void setSessionAttribute(HttpSession session, Team team, String locationName) {
		
		Map<Integer, String> supervisors = userServiceImpl.getProviderListAsMap();
		
		if (team.getLocation() != null) {
			session.setAttribute("selectedLocation", team.getLocation().getId());
		} else {
			session.setAttribute("selectedLocation", 0);
		}
		session.setAttribute("supervisors", supervisors);
		if (team.getSuperVisor() != null) {
			session.setAttribute("selectedSuperviosr", team.getSuperVisor().getId());
		} else {
			session.setAttribute("selectedSuperviosr", 0);
		}
		
		session.setAttribute("locationName", locationName);
	}
	
	public void setModelAttribute(ModelMap model, Location location) {
		model.addAttribute("name", location.getName());
		model.addAttribute("uniqueErrorMessage", "Specified Location name already exists, please specify another");
		
	}
	
	public boolean isNameAndIdentifierSame(int id, String editedName, String editedIdentifier) {
		boolean isSame = false;
		boolean sameName = false;
		boolean sameIdentifier = false;
		Team team = databaseRepositoryImpl.findById(id, "id", Team.class);
		String actualName = team.getName();
		String actualIdentifier = team.getIdentifier();
		if (actualName.equalsIgnoreCase(editedName)) {
			sameName = true;
		}
		
		if (actualIdentifier.equalsIgnoreCase(editedIdentifier)) {
			sameIdentifier = true;
		}
		
		if (sameName && sameIdentifier) {
			isSame = true;
		}
		return isSame;
	}
	
	public Team setCreatorLocationAndSupervisorAttributeInLocation(Team team, int locationId, int supervisorId) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		User creator = (User) databaseRepositoryImpl.findByKey(auth.getName(), "username", User.class);
		Location location = (Location) databaseRepositoryImpl.findById(locationId, "id", Location.class);
		User supervisor = (User) databaseRepositoryImpl.findById(supervisorId, "id", User.class);
		team.setCreator(creator);
		team.setLocation(location);
		team.setSuperVisor(supervisor);
		return team;
	}
	
	public boolean chckeUuid(Team team, ModelMap model) {
		boolean isValid = false;
		boolean isLocationValid = false;
		boolean isSupervisorValid = true;
		if (team.getLocation() != null) {
			
			if (team.getLocation().getUuid() == null) {
				model.put("locationUuidErrorMessage", "Specified Location uuid is empty, please specify another");
			} else {
				isLocationValid = true;
			}
		} else {
			model.put("locationUuidErrorMessage", "Specified Location uuid is empty, please specify another");
		}
		
		if (team.getSuperVisor() != null) {
			if (team.getSuperVisor().getUuid() == null) {
				isSupervisorValid = false;
				model.put("supervisorUuidErrorMessage", "Specified Supervisor uuid is empty, please specify another");
			}
		}
		
		if (isSupervisorValid && isLocationValid) {
			isValid = true;
		}
		
		return isValid;
	}
	
	public Map<Integer, String> getTeamListAsMap() {
		List<Team> teams = findAll("Team");
		Map<Integer, String> teamsMap = new HashMap<Integer, String>();
		for (Team team : teams) {
			teamsMap.put(team.getId(), team.getName());
			
		}
		return teamsMap;
	}
}
