/**
 * 
 */
package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.entity.Location;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.FacilityWorkerService;
import org.opensrp.core.service.LocationService;
import org.opensrp.web.nutrition.service.ChildGrowthService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.PaginationHelperUtil;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
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

	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;

	@Autowired
	private FacilityService facilityService;

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

	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_AGGREGATED_REPORT')")
	@RequestMapping(value = "/householdDataReport.html", method = RequestMethod.GET)
	public String showFormWiseReport(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		if (!AuthenticationManagerUtil.isAdmin()) {
			User user = AuthenticationManagerUtil.getLoggedInUser();
			Facility facility = facilityService.findById(Integer.parseInt(user.getChcp()), "id", Facility.class);
			request.setAttribute("division", facility.getDivision());
			request.setAttribute("district", facility.getDistrict());
			request.setAttribute("upazila", facility.getUpazila());
			request.setAttribute("union", facility.getUnion());
			request.setAttribute("ward", facility.getWard());
			request.setAttribute("cc", facility.getName());
		}
		searchBuilder = paginationHelperUtil.setParams(request, session);
		searchUtil.setDivisionAttribute(session);
		List<Object> formWiseAggregatedList = (List<Object>) databaseServiceImpl.getReportData(searchBuilder);
		session.setAttribute("formWiseAggregatedList", formWiseAggregatedList);

		if (formWiseAggregatedList != null && !formWiseAggregatedList.isEmpty()) {
			System.out.println("size of report data: " + formWiseAggregatedList.size());
		}
		//for setting start date and end date in report
		String startDate = "";
		String endDate = "";
		String memberType = "";
		if (request.getParameterMap().containsKey("start")) {
			startDate = (String) request.getParameter("start");
		}
		if (request.getParameterMap().containsKey("end")) {
			endDate = (String) request.getParameter("end");
		}
		if (request.getParameterMap().containsKey("memberType")) {
			memberType = (String) request.getParameter("memberType");
		}
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		session.setAttribute("memberType", memberType);
		//end: setting start date and end date in report
		return "report/householdDataReport";
	}

}
