package org.opensrp.core.service.mapper;

import org.opensrp.core.dto.BranchDTO;
import org.opensrp.core.entity.Branch;
import org.springframework.stereotype.Service;

@Service
public class BranchMapper {
    /**
     * DTO to Entity
     * @param branchDTO
     * @return
     */
    public Branch map(BranchDTO branchDTO) {
        Branch branch = new Branch();
        branch.setCode(branchDTO.getCode());
        branch.setName(branchDTO.getName());
        return branch;
    }

    /**
     * Entity to DTO
     * @param branch
     * @return
     */
    public BranchDTO map(Branch branch) {
        BranchDTO branchDTO = new BranchDTO();
        branchDTO.setCode(branch.getCode());
        branchDTO.setName(branch.getName());
        return branchDTO;
    }
}
