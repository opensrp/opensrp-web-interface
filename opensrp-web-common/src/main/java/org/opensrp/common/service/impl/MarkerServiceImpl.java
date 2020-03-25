/**
 * 
 */
package org.opensrp.common.service.impl;

import java.util.List;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.hibernate.SessionFactory;
import org.opensrp.common.dto.ReportDTO;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author proshanto
 */

@Service
public class MarkerServiceImpl implements DatabaseService {
	
	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		
		return databaseRepositoryImpl.save(t);
	}
	
	@Transactional
	@Override
	public <T> long update(T t) throws Exception {
		
		return databaseRepositoryImpl.update(t);
	}
	
	@Transactional
	@Override
	public <T> int delete(T t) {
		
		return 0;
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		
		return null;
	}

	@Override
	public <T> List<T> getHouseholdListByMHV(String username, HttpSession session) {
		return null;
	}

	@Override
	public <T> List<T> getMemberListByHousehold(String householdBaseId, String mhvId) {
		return null;
	}

	@Override
	public <T> T getMemberByHealthId(String healthId) {
		return null;
	}

	@Override
	public <T> T getMemberByBaseEntityId(String baseEntityId) {
		return null;
	}

	@Override
	public <T> List<T> getMemberListByCC(String ccName) {
		return null;
	}

	@Override
	public <T> List<T> getUpazilaList() {
		return null;
	}

	@Override
	public <T> List<T> getCCListByUpazila(SearchBuilder searchBuilder) {
		return null;
	}

	@Override
	public List<ReportDTO> getMHVListFilterWise(SearchBuilder searchBuilder) {
		return null;
	}

	@Override
	public List<Object[]> getHouseHoldReports(String startDate, String endDate, String address_value, String searchedValue, List<Object[]> allSKs, Integer searchedValueId) {
		return null;
	}



  
  @Override
	public List<Object[]> getAllSks(List<Object[]> branches) {
		return null;
	}

	@Override
	public List<Object[]> getSKByBranch(String branchIds) {
		return null;
	}

	@Override
	public List<Object[]> getClientInformation() {
		return null;
	}

	@Override
	public List<Object[]> getClientInfoFilter(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs, Integer pageNumber) {
		return null;
	}

	public Integer getClientInfoFilterCount(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs){
		return null;
	}

	@Override
	public List<Object[]> getByCreator(String username, String formName) {
		return null;
	}

	@Transactional
	public Marker findByName(String name) {
		// TODO Auto-generated method stub
		return databaseRepositoryImpl.findByKey(name, "name", Marker.class);
	}

	public List<Object[]> getByCreator(String username){
		return null;
	}
}
