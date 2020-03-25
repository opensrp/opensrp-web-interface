package org.opensrp.common.interfaces;

import org.dom4j.Branch;
import org.opensrp.common.dto.ReportDTO;
import org.opensrp.common.entity.ExportEntity;
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
	
	public List<Object[]> getHouseHoldReports(String startDate, String endDate, String address_value,String searchedValue,List<Object[]> allSKs, Integer searchedValueId);

	public  List<Object[]> getAllSks(List<Object[]> branches);

	public List<Object[]> getSKByBranch(String branchIds);

	public List<Object[]> getClientInformation();

	public List<Object[]> getClientInfoFilter(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs, Integer pageNumber);

	public Integer getClientInfoFilterCount(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs);

	List<Object[]> getByCreator(String username, String formName);

}
