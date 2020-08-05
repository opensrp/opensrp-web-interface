package org.opensrp.core.service.mapper;

import org.opensrp.core.dto.BranchDTO;
import org.opensrp.core.entity.Branch;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class BranchMapper {
    /**
     * DTO to Entity
     *
     * @param branchDTO
     * @return
     */
    public Branch map(BranchDTO branchDTO) {
        Branch branch = new Branch();
        if (branchDTO.getId() != 0) branch.setId(branchDTO.getId());
        branch.setCode(branchDTO.getCode());
        branch.setName(branchDTO.getName());
        branch.setDivision(branchDTO.getDivision());
        branch.setDistrict(branchDTO.getDistrict());
        branch.setUpazila(branchDTO.getUpazila());
        branch.setSsPosition(branchDTO.getSsPosition());
        branch.setSkPosition(branchDTO.getSkPosition());
        branch.setPaPosition(branchDTO.getPaPosition());
        branch.setPkPosition(branchDTO.getPkPosition());
        return branch;
    }

    /**
     * DTO's to Entities
     *
     * @param dtos
     * @return
     */
    public List<Branch> map(List<BranchDTO> dtos) {
        List<Branch> entities = new ArrayList<>();

        dtos.forEach(dto->entities.add(this.map(dto)));

        return entities;
    }

    /**
     * Entity to DTO
     *
     * @param branch
     * @return
     */
    public BranchDTO map(Branch branch) {
        BranchDTO branchDTO = new BranchDTO();
        branchDTO.setId(branch.getId());
        branchDTO.setCode(branch.getCode());
        branchDTO.setName(branch.getName());
        branchDTO.setDivision(branch.getDivision());
        branchDTO.setDistrict(branch.getDistrict());
        branchDTO.setUpazila(branch.getUpazila());
        branchDTO.setSsPosition(branch.getSsPosition());
        branchDTO.setSkPosition(branch.getSkPosition());
        branchDTO.setPaPosition(branch.getPaPosition());
        branchDTO.setPkPosition(branch.getPkPosition());
        return branchDTO;
    }
}
