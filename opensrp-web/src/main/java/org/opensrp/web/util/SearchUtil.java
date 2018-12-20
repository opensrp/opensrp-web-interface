package org.opensrp.web.util;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SearchUtil {
	
	private static final Logger logger = Logger.getLogger(SearchUtil.class);
	
	private static final int DIVISION_TAG_ID = 16;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private PaginationHelperUtil paginationHelperUtil;
	
	@Autowired
	private LocationService locationServiceImpl;
	
	public SearchUtil() {
	}
	
	public SearchBuilder generateSearchBuilderParams(HttpServletRequest request, HttpSession session) {
		String search = "";
		search = (String) request.getParameter("search");
		if (search != null) {
			searchBuilder = paginationHelperUtil.setParams(request, session);
		} else {
			searchBuilder = searchBuilder.clear();
		}
		return searchBuilder;
	}
	
	public void setDivisionAttribute(HttpSession session) {
		List<Object[]> divisions = locationServiceImpl.getLocationByTagId(DIVISION_TAG_ID);
		logger.debug("set session attribute divisions: " + divisions.size());
		session.setAttribute("divisions", divisions);
	}
}
