/**
 * @author proshanto
 * */

package org.opensrp.acl.service.impl;

import java.util.List;

import javax.transaction.Transactional;

import org.opensrp.acl.service.AclService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.PermissionName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PermissionServiceImpl implements AclService {
	
	@Autowired
	private DatabaseRepositoryImpl repository;
	
	public PermissionServiceImpl() {
		
	}
	
	public void addPermission() throws Exception {
		for (PermissionName permission : PermissionName.values()) {
			if (findByKey(permission.name(), "name", org.opensrp.acl.entity.Permission.class) == null) {
				org.opensrp.acl.entity.Permission perm = new org.opensrp.acl.entity.Permission();
				perm.setName(permission.name());
				save(perm);
			}
		}
	}
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		return repository.save(t);
	}
	
	@Override
	public <T> int update(T t) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public <T> boolean delete(T t) {
		// TODO Auto-generated method stub
		return false;
	}
	
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		// TODO Auto-generated method stub
		return repository.findAll("Permission");
	}
}
