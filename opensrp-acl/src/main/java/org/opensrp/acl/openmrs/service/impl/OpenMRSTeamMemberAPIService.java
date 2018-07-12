/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.acl.openmrs.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.acl.entity.Location;
import org.opensrp.acl.entity.TeamMember;
import org.opensrp.acl.openmrs.service.OpenMRSConnector;
import org.opensrp.connector.openmrs.service.impl.OpenMRSAPIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSTeamMemberAPIService implements OpenMRSConnector<TeamMember> {
	
	private static final String TEAM_MEMBER_URL = "ws/rest/v1/team/teammember";
	
	public final static String teamKey = "team";
	
	public final static String identifierKey = "identifier";
	
	public final static String personKey = "person";
	
	public final static String locationsKey = "locations";
	
	public final static String isDataProviderKey = "isDataProvider";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private OpenMRSAPIServiceImpl openMRSAPIServiceImpl;
	
	@Override
	public TeamMember add(TeamMember teamMember) throws JSONException {
		String teamMemberUuid = "";
		JSONObject createdTeamMember = openMRSAPIServiceImpl.add(PAYLOAD, makeTeamMemebrObject(teamMember), TEAM_MEMBER_URL);
		System.err.println(createdTeamMember);
		if (createdTeamMember.has("uuid")) {
			teamMemberUuid = (String) createdTeamMember.get("uuid");
			teamMember.setUuid(teamMemberUuid);
		} else {
			
		}
		return teamMember;
	}
	
	@Override
	public String update(TeamMember teamMember, String uuid) throws JSONException {
		String teamMemberUuid = "";
		JSONObject updatedTeamMember = openMRSAPIServiceImpl.update(PAYLOAD, makeTeamMemebrObject(teamMember), uuid,
		    TEAM_MEMBER_URL);
		if (updatedTeamMember.has("uuid")) {
			teamMemberUuid = (String) updatedTeamMember.get("uuid");
		}
		return teamMemberUuid;
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
	
	public JSONObject makeTeamMemebrObject(TeamMember teamMember) throws JSONException {
		
		List<String> locationList = new ArrayList<String>();
		Set<Location> locations = teamMember.getLocations();
		
		if (locations.size() != 0) {
			for (Location location : locations) {
				locationList.add(location.getUuid());
			}
			
		}
		
		JSONObject teamMemberObject = new JSONObject();
		teamMemberObject.put(personKey, teamMember.getPerson().getPersonUUid());
		teamMemberObject.put(identifierKey, teamMember.getIdentifier());
		teamMemberObject.put(teamKey, teamMember.getTeam().getUuid());
		teamMemberObject.put(isDataProviderKey, "true");
		teamMemberObject.put(locationsKey, locationList);
		
		return teamMemberObject;
	}
}
