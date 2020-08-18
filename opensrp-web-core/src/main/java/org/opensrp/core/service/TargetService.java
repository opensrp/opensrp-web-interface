/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.opensrp.common.util.Status;
import org.opensrp.common.util.TaregtSettingsType;
import org.opensrp.core.dto.ProductDTO;
import org.opensrp.core.dto.TargetDTO;
import org.opensrp.core.dto.TargetDetailsDTO;
import org.opensrp.core.entity.TargetDetails;
import org.opensrp.core.entity.User;
import org.opensrp.core.mapper.TargetMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class TargetService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(TargetService.class);
	
	@Autowired
	private TargetMapper targetMapper;
	
	public TargetService() {
		
	}
	
	@Transactional
	public <T> Integer saveAll(TargetDTO dto) throws Exception {
		Session session = getSessionFactory().openSession();
		Transaction tx = null;
		Integer returnValue = null;
		try {
			tx = session.beginTransaction();
			
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			User user = (User) auth.getPrincipal();
			
			Set<TargetDetailsDTO> targetDetailsDTOs = dto.getTargetDetailsDTOs();
			
			List<Integer> targetTos = allTargetUser(dto.getRole(), TaregtSettingsType.valueOf(dto.getType()).name(),
			    dto.getTargetTo());
			
			for (Integer targetTo : targetTos) {
				
				for (TargetDetailsDTO targetDetailsDTO : targetDetailsDTOs) {
					Map<String, Object> fieldValues = new HashMap<>();
					fieldValues.put("year", targetDetailsDTO.getYear());
					fieldValues.put("month", targetDetailsDTO.getMonth());
					fieldValues.put("userId", targetTo);
					TargetDetails targetDetails = findByKeys(fieldValues, TargetDetails.class);
					if (targetDetails == null) {
						targetDetails = new TargetDetails();
						targetDetails.setCreator(user);
					} else {
						targetDetails.setUpdatedBy(user);
					}
					targetDetails = targetMapper.map(targetDetailsDTO, targetDetails);
					targetDetails.setUserId(targetTo);
					session.saveOrUpdate(targetDetails);
					
				}
				
			}
			
			if (!tx.wasCommitted())
				tx.commit();
			
			returnValue = 1;
		}
		catch (HibernateException e) {
			tx.rollback();
			logger.error(e);
			throw new Exception(e.getMessage());
		}
		finally {
			session.close();
		}
		return returnValue;
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
	
	@SuppressWarnings("unchecked")
	public List<Integer> allTargetUser(int roleId, String type, int id) {
		Session session = getSessionFactory().openSession();
		List<Integer> result = null;
		try {
			String hql = "select * from core.get_userid_by_branch_or_location(:roleId,:id,:type);";
			Query query = session.createSQLQuery(hql).setInteger("roleId", roleId).setString("type", type)
			        .setInteger("id", id);
			
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
