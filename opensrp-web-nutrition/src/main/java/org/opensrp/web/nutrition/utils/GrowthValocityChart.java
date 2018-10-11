/**
 * 
 */
package org.opensrp.web.nutrition.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.opensrp.web.nutrition.entity.WeightVelocityChart;
import org.opensrp.web.nutrition.service.WeightVelocityChartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author proshanto
 */
@Service
public class GrowthValocityChart {
	
	@Autowired
	private WeightVelocityChartService weightVelocityChartServiceImpl;
	
	public static List<Map<String, Integer>> growthValocityChart = new ArrayList<Map<String, Integer>>();
	
	public static List<Map<String, Integer>> getGrowthValocityChart() {
		return growthValocityChart;
	}
	
	private GrowthValocityChart() {
		
	}
	
	public List<Map<String, Integer>> getAllGrowthValocityChart() {
		
		if (growthValocityChart.size() == 0) {
			Map<String, Integer> maleGrowthValocityChart = new HashMap<String, Integer>();
			Map<String, Integer> femaleGrowthValocityChart = new HashMap<String, Integer>();
			List<WeightVelocityChart> weightVelocityCharts = weightVelocityChartServiceImpl.findAll("WeightVelocityChart");
			String key = "";
			for (WeightVelocityChart weightVelocityChart : weightVelocityCharts) {
				key = String.valueOf(weightVelocityChart.getIntervals()) + String.valueOf(weightVelocityChart.getAge());
				maleGrowthValocityChart.put(key, (int) weightVelocityChart.getMaleWeight());
				femaleGrowthValocityChart.put(key, (int) weightVelocityChart.getFemaleWeight());
				
			}
			
			growthValocityChart.add(maleGrowthValocityChart);
			growthValocityChart.add(femaleGrowthValocityChart);
			
		}
		return growthValocityChart;
		
	}
}
