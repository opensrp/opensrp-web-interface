/**
 * 
 */
package org.opensrp.web.controller;

import java.text.DecimalFormat;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.opensrp.common.dto.ReportDTO;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.FacilityService;
import org.opensrp.core.service.UserService;
import org.opensrp.web.nutrition.service.ChildGrowthService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.opensrp.web.util.PaginationHelperUtil;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author proshanto
 */
@Controller
@RequestMapping(value = "report")
public class ReportController {

	@Autowired
	private PaginationHelperUtil paginationHelperUtil;

	@Autowired
	private UserService userService;

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

		List<ReportDTO> reports = databaseServiceImpl.getMHVListFilterWise(searchBuilder);
		session.setAttribute("formWiseAggregatedList", reports);

		int totalHousehold = 0, totalPopulation = 0, totalMale = 0, totalFemale = 0;
		String malePercentage;
		String femalePercentage;
		for (int i = 0; i < reports.size(); i++) {
			totalHousehold += reports.get(i).getHousehold();
			totalPopulation += reports.get(i).getPopulation();
			totalMale += reports.get(i).getMale();
			totalFemale += reports.get(i).getFemale();
		}

		DecimalFormat df = new DecimalFormat("#.##");

		if (totalPopulation == 0) {
			malePercentage = "0";
			femalePercentage = "0";
		}
		else {
			femalePercentage = df.format((100.0/totalPopulation)*totalFemale);
			malePercentage = df.format((100.0/totalPopulation)*totalMale);
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
		session.setAttribute("totalHousehold", String.valueOf(totalHousehold));
		session.setAttribute("totalPopulation", String.valueOf(totalPopulation));
		session.setAttribute("totalMale", malePercentage);
		session.setAttribute("totalFemale", femalePercentage);
		//end: setting start date and end date in report
		return "report/householdDataReport";
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_AGGREGATED_REPORT')")
	@RequestMapping(value = "/individual-mhv-works.html", method = RequestMethod.GET)
	public String getIndividualMHVData(HttpServletRequest request,
									   HttpSession session,
									   @RequestParam("mhvUsername") String mhvUsername) {

		User user = userService.findByKey(mhvUsername, "username", User.class);
		Facility facility = facilityService.findById(Integer.valueOf(user.getChcp()), "id", Facility.class);
		request.setAttribute("user", user);
		request.setAttribute("facility", facility);
		List<Object[]> householdList = databaseServiceImpl.getHouseholdListByMHV(mhvUsername, session);
		session.setAttribute("householdList", householdList);
		return "report/individual-mhv-works";
	}

	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_AGGREGATED_REPORT')")
	@RequestMapping(value = "/household-member-list.html", method = RequestMethod.GET)
	public String getHouseholdMemberList(HttpServletRequest request,
										 HttpSession session,
										 Model model,
										 @RequestParam("householdBaseId") String householdBaseId,
										 @RequestParam("mhvId") String mhvId) {

		List<Object[]> householdMemberList = databaseServiceImpl.getMemberListByHousehold(householdBaseId, mhvId);
		session.setAttribute("memberList", householdMemberList);
		return "report/household-member-list";
	}
}
