/**
 * @author proshanto (proshanto123@gmail.com)
 */

package org.opensrp.core.openmrs.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.connector.openmrs.service.APIServiceFactory;
import org.opensrp.connector.util.HttpResponse;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.openmrs.service.OpenMRSConnector;
import org.opensrp.core.service.TeamMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OpenMRSTeamMemberAPIService implements OpenMRSConnector<Object> {
	
	private static final Logger logger = Logger.getLogger(OpenMRSTeamMemberAPIService.class);
	
	private static final String TEAM_MEMBER_URL = "ws/rest/v1/team/teammember";
	
	public final static String teamKey = "team";
	
	public final static String identifierKey = "identifier";
	
	public final static String personKey = "person";
	
	public final static String locationsKey = "locations";
	
	public final static String isDataProviderKey = "isDataProvider";
	
	private static String PAYLOAD = "";
	
	@Autowired
	private APIServiceFactory apiServiceFactory;
	
	@Override
	public TeamMember add(Object teamMemberOb) throws JSONException {
		TeamMember teamMember = (TeamMember) teamMemberOb;
		String teamMemberUuid = "";
		JSONObject createdTeamMember = apiServiceFactory.getApiService("openmrs").add(PAYLOAD,
		    makeTeamMemebrObject(teamMember), TEAM_MEMBER_URL);
		
		if (createdTeamMember.has("uuid")) {
			teamMemberUuid = (String) createdTeamMember.get("uuid");
			teamMember.setUuid(teamMemberUuid);
		} else {
			
		}
		return teamMember;
	}

	@Override
	public HttpResponse post(Object jsonObject) {
		return null;
	}

	@Override
	public String update(Object teamMemberOb, String uuid, JSONObject jsonObject) throws JSONException {
		TeamMember teamMember = (TeamMember) teamMemberOb;
		String teamMemberUuid = "";
		JSONObject updatedTeamMember = apiServiceFactory.getApiService("openmrs").update(PAYLOAD,
		    makeTeamMemebrObject(teamMember), uuid, TEAM_MEMBER_URL);
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
		//added on : December 2, 2018
		JSONObject deletedTeamMember = apiServiceFactory.getApiService("openmrs").delete(PAYLOAD, uuid, TEAM_MEMBER_URL);
		logger.info(deletedTeamMember.toString());
		String teamMemberUuid = "";
		if (deletedTeamMember.has("uuid")) {
			teamMemberUuid = (String) deletedTeamMember.get("uuid");
		}
		return teamMemberUuid;
	}
	
	public JSONObject makeTeamMemebrObject(TeamMember teamMember) throws JSONException {
		
		List<String> locationList = new ArrayList<String>();
		Set<Location> locations = teamMember.getLocations();
		locationList.add("b5fab836-05dc-487c-9366-d89bed77190d");
//		if (locations.size() != 0) {
//			for (Location location : locations) {
//				locationList.add(location.getUuid());
//			}
//
//		}
		
		JSONObject teamMemberObject = new JSONObject();
		teamMemberObject.put(personKey, teamMember.getPerson().getPersonUUid());
		teamMemberObject.put(identifierKey, teamMember.getIdentifier());
		teamMemberObject.put(teamKey, teamMember.getTeam().getUuid());
		teamMemberObject.put(isDataProviderKey, "true");
		teamMemberObject.put(locationsKey, locationList);
		
		return teamMemberObject;
	}
	
	@Override
	public JSONArray getByQuery(String query) throws JSONException {
		// TODO Auto-generated method stub
		return null;
	}
}
