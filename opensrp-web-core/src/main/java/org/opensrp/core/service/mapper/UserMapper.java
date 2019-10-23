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

        user.setEmail(userDTO.getEmail());
        user.setEnabled(true);
        user.setEnableSimPrint(userDTO.getEnableSimPrint());

        user.setLastName(userDTO.getLastName());
        user.setMobile(userDTO.getMobile());
        user.setPassword(userDTO.getPassword());

        user.setRoles(userService.setRoles(roles));
        User parentUser = userService.findById(userDTO.getParentUser(), "id", User.class);
        user.setParentUser(parentUser);
        user.setBranches(userService.setBranches(branches));

        String ssNo = "";

        if (userDTO.getSsNo() != null && userDTO.getSsNo().length() > 0){
            int length = userDTO.getSsNo().length();
            user.setSsNo(userDTO.getSsNo().substring(1, length));
            ssNo = userDTO.getSsNo();
        }
        user.setUsername(userDTO.getUsername()+ssNo);


        return user;
    }
}
