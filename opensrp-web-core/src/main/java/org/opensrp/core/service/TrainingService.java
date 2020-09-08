/**
 * @author proshanto
 * */

package org.opensrp.core.service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.CommonDataSource;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.transform.AliasToBeanResultTransformer;
import org.hibernate.type.StandardBasicTypes;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.dto.InventoryDTO;
import org.opensrp.common.dto.TargetCommontDTO;
import org.opensrp.common.util.TrainingLocationType;
import org.opensrp.core.dto.TrainingDTO;
import org.opensrp.core.entity.Branch;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.Training;
import org.opensrp.core.mapper.TrainingMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TrainingService extends CommonService {
	
	private static final Logger logger = Logger.getLogger(TrainingService.class);
	
	@Autowired
	private TrainingMapper trainingMapper;
	
	public TrainingService() {
		
	}
	
	@Transactional
	public Training save(TrainingDTO dto) throws Exception {
		Training training;
		Session session = getSessionFactory();
		if (TrainingLocationType.valueOf(dto.getTrainingLocationType()).name().equalsIgnoreCase("BRANCH")) {
			
			Map<String, Object> map = new HashMap<>();
			map.put("id", dto.getBranch());
			Branch branch = findByKeys(map, Branch.class);
			
			dto.setDivision(branch.getDivision());
			dto.setDistrict(branch.getDistrict());
			dto.setUpazila(branch.getUpazila());
		}
		
		deleteAllByPrimaryKey(dto.getId(), "training_role", "training_id", session);
		deleteAllByPrimaryKey(dto.getId(), "training_user", "training_id", session);
		if (dto.getId() != null && dto.getId() != 0) {
			training = findById(dto.getId(), "id", Training.class);
			training = trainingMapper.map(dto, training);
		} else {
			training = new Training();
			training = trainingMapper.map(dto, training);
		}
		
		session.saveOrUpdate(training);
		
		logger.info("training saved successfully: ");
		
		return training;
		
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<InventoryDTO> getTrainingAttendanceList(int branchId, int roleId, int ssId,int adminId,int start,int length) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		String hql = " select id,username,role_id roleId, role_name roleName,branch_name branchName  from core.training_attendance_list_user(:branchId,:roleId,:ssId,:adminId,:start,:length)";
		//String hql = " select id,username,role_id roleId, role_name roleName,branch_name branchName  from core.training_attendance_list_user(6,32,29,26,0,20)";
		Query query = session.createSQLQuery(hql)
		        .addScalar("id", StandardBasicTypes.LONG).addScalar("username", StandardBasicTypes.STRING)
		        .addScalar("roleId", StandardBasicTypes.INTEGER).addScalar("roleName", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING)
		        .setInteger("branchId", branchId).setInteger("roleId", roleId).setInteger("ssId", ssId)
		        .setInteger("adminId", adminId)
		        .setInteger("start", start).setInteger("length", length)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getTrainingListCount(int locationId, int branchId, int roleId,String startDate,String endDate) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.training_list_count(:locationId,:branchId,:roleId,:startDate,:endDate)";
		Query query = session.createSQLQuery(hql).setInteger("locationId", locationId).setInteger("branchId", branchId)
		        .setInteger("roleId", roleId).setString("startDate", startDate).setString("endDate", endDate);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public JSONObject geTrainingListSetOfDataTable(Integer draw, int trainingListCount, List<TrainingDTO> dtos)
		    throws JSONException {
			JSONObject response = new JSONObject();
			response.put("draw", draw + 1);
			response.put("recordsTotal", trainingListCount);
			response.put("recordsFiltered", trainingListCount);
			JSONArray array = new JSONArray();
			for (TrainingDTO dto : dtos) {
				JSONArray training = new JSONArray();
				training.put(dto.getId());
				training.put(dto.getTitle());
				training.put(dto.getStartDate());
				training.put(dto.getAudience());
				training.put(dto.getNameOfTrainer());
				training.put(dto.getLocationName());
				String view = "<div class='col-sm-12 form-group'><a \" href=\"view-training/" + dto.getId()+">View Details</a> </div>";
				training.put(view);
				array.put(training);
			}
			response.put("data", array);
			return response;
		}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<Role> getRoleFOrTraining(String excludeRoal) {
		
		Session session = getSessionFactory();
		List<Role> dtos = new ArrayList<>();
		
		String hql = "select r.id,r.name from core.role as r where r.name not in('SS','Admin')";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.INTEGER)
		        .addScalar("name", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(Role.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TrainingDTO> getTrainingList(int locationId, int branchId, int roledId, String startDate,String endDate,
	                                                               Integer length, Integer start, String orderColumn,
	                                                               String orderDirection) {
		
		Session session = getSessionFactory();
		List<TrainingDTO> dtos = new ArrayList<>();
		String hql = " select id,title, start_date startDate,trainee_name nameOfTrainer,user_type audience,location_name locationName from core.training_list(:locationId,:branchId,:roleId,:startDate,:endDate,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("branchId", StandardBasicTypes.INTEGER)
		        .addScalar("branchCode", StandardBasicTypes.STRING).addScalar("branchName", StandardBasicTypes.STRING)
		        .addScalar("upazilaName", StandardBasicTypes.STRING).addScalar("userCount", StandardBasicTypes.INTEGER)
		        .setInteger("locationId", locationId).setInteger("branchId", branchId).setInteger("roleId", roledId)
		        .setString("startDate", startDate).setString("endDate", endDate)
		        .setInteger("length", length).setInteger("start", start)
		        .setResultTransformer(new AliasToBeanResultTransformer(TrainingDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
}
