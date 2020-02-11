package org.opensrp.web.nutrition.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;

public class Interval {
	
	public static int getInterval(Date lastEvent, Date curentEventDate) {
		
		long diffInMillies = Math.abs(curentEventDate.getTime() - lastEvent.getTime());
		double diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
		
		double interval;
		double precesion = diff / 30 - Math.floor(diff / 30);
		if (precesion >= .5) {
			interval = Math.ceil(diff / 30);
		} else {
			interval = Math.floor(diff / 30);
		}
		
		return (int) interval;
		
	}
}
