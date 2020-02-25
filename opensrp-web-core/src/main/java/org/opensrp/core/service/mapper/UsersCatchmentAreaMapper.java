package org.opensrp.core.service.mapper;

import org.opensrp.core.dto.UsersCatchmentAreaDTO;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.UsersCatchmentArea;
import org.opensrp.core.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UsersCatchmentAreaMapper {

    @Autowired
    private LocationService locationService;
    /**
     * Make UsersCatchmentArea Entity from location and userId
     * @param location
     * @param userId
     * @return
     */
    public UsersCatchmentArea map(Location location, int userId) {
        UsersCatchmentArea entity = new UsersCatchmentArea();

        entity.setParentLocationId(location.getParentLocation().getId());
        entity.setLocationId(location.getId());
        entity.setUserId(userId);

        return entity;
    }

    /**
     * Making list of UsersCatchmentArea from location ids and userId
     * @param locations
     * @param userId
     * @return
     */
    public List<UsersCatchmentArea> map(int[] locations, int userId) {
        List<UsersCatchmentArea> list = new ArrayList<>();
        for (int i = 0; i < locations.length; i++) {
            list.add(this.map((Location) locationService.findById(locations[i], "id", Location.class), userId));
        }
        return list;
    }
}
