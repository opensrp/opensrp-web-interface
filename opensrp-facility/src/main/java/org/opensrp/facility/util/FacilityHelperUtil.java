package org.opensrp.facility.util;

import javax.servlet.http.HttpSession;

import org.opensrp.facility.entity.Facility;

public class FacilityHelperUtil {

	public static void setSessionAttribute(HttpSession session, Facility facility, String locationName) {
		if (facility.getLocation() != null) {
			session.setAttribute("selectedLocation", facility.getLocation().getId());
		} else {
			session.setAttribute("selectedLocation", 0);
		}
		session.setAttribute("locationName", locationName);
	}
	
}
