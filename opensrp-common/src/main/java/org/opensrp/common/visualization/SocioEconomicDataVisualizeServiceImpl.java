package org.opensrp.common.visualization;

import java.util.List;

import javax.transaction.Transactional;

import org.opensrp.common.repository.impl.DatabaseRepositoryImpl;
import org.opensrp.common.util.SearchBuilder;
import org.opensrp.common.util.SearchCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SocioEconomicDataVisualizeServiceImpl implements VisualizationService{

	@Autowired
	private DatabaseRepositoryImpl databaseRepositoryImpl;

    @Transactional
    @Override
    public List<Object[]> getMonthWiseData(SearchBuilder searchBuilder) {
        String sqlQuery = "select date_part('month', date(created_date)),count(date_part('month', date(created_date)))"
                + " from " + "core.team "
                + " where date_part('year', date(created_date)) = " + searchBuilder.getYear() + " "
                + SearchCriteria.getSearchCriteria(searchBuilder) + " group by date_part('month', date(created_date)) "
                + " order by date_part('month', date(created_date)) asc";
        return databaseRepositoryImpl.executeSelectQuery(sqlQuery);
    }

    @Transactional
    @Override
    public List<Object[]> getDayWiseData(SearchBuilder searchBuilder) {
        String sqlQuery = "select date(created_date) ,count(date(created_date)) " 
                + " from " + "core.team "
                + " where date_part('year', date(created_date)) = " + searchBuilder.getYear() + " "
                + SearchCriteria.getSearchCriteria(searchBuilder) + " group by date(created_date) "
                + " order by date(created_date) asc";
        return databaseRepositoryImpl.executeSelectQuery(sqlQuery);
    }

}
