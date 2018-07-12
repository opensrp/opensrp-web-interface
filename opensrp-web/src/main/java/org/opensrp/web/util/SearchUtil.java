package org.opensrp.web.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SearchUtil {
	
	private static final Logger logger = Logger.getLogger(SearchUtil.class);
	
	private static final int DIVISION_TAG_ID = 1;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private PaginationHelperUtil paginationHelperUtil;
	
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
}
