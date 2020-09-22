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
import org.opensrp.core.entity.BLC;
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
		if (TrainingLocationType.valueOf(dto.getTrainingLocationType()).name().equalsIgnoreCase("BLC")) {
			
			Map<String, Object> map = new HashMap<>();
			map.put("id", dto.getBlc());
			BLC blc = findByKeys(map, BLC.class);
			
			dto.setDivision(blc.getDivision());
			dto.setDistrict(blc.getDistrict());
			dto.setUpazila(blc.getUpazila());
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
	public List<InventoryDTO> getTrainingAttendanceList(int branchId, int roleId, int ssRoledId,int adminRoleId,int start,int length) {
		
		Session session = getSessionFactory();
		List<InventoryDTO> dtos = new ArrayList<>();
		String hql = " select id,username,role_id roleId, role_name roleName,branch_name branchName,full_name as firstName  from core.training_attendance_list_user(:branchId,:roleId,:ssId,:adminId,:start,:length)";
		Query query = session.createSQLQuery(hql)
		        .addScalar("id", StandardBasicTypes.LONG).addScalar("username", StandardBasicTypes.STRING)
		        .addScalar("roleId", StandardBasicTypes.INTEGER).addScalar("roleName", StandardBasicTypes.STRING)
		        .addScalar("branchName", StandardBasicTypes.STRING).addScalar("firstName", StandardBasicTypes.STRING)
		        .setInteger("branchId", branchId).setInteger("roleId", roleId).setInteger("ssId", ssRoledId)
		        .setInteger("adminId", adminRoleId)
		        .setInteger("start", start).setInteger("length", length)
		        .setResultTransformer(new AliasToBeanResultTransformer(InventoryDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@Transactional
	public int getTrainingAttendanceListCount(int branchId, int roleId,int ssRoledId,int adminRoleId) {
		
		Session session = getSessionFactory();
		BigInteger total = null;
		
		String hql = "select * from core.training_attendance_list_user_count(:branchId,:roleId,:ssId,:adminId)";
		Query query = session.createSQLQuery(hql).setInteger("branchId", branchId).setInteger("roleId", roleId)
		        .setInteger("roleId", roleId).setInteger("ssId", ssRoledId).setInteger("adminId", adminRoleId);
		total = (BigInteger) query.uniqueResult();
		
		return total.intValue();
	}
	
	public JSONObject geTrainingAttendanceListSetOfDataTable(Integer draw, int attendanceListCount, List<InventoryDTO> dtos)
		    throws JSONException {
			JSONObject response = new JSONObject();
			response.put("draw", draw + 1);
			response.put("recordsTotal", attendanceListCount);
			response.put("recordsFiltered", attendanceListCount);
			JSONArray array = new JSONArray();
			for (InventoryDTO dto : dtos) {
				JSONArray training = new JSONArray();
				String checkBox = "<input type=\"checkbox\" class=\"select-checkbox\" id=" + dto.getId() + "\" value="
				        + dto.getId() +"_"+dto.getRoleId()+ ">";
				training.put(checkBox);
				training.put(dto.getFirstName());
				training.put(dto.getUsername());
				training.put(dto.getRoleName());
				training.put(dto.getBranchName());
				array.put(training);
			}
			response.put("data", array);
			return response;
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
				//String view = "<div class='col-sm-12 form-group'><a \" href=\"view-training/" + dto.getId()+">View Details</a> </div>";
				String view = "<div class='col-sm-12 form-group'><a class=\"text-primary\" href=\"view-training/"  + dto.getId()
				        + ".html\"><strong>View details </strong></a> </div>";
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
	public List<TrainingDTO> getTrainingList(int locationId, int branchId, int roledId,String trainingTitle, String startDate,String endDate,
	                                                               Integer length, Integer start, String orderColumn,
	                                                               String orderDirection) {
		
		Session session = getSessionFactory();
		List<TrainingDTO> dtos = new ArrayList<>();
		String hql = " select id,title, start_date startDate,trainee_name nameOfTrainer,user_type audience,location_name locationName from core.training_list(:locationId,:branchId,:roleId,:trainingTitle,:startDate,:endDate,:start,:length)";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("title", StandardBasicTypes.STRING).addScalar("startDate", StandardBasicTypes.DATE)
		        .addScalar("nameOfTrainer", StandardBasicTypes.STRING).addScalar("audience", StandardBasicTypes.STRING)
		        .addScalar("locationName", StandardBasicTypes.STRING)
		        .setInteger("locationId", locationId).setInteger("branchId", branchId).setInteger("roleId", roledId).setString("trainingTitle", trainingTitle)
		        .setString("startDate", startDate).setString("endDate", endDate)
		        .setInteger("length", length).setInteger("start", start)
		        .setResultTransformer(new AliasToBeanResultTransformer(TrainingDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TrainingDTO> getAllTrainingTitle() {
		
		Session session = getSessionFactory();
		List<TrainingDTO> dtos = new ArrayList<>();
		String hql = "select id,name as title from core.training_title";
		Query query = session.createSQLQuery(hql).addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("title", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(TrainingDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	public List<TrainingDTO> getAllBlcList() {
		
		Session session = getSessionFactory();
		List<TrainingDTO> dtos = new ArrayList<>();
		String hql = "select id as blc,code as description from core.blc";
		Query query = session.createSQLQuery(hql).addScalar("blc", StandardBasicTypes.INTEGER)
		        .addScalar("description", StandardBasicTypes.STRING)
		        .setResultTransformer(new AliasToBeanResultTransformer(TrainingDTO.class));
		dtos = query.list();
		
		return dtos;
	}
	
	
	@SuppressWarnings("unchecked")
	@Transactional
	public TrainingDTO getTrainingDetailsListById(int trainingId) {
		
		Session session = getSessionFactory();
		List<TrainingDTO> dtos = new ArrayList<>();
		String hql 	= ""
					+ "WITH training_details "
					+ "     AS (SELECT tr.id, "
					+ "                l.\"name\"  AS division, "
					+ "                ld.\"name\" AS district, "
					+ "                lu.\"name\" AS upazilla, "
					+ "                tr.\"name\" AS title, "
					+ "                tr.description, "
					+ "                tr.designation_of_trainer, "
					+ "                tr.name_of_trainer, "
					+ "                tr.start_date, "
					+ "                tr.duration, "
					+ "                tr.participant_number "
					+ "         FROM   core.training tr "
					+ "                JOIN core.\"location\" l "
					+ "                  ON tr.division_id = l.id "
					+ "                JOIN core.\"location\" ld "
					+ "                  ON tr.district_id = ld.id "
					+ "                JOIN core.\"location\" lu "
					+ "                  ON tr.upazila_id = lu.id), "
					+ "     user_audience "
					+ "     AS (SELECT String_agg(r.\"name\", ',')audience, "
					+ "                tr.id "
					+ "         FROM   core.training tr "
					+ "                JOIN core.training_role trole "
					+ "                  ON trole.training_id = tr.id "
					+ "                JOIN core.\"role\" r "
					+ "                  ON r.id = trole.role_id "
					+ "         GROUP  BY tr.id) "
					+ "SELECT td.id, "
					+ "       td.title, "
					+ "       concat(td.division,' ,',td.district,' ,',td.upazilla) as locationName, "
					+ "       ua.audience, "
					+ "       td.description, "
					+ "       td.designation_of_trainer AS designationOfTrainer, "
					+ "       td.name_of_trainer        AS nameOfTrainer, "
					+ "       td.start_date             AS startDate, "
					+ "       td.duration, " 
					+ "		  td.participant_number AS participantNumber "
					+ "FROM   training_details td "
					+ "       JOIN user_audience ua "
					+ "         ON td.id = ua.id "
					+ "WHERE  td.id = "+trainingId+"";
		Query query = session.createSQLQuery(hql)
				.addScalar("id", StandardBasicTypes.LONG)
		        .addScalar("title", StandardBasicTypes.STRING)
		        .addScalar("locationName", StandardBasicTypes.STRING)
		        .addScalar("audience", StandardBasicTypes.STRING)
		        .addScalar("description", StandardBasicTypes.STRING)
		        .addScalar("designationOfTrainer", StandardBasicTypes.STRING)
		        .addScalar("nameOfTrainer", StandardBasicTypes.STRING)
		        .addScalar("startDate", StandardBasicTypes.DATE)
		        .addScalar("duration", StandardBasicTypes.STRING)
		        .addScalar("participantNumber", StandardBasicTypes.INTEGER)
		        .setResultTransformer(new AliasToBeanResultTransformer(TrainingDTO.class));
		dtos = query.list();
		if(dtos.size() < 1) {
			return null;
		}
		else return dtos.get(0);
	}
	
	
	
}
