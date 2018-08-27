package org.opensrp.common.visualization;

import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opensrp.common.util.DateUtil;

import org.opensrp.common.util.DateUtil.Months;;

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

	public static JSONArray getMultiLineChartData(List<Object[]> monthWiseCountData, String years) throws JSONException {
		JSONArray lineChartSeriesData = new JSONArray();
		String prevYear = "";
		JSONArray array = new JSONArray();
		JSONObject dataJsonObject = new JSONObject();

		if (monthWiseCountData != null) {
			for (Object[] row : monthWiseCountData) {
				if (prevYear.equalsIgnoreCase("")
						|| String.valueOf(row[0]).equalsIgnoreCase(prevYear)) {
					array.put(row[2]);
					prevYear = String.valueOf(row[0]);
				} else {
					dataJsonObject.put("name", prevYear);
					dataJsonObject.put("data", array);
					lineChartSeriesData.put(dataJsonObject);

					array = new JSONArray();
					dataJsonObject = new JSONObject();
					array.put(row[2]);
					prevYear = String.valueOf(row[0]);
				}
			}
			dataJsonObject.put("name", prevYear);
			dataJsonObject.put("data", array);
			lineChartSeriesData.put(dataJsonObject);
		}
		return lineChartSeriesData;
	}

	public static JSONArray getMultiLineChartCategory(List<Object[]> monthWiseCountData) throws JSONException {
		JSONArray lineChartCategory = new JSONArray();
		List<Months> monthList = Arrays.asList(Months.values());

		for (Months month : monthList) {
			lineChartCategory.put(month);
		}

		return lineChartCategory;
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