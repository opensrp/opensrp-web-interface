/**
 * 
 */
package org.opensrp.web.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.*;
import org.opensrp.common.util.LocationTags;
import org.opensrp.common.util.ProductType;
import org.opensrp.common.util.Roles;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.TargetService;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * @author proshanto
 */
@Controller
public class TargetController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	SearchBuilder searchBuilder;
	
	@Autowired
	private BranchService branchService;
	
	@Value("#{opensrp['division.tag.id']}")
	private int divisionTagId;
	
	@Value("#{opensrp['divm.role.id']}")
	private String divMRoleId;
	
	@RequestMapping(value = "/target/target-by-individual.html", method = RequestMethod.GET)
	public String targetByIndividual(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		return "targets/sk-pa-list-for-individual-target";
	}
	
	@RequestMapping(value = "/target/target-by-position-list.html", method = RequestMethod.GET)
	public String targetByPosition(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		return "targets/target-by-position-list";
	}
	
	@RequestMapping(value = "/target/set-target-by-position.html", method = RequestMethod.GET)
	public String seTtargetByPosition(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		String roleName = request.getParameter("role");
		Role role = targetService.findByKey(roleName, "name", Role.class);
		model.addAttribute("targets", targetService.allActiveTarget(role.getId(), ProductType.TARGET.name()));
		model.addAttribute("setTargetTo", request.getParameter("setTargetTo"));
		model.addAttribute("role", role.getId());
		model.addAttribute("type", request.getParameter("type"));
		model.addAttribute("locationTag", request.getParameter("locationTag"));
		model.addAttribute("text", request.getParameter("text"));
		return "targets/set-target-by-position";
	}
	
	@RequestMapping(value = "/target/set-individual/{branch_id}/{role_id}/{user_id}.html", method = RequestMethod.GET)
	public String targetSetIndividually(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                                    @PathVariable("branch_id") int branchId, @PathVariable("role_id") int roleId,
	                                    @PathVariable("user_id") int userId) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(roleId, ProductType.TARGET.name()));
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("roleId", roleId);
		model.addAttribute("name", request.getParameter("name"));
		return "targets/sk-pa-individual-target-set";
	}
	
	@RequestMapping(value = "/target/view-individual/{branch_id}/{role_id}/{user_id}.html", method = RequestMethod.GET)
	public String viewTargetIndividually(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                                     @PathVariable("branch_id") int branchId, @PathVariable("role_id") int roleId,
	                                     @PathVariable("user_id") int userId) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(roleId, ProductType.TARGET.name()));
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("roleId", roleId);
		model.addAttribute("name", request.getParameter("name"));
		return "targets/view-sk-pa-individual-target";
	}
	
	@RequestMapping(value = "/target/edit-individual/{branch_id}/{role_id}/{user_id}.html", method = RequestMethod.GET)
	public String editTargetIndividually(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                                     @PathVariable("branch_id") int branchId, @PathVariable("role_id") int roleId,
	                                     @PathVariable("user_id") int userId) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(roleId, ProductType.TARGET.name()));
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("roleId", roleId);
		model.addAttribute("name", request.getParameter("name"));
		return "targets/edit-sk-pa-individual-target";
	}
	
	@RequestMapping(value = "/target/get-target-info", method = RequestMethod.GET)
	public String getTargetInfo(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		int roleId = 0;
		String roleParam = request.getParameter("role");
		
		Role role = targetService.findByKey(roleParam, "name", Role.class);
		if (role != null) {
			roleId = role.getId();
		} else {
			roleId = Integer.parseInt(roleParam);
		}
		
		String typeName = request.getParameter("typeName");
		
		String locationTag = request.getParameter("locationTag");
		int month = Integer.parseInt(request.getParameter("month"));
		int year = Integer.parseInt(request.getParameter("year"));
		int locationOrBranchOrUserId = Integer.parseInt(request.getParameter("locationOrBranchOrUserId"));
		int day = Integer.parseInt(request.getParameter("day"));
		
		List<TargetCommontDTO> targets = targetService.getTargetInfoByBranchOrLocationOrUserByRoleByMonth(roleId,
		    locationOrBranchOrUserId, typeName, locationTag, month, year, day);
		
		model.addAttribute("productList", targetService.allActiveTarget(roleId, ProductType.TARGET.name()));
		model.addAttribute("targets", targets);
		
		return "targets/get-target-info";
	}
	
	@RequestMapping(value = "/target/get-population-wise-target-info", method = RequestMethod.GET)
	public String getTargetInfoPopulationWise(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		int role = Roles.PK.getId();
		int locationTag = LocationTags.UNION_WARD.getId();
		int month = Integer.parseInt(request.getParameter("month"));
		int year = Integer.parseInt(request.getParameter("year"));
		model.addAttribute("targets", targetService.getTargetInfoForPopulationWise(role, locationTag, month, year));
		
		return "targets/get-target-info-for-populationwise-target";
	}
	
	@RequestMapping(value = "/target/target-by-population.html", method = RequestMethod.GET)
	public String targetByPopulation(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		return "targets/target-by-population-list";
	}
	
	@RequestMapping(value = "/target/set-individual-target-pk/{branch_id}/{role_id}/{user_id}", method = RequestMethod.GET)
	public String indiviualTargetSetForPkB(HttpServletRequest request, HttpSession session, Model model, Locale locale,
	                                       @PathVariable("branch_id") int branchId, @PathVariable("role_id") int roleId,
	                                       @PathVariable("user_id") int userId) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(Roles.PK.getId(), ProductType.TARGET.name()));
		model.addAttribute("branchId", branchId);
		model.addAttribute("userId", userId);
		model.addAttribute("roleId", roleId);
		model.addAttribute("pkname", request.getParameter("name"));
		model.addAttribute("pkid", request.getParameter("id"));
		model.addAttribute("pkLocation", request.getParameter("location"));
		model.addAttribute("population", request.getParameter("population"));
		return "targets/individual-target-by-population-pk";
	}
	
	@RequestMapping(value = "/target/population-wise-target-set", method = RequestMethod.GET)
	public String populationWiseTargetSet(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("targets", targetService.allActiveTarget(Roles.PK.getId(), ProductType.TARGET.name()));
		return "targets/population-wise-target-set";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-visit-report-pm.html", method = RequestMethod.GET)
	public String targetVsAchievementSKVisitPMReport(HttpServletRequest request, HttpSession session, Model model,
	                                                 Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("divms", targetService.getUserByRoles(divMRoleId));
		model.addAttribute("branches", branches);
		return "targets/target-vs-achievement-sk-visit-pm-report";
	}
	
	@RequestMapping(value = "/target/report/pm-visit-target-report", method = RequestMethod.POST)
	public String pmVisitTargetReportByManager(@RequestBody String dto, HttpServletRequest request, HttpSession session,
	                                           Model model) throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		String managerOrLocation = params.getString("managerOrLocation");
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		if (managerOrLocation.equalsIgnoreCase("managerWise")) {
			totalList = targetService.getPMVisitReportByManager(params);
			
		} else {
			totalList = targetService.getPMVisitReportByLocation(params);
		}
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		model.addAttribute("type", managerOrLocation);
		
		return "targets/target-vs-achievement-visit-pm-report";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-service-report-pm.html", method = RequestMethod.GET)
	public String targetVsAchievementSKServicePMReport(HttpServletRequest request, HttpSession session, Model model,
	                                                   Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("divms", targetService.getUserByRoles(divMRoleId));
		model.addAttribute("branches", branches);
		return "targets/target-vs-achievement-service-pm-report";
	}
	
	@RequestMapping(value = "/target/report/pm-service-target-report", method = RequestMethod.POST)
	public String pmServiceTargetReport(@RequestBody String dto, HttpServletRequest request, HttpSession session, Model model)
	    throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		String managerOrLocation = params.getString("managerOrLocation");
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		if (managerOrLocation.equalsIgnoreCase("managerWise")) {
			totalList = targetService.getPMServiceReportByManager(params);
			System.err.println("totalList::" + totalList);
		} else {
			totalList = targetService.getPMServiceReportByLocation(params);
		}
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		model.addAttribute("type", managerOrLocation);
		
		return "targets/target-vs-achievement-service-pm-report-table";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-service-report-dm.html", method = RequestMethod.GET)
	public String targetVsAchievementServiceDMReport(HttpServletRequest request, HttpSession session, Model model,
	                                                 Locale locale) {
		model.addAttribute("locale", locale);
		/*model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("divms", targetService.getUserByRoles(divMRoleId));
		model.addAttribute("branches", branches);*/
		
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		List<UserDTO> users = targetService.getUserByUserIds(userIds, 32);
		model.addAttribute("users", users);
		return "targets/target-vs-achievement-service-dm-report";
	}
	
	@RequestMapping(value = "/target/report/dm-service-target-report", method = RequestMethod.POST)
	public String dmServiceTargetReport(@RequestBody String dto, HttpServletRequest request, HttpSession session, Model model)
	    throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		String managerOrLocation = params.getString("managerOrLocation");
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		if (managerOrLocation.equalsIgnoreCase("managerWise")) {
			totalList = targetService.getDMServiceReportByManager(params);
		} else {
			totalList = targetService.getDMServiceReportByLocation(params);
		}
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		model.addAttribute("type", managerOrLocation);
		
		return "targets/target-vs-achievement-service-dm-report-table";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-visit-report-dm.html", method = RequestMethod.GET)
	public String targetVsAchievementVisitDMReport(HttpServletRequest request, HttpSession session, Model model,
	                                               Locale locale) {
		model.addAttribute("locale", locale);
		/*model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("divms", targetService.getUserByRoles(divMRoleId));
		model.addAttribute("branches", branches);*/
		
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		List<UserDTO> users = targetService.getUserByUserIds(userIds, 32);
		model.addAttribute("users", users);
		return "targets/target-vs-achievement-visit-dm-report";
	}
	
	@RequestMapping(value = "/target/report/dm-visit-target-report", method = RequestMethod.POST)
	public String dmVisitTargetReport(@RequestBody String dto, HttpServletRequest request, HttpSession session, Model model)
	    throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		String managerOrLocation = params.getString("managerOrLocation");
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		if (managerOrLocation.equalsIgnoreCase("managerWise")) {
			totalList = targetService.getDMVisitReportByManager(params);
		} else {
			totalList = targetService.getDMVisitReportByLocation(params);
		}
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		model.addAttribute("type", managerOrLocation);
		
		return "targets/target-vs-achievement-visit-dm-report-table";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-service-report-am-branch-wise.html", method = RequestMethod.GET)
	public String targetVsAchievementServiceAMReport(HttpServletRequest request, HttpSession session, Model model,
	                                                 Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "targets/target-vs-achievement-service-am-branch-wise-report";
	}
	
	@RequestMapping(value = "/target/report/am-branch-wise-service-target-report", method = RequestMethod.POST)
	public String amServiceTargetReport(@RequestBody String dto, HttpServletRequest request, HttpSession session, Model model)
	    throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		
		totalList = targetService.getAMServiceReportByBranch(params);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		model.addAttribute("reportDatas", totalList);
		
		return "targets/target-vs-achievement-service-am-branch-wise-report-table";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-service-report-am-provider-wise.html", method = RequestMethod.GET)
	public String targetVsAchievementServiceProviderWiseAMReport(HttpServletRequest request, HttpSession session,
	                                                             Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "targets/target-vs-achievement-service-am-provider-wise-report";
	}
	
	@RequestMapping(value = "/target/report/am-provider-wise-service-target-report", method = RequestMethod.POST)
	public String providerWiseAMServiceTargetReport(@RequestBody String dto, HttpServletRequest request,
	                                                HttpSession session, Model model) throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		
		totalList = targetService.getAMServiceReportByProvider(params);
		
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		return "targets/target-vs-achievement-service-am-provider-wise-report-table";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-visit-report-am-branch-wise.html", method = RequestMethod.GET)
	public String targetVsAchievementVisitAMReport(HttpServletRequest request, HttpSession session, Model model,
	                                               Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "targets/target-vs-achievement-visit-am-report-branch-wise";
	}
	
	@RequestMapping(value = "/target/report/am-visit-target-branch-wise-report", method = RequestMethod.POST)
	public String amVisitTargetReport(@RequestBody String dto, HttpServletRequest request, HttpSession session, Model model)
	    throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		
		totalList = targetService.getAMVisitReportByBranch(params);
		
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		return "targets/target-vs-achievement-visit-am-report-branch-wise-table";
	}
	
	@RequestMapping(value = "/target/target-vs-achievement-visit-report-am-provider-wise.html", method = RequestMethod.GET)
	public String targetVsAchievementVisitProviderWiseAMReport(HttpServletRequest request, HttpSession session, Model model,
	                                                           Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "targets/target-vs-achievement-visit-am-provider-wise-report";
	}
	
	@RequestMapping(value = "/target/report/am-provider-wise-visit-target-report", method = RequestMethod.POST)
	public String providerWiseAMvisitTargetReport(@RequestBody String dto, HttpServletRequest request, HttpSession session,
	                                              Model model) throws JSONException {
		
		JSONObject params = new JSONObject(dto);
		
		List<TargetReportDTO> totalList = new ArrayList<TargetReportDTO>();
		
		totalList = targetService.getAMVisitReportByProvider(params);
		
		model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetsAsJson(totalList).toString());
		return "targets/target-vs-achievement-visit-am-provider-wise-report-table";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-pm.html", method = RequestMethod.GET)
	public String pmWiseForumReport(Model model, Locale locale) {

		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("divms", targetService.getUserByRoles(divMRoleId));
		model.addAttribute("branches", branches);

		return "targets/target_vs_achv_forum_report_pm";
	}

	@RequestMapping(value = "/target/report/pm-wise-forum-report", method = RequestMethod.POST)
	public String forumReportTableForPM(@RequestBody String dto, Model model) throws JSONException {
        JSONObject params = new JSONObject(dto);
        String managerOrLocation = params.getString("managerOrLocation");

        List<ForumTargetReportDTO> totalList;
        if (managerOrLocation.equalsIgnoreCase("managerWise")) {
            totalList = targetService.getForumReportForPMByManager(params);
        } else {
            totalList = targetService.getForumReportForPMByManager(params);
        }
        model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetForumsAsJson(totalList).toString());
        model.addAttribute("type", managerOrLocation);

		return "targets/target-vs-achv-forum-report-table-pm";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-dm.html", method = RequestMethod.GET)
	public String targetVsAchievementForumDMReport(Model model,
													 Locale locale) {
		model.addAttribute("locale", locale);

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		List<UserDTO> users = targetService.getUserByUserIds(userIds, 32);
		model.addAttribute("users", users);
		return "targets/target_vs_achv_forum_report_dm";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-dm", method = RequestMethod.POST)
	public String targetVsAchievementForumDMReportTable(@RequestBody String dto, Model model) throws JSONException {
        JSONObject params = new JSONObject(dto);
        String managerOrLocation = params.getString("managerOrLocation");

        List<ForumTargetReportDTO> totalList = new ArrayList<>();
        if (managerOrLocation.equalsIgnoreCase("managerWise")) {
            totalList = targetService.getForumReportForDMByAM(params);
        }
        model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetForumsAsJson(totalList).toString());
        model.addAttribute("type", managerOrLocation);
		return "targets/target-vs-achv-forum-report-table-dm";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-am-branch-wise.html", method = RequestMethod.GET)
	public String targetVsAchievementForumAMReportForBranch( Model model,
												   Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "targets/target-vs-achv-forum-am-report-by-branch";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-am-by-branch", method = RequestMethod.POST)
	public String targetVsAchievementForumAMReportForBranchTable( @RequestBody String dto, Model model) throws JSONException {
        JSONObject params = new JSONObject(dto);

        List<ForumTargetReportDTO> totalList = new ArrayList<>();

        totalList = targetService.getForumReportForAMByBranch(params);

        model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetForumsAsJson(totalList).toString());
		return "targets/target-vs-achv-forum-report-table-am-by-branch";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-am-provider-wise.html", method = RequestMethod.GET)
	public String targetVsAchievementForumAMReportForSK( Model model,
													Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "targets/target-vs-achv-forum-am-report-by-provider";
	}

	@RequestMapping(value = "/target/target-vs-achv-forum-report-am-by-provider", method = RequestMethod.POST)
	public String targetVsAchievementForumAMReportForSKTable( @RequestBody String dto, Model model) throws JSONException {
        JSONObject params = new JSONObject(dto);

        List<ForumTargetReportDTO> totalList;

        totalList = targetService.getForumReportForAMBySK(params);

        model.addAttribute("reportDatas", totalList);
		model.addAttribute("jsonReportData", getTargetForumsAsJson(totalList).toString());
		return "targets/target-vs-achv-forum-report-table-am-by-sk";
	}

	@RequestMapping(value = "/report/pm-timestamp-report-dm--wise.html", method = RequestMethod.GET)
	public String pmTimestampReportDMWise( Model model, Locale locale) {
		model.addAttribute("locale", locale);
		model.addAttribute("divisions", targetService.getLocationByTagId(divisionTagId));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("divms", targetService.getUserByRoles(divMRoleId));
		model.addAttribute("branches", branches);
		return "report/timestamp-report/pm-report-dm-wise";
	}

	@RequestMapping(value = "/report/pm-timestamp-report-dm-wise", method = RequestMethod.POST)
	public String pmTimestampReportDMWiseTable( @RequestBody String dto, Model model) throws JSONException {
		JSONObject params = new JSONObject(dto);

		List<TimestamReportDTO> totalList;

		totalList = targetService.getPMTimestapmReportDMWise(params);

		model.addAttribute("reportDatas", totalList);
		return "report/timestamp-report/pm-report-dm-table";
	}

	@RequestMapping(value = "/report/dm-timestamp-report-am-wise.html", method = RequestMethod.GET)
	public String dmTimestampReportAmWise(Model model, Locale locale) {
		model.addAttribute("locale", locale);

		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		List<UserDTO> users = targetService.getUserByUserIds(userIds, 32);
		model.addAttribute("users", users);
		return "report/timestamp-report/dm-report-am-wise";
	}

	@RequestMapping(value = "/report/dm-timestamp-report-am-wise", method = RequestMethod.POST)
	public String dmTimestampReportAmWiseTable(@RequestBody String dto, Model model) throws JSONException {
		JSONObject params = new JSONObject(dto);
		String managerOrLocation = params.getString("managerOrLocation");

		List<TimestamReportDTO> totalList =  targetService.getDMTimestapmReportAMWise(params);

		model.addAttribute("reportDatas", totalList);
		model.addAttribute("type", managerOrLocation);
		return "report/timestamp-report/dm-report-am-table";
	}

	@RequestMapping(value = "/report/am-timestamp-report-branch-wise.html", method = RequestMethod.GET)
	public String amTimestampReportBranchWise(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "report/timestamp-report/am-report-branch-wise";
	}

	@RequestMapping(value = "/report/am-timestamp-report-branch-wise", method = RequestMethod.POST)
	public String amTimestampReportBranchTable(@RequestBody String dto, Model model)
			throws JSONException {

		JSONObject params = new JSONObject(dto);

		List<TimestamReportDTO> totalList =  targetService.getAMTimestapmReportBranchWise(params);

		model.addAttribute("reportDatas", totalList);
		return "report/timestamp-report/am-report-branch-table";
	}

	@RequestMapping(value = "/report/am-timestamp-report-provider-wise.html", method = RequestMethod.GET)
	public String amTimestampReportProviderWise(Model model, Locale locale) {
		model.addAttribute("locale", locale);
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		String userIds = loggedInUser.getId() + "";
		model.addAttribute("userIds", userIds);
		return "report/timestamp-report/am-report-provider-wise";
	}

	@RequestMapping(value = "/report/am-timestamp-report-provider-wise", method = RequestMethod.POST)
	public String amTimestampReportProviderTable(@RequestBody String dto, Model model) throws JSONException {

		JSONObject params = new JSONObject(dto);

		List<TimestamReportDTO> totalList = targetService.getAMTimestapmReportProviderWise(params);

		model.addAttribute("reportDatas", totalList);
		return "report/timestamp-report/am-report-provider-table";
	}


	private JsonArray getTargetsAsJson(List<TargetReportDTO> targetList){

		Gson gson = new Gson();
		JsonElement element = gson.toJsonTree(targetList, new TypeToken<List<TargetReportDTO>>() {}.getType());
		System.out.println(element.getAsJsonArray());
		return element.getAsJsonArray();

	}

	private JsonArray getTargetForumsAsJson(List<ForumTargetReportDTO> targetList){

		Gson gson = new Gson();
		JsonElement element = gson.toJsonTree(targetList, new TypeToken<List<ForumTargetReportDTO>>() {}.getType());
		System.out.println(element.getAsJsonArray());
		return element.getAsJsonArray();

	}
	
}
