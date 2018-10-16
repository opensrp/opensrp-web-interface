package org.opensrp.common.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.opensrp.common.interfaces.DatabaseService;
import org.springframework.stereotype.Service;

@Service
public class ExportServiceImpl implements DatabaseService {

	@Override
	public <T> long save(T t) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public <T> long update(T t) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public <T> int delete(T t) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public <T> List<T> findAll(String tableClass) {
		// TODO Auto-generated method stub
		return null;
	}
}
