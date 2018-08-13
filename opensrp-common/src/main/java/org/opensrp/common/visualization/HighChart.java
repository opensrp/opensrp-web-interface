package org.opensrp.common.visualization;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.util.DateUtil;

public class HighChart {
	public static JSONArray getLineChartData(List<Object[]> monthWiseCountData, String year) throws JSONException {
		JSONArray lineChartSeriesData = new JSONArray();
		JSONArray array = new JSONArray();
		JSONObject dataJsonObject = new JSONObject();
		for (Object[] row : monthWiseCountData) {
			array.put(row[1]);
		}
		dataJsonObject.put("name", year);
		dataJsonObject.put("data", array);
		lineChartSeriesData.put(dataJsonObject);
		return lineChartSeriesData;
	}

	public static JSONArray getLineChartCategory(List<Object[]> monthWiseCountData) throws JSONException {

		JSONArray lineChartCategory = new JSONArray();

		for (Object[] row : monthWiseCountData) {
			Double monthNumber = Double.parseDouble(row[0].toString());
			lineChartCategory.put(DateUtil.getMonthName((int) Math.round(monthNumber) - 1));
		}

		return lineChartCategory;
	}
}
