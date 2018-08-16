package org.opensrp.common.visualization;

import java.util.List;

import org.opensrp.common.util.SearchBuilder;
import org.springframework.stereotype.Service;

@Service
public class DataVisualization {
	public List<Object[]> getMonthWiseData(SearchBuilder searchBuilder, VisualizationService visualizationService) {
		return visualizationService.getMonthWiseData(searchBuilder);
	}

	public List<Object[]> getDayWiseData(SearchBuilder searchBuilder, VisualizationService visualizationService) {
		return visualizationService.getDayWiseData(searchBuilder);
	}

}
