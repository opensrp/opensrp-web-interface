package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.opensrp.common.util.DefaultHeadQuarter;
import org.opensrp.common.util.LocationTags;
import org.opensrp.core.dto.TrainingDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.TrainingTitle;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.TargetService;
import org.opensrp.core.service.TrainingService;
import org.opensrp.web.util.SearchUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "training")
public class TrainingManagementController {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	private TrainingService trainingService;
	
	@Autowired
	private BranchService branchService;
	
	@Autowired
	private SearchUtil searchUtil;
	
	@RequestMapping(value = "/training-list.html", method = RequestMethod.GET)
	public String myInventory(Model model, Locale locale) {
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("roles", trainingService.getRoleFOrTraining("excludeRoles"));
		model.addAttribute("trainingTitleList", trainingService.getAllTrainingTitle());
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "training/training-list";
	}
	
	@RequestMapping(value = "/training-title-list.html", method = RequestMethod.GET)
	public String trainingTitleList(Model model, Locale locale) {
		
		model.addAttribute("titles", trainingService.getAllTrainingTitle());
		model.addAttribute("locale", locale);
		return "training/title-list";
	}
	
	@RequestMapping(value = "/add-training.html", method = RequestMethod.GET)
	public String addTraining(Model model, Locale locale, HttpSession session) {
		//model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("roles", trainingService.getRoleFOrTraining("excludeRoles"));
		model.addAttribute("blcList", trainingService.getAllBlcList());
		model.addAttribute("trainingTitleList", trainingService.getAllTrainingTitle());
		List<Branch> branches = branchService.findAll("Branch");
		searchUtil.setDivisionAttribute(session);
		model.addAttribute("hqDivision", DefaultHeadQuarter.DIVISION.getId());
		model.addAttribute("hqDistrict", DefaultHeadQuarter.DISTRICT.getId());
		model.addAttribute("hqUpazilla", DefaultHeadQuarter.UPAZILA_CITY_CORPORATION.getId());
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "training/add-training";
	}
	
	@RequestMapping(value = "/add-training-title.html", method = RequestMethod.GET)
	public String addTrainingtitle(Model model, Locale locale, HttpSession session) {
		model.addAttribute("locale", locale);
		return "training/add-title";
	}
	
	@RequestMapping(value = "/{id}/edit-training.html", method = RequestMethod.GET)
	public String editTrainingtitle(Model model, Locale locale, HttpSession session, @PathVariable("id") long id) {
		model.addAttribute("locale", locale);
		
		model.addAttribute("trainingTitle", trainingService.findById(id, "id", TrainingTitle.class));
		return "training/edit-title";
	}
	
	@RequestMapping(value = "/view-training/{id}.html", method = RequestMethod.GET)
	public String myInventoryList(Model model, Locale locale, @PathVariable("id") long id) {
		model.addAttribute("id", id);
		model.addAttribute("locale", locale);
		TrainingDTO trainingList = trainingService.getTrainingDetailsListById(id);
		
		model.addAttribute("trainingObj", trainingList);
		model.addAttribute("users", trainingService.getTrainingUserListById(id));
		return "training/view-training-details";
	}
	
}
