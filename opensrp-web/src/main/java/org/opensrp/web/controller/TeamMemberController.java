/**
 * @author proshanto
 * */

package org.opensrp.web.controller;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.JSONException;
import org.opensrp.core.entity.TeamMember;
import org.opensrp.core.entity.User;
import org.opensrp.core.service.LocationService;
import org.opensrp.core.service.TeamMemberService;
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

@RequestMapping(value = "team/teammember")
@Controller
public class TeamMemberController {
	
	@Autowired
	private LocationService locationServiceImpl;
	
	@Autowired
	private TeamMemberService teamMemberServiceImpl;
	
	@Autowired
	private TeamMember teamMember;
	
	@Autowired
	private PaginationUtil paginationUtil;
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_READ_TEAM_MEMBER_LIST')")
	@RequestMapping(value = "/list.html", method = RequestMethod.GET)
	public String locationList(HttpServletRequest request, HttpSession session, Model model, Locale locale) {
		Class<TeamMember> entityClassName = TeamMember.class;
		paginationUtil.createPagination(request, session, entityClassName);
		model.addAttribute("locale", locale);
		return "team-member/index";
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_TEAM_MEMBER')")
	@RequestMapping(value = "/add.html", method = RequestMethod.GET)
	public ModelAndView saveTeamMember(ModelMap model, HttpSession session, Locale locale) throws JSONException {
		model.addAttribute("teamMember", new TeamMember());
		String personName = "";
		model.addAttribute("locale", locale);
		session.setAttribute("locationList", locationServiceImpl.list().toString());
		int[] locations = new int[0];
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		return new ModelAndView("team-member/add", "command", teamMember);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_WRITE_TEAM_MEMBER')")
	@RequestMapping(value = "/add.html", method = RequestMethod.POST)
	public ModelAndView saveTeamMember(@RequestParam(value = "person", required = false) int personId,
	                                   @RequestParam(value = "personName") String personName,
	                                   @RequestParam(value = "team") int teamId,
	                                   @RequestParam(value = "locationList[]", required = false) int[] locations,
	                                   @ModelAttribute("teamMember") @Valid TeamMember teamMember, BindingResult binding,
	                                   ModelMap model, HttpSession session, Locale locale) throws Exception {
		teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember, personId,
		    teamId, locations);
		
		if (!teamMemberServiceImpl.isPersonAndIdentifierExists(model, teamMember, locations)) {
			teamMemberServiceImpl.save(teamMember);
		} else {
			teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
			return new ModelAndView("/team-member/add");
		}
		
		return new ModelAndView("redirect:/team/teammember/list.html?lang=" + locale);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_TEAM_MEMBER')")
	@RequestMapping(value = "/{id}/edit.html", method = RequestMethod.GET)
	public ModelAndView editTeamMember(ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws JSONException {
		model.addAttribute("locale", locale);
		TeamMember teamMember = teamMemberServiceImpl.findById(id, "id", TeamMember.class);
		model.addAttribute("id", id);
		model.addAttribute("teamMember", teamMember);
		int[] locations = teamMemberServiceImpl.getLocationIds(teamMember.getLocations());
		User person = teamMember.getPerson();
		String personName = person.getUsername() + " (" + person.getFullName() + ")";
		teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
		
		return new ModelAndView("team-member/edit", "command", teamMember);
		
	}
	
	@PostAuthorize("hasPermission(returnObject, 'PERM_UPDATE_TEAM_MEMBER')")
	@RequestMapping(value = "/{id}/edit.html", method = RequestMethod.POST)
	public ModelAndView editTeamMember(@RequestParam(value = "person", required = false) int personId,
	                                   @RequestParam(value = "personName") String personName,
	                                   @RequestParam(value = "team") int teamId,
	                                   @RequestParam(value = "locationList[]", required = false) int[] locations,
	                                   @ModelAttribute("teamMember") @Valid TeamMember teamMember, BindingResult binding,
	                                   ModelMap model, HttpSession session, @PathVariable("id") int id, Locale locale)
	    throws Exception {
		teamMember.setId(id);
		teamMember = teamMemberServiceImpl.setCreatorLocationAndPersonAndTeamAttributeInLocation(teamMember, personId,
		    teamId, locations);
		if (!teamMemberServiceImpl.isPersonAndIdentifierExists(model, teamMember, locations)) {
			teamMemberServiceImpl.update(teamMember);
			
		} else {
			teamMemberServiceImpl.setSessionAttribute(session, teamMember, personName, locations);
			return new ModelAndView("/team-member/edit");
		}
		
		return new ModelAndView("redirect:/team/teammember/list.html?lang=" + locale);
		
	}
}
