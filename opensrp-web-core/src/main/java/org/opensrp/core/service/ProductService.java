/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.List;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.entity.Role;
import org.springframework.stereotype.Service;

@Service
public class ProductService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(ProductService.class);
	
	public ProductService() {
		
	}
	
	@Transactional
	@SuppressWarnings("unchecked")
	public List<ProductDTO> productListByBranchWithCurrentStockWithoutRole(Integer branchId, Integer productId) {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String hql = "select * from core.product_list_by_branch_with_current_stock_without_role(:branchId,:productId);";
		Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.LONG).addScalar("stock", StandardBasicTypes.INTEGER)
		        .setInteger("branchId", branchId).setInteger("productId", productId)
		        .setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		result = query.list();
		
		return result;
	}
	
	@Transactional
	public List<ProductDTO> productListWithoutBranch(String productIds, Integer roleId) {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String hql = "select * from core.product_list_by_branch_without_current_stock(:roleId,'" + productIds + "');";
		Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
		        .addScalar("id", StandardBasicTypes.LONG).addScalar("stock", StandardBasicTypes.INTEGER)
		        .setInteger("roleId", roleId).setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Role> getRoleForProduct() {
		Session session = getSessionFactory();
		List<Role> result = null;
		
		String hql = "select * from core.get_role_for_product();";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("name", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(Role.class));
		result = query.list();
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<ProductDTO> getAllProductListDetails() {
		Session session = getSessionFactory();
		List<ProductDTO> result = null;
		
		String hql = "" + "SELECT p.id, " + "       p.\"name\", " + "       p.selling_price           AS sellingPrice, "
		        + "       p.purchase_price          AS purchasePrice, " + "       p.description, "
		        + "       String_agg(r.\"name\", ',') buyers " + "FROM   core.product p "
		        + "       JOIN core.product_role pr " + "         ON p.id = pr.product_id " + "       JOIN core.\"role\" r "
		        + "         ON pr.role_id = r.id " + "GROUP  BY p.id, " + "          p.\"name\", "
		        + "          p.selling_price, " + "          p.purchase_price, " + "          p.description "
		        + "ORDER  BY p.id ASC";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("name", StandardBasicTypes.STRING).addScalar("sellingPrice", StandardBasicTypes.FLOAT)
		        .addScalar("purchasePrice", StandardBasicTypes.FLOAT).addScalar("description", StandardBasicTypes.STRING)
		        .addScalar("buyers", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
		result = query.list();
		
		return result;
	}
}