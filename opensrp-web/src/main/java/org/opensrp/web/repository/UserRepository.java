package org.opensrp.web.repository;

import org.ektorp.Page;
import org.opensrp.core.entity.User;
import org.opensrp.web.model.ClientInfo;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

	@Query("select u from User as u")
	public Page<User> getClientInfoFilter(Pageable pageable);
}
