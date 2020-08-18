/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.List;

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
	
	@SuppressWarnings("unchecked")
	public List<ProductDTO> productListByBranchWithCurrentStock(Integer branchId, Integer roleId) {
		Session session = getSessionFactory().openSession();
		List<ProductDTO> result = null;
		try {
			String hql = "select * from core.product_list_by_branch_with_current_stock(:branchId,:roleId);";
			Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
			        .addScalar("id", StandardBasicTypes.LONG).addScalar("stock", StandardBasicTypes.INTEGER)
			        .setInteger("branchId", branchId).setInteger("roleId", roleId)
			        .setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
			result = query.list();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return result;
	}
	
	public List<ProductDTO> productListWithoutBranch(String productIds, Integer roleId) {
		Session session = getSessionFactory().openSession();
		List<ProductDTO> result = null;
		try {
			String hql = "select * from core.product_list_by_branch_without_current_stock(:roleId,'" + productIds + "');";
			Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
			        .addScalar("id", StandardBasicTypes.LONG).addScalar("stock", StandardBasicTypes.INTEGER)
			        .setInteger("roleId", roleId).setResultTransformer(new AliasToBeanResultTransformer(ProductDTO.class));
			result = query.list();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<Role> getRoleForProduct() {
		Session session = getSessionFactory().openSession();
		List<Role> result = null;
		try {
			String hql = "select * from core.get_role_for_product();";
			Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.INTEGER)
			        .addScalar("name", StandardBasicTypes.STRING)
			        .setResultTransformer(new AliasToBeanResultTransformer(Role.class));
			result = query.list();
		}
		catch (Exception e) {
			logger.error(e);
		}
		finally {
			session.close();
		}
		
		return result;
	}
	
}
