package org.opensrp.web.controller;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.core.entity.HealthId;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.HealthIdService;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamMemberService;
import org.opensrp.core.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HealthIdController {

	private static final Logger logger = Logger.getLogger(HealthIdController.class);
	
	@Autowired
	private HealthIdService healthIdService;

	@Autowired
	private UserService userService;

	@Autowired
	private LocationService locationService;

	@Autowired
	private TeamMemberService teamMemberService;

	@Autowired
	private HealthId healthId;
	
	private static int CHILD_ROLE_ID = 29;
	private static int LOCATION_TAG_ID = 33;

	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_HEALTH_ID')")
	@RequestMapping(value = "/healthId/upload_csv.html", method = RequestMethod.GET)
	public String csvUpload(HttpSession session, ModelMap model, Locale locale) throws JSONException {
		model.addAttribute("locale", locale);
		return "/health-id/upload_csv";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPLOAD_HEALTH_ID')")
	@RequestMapping(value = "/healthId/upload_csv.html", method = RequestMethod.POST)
	public ModelAndView csvUpload(@RequestParam MultipartFile file, HttpServletRequest request, ModelMap model, Locale locale)
	    throws Exception {
		if (file.isEmpty()) {
			model.put("msg", "Failed to upload the file because it is empty");
			model.addAttribute("msg", "Failed to upload the file because it is empty");
			return new ModelAndView("/health-id/upload_csv");
		} else if (!"text/csv".equalsIgnoreCase(file.getContentType())) {
			model.addAttribute("msg", "File type should be '.csv'");
			return new ModelAndView("/health-id/upload_csv");
		}
		
		String rootPath = request.getSession().getServletContext().getRealPath("/");
		File dir = new File(rootPath + File.separator + "uploadedfile");
		if (!dir.exists()) {
			dir.mkdirs();
		}
		
		File csvFile = new File(dir.getAbsolutePath() + File.separator + file.getOriginalFilename());
		
		try {
			try (InputStream is = file.getInputStream();
			        BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(csvFile))) {
				int i;
				
				while ((i = is.read()) != -1) {
					stream.write(i);
				}
				stream.flush();
			}
		}
		catch (IOException e) {
			model.put("msg", "failed to process file because : " + e.getMessage());
			return new ModelAndView("/health-id/upload_csv");
		}
		String msg = healthIdService.uploadHealthId(csvFile);
		
		model.addAttribute("locale", locale);
		if (!msg.isEmpty()) {
			model.put("msg", msg);
			return new ModelAndView("/health-id/upload_csv");
		}
		return new ModelAndView("redirect:/cbhc-dashboard?lang=" + locale);
	}

	@RequestMapping(value = "/household/generated-code", method = RequestMethod.GET)
	public ResponseEntity<String> getHouseholdIds(@RequestParam("villageId") String villageId,
												  @RequestParam("username") String username) throws Exception {
		int[] villageIds = new int[1000];
		String[] ids = villageId.split(",");
		for (int i = 0; i < ids.length; i++) {
		    villageIds[i] = Integer.parseInt(ids[i]);
        }

		if (villageIds[0] == 0)  {
			User user = userService.findByKey(username, "username", User.class);
			List<Integer> locationIds = locationService.getVillageIdByProvider(user.getId(), CHILD_ROLE_ID, LOCATION_TAG_ID);
			int i = 0;
			for (Integer locationId : locationIds) {
				villageIds[i++] = locationId;
			}
		}
		JSONArray array = healthIdService.generateHouseholdId(villageIds);		
		return new ResponseEntity<>(array.toString(), HttpStatus.OK);
	}
	
}
