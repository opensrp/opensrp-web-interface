package org.opensrp.core.service.mapper;

import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.Team;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Set;

@Service
public class TeamMemberMapper {

    @Autowired
    private DatabaseRepository databaseRepository;

    @Autowired
    private LocationService locationService;

    public TeamMember map(Team team, int personId, int[] locations) {
        TeamMember teamMember = new TeamMember();

        teamMember.setPerson(databaseRepository.findById(personId, "id", User.class));
        if (locations != null)teamMember.setLocations(locationService.getLocationByIds(locations));
        teamMember.setTeam(team);

        return teamMember;
    }
}
