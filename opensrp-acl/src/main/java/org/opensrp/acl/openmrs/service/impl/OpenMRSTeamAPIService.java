/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.openmrs.service.impl;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.Team;
import org.opensrp.acl.openmrs.service.OpenMRSConnector;
import org.opensrp.connector.openmrs.service.impl.OpenMRSAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSTeamAPIService implements OpenMRSConnector<Team> {
	
	private static final String TEAM_URL = "ws/rest/v1/team/team";
	
	public final static String nameKey = "teamName";
	
	public final static String teamIdentifierKey = "teamIdentifier";
	
	public final static String supervisorKey = "supervisor";
	
	public final static String locationKey = "location";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIServiceImpl;
	
	@Override
	public Team add(Team team) throws JSONException {
		String teamUuid = "";
		JSONObject createdTeam = openMRSAPIServiceImpl.add(PAYLOAD, makeTeamObject(team), TEAM_URL);
		if (createdTeam.has("uuid")) {
			teamUuid = (String) createdTeam.get("uuid");
			team.setUuid(teamUuid);
		} else {
			
		}
		return team;
	}
	
	@Override
	public String update(Team team, String uuid) throws JSONException {
		String teamUuid = "";
		JSONObject updatedTeam = openMRSAPIServiceImpl.update(PAYLOAD, makeTeamObject(team), uuid, TEAM_URL);
		if (updatedTeam.has("uuid")) {
			teamUuid = (String) updatedTeam.get("uuid");
		}
		return teamUuid;
	}
	
	@Override
	public String get(String uuid) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public String delete(String uuid) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
	
	public JSONObject makeTeamObject(Team team) throws JSONException {
		JSONObject teamObject = new JSONObject();
		teamObject.put(nameKey, team.getName());
		teamObject.put(teamIdentifierKey, team.getIdentifier());
		if (team.getSuperVisor() != null) {
			teamObject.put(supervisorKey, team.getSuperVisor().getPersonUUid());
		}
		if (team.getLocation() != null) {
			teamObject.put(locationKey, team.getLocation().getUuid());
		}
		return teamObject;
	}
	
}
