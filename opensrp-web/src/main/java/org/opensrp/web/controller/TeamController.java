/**
 * @author proshanto
 * */

package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.opensrp.core.entity.Team;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamService;
import org.opensrp.web.util.PaginationUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping(value = "team")
@Controller
public class TeamController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private TeamService teamServiceImpl;
	
	@Autowired
	private Team team;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_TEAM_LIST')")
	@RequestMapping(value = "/list.html", method = RequestMethod.GET)
	public String listTeam(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		model.addAttribute("locale", locale);
		Class<Team> entityClassName = Team.class;
		paginationUtil.createPagination(request, session, entityClassName);
		return "team/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_TEAM')")
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView saveTeam(ModelMap model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("team", new Team());
		String locationName = "";
		teamServiceImpl.setSessionAttribute(session, team, locationName);
		model.addAttribute("locale", locale);
		return new ModelAndView("team/add", "command", team);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_TEAM')")
	@RequestMapping(value = "/add.html", method = RequestMethod.POST)
	public ModelAndView saveTeam(@RequestParam(value = "location", required = false) int locationId,
	                             @RequestParam(value = "superVisor") int supervisorId,
	                             @RequestParam(value = "locationName") String locationName,
	                             @ModelAttribute("team") @Valid Team team, BindingResult binding, ModelMap model,
	                             HttpSession session, Locale locale) throws Exception {
		
		if (!teamServiceImpl.isTeamNameAndIdentifierExists(model, team)) {
			team = teamServiceImpl.setCreatorLocationAndSupervisorAttributeInLocation(team, locationId, supervisorId);
			if (teamServiceImpl.chckeUuid(team, model)) {
				teamServiceImpl.save(team);
			} else {
				teamServiceImpl.setSessionAttribute(session, team, locationName);
				return new ModelAndView("/team/add");
			}
		} else {
			team = teamServiceImpl.setCreatorLocationAndSupervisorAttributeInLocation(team, locationId, supervisorId);
			teamServiceImpl.chckeUuid(team, model);
			teamServiceImpl.setSessionAttribute(session, team, locationName);
			
			return new ModelAndView("/team/add");
		}
		
		return new ModelAndView("redirect:/team/list.html?lang=" + locale);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_TEAM')")
	@RequestMapping(value = "/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editTeam(ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale) {
		model.addAttribute("locale", locale);
		Team team = teamServiceImpl.findById(id, "id", Team.class);
		model.addAttribute("id", id);
		model.addAttribute("team", team);
		String locationName = locationServiceImpl.makeLocationName(team.getLocation());
		teamServiceImpl.setSessionAttribute(session, team, locationName);
		return new ModelAndView("team/edit", "command", team);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_TEAM')")
	@RequestMapping(value = "/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editTeam(@RequestParam(value = "location", required = false) int locationId,
	                             @RequestParam(value = "superVisor") int supervisorId,
	                             @RequestParam(value = "locationName") String locationName,
	                             @ModelAttribute("team") @Valid Team team, BindingResult binding, ModelMap model,
	                             HttpSession session, @PathVariable("id") int id, Locale locale) throws Exception {
		team.setId(id);
		team.setName(team.getName().trim());
		
		if (!teamServiceImpl.isTeamNameAndIdentifierExists(model, team)) {
			team = teamServiceImpl.setCreatorLocationAndSupervisorAttributeInLocation(team, locationId, supervisorId);
			if (teamServiceImpl.chckeUuid(team, model)) {
				teamServiceImpl.update(team);
			} else {
				teamServiceImpl.setSessionAttribute(session, team, locationName);
				return new ModelAndView("/team/edit");
			}
		} else {
			team = teamServiceImpl.setCreatorLocationAndSupervisorAttributeInLocation(team, locationId, supervisorId);
			teamServiceImpl.chckeUuid(team, model);
			teamServiceImpl.setSessionAttribute(session, team, locationName);
			return new ModelAndView("/team/edit");
		}
		
		return new ModelAndView("redirect:/team/list.html?lang=" + locale);
		
	}
}
