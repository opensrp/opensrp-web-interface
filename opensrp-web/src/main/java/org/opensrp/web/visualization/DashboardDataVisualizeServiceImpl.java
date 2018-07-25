package org.opensrp.web.visualization;

import java.util.List;

import javax.transaction.Transactional;

import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.SearchBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DashboardDataVisualizeServiceImpl  implements VisualizationService{

	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;

	@Transactional
	@Override
	public List<Object[]> getMonthWiseData(SearchBuilder searchBuilder) {
		String query = "select date_part('month', date(last_event_date)),count(date_part('month', date(last_event_date)))"
                + " from " + " core.child_growth "
                + " where date_part('year', date(last_event_date)) = " + searchBuilder.getYear() + " "
                // + SearchCriteria.getSearchCriteria(searchBuilder) 
                + " group by date_part('month', date(last_event_date)) "
                + " order by date_part('month', date(last_event_date)) asc";
		//String sqlQuery = "select * from core.test_tablea";
        return databaseRepositoryImpl.executeSelectQuery(query);
	}

	@Transactional
	@Override
	public List<Object[]> getDayWiseData(SearchBuilder searchBuilder) {
		/*String sqlQuery = DataVisualizationQueryBuilder.getDayWiseDataQuery(searchBuilder, "child");
        return databaseRepositoryImpl.executeRawQuery(searchBuilder, sqlQuery);*/
		return null;
	}

}
