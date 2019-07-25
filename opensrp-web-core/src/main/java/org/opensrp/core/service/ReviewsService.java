package org.opensrp.core.service;

import org.apache.log4j.Logger;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.core.entity.Facility;
import org.opensrp.core.entity.FacilityWorker;
import org.opensrp.core.util.FacilityHelperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReviewsService {

    private static final Logger logger = Logger.getLogger(FacilityService.class);

    @Autowired
    private DatabaseRepository repository;

    @Transactional
    public <T> long save(T t) throws Exception {
        return repository.save(t);
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
    public <T> T findById(int id, String fieldName, Class<?> className) {
        return repository.findById(id, fieldName, className);
    }

    @Transactional
    public <T> T findByKey(String value, String fieldName, Class<?> className) {
        return repository.findByKey(value, fieldName, className);
    }

    @Transactional
    public <T> T findOneByKeys(Map<String, Object> fielaValues, Class<?> className) {
        return repository.findByKeys(fielaValues, className);
    }

    @Transactional
    public <T> List<T> findAllByKeys(Map<String, Object> fielaValues, Class<?> className) {
        return repository.findAllByKeys(fielaValues, className);
    }

    @Transactional
    public <T> T findLastByKeys(Map<String, Object> fielaValues, String orderByFieldName, Class<?> className) {
        return repository.findLastByKey(fielaValues, orderByFieldName, className);
    }

    @Transactional
    public <T> List<T> findAll(String tableClass) {
        return repository.findAll(tableClass);
    }

}
