package org.opensrp.core.service;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.UsersCatchmentArea;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class UsersCatchmentAreaService {

    private static final Logger logger = Logger.getLogger(UsersCatchmentAreaService.class);

    @Autowired
    private DatabaseRepository repository;

    @Autowired
    private SessionFactory sessionFactory;

    @Transactional
    public <T> long save(T t) throws Exception {
        return repository.save(t);
    }

    @Transactional
    public <T> long saveAll(List<T> t) throws Exception {
        return repository.saveAll(t);
    }

    @Transactional
    public <T> int update(T t) throws Exception {
        return repository.update(t);
    }

    @Transactional
    public <T> boolean delete(T t) {
        return repository.delete(t);
    }

    @Transactional
    public <T> boolean deleteAllByKeys(List<Integer> locationIds, Integer userId) {
        return repository.deleteAllByKeys(locationIds, userId);
    }


    @Transactional
    public <T> T findById(int id, String fieldName, Class<?> className) {
        return repository.findById(id, fieldName, className);
    }

    @Transactional
    public <T> T findByKey(String value, String fieldName, Class<?> className) {
        return repository.findByKey(value, fieldName, className);
    }

    @Transactional
    public <T> List<T> findAllByForeignKey(int value, String fieldName, String className) {
        return repository.findAllByForeignKey(value, fieldName, className);
    }


    @Transactional
    public <T> T findOneByKeys(Map<String, Object> fielaValues, Class<?> className) {
        return repository.findByKeys(fielaValues, className);
    }

    @Transactional
    public <T> List<T> findAllByKeys(Map<String, Object> fieldValues) {
        return repository.findAllByKeys(fieldValues, UsersCatchmentArea.class);
    }

    @Transactional
    public <T> T findLastByKeys(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className) {
        return repository.findLastByKey(fielaValues, orderByFieldName, className);
    }

    @Transactional
    public <T> List<T> findAll(String tableClass) {
        return repository.findAll(tableClass);
    }

    @Transactional
    public Integer deleteAllByParentAndUser(int parentId, int userId) {
        Session session = sessionFactory.openSession();
        Integer usersCatchmentAreas = 0;
        try {
            String hql = "delete from core.users_catchment_area where parent_location_id = :parentId and user_id = :userId";
            usersCatchmentAreas = session.createSQLQuery(hql)
                    .setInteger("parentId", parentId)
                    .setInteger("userId", userId).executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            session.close();
        }

        return usersCatchmentAreas;
    }

    public Integer deleteByUser(Integer userId) {
        Session session = sessionFactory.openSession();
        Integer usersCatchmentAreas = 0;
        try {
            String hql = "delete from core.users_catchment_area where user_id = :userId";
            usersCatchmentAreas = session.createSQLQuery(hql)
                    .setInteger("userId", userId).executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            session.close();
        }

        return usersCatchmentAreas;
    }

    @Transactional
    public List<Object[]> getUsersCatchmentAreaTableAsJson(int userId) {
        return repository.getCatchmentArea(userId);
    }

    @Transactional
    public int deleteCatchmentAreas(List <Integer> ids) {
        return repository.deleteCatchmentAreas(ids);
    }

    @Transactional
    public List<Object[]> getCatchmentAreaForUserAsJson(int userId) {
        return repository.getCatchmentAreaForUser(userId);
    }

}
