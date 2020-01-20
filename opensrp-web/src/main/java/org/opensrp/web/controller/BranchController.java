package org.opensrp.web.controller;

import com.google.gson.Gson;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.UserService;
import org.opensrp.core.service.mapper.BranchMapper;
import org.opensrp.web.util.AuthenticationManagerUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
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

    @Autowired
    private UserService userService;

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
        Branch branch = branchService.findById(id, "id", Branch.class);
        model.addAttribute("locale", locale);
        model.addAttribute("branch", new Branch());
        model.addAttribute("branchDTO", branchMapper.map(branch));
        return "branch/edit";
    }

    @RequestMapping(value = "/branches/sk", method = RequestMethod.GET)
    public String getBranchList(HttpServletRequest request, HttpSession session, @RequestParam("branchId") Integer branchId) {
        List<Branch> branches = new ArrayList<>(userService.getLoggedInUser().getBranches());
        String branchList = "";
        if (branchId == 0) {
            branchList = branchService.commaSeparatedBranch(branches);
        } else {
            branchList = branchId.toString();
        }
        List<Object[]> sks = databaseServiceImpl.getSKByBranch(branchList);
        session.setAttribute("data", sks);
        String errorMessage = "";
        return "/make-select-option";
    }

    @RequestMapping(value = "/branches/sk-change", method = RequestMethod.GET)
    public String skChange(HttpServletRequest request, HttpSession session, @RequestParam("ssId") Integer ssId, Model model) {
        User am = AuthenticationManagerUtil.getLoggedInUser();
        User ss = databaseServiceImpl.findById(ssId, "id", User.class);
        List<Branch> branches = branchService.getBranchByUser(am.getId());
        String errorMessage = "";
        model.addAttribute("ssInfo", ss);
        model.addAttribute("branches", branches);
        return "user/sk-change-ajax";
    }
}
