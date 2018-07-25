package org.opensrp.web.controller;

import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.web.util.SearchUtil;
import org.opensrp.web.visualization.ChildDataVisualizeServiceImpl;
import org.opensrp.web.visualization.DashboardDataVisualizeServiceImpl;
import org.opensrp.web.visualization.DataVisualization;
import org.opensrp.web.visualization.HighChart;
import org.opensrp.web.visualization.VisualizationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class DashboardController {
	
	private static final Logger logger = Logger.getLogger(DashboardController.class);
	
	private Integer currentYear = Calendar.getInstance().get(Calendar.YEAR);
	
	@Autowired
	private DatabaseServiceImpl databaseServiceImpl;
	
	@Autowired
	SearchBuilder searchBuilder;

	@Autowired
	private SearchUtil searchUtil;

	public VisualizationService visualizationService;

	@Autowired
	private DashboardDataVisualizeServiceImpl dashboardDataVisualizeServiceImpl;

	@Autowired
	private DataVisualization dataVisualization;
	
	@RequestMapping("/")
	public String showHome(HttpServletRequest request, Model model, HttpSession session) throws JSONException {
		searchBuilder.clear();
		int totalChildCount = databaseServiceImpl.getViewDataSize(searchBuilder, "viewJsonDataConversionOfClient", "child");
		session.setAttribute("totalChildCount", totalChildCount);

		searchBuilder.setPregStatus("Yes");
		int totalPregnantCount = databaseServiceImpl.getViewDataSize(searchBuilder, "viewJsonDataConversionOfEvent", "mother");
		session.setAttribute("totalPregnantCount", totalPregnantCount);

		searchBuilder.setPregStatus("Yes");
		String childGrowthFalteringPercentage = databaseServiceImpl.getChildGrowthFalteringPercentage();
		session.setAttribute("childGrowthFalteringPercentage", childGrowthFalteringPercentage);

		visualizationService = dashboardDataVisualizeServiceImpl;
		setHighChartData(request, session);
		setTitles(model, session, "Child");
		return "home";
	}

	private void setHighChartData(HttpServletRequest request, HttpSession session)
			throws JSONException {
		SearchBuilder searchBuilder = searchUtil.generateSearchBuilderParams(request, session);
		if (searchBuilder.getYear() == null || searchBuilder.getYear().isEmpty()) {
			searchBuilder.setYear(currentYear.toString());
		}
		//searchUtil.setProviderAttribute(session);
		searchUtil.setDivisionAttribute(session);
		//searchUtil.setSelectedfilter(request, session);

		List<Object[]> monthWiseData = dataVisualization.getMonthWiseData(searchBuilder, visualizationService);
		/*JSONArray monthWiseSeriesData = HighChart.getMonthWiseSeriesData(monthWiseData);

		List<Object[]> dayWiseData = dataVisualization.getDayWiseData(searchBuilder, visualizationService);
		JSONArray dataJsonArray = HighChart.getDayWiseDrilldownSeriesData(dayWiseData);*/
		JSONArray lineChartData = HighChart.getLineChartData(monthWiseData, searchBuilder.getYear());
		JSONArray lineChartCategory = HighChart.getLineChartCategory(monthWiseData);
		//session.setAttribute("dayWiseData", dataJsonArray);
		session.setAttribute("lineChartData", lineChartData);
		//session.setAttribute("monthWiseSeriesData", monthWiseSeriesData);
		session.setAttribute("lineChartCategory", lineChartCategory);
	}

	private void setTitles(Model model, HttpSession session, String title) {
		model.addAttribute("title", title + " Search Criteria");
		session.setAttribute("chatTitle", title + " Data Visualization");
	}
	
}
