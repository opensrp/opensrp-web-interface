/**
 * 
 */
package org.opensrp.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.nutrition.service.impl.ChildGrowthServiceImpl;
import org.opensrp.web.util.PaginationHelperUtil;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
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
	private ChildGrowthServiceImpl childGrowthServiceImpl;
	
	@Autowired
	private SearchBuilder searchBuilder;
	
	@Autowired
	private SearchUtil searchUtil;
	
	@RequestMapping(value = "/child-growth.html", method = RequestMethod.GET)
	public String childGrowthReport(HttpServletRequest request, HttpSession session, Model model) {
		String search = "";
		search = (String) request.getParameter("search");
		if (search != null) {
			searchBuilder = paginationHelperUtil.setParams(request, session);
		} else {
			searchBuilder = searchBuilder.clear();
		}
		searchUtil.setDivisionAttribute(session);
		searchBuilder.clear();
		List<Object[]> data = childGrowthServiceImpl.getChildFalteredData(searchBuilder);
		session.setAttribute("data", data);
		System.err.println("Size:" + data.size());
		return "/report/child-growth";
	}
}
