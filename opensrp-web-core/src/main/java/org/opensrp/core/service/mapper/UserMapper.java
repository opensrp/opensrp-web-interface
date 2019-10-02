package org.opensrp.core.service.mapper;

import org.opensrp.common.dto.UserDTO;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserMapper {

    @Autowired
    private UserService userService;

    public User map(UserDTO userDTO) {
        User user = new User();
        String[] roles = userDTO.getRoles().split(",");
        String[] branches = userDTO.getBranches().split(",");

        user.setFirstName(userDTO.getFirstName());
        user.setGender("");
        user.setIdetifier(userDTO.getIdetifier());

        user.setUsername(userDTO.getUsername());
        user.setEmail(userDTO.getEmail());
        user.setEnabled(true);

        user.setLastName(userDTO.getLastName());
        user.setMobile(userDTO.getMobile());
        user.setPassword(userDTO.getPassword());
        user.setEnableSimPrint(userDTO.isEnableSimPrint());

        user.setRoles(userService.setRoles(roles));
        User parentUser = userService.findById(userDTO.getParentUser(), "id", User.class);
        user.setParentUser(parentUser);
        user.setBranches(userService.setBranches(branches));

        return user;
    }
}
