package org.opensrp.web.nutrition.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;

public class Interval {
	
	public static double getInterval(Date lastEvent, Date eventDate) {
		
		long diffInMillies = Math.abs(eventDate.getTime() - lastEvent.getTime());
		double diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
		
		return Math.floor(diff / 30);
		
	}
	
}
