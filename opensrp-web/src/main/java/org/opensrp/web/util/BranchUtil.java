package org.opensrp.web.util;

import java.util.List;

import org.opensrp.core.dto.BranchDTO;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.BranchService;
import org.opensrp.core.service.TargetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BranchUtil {
	
	@Autowired
	private TargetService targetService;
	
	@Autowired
	private BranchService branchService;
	
	public List<BranchDTO> getBranches() {
		User loggedInUser = AuthenticationManagerUtil.getLoggedInUser();
		int roleId = 0;
		for (Role role : loggedInUser.getRoles()) {
			roleId = role.getId();
			
		}
		List<BranchDTO> branches;
		if (roleId == 32 || roleId == 34) { // 32 AM, 34 Divm
			branches = targetService.getBranchListByUserIds(loggedInUser.getId() + "");
		} else {
			
			branches = branchService.findAll("Branch");
		}
		return branches;
	}
}
