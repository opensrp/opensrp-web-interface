/**
 *
 */
package org.opensrp.web.controller;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.opensrp.common.dto.*;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.DateUtil;
import org.opensrp.common.util.Roles;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.*;
import org.opensrp.core.service.*;
import org.opensrp.web.nutrition.service.ChildGrowthService;
import org.opensrp.web.util.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

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

	@Autowired
	private ReportService reportService;

	@Autowired
	private PaginationUtil paginationUtil;

	@Autowired
	private BranchService branchService;

	@Autowired
	private LocationService locationService;

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
	public String showFormWiseReport(HttpServletRequest request,
									 HttpSession session,
									 Model model,
									 Locale locale,
									 @RequestParam("address_field") String address_value,
									 @RequestParam("searched_value") String searched_value,
									 @RequestParam("searched_value_id") Integer searchedValueId) throws ParseException {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		model.addAttribute("locale", locale);
		String branchId = request.getParameterMap().containsKey("branch")?request.getParameter("branch") : "";
		System.err.println("branchId"+branchId);
		User user = userService.getLoggedInUser();
		if (AuthenticationManagerUtil.isAM()) {
			List<Object[]> branches = new ArrayList<>();
			for (Branch branch: user.getBranches()) {
				Object[] obj = new Object[10];
				obj[0] = branch.getId();
				obj[1] = branch.getName();
				branches.add(obj);
			}
		}
		session.setAttribute("branchList", branchService.getBranchByUser(user.getId()));
		for (Branch b: branchService.getBranchByUser(user.getId())) {
			System.out.println(" branch-name: "+ b.getName());
		}
		List<Object[]> allSKs = new ArrayList<>();
		if (AuthenticationManagerUtil.isAM()) {
			List<Object[]> branches = new ArrayList<>();
			if(!branchId.isEmpty() ){
				Branch branch = branchService.findById(Integer.parseInt(branchId), "id", Branch.class);

				Object[] obj = new Object[10];
				obj[0] = branch.getId();
				obj[1] = branch.getName();
				branches.add(obj);
			}else {

				for (Branch branch: user.getBranches()) {
					Object[] obj = new Object[10];
					obj[0] = branch.getId();
					obj[1] = branch.getName();
					branches.add(obj);
				}
			}
			allSKs = databaseServiceImpl.getAllSks(branches);
		} else if (AuthenticationManagerUtil.isAdmin()){
			allSKs =  new ArrayList<Object[]>();
		}

		// List<Object[]> skLists = databaseServiceImpl.getAllSks();
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());

		String endDateValue = formatter.format(DateUtils.addDays(formatter.parse(endDate), 1));
		if (AuthenticationManagerUtil.isAM()) address_value = "sk_id"; // for AM role
		List<Object[]> reports = databaseServiceImpl.getHouseHoldReports(startDate, endDateValue, address_value, searched_value, allSKs, searchedValueId);
		session.setAttribute("formWiseAggregatedList", reports);
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		session.setAttribute("startDate", startDate);
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

	@RequestMapping(value = "/clientDataReport.html", method = RequestMethod.GET)
	public String getClientDataReportPage(HttpServletRequest request,
										  HttpSession session,
										  Model model,
										  Locale locale){
		model.addAttribute("formNameList", ModelConverter.mapLoad());
		List<Object[]> allSKs = new ArrayList<>();
		List<Object[]> branches = new ArrayList<>();
		User user = userService.getLoggedInUser();
		if (AuthenticationManagerUtil.isAM()) {
			for (Branch branch: user.getBranches()) {
				Object[] obj = new Object[10];
				obj[0] = branch.getId();
				obj[1] = branch.getName();
				branches.add(obj);
			}
			allSKs = databaseServiceImpl.getAllSks(branches);
		} else if (AuthenticationManagerUtil.isAdmin()){
			allSKs =  databaseServiceImpl.getAllSks(null);
		}

		session.setAttribute("skList",allSKs);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));

//        paginationUtil.createPagination(request, session, "viewJsonDataConversionOfClient", "ec_family");
		model.addAttribute("locale", locale);

		return "report/client-data-report";
	}

	@RequestMapping(value = "/aggregatedReport.html", method = RequestMethod.GET)
	public String getAggregatedReportPage(HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",branchService.getBranchByUser(user.getId()));
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		return "report/aggregated-report";
	}

	@RequestMapping(value = "/aggregated-report", method = RequestMethod.GET)
	public String generateAggregatedReport(HttpServletRequest request,
										   HttpSession session,
										   @RequestParam(value = "address_field", required = false, defaultValue = "division") String addressValue,
										   @RequestParam(value = "searched_value", required = false) String searchedValue,
										   @RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
										   @RequestParam(value = "startDate", required = false) String startDate,
										   @RequestParam(value = "endDate", required = false) String endDate) {

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<AggregatedReportDTO> aggregatedReports = new ArrayList<>();
		String skIds = "";
		String locationValue = request.getParameter("locationValue");
		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {
			String branchId = request.getParameter("branch");
			if (StringUtils.isBlank(branchId)) {
				String branches = branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
			} else {
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branchId + "}'");
			}
			aggregatedReports = reportService.getAggregatedReportBySK(startDate, endDate, skIds);
			session.setAttribute("isSKList", true);
		} else {
			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
			String parentLocationName = parentLocation.getName().split(":")[0];
			System.out.println("");
			if (addressValue.equalsIgnoreCase("sk_id")) {
				skIds = userService.findSKByLocationSeparatedByComma(searchedValueId, Roles.SK.getId());
				aggregatedReports = reportService.getAggregatedReportBySK(startDate, endDate, skIds);
				session.setAttribute("isSKList", true);
			} else {
				aggregatedReports = reportService.getAggregatedReportByLocation(startDate, endDate, searchedValueId, addressValue, parentLocationTag, parentLocationName);
				session.setAttribute("isSKList", false);
			}
		}
		session.setAttribute("aggregatedReports", aggregatedReports);
		return "report/aggregated-report-table";
	}

	@RequestMapping(value = "/familyPlanningReport.html", method = RequestMethod.GET)
	public String getFamilyPlanningReportPage(HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		return "report/family-planning-report";
	}

	@RequestMapping(value = "/family-planning-report", method = RequestMethod.GET)
	public String generateFamilyPlanningReport(HttpServletRequest request,
											   HttpSession session,
											   @RequestParam(value = "address_field", required = false, defaultValue = "division") String addressValue,
											   @RequestParam(value = "searched_value", required = false) String searchedValue,
											   @RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
											   @RequestParam(value = "startDate", required = false) String startDate,
											   @RequestParam(value = "endDate", required = false) String endDate) {

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<ElcoReportDTO> elcoReports = new ArrayList<>();
		String skIds = "";
		String locationValue = request.getParameter("locationValue");
		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {
			String branchId = request.getParameter("branch");
			if (StringUtils.isBlank(branchId)) {
				String branches = branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
			} else {
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branchId + "}'");
			}
			elcoReports = reportService.getElcoReportBySK(startDate, endDate, skIds);
		} else {
			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
			String parentLocationName = parentLocation.getName().split(":")[0];
			if (addressValue.equalsIgnoreCase("sk_id")) {
				skIds = userService.findSKByLocationSeparatedByComma(searchedValueId, Roles.SK.getId());
				elcoReports = reportService.getElcoReportBySK(startDate, endDate, skIds);
			} else {
				elcoReports = reportService.getElcoReportByLocation(startDate, endDate, searchedValueId, addressValue, parentLocationTag, parentLocationName);
			}
		}
		session.setAttribute("elcoReports", elcoReports);
		return "report/family-planning-report-table";
	}

	@RequestMapping(value = "/pregnancyReport.html", method = RequestMethod.GET)
	public String getPregnancyReportPage(HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		return "report/pregnancy-report";
	}

	@RequestMapping(value = "/pregnancy-report", method = RequestMethod.GET)
	public String generatePregnancyReport(HttpServletRequest request,
										  HttpSession session,
										  @RequestParam(value = "address_field", required = false, defaultValue = "division") String addressValue,
										  @RequestParam(value = "searched_value", required = false) String searchedValue,
										  @RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
										  @RequestParam(value = "startDate", required = false) String startDate,
										  @RequestParam(value = "endDate", required = false) String endDate) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<PregnancyReportDTO> pregnancyReports = new ArrayList<>();
		String skIds = "";
		String locationValue = request.getParameter("locationValue");
		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {
			String branchId = request.getParameter("branch");
			if (StringUtils.isBlank(branchId)) {
				String branches = branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
			} else {
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branchId + "}'");
			}
			pregnancyReports = reportService.getPregnancyReportBySK(startDate, endDate, skIds);
		} else {
			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
			String parentLocationName = parentLocation.getName().split(":")[0];
			if (addressValue.equalsIgnoreCase("sk_id")) {
				skIds = userService.findSKByLocationSeparatedByComma(searchedValueId, Roles.SK.getId());
				pregnancyReports = reportService.getPregnancyReportBySK(startDate, endDate, skIds);
			} else {
				pregnancyReports = reportService.getPregnancyReportByLocation(startDate, endDate, searchedValueId, addressValue, parentLocationTag, parentLocationName);
			}
		}
		session.setAttribute("pregnancyReports", pregnancyReports);
		return "report/pregnancy-report-table";
	}

	@RequestMapping(value = "/miscellaneousReport.html", method = RequestMethod.GET)
	public String getChildNutritionReportPage(HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		return "report/child-nutrition-report";
	}

	@RequestMapping(value = "/child-nutrition-report", method = RequestMethod.GET)
	public String generateChildNutritionReport(HttpServletRequest request,
										  HttpSession session,
										  @RequestParam(value = "address_field", required = false, defaultValue = "division") String addressValue,
										  @RequestParam(value = "searched_value", required = false) String searchedValue,
										  @RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
										  @RequestParam(value = "startDate", required = false) String startDate,
										  @RequestParam(value = "endDate", required = false) String endDate) {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<ChildNutritionReportDTO> childNutritionReports = new ArrayList<>();
		String skIds = "";
		String locationValue = request.getParameter("locationValue");
		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {
			String branchId = request.getParameter("branch");
			if (StringUtils.isBlank(branchId)) {
				String branches = branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
			} else {
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branchId + "}'");
			}
			childNutritionReports = reportService.getChildNutritionReportBySK(startDate, endDate, skIds);
		} else {
			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
			String parentLocationName = parentLocation.getName().split(":")[0];
			if (addressValue.equalsIgnoreCase("sk_id")) {
				skIds = userService.findSKByLocationSeparatedByComma(searchedValueId, Roles.SK.getId());
				childNutritionReports = reportService.getChildNutritionReportBySK(startDate, endDate, skIds);
			} else {
				childNutritionReports = reportService.getChildNutritionReportByLocation(startDate, endDate, searchedValueId, addressValue, parentLocationTag, parentLocationName);
			}
		}
		session.setAttribute("childNutritionReports", childNutritionReports);
		return "report/child-nutrition-report-table";
	}

	@RequestMapping(value = "/covid-19.html", method = RequestMethod.GET)
	public String getCOVID19ReportPage(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		String branchId = request.getParameterMap().containsKey("branch")?request.getParameter("branch") : "";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		List<Object[]> skList = new ArrayList<>();
		List<Branch> branchList = new ArrayList<>();
		if (AuthenticationManagerUtil.isAM()) {
			branchList = new ArrayList<>(user.getBranches());
			List<Object[]> branches = branchService.getBranchByUser(branchId, user);
			skList = databaseServiceImpl.getAllSks(branches);
		}
		else {
			branchList = branchService.findAll("Branch");
			skList = databaseServiceImpl.getAllSks(new ArrayList<Object[]>());
		}
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList", branchList);
		session.setAttribute("skList", skList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		return "report/covid-19-report";
	}

	@RequestMapping(value = "/covid-19-report", method = RequestMethod.GET)
	public String generateCOVID19Report(HttpServletRequest request,
										   HttpSession session,
										   @RequestParam(value = "startDate", required = false) String startDate,
										   @RequestParam(value = "endDate", required = false) String endDate) {
		String branchId = request.getParameterMap().containsKey("branch")?request.getParameter("branch") : "";
		String skIds = request.getParameterMap().containsKey("sk")?request.getParameter("sk") : "";
		System.out.println("branch id: "+branchId);
		List<COVID19ReportDTO> covid19Reports = new ArrayList<>();
		User user = AuthenticationManagerUtil.getLoggedInUser();
		if (!StringUtils.isBlank(skIds) && !skIds.equals("0")) {
			covid19Reports = reportService.getCOVID19ReportBySK(startDate, endDate, skIds, 0, 10);
		} else {
			if (StringUtils.isBlank(branchId) || branchId.equals("0")) {
				if (AuthenticationManagerUtil.isAdmin()) {
					covid19Reports = reportService.getCOVID19Report(startDate, endDate, 0, 10);
				} else {
					String branches = branchService.commaSeparatedBranch(new ArrayList<>(user.getBranches()));
					skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
					covid19Reports = reportService.getCOVID19ReportBySK(startDate, endDate, skIds, 0, 10);
				}
			} else {
				Branch branch = branchService.findById(Integer.valueOf(branchId), "id", Branch.class);
				String branches = branchService.commaSeparatedBranch(Arrays.asList(branch));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
				covid19Reports = reportService.getCOVID19ReportBySK(startDate, endDate, skIds, 0, 10);
			}
		}
		session.setAttribute("covid19Reports", covid19Reports);
		return "report/covid-19-report-table";
	}

	@RequestMapping(value = "/clientDataReportTable", method = RequestMethod.GET)
	public String getClientDataReportTable(HttpServletRequest request,
										   HttpSession session,
										   Model model,
										   @RequestParam(value = "pageSize", required = false, defaultValue = "10") Integer RESULT_SIZE)
			throws ParseException {

		// Request Parameters
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

		String  startTime =
				request.getParameterMap().containsKey("startDate")?
						request.getParameter("startDate"): formatter.format(DateUtils.addMonths(new Date(), -3));

		String endTime = request.getParameterMap().containsKey("endDate")?
				request.getParameter("endDate"):formatter.format(new Date());
//		endTime = formatter.format(DateUtils.addDays(formatter.parse(endTime), 1));

		String formName = request.getParameterMap().containsKey("formName")?
				request.getParameter("formName"):"ec_family";

		String branchId = request.getParameterMap().containsKey("branch")?request.getParameter("branch") : "";

		String sk = request.getParameterMap().containsKey("sk")?request.getParameter("sk"):"";

		Integer pageNumber = Integer.parseInt(request.getParameter("pageNo"));
		List<Object[]> allSKs = new ArrayList<>();

		User user = userService.getLoggedInUser();
		if (AuthenticationManagerUtil.isAM()) {
			List<Object[]> branches = new ArrayList<>();
			if(!branchId.isEmpty() && !branchId.equals("0")){
				Branch branch = branchService.findById(Integer.parseInt(branchId), "id", Branch.class);

				Object[] obj = new Object[10];
				obj[0] = branch.getId();
				obj[1] = branch.getName();
				branches.add(obj);
			}else {

				for (Branch branch: user.getBranches()) {
					Object[] obj = new Object[10];
					obj[0] = branch.getId();
					obj[1] = branch.getName();
					branches.add(obj);
				}
			}
			if(StringUtils.isBlank(sk)) {
				allSKs = databaseServiceImpl.getAllSks(branches);
				sk = userService.commaSeparatedSK(allSKs);
			}
		}

		List<Object[]> tempClientInfo = databaseServiceImpl.getClientInfoFilter(startTime, endTime, formName.replaceAll("\\_"," ") , sk, allSKs, pageNumber);
		List allClientInfo =  ModelConverter.modelConverterForClientData(formName, tempClientInfo);

		System.out.println("SIZE:: "+tempClientInfo.size());

		Integer size = 0;
		if (pageNumber == 0) {
			size = databaseServiceImpl.getClientInfoFilterCount(startTime, endTime, formName.replaceAll("\\_"," ") , sk, allSKs);
			if ((size % RESULT_SIZE) == 0) {
				session.setAttribute("size", (size / RESULT_SIZE) - 1);
			} else {
				session.setAttribute("size", size / RESULT_SIZE);
			}
			session.setAttribute("recordSize", size);
		}

		new PaginationUtil().createPageList(session, pageNumber.toString());

		session.setAttribute("clientInfoList",allClientInfo);
		session.setAttribute("headerList", ModelConverter.headerListForClientData(formName));
		session.setAttribute("emptyFlag",1);
		session.setAttribute("pageNumber", pageNumber);
		session.setAttribute("startTime", startTime);
		session.setAttribute("endTime", endTime);
		session.setAttribute("formName", formName);

		return "report/client-data-report-table";
	}


    @RequestMapping(value = "/forum-report.html", method = RequestMethod.GET)
    public ModelAndView getForumReport(ModelAndView modelAndView, HttpSession session) {

		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	    modelAndView.setViewName("report/forum-report/report");
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));
		session.setAttribute("startDate", formatter.format(DateUtil.getFirstDayOfMonth(new Date())));
	    session.setAttribute("endDate", formatter.format(new Date()));
	    return modelAndView;
    }

    @RequestMapping(value = "/forum-report", method = RequestMethod.GET)
    public String getForumReportTable(
    		HttpSession session,
			@RequestParam(value = "startDate", required = false) String startDate,
			@RequestParam(value = "endDate", required = false) String endDate,
			@RequestParam(value = "address_field", required = false, defaultValue = "division") String locationTag,
			@RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
			@RequestParam(value = "branch", required = false, defaultValue = "") String branchId,
			@RequestParam(value = "locationValue", required = false, defaultValue = "") String locationValue,
			@RequestParam(value = "designation", required = false, defaultValue = "") String designation,
    		@RequestParam(value = "forumType", required = false, defaultValue = "") String forumType ) {

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<ForumReportDTO> forumReport = new ArrayList<>();
		List<ForumIndividualReportDTO> forumIndividualReport = new ArrayList<>();
		String skIds = "";

		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {

			if (StringUtils.isBlank(branchId)) {
				String branches = branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
			} else {
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branchId + "}'");
			}

			 if(StringUtils.isBlank(forumType)) forumReport = reportService.getForumReportBySK(startDate, endDate, skIds, designation);
			 else forumIndividualReport = reportService.getForumIndividualReportBySk(startDate, endDate, forumType, skIds, designation) ;

		}
		else {
			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
			String parentLocationName = parentLocation.getName().split(":")[0];

			if (locationTag.equalsIgnoreCase("sk_id")) {
				skIds = userService.findSKByLocationSeparatedByComma(searchedValueId, Roles.SK.getId());
				if(StringUtils.isBlank(forumType)) forumReport = reportService.getForumReportBySK(startDate, endDate, skIds, designation);
				else forumIndividualReport = reportService.getForumIndividualReportBySk(startDate, endDate, forumType, skIds, designation) ;

			}
			else {
				// '1991-01-01', '2021-12-01', 'division', 9266 , 'DHAKA' , 'district');
				if(StringUtils.isBlank(forumType)) {
					forumReport = reportService.getForumReportByLocation(
							startDate,
							endDate,
							parentLocationTag,
							searchedValueId,
							parentLocationName,
							locationTag,
							designation);
				}else {
					forumIndividualReport = reportService.getForumIndividualReportByLocation(
							startDate,
							endDate,
							parentLocationTag,
							searchedValueId,
							parentLocationName,
							locationTag,
							forumType,
							designation
					);
				}
			}
		}
		session.setAttribute("forumReport", forumReport);
		session.setAttribute("forumIndividualReport", forumIndividualReport);
		session.setAttribute("forumType", forumType);
		return StringUtils.isBlank(forumType) ?  "report/forum-report/report-table" : "report/forum-report/individual-report-table" ;
    }

	@RequestMapping(value = "/aggregated-biometric-report.html", method = RequestMethod.GET)
	public String getAggregatedBiometricReport(
			HttpSession session
	) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);

		return "report/aggregated-biometric-report";
	}

	@RequestMapping(value = "/aggregated-biometric-table", method = RequestMethod.GET)
	public String getAggregatedBiometricTable(
			HttpSession session,
			@RequestParam(value = "startDate", required = false) String startDate,
		    @RequestParam(value = "endDate", required = false) String endDate,
		  	@RequestParam(value = "address_field", required = false, defaultValue = "division") String locationTag,
		  	@RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
		  	@RequestParam(value = "branch", required = false, defaultValue = "") String branchId,
		  	@RequestParam(value = "locationValue", required = false, defaultValue = "") String locationValue) {

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<AggregatedBiometricDTO> report;
		String skIds = "";

		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {

			if (StringUtils.isBlank(branchId)) {
				String branches = branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()));
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branches + "}'");
			} else {
				skIds = userService.findSKByBranchSeparatedByComma("'{" + branchId + "}'");
			}

			report = reportService.getAggregatedBiometricReportBySK(startDate, endDate, skIds);

		}
		else {
			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();
			String parentLocationName = parentLocation.getName().split(":")[0];

			if (locationTag.equalsIgnoreCase("sk_id")) {
				skIds = userService.findSKByLocationSeparatedByComma(searchedValueId, Roles.SK.getId());
				report = reportService.getAggregatedBiometricReportBySK(startDate, endDate, skIds);
			}
			else {
				// '1991-01-01', '2021-12-01', 'division', 9266 , 'DHAKA' , 'district');
				report = reportService.getAggregatedBiometricReport(
						startDate,
						endDate,
						parentLocationTag,
						searchedValueId,
						parentLocationName,
						locationTag);
			}
		}

		session.setAttribute("aggregatedBiometricReport", report);
		return "report/aggregated-biometric-table";
	}

	@RequestMapping(value = "/individual-biometric-report.html", method = RequestMethod.GET)
	public String getIndividualBiometricReport(
			HttpSession session
	) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String startDate = formatter.format(DateUtil.getFirstDayOfMonth(new Date()));
		String endDate = formatter.format(new Date());
		User user = AuthenticationManagerUtil.getLoggedInUser();
		searchUtil.setDivisionAttribute(session);
		session.setAttribute("branchList",new ArrayList<>(user.getBranches()));
		session.setAttribute("startDate", startDate);
		session.setAttribute("endDate", endDate);
		return "report/individual-biometric-report";
	}

	@RequestMapping(value = "/individual-biometric-table", method = RequestMethod.GET)
	public String getIndividualBiometricTable(
			HttpSession session,
			@RequestParam(value = "address_field", required = false, defaultValue = "") String locationTag,
			@RequestParam(value = "searched_value_id", required = false, defaultValue = "9265") Integer searchedValueId,
			@RequestParam(value = "startDate", required = false) String startDate,
			@RequestParam(value = "endDate", required = false) String endDate,
			@RequestParam(value = "searched_value", required = false) String searchedValue,
			@RequestParam(value = "branch", required = false, defaultValue = "-1") Integer branch,
			@RequestParam(value = "serviceName", required = false, defaultValue = "") String serviceName,
			@RequestParam(value = "locationValue", required = false, defaultValue = "catchmentArea") String locationValue) {

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		List<IndividualBiometricReportDTO> report;

		if (AuthenticationManagerUtil.isAM() && locationValue.equalsIgnoreCase("catchmentArea")) {
			String branchIds;
			branchIds = (branch == -1)
					? branchService.commaSeparatedBranch(new ArrayList<>(loggedInUser.getBranches()))
					: branch.toString();
			report = reportService.getIndividualBiometricReport(
					startDate,
					endDate,
					serviceName,
					"branch",
					"",
					branchIds);
		}
		else {

			Location parentLocation = locationService.findById(searchedValueId, "id", Location.class);
			String parentLocationTag = parentLocation.getLocationTag().getName().toLowerCase();

			String searchValue = searchedValue.equalsIgnoreCase("bangladesh") ? "" : searchedValue.split("=")[1].replace("'","").trim();
			System.out.println("==========>>"+ searchValue);
			report = reportService.getIndividualBiometricReport(startDate, endDate, serviceName, parentLocationTag, searchValue, "");
		}

		session.setAttribute("individualBiometricReport", report);
		return "report/individual-biometric-table";
	}


}
