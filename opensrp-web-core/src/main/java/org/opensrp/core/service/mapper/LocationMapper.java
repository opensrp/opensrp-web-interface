package org.opensrp.core.service.mapper;

import org.opensrp.common.dto.LocationDTO;
import org.opensrp.core.dto.LocationHierarchyDTO;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.LocationTag;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.LocationTagService;
import org.opensrp.core.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;

@Service
public class LocationMapper {

    @Autowired private LocationService locationService;
    @Autowired private LocationTagService locationTagService;
    @Autowired private UserService userService;

    public Location map(LocationDTO dto) {
        Location location = new Location();

        if (dto.getId() != null) location.setId(dto.getId());
        location.setName(dto.getName().toUpperCase());
        location.setCode(dto.getCode());

        location.setDescription(dto.getDescription());
        location.setParentLocation(locationService.findById(dto.getParentLocationId(), "id", Location.class));
        location.setLocationTag(locationTagService.findById(dto.getLocationTagId(), "id", LocationTag.class));

        location.setCreated(dto.getCreated());
        location.setUpdated(dto.getUpdated());
        location.setCreator(userService.getLoggedInUser()); // logged in user is the creator of this location

        location.setLoginLocation(dto.isLoginLocation());
        location.setVisitLocation(dto.isVisitLocation());

        return location;
    }

    public LocationDTO map(Location location) {
        LocationDTO dto = new LocationDTO();

        dto.setId(location.getId());
        dto.setName(location.getName());
        dto.setCode(location.getCode());

        dto.setDescription(location.getDescription());
        dto.setParentLocationId(location.getParentLocation().getId());
        dto.setLocationTagId(location.getLocationTag().getId());

        dto.setCreated(location.getCreated());
        dto.setUpdated(location.getUpdated());

        dto.setLoginLocation(location.isLoginLocation());
        dto.setVisitLocation(location.isVisitLocation());

        LocationHierarchyDTO hierarchyDTO = locationService.getLocationHierarchy(location.getId());

        dto.setUnionId(hierarchyDTO.getUnionId());
        dto.setPourasabhaId(hierarchyDTO.getPourasabhaId());
        dto.setUpazilaId(hierarchyDTO.getUpazilaId());
        dto.setDistrictId(hierarchyDTO.getDistrictId());
        dto.setDivisionId(hierarchyDTO.getDivisionId());

        return dto;
    }
}
