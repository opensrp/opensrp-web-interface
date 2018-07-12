package org.opensrp.web.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.opensrp.acl.service.impl.LocationServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PaginationHelperUtil {
	
	private static final Logger logger = Logger.getLogger(PaginationHelperUtil.class);
	
	@Autowired
	private LocationServiceImpl locationServiceImpl;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	public PaginationHelperUtil() {
		
	}
	
	public static int getParentId(String locationName) {
		int parentId = 0;
		try {
			if (locationName != null && !locationName.isEmpty() && !locationName.equalsIgnoreCase("0?")) {
				String[] div = locationName.split("\\?");
				parentId = Integer.parseInt(div[0]);
				logger.info("parentId::" + parentId);
			}
		}
		catch (Exception e) {
			
		}
		return parentId;
		
	}
	
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
	
	public void setParentLocationToSession(String location, String sessionName, HttpSession session) {
		if (location != null && !location.isEmpty() && !location.equalsIgnoreCase("0?")) {
			String[] divisionName = location.split("\\?");
			List<Object[]> parentLOcationListByParent = locationServiceImpl.getChildData(Integer.parseInt(divisionName[0]));
			session.setAttribute(sessionName, parentLOcationListByParent);
		}
	}
	
	/**
	 * Set Params to session & return search option
	 */
	public SearchBuilder setParams(HttpServletRequest request, HttpSession session) {
		String division = "";
		String district = "";
		String upazila = "";
		String union = "";
		String ward = "";
		String subunit = "";
		String mauzapara = "";
		String provider = "";
		String name = "";
		String year = "";
		String userName = "";
		
		if (request.getParameterMap().containsKey("division")) {
			division = (String) request.getParameter("division");
			this.setParentLocationToSession(division, "districtListByParent", session);
		}
		if (request.getParameterMap().containsKey("district")) {
			district = (String) request.getParameter("district");
			this.setParentLocationToSession(district, "upazilasListByParent", session);
		}
		if (request.getParameterMap().containsKey("upazila")) {
			upazila = (String) request.getParameter("upazila");
			this.setParentLocationToSession(upazila, "unionsListByParent", session);
		}
		if (request.getParameterMap().containsKey("union")) {
			union = (String) request.getParameter("union");
			this.setParentLocationToSession(union, "wardsListByParent", session);
		}
		if (request.getParameterMap().containsKey("ward")) {
			ward = (String) request.getParameter("ward");
			this.setParentLocationToSession(ward, "subunitListByParent", session);
		}
		if (request.getParameterMap().containsKey("subunit")) {
			subunit = (String) request.getParameter("subunit");
			this.setParentLocationToSession(subunit, "mauzaparaListByParent", session);
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
		searchBuilder.setDivision(locationName(division)).setDistrict(locationName(district))
		        .setUpazila(locationName(upazila)).setUnion(locationName(union)).setWard(locationName(ward))
		        .setSubunit(locationName(subunit)).setMauzapara(locationName(mauzapara)).setProvider(provider).setName(name)
		        .setYear(year).setUserName(userName);
		logger.debug("set searchBuilder: " + searchBuilder.toString());
		return searchBuilder;
		
	}
	
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
		String search = "";
		String searchLink = "";
		if (request.getParameterMap().containsKey("search")) {
			search = request.getParameter("search") == null ? "0?" : request.getParameter("search");
			searchLink = "&search=" + search;
		}
		String paginationLink = divisionLink + districtLink + upazilaLink + unionLink + wardLink + subunitLink
		        + mauzaparaLink + providerLink + nameLink + searchLink;
		map.put("paginationLink", paginationLink);
		session.setAttribute("paginationAtributes", map);
		return map;
	}
}
