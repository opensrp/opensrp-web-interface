package org.opensrp.web.controller;

import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.service.BranchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.List;
import java.util.Locale;

@Controller
public class BranchController {

    @Autowired
    private BranchService branchService;

    @PostAuthorize("hasPermission(returnObject, 'PERM_READ_BRANCH_LIST')")
    @RequestMapping(value = "/branch-list.html", method = RequestMethod.GET)
    public String roleList(Model model, Locale locale) {
        List<Branch> branches = branchService.findAll("Branch");
        model.addAttribute("branches", branches);
        model.addAttribute("locale", locale);
        return "branch/index";
    }
}
