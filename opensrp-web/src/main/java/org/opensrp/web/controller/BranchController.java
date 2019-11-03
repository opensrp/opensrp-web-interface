package org.opensrp.web.controller;

import com.google.gson.Gson;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.mapper.BranchMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Locale;

import static org.springframework.http.HttpStatus.OK;

@Controller
public class BranchController {

    @Autowired
    private BranchService branchService;

    @Autowired
    private BranchMapper branchMapper;

    @Autowired
    private DatabaseServiceImpl databaseServiceImpl;

    @PostAuthorize("hasPermission(returnObject, 'PERM_READ_BRANCH_LIST')")
    @RequestMapping(value = "/branch-list.html", method = RequestMethod.GET)
    public String branchList(Model model, Locale locale) {
        List<Branch> branches = branchService.findAll("Branch");
        model.addAttribute("branches", branches);
        model.addAttribute("locale", locale);
        model.addAttribute("branches", branches);
        return "branch/index";
    }

    @PostAuthorize("hasPermission(returnObject, 'PERM_READ_BRANCH_LIST')")
    @RequestMapping(value = "/branch/add.html", method = RequestMethod.GET)
    public String addBranch(Model model, Locale locale) {
        model.addAttribute("locale", locale);
        model.addAttribute("branch", new Branch());
        return "branch/add";
    }

    @PostAuthorize("hasPermission(returnObject, 'PERM_READ_BRANCH_LIST')")
    @RequestMapping(value = "/branch/edit.html", method = RequestMethod.GET)
    public String processUpdate(@RequestParam("id") int id, Model model, Locale locale) {
        System.out.println("CALLING UPDATE");
        Branch branch = branchService.findById(id, "id", Branch.class);
        model.addAttribute("locale", locale);
        model.addAttribute("branch", new Branch());
        model.addAttribute("branchDTO", branchMapper.map(branch));
        return "branch/edit";
    }

    @RequestMapping(value = "/branches/sk", method = RequestMethod.GET)
    public String getBranchList(HttpServletRequest request, HttpSession session, @RequestParam("branchId") Integer branchId) {
        List<Object[]> sks = databaseServiceImpl.getSKByBranch(branchId);
        session.setAttribute("data", sks);
        String errorMessage = "";
        return "/make-select-option";
    }
}
