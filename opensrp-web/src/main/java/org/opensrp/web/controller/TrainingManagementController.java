package org.opensrp.web.controller;

import java.util.List;
import java.util.Locale;

import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.util.LocationTags;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.TargetService;
import org.opensrp.core.service.TrainingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	@RequestMapping(value = "/view-training.html", method = RequestMethod.GET)
	public String myInventory(Model model, Locale locale) {
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("locale", locale);
		return "training/training-list";
	}
	
	@RequestMapping(value = "/add-training.html", method = RequestMethod.GET)
	public String addTraining(Model model, Locale locale) {
		model.addAttribute("divisions", targetService.getLocationByTagId(LocationTags.DIVISION.getId()));
		model.addAttribute("roles", trainingService.getRoleFOrTraining("excludeRoles"));
		List<Branch> branches = branchService.findAll("Branch");
		model.addAttribute("branches", branches);
		model.addAttribute("locale", locale);
		return "training/add-training";
	}
	
}
