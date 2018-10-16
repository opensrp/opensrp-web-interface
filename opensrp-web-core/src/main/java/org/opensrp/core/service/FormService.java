package org.opensrp.core.service;

import java.util.List;

import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.opensrp.common.interfaces.DatabaseRepository;
import org.opensrp.common.interfaces.DatabaseService;
import org.opensrp.common.util.EntityProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FormService extends EntityProperties implements DatabaseService {
	
	private static final Logger logger = Logger.getLogger(FormService.class);
	
	@Autowired
	private DatabaseRepository repository;
	
	public FormService() {
		
	}
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Transactional
	@Override
	public <T> int delete(T t) {
		return 0;
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@SuppressWarnings("unchecked")
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return (List<T>) repository.findAll(tableClass);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> long update(T t) throws Exception {
		return repository.update(t);
	}
	
}
