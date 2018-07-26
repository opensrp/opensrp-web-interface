package org.opensrp.web.visualization;

import java.util.List;

import javax.transaction.Transactional;

import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ChildDataVisualizeServiceImpl  implements VisualizationService{

	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;

	@Transactional
	@Override
	public List<Object[]> getMonthWiseData(SearchBuilder searchBuilder) {
		String sqlQuery = "select * from core.test_tablea";
        return databaseRepositoryImpl.executeSelectQuery(sqlQuery);
	}

	@Transactional
	@Override
	public List<Object[]> getDayWiseData(SearchBuilder searchBuilder) {
		/*String sqlQuery = DataVisualizationQueryBuilder.getDayWiseDataQuery(searchBuilder, "child");
        return databaseRepositoryImpl.executeRawQuery(searchBuilder, sqlQuery);*/
		return null;
	}

}
