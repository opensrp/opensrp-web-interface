/**
 * 
 */
package org.opensrp.web.controller;

import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
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
	
	@PostAuthorize("hasPermission(returnObject, 'ANALYTICS')")
	@RequestMapping(value = "/analytics.html", method = RequestMethod.GET)
	public String analytics(HttpServletRequest request, HttpSession session, Model model,Locale locale) {

		Random rand = new Random();

		Integer[] ancRate = SearchUtil.rand30(90, 60);

		Integer[] pncRate = SearchUtil.rand30(90, 60);

		Integer[] ancReferred = SearchUtil.rand30(30, 15);

		Integer[] pncReferred = SearchUtil.rand30(30, 15);

		Integer[] serviceRate = SearchUtil.rand30(90, 70);

		Integer[] ancCCAccess = SearchUtil.rand30(300, 50);

		Integer[] pncCCAccess = SearchUtil.rand30(300, 50);

		Integer[] serviceAccess = SearchUtil.rand30(1000, 100);

		session.setAttribute("ancRate", ancRate);
		session.setAttribute("pncRate", pncRate);
		session.setAttribute("ancReferred", ancReferred);
		session.setAttribute("pncReferred", pncReferred);
		session.setAttribute("serviceRate", serviceRate);
		session.setAttribute("ancCCAccess", ancCCAccess);
		session.setAttribute("pncCCAccess", pncCCAccess);
		session.setAttribute("serviceAccess", serviceAccess);


		model.addAttribute("locale", locale);
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
