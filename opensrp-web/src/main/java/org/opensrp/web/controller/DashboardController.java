package org.opensrp.web.controller;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.service.impl.DatabaseServiceImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.common.visualization.DashboardDataVisualizeServiceImpl;
import org.opensrp.common.visualization.DataVisualization;
import org.opensrp.common.visualization.HighChart;
import org.opensrp.common.visualization.VisualizationService;
import org.opensrp.web.nutrition.entity.ChildGrowth;
import org.opensrp.web.util.SearchUtil;
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
	
	@RequestMapping("/nutrition-dashboard")
	public String showHome(HttpServletRequest request, Model model, HttpSession session, Locale locale) throws JSONException {
		/*Different types of data counts and percentages*/
		List<Object> dashboardAggregatedList = databaseServiceImpl
		        .executeSelectQuery("select * from core.fn_growplus_dashboard_data_count()");
		session.setAttribute("dashboardAggregatedList", dashboardAggregatedList);
		
		/*Line chart data*/
		visualizationService = dashboardDataVisualizeServiceImpl;
		setHighChartData(request, session);
		setTitles(model, session, "Child");
		
		/*Maps data*/
		JSONObject featureCollectionOfGrowthFaltering = createGeoJSON(false);
		session.setAttribute("featureCollectionOfGrowthFaltering", featureCollectionOfGrowthFaltering);
		model.addAttribute("locale", locale);
		JSONObject featureCollectionOfAdequateGrowth = createGeoJSON(true);
		session.setAttribute("featureCollectionOfAdequateGrowth", featureCollectionOfAdequateGrowth);
		
		return "home";
	}
	
	private JSONObject createGeoJSON(boolean flag) throws JSONException {
		
		/* Sample geoJSON:
		 * {type: 'FeatureCollection',
		        features: [{
		            type: 'Feature',
		            geometry: {
		            type: 'Point',
		            coordinates: [90.4043, 23.7940]
		            },
		            properties: {
		            title: 'Mapbox',
		            description: 'Banani'
		            }
		         },
		        {
		            type: 'Feature',
		            geometry: {
		            type: 'Point',
		            coordinates: [90.3442, 23.7837]
		            },
		            properties: {
		            title: 'Mapbox',
		            description: 'Gabtoli'
		            }
		        }]
		    };*/
		Map<String, Object> fieldValues = new HashMap<String, Object>();
		fieldValues.put("growthStatus", flag);
		List<ChildGrowth> geoDatas = databaseServiceImpl.findAllByKeys(fieldValues, ChildGrowth.class);
		JSONObject featureCollection = new JSONObject();
		featureCollection.put("type", "FeatureCollection");
		
		JSONArray features = new JSONArray();
		
		if (geoDatas != null && !geoDatas.isEmpty()) {
			for (ChildGrowth row : geoDatas) {
				if (row.getLon() != 0.0) {
					//co-odinates [90.4043, 23.7940]
					JSONObject feature = new JSONObject();
					feature.put("type", "Feature");
					JSONObject geometry = new JSONObject();
					geometry.put("type", "Point");
					JSONArray JSONArrayCoord = new JSONArray();
					
					JSONArrayCoord.put(row.getLon());
					JSONArrayCoord.put(row.getLat());
					geometry.put("coordinates", JSONArrayCoord);
					feature.put("geometry", geometry);
					JSONObject properties = new JSONObject();
					
					properties.put("title", row.getFirst_name());
					
					properties.put("gender", row.getGender());
					properties.put("age", row.getAge());
					properties.put("weight", row.getWeight());
					properties.put("provider", row.getProvider());
					feature.put("properties", properties);
					features.put(feature);
				}
			}
		}
		featureCollection.put("features", features);
		
		return featureCollection;
	}
	
	private void setHighChartData(HttpServletRequest request, HttpSession session) throws JSONException {
		SearchBuilder searchBuilder = searchUtil.generateSearchBuilderParams(request, session);
		if (searchBuilder.getYear() == null || searchBuilder.getYear().isEmpty()) {
			searchBuilder.setYear(currentYear.toString());
		}
		searchUtil.setDivisionAttribute(session);
		List<Object[]> monthWiseData = dataVisualization.getMonthWiseData(searchBuilder, visualizationService);
		
		JSONArray lineChartData = HighChart.getMultiLineChartData(monthWiseData, searchBuilder.getYear());
		JSONArray lineChartCategory = HighChart.getMultiLineChartCategory(monthWiseData);
		session.setAttribute("lineChartData", lineChartData);
		session.setAttribute("lineChartCategory", lineChartCategory);
	}
	
	private void setTitles(Model model, HttpSession session, String title) {
		model.addAttribute("title", title + " Search Criteria");
		session.setAttribute("chatTitle", title + " Data Visualization");
	}
	
}
