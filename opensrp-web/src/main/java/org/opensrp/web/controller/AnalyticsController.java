/**
 * 
 */
package org.opensrp.web.controller;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "analytics")
public class AnalyticsController {
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	@RequestMapping(value = "/analytics.html", method = RequestMethod.GET)
	public String analytics(HttpServletRequest request, HttpSession session, Model model) {
		return "/analytics/analytics";
	}
	
	@RequestMapping(value = "/analytics-ajax.html", method = RequestMethod.GET)
	public String analyticsAjax(HttpServletRequest request, HttpSession session, Model model) {
		searchBuilder.clear();
		List<Object[]> viewRefresh = databaseServiceImpl.refreshView(searchBuilder);
		int refreshCount = 0;
		Iterator obArrIterator = viewRefresh.iterator();
		if (obArrIterator.hasNext()) {
			refreshCount = refreshCount + (Integer) obArrIterator.next();
		}
		session.setAttribute("refreshCount", refreshCount);
		return "/analytics/analytics-ajax";
	}
	
}
