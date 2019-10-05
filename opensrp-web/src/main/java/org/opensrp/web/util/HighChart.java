package org.opensrp.web.util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class HighChart {

	public static JSONArray countPopulation(List<Object[]> objects3) throws JSONException {
		JSONArray countPopulationArray = new JSONArray();

		JSONObject a = new JSONObject();
		a.put("name", "Total Collected Population");
		a.put("y", objects3.get(0)[2]);
		countPopulationArray.put(a);

		a = new JSONObject();

		a.put("name", "Total Targeted Population");
		a.put("y", objects3.get(0)[3]);

		countPopulationArray.put(a);
		return countPopulationArray;
	}

	public static JSONArray categories(List<Object[]> data) {
		JSONArray outcome = new JSONArray();
		for (Object[] list: data) {
			outcome.put(list[0]);
		}
		return outcome;
	}

	public static JSONArray maleFemaleChart(List<Object[]> data) throws JSONException {
		JSONArray outcome = new JSONArray();
		JSONObject male = new JSONObject();
		JSONObject female = new JSONObject();
		JSONObject total = new JSONObject();
		JSONArray males = new JSONArray();
		JSONArray females = new JSONArray();
		JSONArray totals = new JSONArray();
		for (Object[] list: data) {
			males.put(list[1]);
			females.put(list[2]);
			totals.put(list[3]);
		}
		male.put("name", "Male");
		male.put("data", males);
		female.put("name", "Female");
		female.put("data", females);
		total.put("name", "Total");
		total.put("data", totals);
		outcome.put(male);
		outcome.put(female);
		outcome.put(total);
		return outcome;
	}
}
