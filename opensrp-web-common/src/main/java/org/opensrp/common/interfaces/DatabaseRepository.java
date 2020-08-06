package org.opensrp.common.interfaces;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Session;
import org.opensrp.common.dto.*;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.security.core.userdetails.User;

/**
 * <p>
 * This is the central API class abstracting the notion of a persistence service.<br>
 * </p>
 * <br>
 * The main function of the <tt>DatabaseRepository</tt> is to offer create, read and delete
 * operations for instances of mapped entity classes.<br>
 * Transient instances may be made persistent by calling <tt>save()</tt>, <br>
 * Transient instances may be made update by calling <tt>update()</tt>, <br>
 * Transient instances may be removed from persistent by calling <tt>delete()</tt>, <br>
 * <h1>Some Query API for Entity class:<h1><br />
 * <ul>
 * <li>{@link #findById(int, String, Class)}</li>
 * <li>{@link #findAllByKey(String, String, Class)}</li>
 * <li>{@link #findByKey(String, String, Class)}</li>
 * <li>{@link #findByKeys(Map, Class)}</li>
 * <li>{@link #findLastByKey(Map, String, Class)}</li>
 * <li>{@link #findLastByKeyLessThanDateConditionOneField(Map, Date, String, String, Class)}</li>
 * <li>{@link #findAllByKeys(Map, Class)}</li>
 * <li>{@link #findAllByKeysWithALlMatches(boolean, Map, Class)}</li>
 * <li>{@link #isExists(String, String, Class)}</li>
 * <li>{@link #entityExistsNotEqualThisId(int, Object, String, Class)}</li>
 * <li>{@link #findAllByKey(String, String, Class)}</li>
 * <li>{@link #search(SearchBuilder, int, int, Class)}</li>
 * <li>{@link #countBySearch(SearchBuilder, Class)}</li>
 * <li>{@link #countBySearch(SearchBuilder, Class)}</li>
 * </ul>
 * <p>
 * <br />
 * <h1>Some Query API for View:
 * <h1><br />
 * <ul>
 * <li>{@link #getDataFromViewByBEId(String, String, String)}</li>
 * <li>{@link #getDataFromView(SearchBuilder, int, int, String, String, String)}</li>
 * <li>{@link #getViewDataSize(SearchBuilder, String, String)}</li>
 * </ul>
 * </p>
 * <p>
 * <br />
 * <h1>Some Query API for RAW :
 * <h1><br />
 * <ul>
 * <li>{@link #findAll(String)}</li>
 * <li>{@link #executeSelectQuery(String, Map)}</li>
 * <li>{@link #executeSelectQuery(String)}</li>
 * <li>{@link #getDataFromSQLFunction(SearchBuilder, Query, Session)}</li>
 * </ul>
 * </p>
 *
 * @author proshanto
 * @author nursat
 * @author prince
 * @version 0.1.0
 * @since 2018-05-30
 */
public interface DatabaseRepository {

	public <T> long save(T t) throws Exception;

	public <T> long saveAll(List<T> t) throws Exception;

	public <T> int update(T t);

	public <T> boolean delete(T t);

	public <T> boolean deleteAllByKeys(List<Integer> locationIds, Integer userId);

	public <T> T findById(int id, String fieldName, Class<?> className);

	public <T> List<T> findAllById(List<Integer> ids, String fieldName, String className);

	public <T> T findByForeignKey(int id, String fieldName, String className);

	public <T> List<T> findAllByForeignKey(int id, String fieldName, String className);

	public <T> T findByKey(String value, String fieldName, Class<?> className);

	public <T> List<T> findAll(String tableClass);

	public <T> List<T> findAllLocationPartialProperty(Integer roleId);

	public <T> List<T> findAllLocation(String tableClass);

	public <T> T findByKeys(Map<String, Object> fieldValues, Class<?> className);

	public <T> T findLastByKey(Map<String, Object> fieldValues, String orderByFieldName, Class<?> className);

	public <T> T findLastByKeyLessThanDateConditionOneField(Map<String, Object> fielaValues, Date fieldvalue, String field,
	                                                        String orderByFieldName, Class<?> className);

	public <T> List<T> findAllByKeys(Map<String, Object> fieldValues, Class<?> className);

	public <T> List<T> findAllByKeysWithALlMatches(boolean isProvider, Map<String, String> fielaValues, Class<?> className);

	public boolean isExists(Map<String, Object> fieldValues, Class<?> className);

	public boolean isExistsCustom(String value, Class<?> className);

	public <T> boolean entityExistsNotEqualThisId(int id, T value, String fieldName, Class<?> className);

	public <T> boolean isLocationExists(int parentId, String name, String code, Class<?> className);

	public <T> List<T> findAllByKey(String value, String fieldName, Class<?> className);

	public List<Object[]> executeSelectQuery(String sqlQuery, Map<String, Object> params);

	public <T> List<T> executeSelectQuery(String sqlQuery);

	public <T> List<T> search(SearchBuilder searchBuilder, int result, int offsetreal, Class<?> entityClassName);;

	public int countBySearch(SearchBuilder searchBuilder, Class<?> entityClassName);

	public <T> List<T> getDataFromViewByBEId(String viewName, String entityType, String baseEntityId);

	public <T> List<T> getDataFromView(SearchBuilder searchBuilder, int maxRange, int offsetreal, String viewName,
	                                   String entityType, String orderingBy);

	public int getViewDataSize(SearchBuilder searchBuilder, String viewName, String entityType);

	public <T> List<T> getDataFromSQLFunction(Query query, Session session);

	public <T> List<T> getDataByMHV(String username);

	public <T> List<T> getMemberListByHousehold(String householdBaseId, String mhvId);

	public <T> T getMemberByHealthId(String healthId);

	public <T> T getMemberByBaseEntityId(String baseEntityId);

	public <T> List<T> getMemberListByCC(String ccName);

	public <T> List<T> getUpazilaList();

	public <T> List<T> getCCListByUpazila(SearchBuilder searchBuilder);

	public List<ReportDTO> getMHVListFilterWise(String filterString);

	public <T> List<T> getCatchmentArea(int userId);

	public <T> List<T> getCatchmentAreaForUser(int userId);

	public <T> List<T> getSSListByLocation(Integer locationId, Integer roleId);

	public <T> List<T> getVillageIdByProvider(int memberId, int childRoleId, int locationTagId);

	public <T> T countByField(int id, String fieldName, String className);

	public <T> T maxByHealthId(int id, String fieldName, String className);

	public List<LocationTreeDTO> getProviderLocationTreeByChildRole(int memberId, int childRoleId);

	public List<Object[]> getHouseHoldReports(String startDate, String endDate, String filterString,String searched_value,List<Object[]> allSKs, Integer searchedValueId);

	public List<Object[]> getAllSK(List<Object[]> branches);

	public List<Object[]> getSKByBranch(String branchIds);

	public List<UserDTO> findSKByBranch(Integer branchId);

	public <T> T findSKByLocationSeparatedByComma(Integer locationId, Integer roleId);

	public <T> T findSKByBranchSeparatedByComma(String branchIds);

	public Integer updateParentForSS(Integer ssId, Integer parentId);

	public <T> List<T> getUniqueLocation(String village, String ward);

	public List<Object[]> getClientInformation();

	public List<Object[]> getClientInfoFilter(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs, Integer pageNumber);

	public Integer getClientInfoFilterCount(String startTime, String endTime, String formName, String sk, List<Object[]> allSKs);

	List<Object[]> getExportByCreator(String username, String formName);

	public List<Object[]> getUserListByFilterString(int locationId, int locationTagId, int roleId, int branchId, String name, int limit, int offset, String orderColumn, String orderDirection);

	public <T> T getUserListByFilterStringCount(int locationId, int locationTagId, int roleId, int branchId, String name, int limit, int offset);

	public List<Object[]> getUserListWithoutCatchmentArea(int roleId, int branchId, String name, Integer limit, Integer offset, String orderColumn, String orderDirection);

	public <T> T getUserListWithoutCatchmentAreaCount(int roleId, int branchId, String name);

	public List<UserAssignedLocationDTO> assignedLocationByRole(Integer roleId);

	public int updatePassword(ChangePasswordDTO dto);

	public int deleteCatchmentAreas(List<Integer> ids);

	public <T> List<T> getChildUserByParentUptoUnion(Integer userId, String roleName);

	public <T> List<T> getChildUserByParentUptoVillage(Integer userId, String roleName);

	public <T> List<T> getLocationByAM(Integer userId, Integer roleId);

	public <T> List<T> getSSWithoutCatchmentAreaByAM(Integer userId);

	public Integer updateSSParentBySKAndLocation(Integer skId, Integer ssRoleId, List<Integer> locationList);

	public <T> T findAMByBranchId(Integer branchId);

	public <T> List<T> getLocations(String name, Integer length, Integer start, String orderColumn, String orderDirection);

	public <T> T getLocationCount(String name);

	public <T> List<T> getCOVID19Report(String startDate, String endDate, String query, Integer offset, Integer limit);

	public <T> T getCOVID19ReportCount(String query);

	public <T> List<T> getCOVID19ReportBySK(String startDate, String endDate, String query, Integer offset, Integer limit);

	public <T> List<T> getElcoReport(String startDate, String endDate, String query);

	public <T> List<T> getAggregatedReport(String startDate, String endDate, String query);

	public <T> List<T> getAggregatedBiometricReport(String startDate, String endDate, String query);

	public <T> List<T> getIndividualBiometricReport(String startDate, String endDate, String query);

	public <T> List<T> getPregnancyReport(String startDate, String endDate, String query);

	public <T> List<T> getChildNutritionReport(String startDate, String endDate, String query);

	<T> List<T> getForumReport(String startDate, String endDate, String query);

	<T> List<T> getForumIndividualReport(String startDate, String endDate, String query);
}
