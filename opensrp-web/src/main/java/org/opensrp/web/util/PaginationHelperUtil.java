package org.opensrp.web.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Location;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
/**
 * <p> The PaginationHelperUtil program implements an application
 * that simply contains the pagination related information.</p>
 * @author proshanto
 * @author nursat
 * @version 0.1.0
 * @since   2018-06-30 
 * */
@Component
public class PaginationHelperUtil {
	
	private static final Logger logger = Logger.getLogger(PaginationHelperUtil.class);
	
	@Autowired
	private LocationService locationServiceImpl;

	@Autowired
	private FacilityService facilityServiceImpl;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	public PaginationHelperUtil() {
		
	}
	/**
	 * <p>This method return parent location id from parsing location name.(example parse form 29?Rajbari)</p>
	 * @param locationName name of location.
	 * @return parentId.
	 * */
	public static int getParentId(String locationName) {
		int parentId = 0;
		try {
			if (locationName != null && !locationName.isEmpty() && !locationName.equalsIgnoreCase("0?")) {
				String[] div = locationName.split("\\?");
				parentId = Integer.parseInt(div[0]);				
			}
		}
		catch (Exception e) {
			
		}
		return parentId;
		
	}
	
	/**
	 * <p>This method return parent location name from parsing location.(example parse form 29?Rajbari)</p>
	 * @param locationName name of location.
	 * @return name.
	 * */
	public static String locationName(String locationName) {
		String name = "";
		try {
			if (locationName != null && !locationName.isEmpty() && !locationName.equalsIgnoreCase("0?")) {
				String[] div = locationName.split("\\?");
				name = div[1];
				logger.info("location name::" + name);
			}
		}
		catch (Exception e) {
			
		}
		return name;
	}
	
	/**
	 * <p>Set selected search option and corresponding child location list to session,so that selected option retain selected after refresh browser.</p>
	 * @param session is an argument to the HttpSession's session.
	 * @param sessionName is name of session (example division).
	 * @param location selected location.
	 * */
	public void setChildLocationToSession(String location, String sessionName, HttpSession session) {
		if (location != null && !location.isEmpty() && !location.equalsIgnoreCase("0?")) {
			String[] divisionName = location.split("\\?");
			List<Object[]> childLocationListByParent = null;
			if (!sessionName.equals("ccListByParent"))
				childLocationListByParent = locationServiceImpl.getChildData(Integer.parseInt(divisionName[0]));
			else childLocationListByParent = facilityServiceImpl.getCCDataByWardName(divisionName[1]);
			session.setAttribute(sessionName, childLocationListByParent);
		}
	}
	
	/**
	 * <p>Set search parameter's to searchBuilder for query and add search parameter's to session.</p>
	 * @param session is an argument to the HttpSession's session
	 * @param request is an argument to the servlet's service
	 * @return {@link #searchBuilder}
	 */
	public SearchBuilder setParams(HttpServletRequest request, HttpSession session) {
		String division = "";
		String district = "";
		String upazila = "";
		String union = "";
		String ward = "";
		String cc = "";
		String subunit = "";
		String mauzapara = "";
		String provider = "";
		String name = "";
		String year = "";
		String userName = "";
		String start_date = "";
		String end_date = "";
		String pregnancy_status = "";
		String age_from = "";
		String age_to = "";
		
		if (request.getParameterMap().containsKey("division")) {
			division = (String) request.getParameter("division");
			this.setChildLocationToSession((String) request.getParameter("division"), "districtListByParent", session);
		}

		if (request.getParameterMap().containsKey("district")) {
			district = (String) request.getParameter("district");
			this.setChildLocationToSession((String) request.getParameter("district"), "upazilasListByParent", session);
		}

		if (request.getParameterMap().containsKey("upazila")) {
			upazila = (String) request.getParameter("upazila");
			this.setChildLocationToSession((String) request.getParameter("upazila"), "unionsListByParent", session);
		}

		if (request.getParameterMap().containsKey("union")) {
			union = (String) request.getParameter("union");
			this.setChildLocationToSession((String) request.getParameter("union"), "wardsListByParent", session);
		}

		if (request.getParameterMap().containsKey("ward")) {
			ward = (String) request.getParameter("ward");
			this.setChildLocationToSession((String) request.getParameter("ward"), "subunitListByParent", session);
			this.setChildLocationToSession((String) request.getParameter("ward"), "ccListByParent", session);
		} else if (request.getAttribute("ward") != null) {
			Location location = locationServiceImpl.findByKey((String)request.getAttribute("ward"), "name", Location.class);
			ward = location.getId()+"?"+(String) request.getAttribute("ward");
		}

		if (request.getParameterMap().containsKey("cc")) {
			cc = (String) request.getParameter("cc");
		} else if (request.getAttribute("cc") != null) {
			cc = "0?"+(String) request.getAttribute("cc");
		}

		if (request.getParameterMap().containsKey("subunit")) {
			subunit = (String) request.getParameter("subunit");
			this.setChildLocationToSession(subunit, "mauzaparaListByParent", session);
		}

		if (request.getParameterMap().containsKey("mauzapara")) {
			mauzapara = (String) request.getParameter("mauzapara");
		}

		if (request.getParameterMap().containsKey("provider")) {
			provider = (String) request.getParameter("provider");
		}
		
		if (request.getParameterMap().containsKey("year")) {
			year = (String) request.getParameter("year");
		}

		if (request.getParameterMap().containsKey("name")) {
			name = (String) request.getParameter("name");
		}

		if (request.getParameterMap().containsKey("userName")) {
			userName = (String) request.getParameter("userName");
		}

		if (request.getParameterMap().containsKey("userName")) {
			userName = (String) request.getParameter("userName");
		}

		if (request.getParameterMap().containsKey("start")) {
			start_date = (String) request.getParameter("start");
			if (start_date.length() > 0) start_date += "T00:00:00.000+06:00";
		}

		if (request.getParameterMap().containsKey("end")) {
			end_date = (String) request.getParameter("end");
			if (end_date.length() > 0) end_date += "T23:59:59.999+06:00";
		}

		if (request.getParameterMap().containsKey("memberType")) {
			String memberType = (String) request.getParameter("memberType");
			if (memberType.equals("Pregnant Woman")) {
				pregnancy_status = "true";
				age_from = "";
				age_to = "";
			}
			else {
				pregnancy_status = "";
				String ageRange = (String) request.getParameter("memberType");

				if (ageRange.equals("Child (0-2 month)")) {
					age_from = "0";
					age_to = "61";
				}
				else if (ageRange.equals("Child(2 month - 5 years)")) {
					age_from = "60";
					age_to = "1866";
				}
				else if (ageRange.equals("Adult (above 50 years)")){
					age_from = "18249";
					age_to = "73000";
				}
			}
		}

		if (cc != null && cc.length() > 0 && !cc.equals("0?")) {
			division = "";
			district = "";
			upazila = "";
			union = "";
			ward = "";
		}

		searchBuilder.setDivision(locationName(division)).setDistrict(locationName(district))
		        .setUpazila(locationName(upazila)).setUnion(locationName(union)).setWard(locationName(ward))
				.setCommunityClinic(locationName(cc)).setSubunit(locationName(subunit)).setMauzapara(locationName(mauzapara))
				.setProvider(provider).setName(name).setYear(year).setUserName(userName).setStart(start_date)
				.setEnd(end_date).setAgeFrom(age_from).setAgeTo(age_to).setPregStatus(pregnancy_status);
		
		return searchBuilder;
		
	}
	
	/**
	 * <p>Creates pagination link with search parameter's</p>
	 * @param session is an argument to the HttpSession's session
	 * @param request is an argument to the servlet's service
	 * @return paginationLink
	 * */
	public static Map<String, String> getPaginationLink(HttpServletRequest request, HttpSession session) {
		Map<String, String> map = new HashMap<>();
		String division = "";
		int divId = 0;
		String divisionLink = "";
		if (request.getParameterMap().containsKey("division")) {
			division = request.getParameter("division") == null ? "0?" : request.getParameter("division");
			divId = PaginationHelperUtil.getParentId(division);
			divisionLink = "&division=" + division;
			map.put("divId", String.valueOf(divId));
		}
		String district = "";
		int distId = 0;
		String districtLink = "";
		if (request.getParameterMap().containsKey("district")) {
			district = request.getParameter("district") == null ? "0?" : request.getParameter("district");
			distId = PaginationHelperUtil.getParentId(district);
			districtLink = "&district=" + district;
			map.put("distId", String.valueOf(distId));
		}
		String upazila = "";
		int upzilaId = 0;
		String upazilaLink = "";
		if (request.getParameterMap().containsKey("upazila")) {
			upazila = request.getParameter("upazila") == null ? "0?" : request.getParameter("upazila");
			upzilaId = PaginationHelperUtil.getParentId(upazila);
			upazilaLink = "&upazila=" + upazila;
			map.put("upzilaId", String.valueOf(upzilaId));
		}
		String union = "";
		int unionId = 0;
		String unionLink = "";
		if (request.getParameterMap().containsKey("union")) {
			union = request.getParameter("union") == null ? "0?" : request.getParameter("union");
			unionId = PaginationHelperUtil.getParentId(union);
			unionLink = "&union=" + union;
			map.put("unionId", String.valueOf(unionId));
		}
		
		String ward = "";
		int wardId = 0;
		String wardLink = "";
		if (request.getParameterMap().containsKey("ward")) {
			ward = request.getParameter("ward") == null ? "0?" : request.getParameter("ward");
			wardId = PaginationHelperUtil.getParentId(ward);
			wardLink = "&ward=" + ward;
			map.put("wardId", String.valueOf(wardId));
		}
		
		String subunit = "";
		int subunitId = 0;
		String subunitLink = "";
		if (request.getParameterMap().containsKey("subunit")) {
			subunit = request.getParameter("subunit") == null ? "0?" : request.getParameter("subunit");
			subunitId = PaginationHelperUtil.getParentId(subunit);
			subunitLink = "&subunit=" + subunit;
			map.put("subunitId", String.valueOf(subunitId));
		}
		String mauzapara = "";
		int mauzaparaId = 0;
		String mauzaparaLink = "";
		if (request.getParameterMap().containsKey("mauzapara")) {
			mauzapara = request.getParameter("mauzapara") == null ? "0?" : request.getParameter("mauzapara");
			mauzaparaId = PaginationHelperUtil.getParentId(mauzapara);
			mauzaparaLink = "&mauzapara=" + mauzapara;
			map.put("mauzaparaId", String.valueOf(mauzaparaId));
		}
		
		String provider = "";
		String providerLink = "";
		if (request.getParameterMap().containsKey("provider")) {
			provider = request.getParameter("provider") == null ? "" : request.getParameter("provider");
			providerLink = "&provider=" + provider;
			map.put("provider", provider);
		}
		
		String name = "";
		String nameLink = "";
		if (request.getParameterMap().containsKey("name")) {
			name = request.getParameter("name") == null ? "0?" : request.getParameter("name");
			nameLink = "&name=" + name;
			map.put("name", name);
		}
		String userName = "";
		String userNameLink = "";
		if (request.getParameterMap().containsKey("userName")) {
			userName = request.getParameter("userName") == null ? "0?" : request.getParameter("userName");
			userNameLink = "&userName=" + userName;
			map.put("userName", userName);
		}
		String search = "";
		String searchLink = "";
		if (request.getParameterMap().containsKey("search")) {
			search = request.getParameter("search") == null ? "0?" : request.getParameter("search");
			searchLink = "&search=" + search;
		}
		String paginationLink = divisionLink + districtLink + upazilaLink + unionLink + wardLink + subunitLink
		        + mauzaparaLink + providerLink + nameLink + userNameLink + searchLink;
		map.put("paginationLink", paginationLink);
		session.setAttribute("paginationAtributes", map);
		return map;
	}
}
