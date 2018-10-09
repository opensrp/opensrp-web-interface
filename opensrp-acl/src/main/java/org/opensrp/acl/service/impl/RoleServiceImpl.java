/**
 * @author proshanto
 * */

package org.opensrp.acl.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.transaction.Transactional;

import org.opensrp.acl.entity.Permission;
import org.opensrp.acl.entity.Role;
import org.opensrp.acl.service.AclService;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.RoleUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoleServiceImpl implements AclService {
	
	@Autowired
	private DatabaseRepositoryImpl repository;
	
	public RoleServiceImpl() {
		
	}
	
	@Transactional
	@Override
	public <T> long save(T t) throws Exception {
		
		return repository.save(t);
	}
	
	@Transactional
	@Override
	public <T> int update(T t) {
		return repository.update(t);
	}
	
	@Transactional
	@Override
	public <T> boolean delete(T t) {
		return false;
	}
	
	@Transactional
	@Override
	public <T> T findById(int id, String fieldName, Class<?> className) {
		return repository.findById(id, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> T findByKey(String value, String fieldName, Class<?> className) {
		return repository.findByKey(value, fieldName, className);
	}
	
	@Transactional
	@Override
	public <T> List<T> findAll(String tableClass) {
		return repository.findAll(tableClass);
	}
	
	public Set<Permission> setPermissions(int[] selectedPermissions) {
		Set<Permission> permissions = new HashSet<Permission>();
		if (selectedPermissions != null) {
			for (int permissionId : selectedPermissions) {
				Permission permission = repository.findById(permissionId, "id", Permission.class);
				permissions.add(permission);
			}
		}
		return permissions;
	}
	
	public boolean isOpenMRSRole(Set<Role> roles) {
		boolean isProvider = false;
		for (Role role : roles) {
			isProvider = RoleUtil.containsRole(role.getName());
			if (isProvider) {
				return isProvider;
			}
		}
		return isProvider;
	}
}
