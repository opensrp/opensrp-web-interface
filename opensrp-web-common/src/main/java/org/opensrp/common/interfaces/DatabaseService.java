package org.opensrp.common.interfaces;

import org.opensrp.common.dto.ReportDTO;
import org.opensrp.common.util.SearchBuilder;

import javax.servlet.http.HttpSession;

import java.util.List;

public interface DatabaseService {
	
	public <T> long save(T t) throws Exception;
	
	public <T> long update(T t) throws Exception;
	
	public <T> int delete(T t);
	
	public <T> T findById(int id, String fieldName, Class<?> className);
	
	public <T> T findByKey(String value, String fieldName, Class<?> className);
	
	public <T> List<T> findAll(String tableClass);

	public <T> List<T> getHouseholdListByMHV(String username, HttpSession session);

	public <T> List<T> getMemberListByHousehold(String householdBaseId, String mhvId);

	public <T> T getMemberByHealthId(String healthId);

	public <T> T getMemberByBaseEntityId(String baseEntityId);

	public <T> List<T> getMemberListByCC(String ccName);

	public <T> List<T> getUpazilaList();

	public <T> List<T> getCCListByUpazila(SearchBuilder searchBuilder);

	public List<ReportDTO> getMHVListFilterWise(SearchBuilder searchBuilder);
	
	public List<Object[]> getHouseHoldReports(String address_value);

	public  List<Object[]> getAllSks();

	public List<Object[]> getClientInformation();

	public List<Object[]> getClientInfoFilter(String startTime,String endTime, String formName,String sk);

}
