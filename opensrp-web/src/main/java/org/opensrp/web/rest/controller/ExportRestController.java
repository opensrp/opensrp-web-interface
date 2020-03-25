package org.opensrp.web.rest.controller;

import org.apache.commons.lang.StringUtils;
import org.json.JSONObject;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@RequestMapping("rest/api/v1/export")
@RestController
public class ExportRestController {

    @Autowired
    private DatabaseServiceImpl databaseServiceImpl;

    @RequestMapping(value = "/data", method = RequestMethod.GET)
    public ResponseEntity<String> exportData(
            @RequestParam(value = "branch", required = false, defaultValue = "0") String branch,
            HttpSession session,
            HttpServletRequest request) throws Exception {

        JSONObject error = new JSONObject();
        error.put("identifiers", "");

        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        List<String> roleName = new ArrayList<String>();
        Set<Role> roles = (Set<Role>) user.getRoles();
        for (Role role : roles) {
            roleName.add(role.getName());
        }

        String formName = request.getParameter("formName").replaceAll(" ", "-");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String userName = user.getUsername();
        String userType = roleName.get(0);
        String sk = request.getParameter("sk");
        String params = "branch="+branch+"&form_name="+formName+"&start="+startDate+"&end="+endDate+"&sk="+sk+"&user="+userName+"&user_type="+userType;
        if(!formName.equalsIgnoreCase("covid19") & params.equals(session.getAttribute("params"))) return new ResponseEntity<String>("", HttpStatus.OK);
        StringBuffer content = new StringBuffer();
        try {
            URL url = new URL("http://localhost:9070/data-export?"+params);
            if (formName.equalsIgnoreCase("covid19")) url = new URL("http://localhost:9070/data-export/covid-19?"+params);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

            String inputLine;
            while ((inputLine = br.readLine()) != null) {
                content.append(inputLine);
            }
            conn.disconnect();

        }
        catch (MalformedURLException e) {

            e.printStackTrace();
            return new ResponseEntity<String>(error.toString(), HttpStatus.INTERNAL_SERVER_ERROR);

        }
        catch (IOException e) {

            e.printStackTrace();
            return new ResponseEntity<String>(error.toString(), HttpStatus.INTERNAL_SERVER_ERROR);

        }
        session.setAttribute("params", params);
        return new ResponseEntity<String>(content.toString(), HttpStatus.OK);
    }

    @RequestMapping(value = "/download-data", method = RequestMethod.GET)
    public List<Object[]>  getExportTable(HttpSession session, @RequestParam(value = "formName", required = true) String formName) {

        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        List<String> roleName = new ArrayList<String>();
        Set<Role> roles = (Set<Role>) user.getRoles();
        for (Role role : roles) {
            roleName.add(role.getName());
        }
        return  databaseServiceImpl.getByCreator(user.getUsername(), formName);
    }
}
