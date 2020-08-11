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
import org.opensrp.common.util.Status;
import org.opensrp.core.dto.ProductDTO;
import org.springframework.stereotype.Service;

@Service
public class TargetService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(TargetService.class);
	
	public TargetService() {
		
	}
	
	@SuppressWarnings("unchecked")
	public List<ProductDTO> allActiveTarget(int roleId) {
		Session session = getSessionFactory().openSession();
		List<ProductDTO> result = null;
		try {
			String hql = "select name,p.id from core.product p join core.product_role pr on p.id=pr.product_id  where status=:status and pr.role_id=:roleId ";
			
			Query query = session.createSQLQuery(hql).addScalar("name", StandardBasicTypes.STRING)
			        .addScalar("id", StandardBasicTypes.LONG).setString("status", Status.ACTIVE.name())
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
	
}
