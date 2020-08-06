package org.opensrp.core.mapper;

import java.util.HashSet;
import java.util.Set;

import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Product;
import org.opensrp.core.entity.ProductRole;
import org.springframework.stereotype.Service;

@Service
public class ProductMapper {
	
	public Product map(ProductDTO dto, Product product) {
		
		product.setName(dto.getName());
		product.setDescription(dto.getDescription());
		product.setPurchasePrice(dto.getPurchasePrice());
		product.setSellingPrice(dto.getSellingPrice());
		
		Set<Integer> productRoles = dto.getSellTo();
		Set<ProductRole> _productRoles = new HashSet<>();
		
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
