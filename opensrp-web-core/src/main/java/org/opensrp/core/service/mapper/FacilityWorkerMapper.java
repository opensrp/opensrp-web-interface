package org.opensrp.core.service.mapper;

import org.opensrp.core.dto.FacilityWorkerDTO;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.entity.FacilityWorkerType;
import org.opensrp.core.entity.User;
import org.springframework.stereotype.Service;

@Service
public class FacilityWorkerMapper {

    public FacilityWorker map(User user, Facility facility, FacilityWorkerType facilityWorkerType) {
        FacilityWorker facilityWorker = new FacilityWorker();

        facilityWorker.setUsername(user.getUsername());
        facilityWorker.setName(user.getFullName());
        facilityWorker.setIdentifier(user.getMobile());

        facilityWorker.setFacility(facility);
        facilityWorker.setFacilityWorkerType(facilityWorkerType);
        facilityWorker.setOrganization("Community Clinic");

        return facilityWorker;
    }
}
