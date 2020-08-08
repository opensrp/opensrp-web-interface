package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.opensrp.common.util.ProductType;
import org.opensrp.common.util.Status;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Product;
import org.opensrp.core.entity.ProductPriceLog;
import org.opensrp.core.entity.ProductRole;
import org.opensrp.core.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class ProductMapper {
	
	@Autowired
	private ProductService productService;
	
	public Product map(ProductDTO dto, Product product) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		//User user = (User) auth.getPrincipal();
		product.setName(dto.getName());
		product.setDescription(dto.getDescription());
		product.setPurchasePrice(dto.getPurchasePrice());
		product.setSellingPrice(dto.getSellingPrice());
		product.setTimestamp(System.currentTimeMillis());
		product.setStatus(Status.valueOf(dto.getStatus()).name());
		product.setType(ProductType.valueOf(dto.getType()).name());
		Set<Integer> productRoles = dto.getSellTo();
		Set<ProductRole> _productRoles = new HashSet<>();
		
		if (product.getId() != null) {
			product.setProductRole(null);
			//product.setUpdatedBy(user);
			boolean isDelete = productService.deleteAllByPrimaryKey(product.getId(), "product_role", "product_id");
			if (!isDelete) {
				return null;
			}
		} else {
			//product.setCreator(user);
			product.setUuid(UUID.randomUUID().toString());
		}
		Set<ProductPriceLog> priceLogs = new HashSet<>();
		ProductPriceLog priceLog = new ProductPriceLog();
		priceLog.setProduct(product);
		priceLog.setPurchasePrice(dto.getPurchasePrice());
		priceLog.setSellingPrice(dto.getSellingPrice());
		priceLog.setUuid(UUID.randomUUID().toString());
		//priceLog.setCreator(user);
		priceLogs.add(priceLog);
		product.setProductPriceLogs(priceLogs);
		for (Integer productRole : productRoles) {
			ProductRole _productRole = new ProductRole();
			_productRole.setRole(productRole);
			_productRole.setProduct(product);
			_productRoles.add(_productRole);
		}
		product.setProductRole(_productRoles);
		return product;
		
	}
	
}
