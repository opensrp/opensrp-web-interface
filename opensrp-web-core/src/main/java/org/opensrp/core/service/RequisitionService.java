/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.opensrp.core.dto.ProductDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RequisitionService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(RequisitionService.class);
	
	@Autowired
	private ProductService productService;
	
	public RequisitionService() {
		
	}
	
	public List<ProductDTO> productListFortRequisition(Integer branchId, Integer roleId) {
		List<ProductDTO> products = productService.productListByBranchWithCurrentStock(branchId, roleId);
		
		List<Long> pids = new ArrayList<>();
		
		for (ProductDTO productDTO : products) {
			pids.add(productDTO.getId());
		}
		products.addAll(productService.productListWithoutBranch(StringUtils.join(pids.toArray(), ", "), roleId));
		
		return products;
	}
}
