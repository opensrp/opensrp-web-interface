package org.opensrp.web.util;

import java.util.List;
import java.util.Random;

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
	
	private static final int DIVISION_TAG_ID = 28;
	
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

	public static Integer randomBetween(Integer max, Integer min) {
		Random rand = new Random();
		return rand.nextInt((max - min) + 1) + min;
	}

	public static Integer[] rand30(int mx, int mn) {
		Integer[] numbers =  {
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn),
			randomBetween(mx, mn), randomBetween(mx, mn), randomBetween(mx, mn)
		};
		return numbers;
	}
}
