/**
 * 
 */
package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.nutrition.service.ChildGrowthService;
import org.opensrp.web.util.PaginationHelperUtil;
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
@RequestMapping(value = "report")
public class ReportController {
	
	@Autowired
	private PaginationHelperUtil paginationHelperUtil;
	
	@Autowired
	private ChildGrowthService childGrowthServiceImpl;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private SearchUtil searchUtil;
	
	@PostAuthorize("hasPermission(returnObject, 'CHILD_GROWTH_REPORT')")
	@RequestMapping(value = "/child-growth.html", method = RequestMethod.GET)
	public String childGrowthReport(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		searchUtil.setDivisionAttribute(session);
		searchBuilder.clear();
		List<Object[]> data = childGrowthServiceImpl.getChildFalteredData(searchBuilder);
		session.setAttribute("data", data);
		
		return "/report/child-growth";
	}
	
	@RequestMapping(value = "/child-growth-ajax.html", method = RequestMethod.GET)
	public String childGrowthReportAjax(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		searchBuilder = paginationHelperUtil.setParams(request, session);
		List<Object[]> data = childGrowthServiceImpl.getChildFalteredData(searchBuilder);
		session.setAttribute("data", data);
		return "/report/child-growth-ajax";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'CHILD_GROWTH_SUMMARY_REPORT')")
	@RequestMapping(value = "/summary.html", method = RequestMethod.GET)
	public String summaryReport(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		searchUtil.setDivisionAttribute(session);
		searchBuilder.clear();
		List<Object[]> data = childGrowthServiceImpl.getSummaryData(searchBuilder);
		session.setAttribute("data", data);
		
		return "/report/sumamry";
	}
	
	@RequestMapping(value = "/summary-ajax.html", method = RequestMethod.GET)
	public String sumamryReportAjax(HttpServletRequest request, HttpSession session, Model model) {
		searchBuilder = paginationHelperUtil.setParams(request, session);
		List<Object[]> data = childGrowthServiceImpl.getSummaryData(searchBuilder);
		session.setAttribute("data", data);
		return "/report/sumamry-ajax";
	}
	
}
