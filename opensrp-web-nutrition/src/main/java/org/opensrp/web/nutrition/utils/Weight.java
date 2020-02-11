package org.opensrp.web.nutrition.utils;

public class Weight {
	
	public static double getWeightInGram(double lastWeight, double currentWeight) {
		
		double weight = (currentWeight - lastWeight) * 1000;
		
		return weight;
		
	}
}
