package org.opensrp.common.visualization;

import java.util.List;

import org.opensrp.common.util.SearchBuilder;

public interface VisualizationService {

	public List<Object[]> getMonthWiseData(SearchBuilder searchBuilder);

	public List<Object[]> getDayWiseData(SearchBuilder searchBuilder);

}