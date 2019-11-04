package org.opensrp.web.repository;

import org.ektorp.Page;
import org.opensrp.core.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository("userRepository")
public interface UserRepository extends JpaRepository<User, Long> {

	@Query("select u from User u")
	Page<User> getClientInfoFilter(Pageable pageable);
}
