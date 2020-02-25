package org.opensrp.web.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.io.Reader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.engine.jdbc.connections.spi.ConnectionProvider;
import org.opensrp.common.entity.Marker;
import org.opensrp.common.service.impl.MarkerServiceImpl;
import org.opensrp.common.util.AllConstant;
import org.opensrp.common.util.DefaultRole;
import org.opensrp.core.entity.Permission;
import org.opensrp.core.entity.Role;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.PermissionService;
import org.opensrp.core.service.RoleService;
import org.opensrp.core.service.SimilarRecordService;
import org.opensrp.core.service.UserService;
import org.opensrp.web.nutrition.entity.WeightVelocityChart;
import org.opensrp.web.nutrition.service.WeightVelocityChartService;
import org.opensrp.web.nutrition.utils.GrowthValocityChart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.test.jdbc.JdbcTestUtils;

import com.ibatis.common.jdbc.ScriptRunner;

@Service
public class DefaultApplicationSettingService {
	
	private static final Logger logger = Logger.getLogger(DefaultApplicationSettingService.class);
	
	@Autowired
	private PermissionService permissionServiceImpl;
	
	@Autowired
	private RoleService roleServiceImpl;
	
	@Autowired
	private UserService userServiceImpl;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	private GrowthValocityChart growthValocityChart;
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private MarkerServiceImpl markerServiceImpl;
	
	@Autowired
	private WeightVelocityChartService weightVelocityChartServiceImpl;
	
	@Autowired
	private SimilarRecordService similarRecordService;
	
	public DefaultApplicationSettingService() {
		
	}
	
	public void saveDefaultAppSetting() throws ClassNotFoundException, SQLException, IOException {
		logger.info("saving default settings ...............");
		
		try {
			permissionServiceImpl.addPermission();
		}
		catch (Exception e) {
			logger.error("error adding permissions" + e.getMessage());
		}
		
		//Create default admin User
		String userName = "admin";
		String roleName = DefaultRole.Admin.name();
		Role role = new Role();
		role.setName(roleName);
		role.setActive(true);
		Role gettingRole = roleServiceImpl.findByKey(role.getName(), "name", Role.class);
		
		try {
			if (gettingRole == null) {
				
				Set<Permission> permissions = new HashSet<Permission>();
				List<Permission> allPermissions = permissionServiceImpl.findAll("Permission");
				for (Permission permission : allPermissions) {
					permissions.add(permission);
				}
				role.setPermissions(permissions);
				roleServiceImpl.save(role);
			}
		}
		catch (Exception e) {
			logger.error("error saving roles:" + e.getMessage());
		}
		
//		/** create OpenMRS Role role */
//		for (DefaultRole defaultRole : DefaultRole.values()) {
//
//			Role openmrsRole = new Role();
//			openmrsRole.setName(defaultRole.name());
//			Role findProviderRole = roleServiceImpl.findByKey(openmrsRole.getName(), "name", Role.class);
//			try {
//				if (findProviderRole == null) {
//					roleServiceImpl.save(openmrsRole);
//				} else {
//					logger.info("Role Provider exists");
//				}
//			}
//			catch (Exception e1) {
//				logger.error("problem occured of saving role provder cause:" + e1.getMessage());
//			}
//		}
		
		User account = userServiceImpl.findByKey(userName, "username", User.class);
		User acc = new User();
		acc.setUsername(userName);
		acc.setFirstName(userName);
		acc.setLastName(userName);
		acc.setEnabled(true);
		acc.setEmail("admin@yahoo.com");
		acc.setPassword("admin");
		Role existingRole = roleServiceImpl.findByKey(role.getName(), "name", Role.class);
		Set<Role> roles = new HashSet<Role>();
		roles.add(existingRole);
		acc.setRoles(roles);
		try {
			if (account == null) {
				userServiceImpl.save(acc, false);
			}
		}
		catch (Exception e) {
			logger.error("error saving default user:" + e.getMessage());
		}
		
		addGrowthValocityChart();
		addMarker();
		
		growthValocityChart.getAllGrowthValocityChart();
		
		similarRecordService.getMatchingCriteriaForAllViews();
		similarRecordService.getCloumnNameListForAllViewsWithSimilarRecord();
		
		/*Connection con = sessionFactory.getSessionFactoryOptions().getServiceRegistry().getService(ConnectionProvider.class)
				.getConnection();
		
		//Execute some location, form and provider SQL script automatically
		String rootPath = "";
		try {
			rootPath = new File(".").getCanonicalPath();
		}
		catch (IOException e) {
			logger.error("error getting rootPath: " + e);
		}
		BufferedReader in = new BufferedReader(new FileReader(rootPath + "/src/main/resources/scripts/script_for_grow_plus.sql"));
		LineNumberReader fileReader = new LineNumberReader(in);
		String query = ScriptUtils.readScript(fileReader, ScriptUtils.DEFAULT_COMMENT_PREFIX, ScriptUtils.DEFAULT_STATEMENT_SEPARATOR);

		Statement stmt = null;
		stmt = con.createStatement();
		stmt.execute(query);*/
	}
	
	public void runScript(String aSQLScriptFilePath, ScriptRunner sr) throws FileNotFoundException, IOException,
	    SQLException {
		Reader reader = new BufferedReader(new FileReader(aSQLScriptFilePath));
		sr.runScript(reader);
	}
	
	private void addGrowthValocityChart() {
		/**********/
		// add weight velocity chart when application start up
		/************/
		
		ClassLoader classLoader = getClass().getClassLoader();
		File file = new File(classLoader.getResource("scripts/weight_velocity_chart.csv").getFile());
		BufferedReader br = null;
		String line = "";
		String cvsSplitBy = ",";
		
		try {
			br = new BufferedReader(new FileReader(file));
			int i = 0;
			while ((line = br.readLine()) != null) {
				if (i != 0) {
					String[] weightVelocityChartData = line.split(cvsSplitBy);
					
					Map<String, Object> fielaValues = new HashMap<String, Object>();
					
					WeightVelocityChart weightVelocityChart = new WeightVelocityChart();
					
					int intervals = Integer.parseInt(weightVelocityChartData[0]);
					int age = Integer.parseInt(weightVelocityChartData[1]);
					fielaValues.put("intervals", intervals);
					fielaValues.put("age", age);
					WeightVelocityChart weightVelocityCharts = weightVelocityChartServiceImpl.findAllByKeys(fielaValues,
					    WeightVelocityChart.class);
					if (weightVelocityCharts == null) {
						weightVelocityChart.setIntervals(intervals);
						weightVelocityChart.setAge(age);
						weightVelocityChart.setMaleWeight(Integer.parseInt(weightVelocityChartData[2]));
						weightVelocityChart.setFemaleWeight(Integer.parseInt(weightVelocityChartData[3]));
						try {
							weightVelocityChartServiceImpl.save(weightVelocityChart);
						}
						catch (Exception e) {
							logger.error("Error:" + e.getMessage());
						}
					}
					
				}
				i++;
			}
		}
		catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		finally {
			if (br != null) {
				try {
					br.close();
				}
				catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private void addMarker() {
		Marker entity = new Marker();
		entity.setName(AllConstant.MRAKER_NAME);
		entity.setTimeStamp(0);
		
		try {
			Marker marker = markerServiceImpl.findByName(AllConstant.MRAKER_NAME);
			if (marker == null) {
				markerServiceImpl.save(entity);
			}
			
		}
		catch (Exception e) {
			logger.error("error adding Marker:" + e.getMessage());
		}
	}
	
}
