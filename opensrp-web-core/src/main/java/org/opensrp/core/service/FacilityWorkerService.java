package org.opensrp.core.service;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityTraining;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.entity.FacilityWorkerType;
import org.opensrp.core.util.FacilityHelperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FacilityWorkerService {

	private static final Logger logger = Logger
			.getLogger(FacilityWorkerService.class);

	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;

	@Autowired
	private FacilityService facilityService;

	@Autowired
	private FacilityWorkerTrainingService facilityWorkerTrainingService;

	@Autowired
	private FacilityWorkerTypeService facilityWorkerTypeService;

	@Autowired
	private FacilityHelperUtil facilityHelperUtil;

	@Transactional
	public <T> long save(T t) throws Exception {
		return databaseRepositoryImpl.save(t);
	}

	@Transactional
	public <T> int update(T t) throws Exception {
		return databaseRepositoryImpl.update(t);
	}

	@Transactional
	public <T> boolean delete(T t) {
		return databaseRepositoryImpl.delete(t);
	}

	@Transactional
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findById(id, fieldName, className);
	}

	@Transactional
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return databaseRepositoryImpl.findByKey(value, fieldName, className);
	}

	@Transactional
	public <T> T findOneByKeys(Map<String, Object> fielaValues,
			Class<?> className) {
		return databaseRepositoryImpl.findByKeys(fielaValues, className);
	}

	@Transactional
	public <T> List<T> findAllByKeys(Map<String, Object> fielaValues,
			Class<?> className) {
		return databaseRepositoryImpl.findAllByKeys(fielaValues, className);
	}

	@Transactional
	public <T> T findLastByKeys(Map<String, Object> fielaValues,
			String orderByFieldName, Class<?> className) {
		return databaseRepositoryImpl.findLastByKey(fielaValues,
				orderByFieldName, className);
	}

	@Transactional
	public <T> List<T> findAll(String tableClass) {
		return databaseRepositoryImpl.findAll(tableClass);
	}

	/**
	 * Get Facility in which the user want to add a new FacilityWorker and set it to session
	 * <p>
	 * <ol>
	 *	<li> Set all FacilityWorkerType and all FacilityWorkerTraining to session </li>
	 *	<li> Find Facility by facilityId </li>
	 *	<li> Set facilityName to session</li>
	 *	<li> Set facilityId to session</li>
	 *  <li> Get list of all FacilityWorker of that Facility by facilityId </li>
	 *  <li> Find count of different types of FacilityWorker (DistinctWorkerCount) from that list</li>
	 *  <li> Set DistinctWorkerCount of the Facility to session</li>
	 * </ol> 
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> setWorkerToAddToSession(session,22) ;
	 * @param session HttpSession
	 * @param facilityId id of Facility
	 * @return
	 */
	public void setWorkerToAddToSession(HttpSession session, int facilityId) {
		facilityHelperUtil.setFacilityWorkerTypeAndTrainingsToSession(session);
		Facility facility = facilityService.findById(facilityId, "id",
				Facility.class);
		session.setAttribute("facilityName", facility.getName());
		session.setAttribute("facilityId", facilityId);
		List<FacilityWorker> facilityWorkerList = facilityService
				.getFacilityWorkerList(facilityId);
		Map<Integer, Integer> distinctWorkerCountMap = facilityHelperUtil
				.getDistinctWorkerCount(facilityWorkerList);
		session.setAttribute("distinctWorkerCountMap", distinctWorkerCountMap);

	}

	/**
	 * Get FacilityWorker that the user want to edit and set it to session
	 * <p>
	 * <ol>
	 *	<li> Set all FacilityWorkerType and all FacilityWorkerTraining to session </li>
	 *	<li> Find FacilityWorker by workerId </li>
	 *	<li> Set FacilityWorker to session</li>
	 * </ol>
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> setWorkerToEditToSession(session,45) ;
	 * @param session HttpSession
	 * @param workerId id of FacilityWorker
	 * @return
	 */
	public void setWorkerToEditToSession(HttpSession session, int workerId) {
		facilityHelperUtil.setFacilityWorkerTypeAndTrainingsToSession(session);
		FacilityWorker facilityWorker = findById(workerId, "id",
				FacilityWorker.class);
		session.setAttribute("workerToEdit", facilityWorker);
	}

	/**
	 * Fulfill all the prerequisites and save new FacilityWorker
	 * <p>
	 * <ol>
	 *	<li> Set training to FacilityWorker </li>
	 *	<li> Set worker-type to FacilityWorker </li>
	 *	<li> Save FacilityWorker </li>
	 * </ol>
	 * </p>
	 * <br/>
	 * <b> How to invoke:</b> long i = saveFacilityWorker(facilityWorker,1, "1,4,7") ;
	 * @param facilityWorker FacilityWorker-object
	 * @param facilityWorkerTypeId id of FacilityWorkerType
	 * @param trainings training of FacilityWorker
	 * @return 1 for success and -1 for failure.
	 */
	@Transactional
	public long saveFacilityWorker(FacilityWorker facilityWorker,
			int facilityWorkerTypeId, String trainings) throws Exception {
		if (!trainings.equals("")) {
			String[] trainingList = trainings.split(",");

			Set<FacilityTraining> facilityTrainings = new HashSet<FacilityTraining>();
			for (int i = 0; i < trainingList.length; i++) {
				FacilityTraining facilityTraining = facilityWorkerTrainingService
						.findById(Integer.parseInt(trainingList[i]), "id",
								FacilityTraining.class);
				if (facilityTraining != null) {
					facilityTrainings.add(facilityTraining);
				}
				facilityWorker.setFacilityTrainings(facilityTrainings);
			}

		}
		FacilityWorkerType facilityWorkerType = facilityWorkerTypeService
				.findById(facilityWorkerTypeId, "id", FacilityWorkerType.class);
		facilityWorker.setFacilityWorkerType(facilityWorkerType);
		return save(facilityWorker);
	}
}
