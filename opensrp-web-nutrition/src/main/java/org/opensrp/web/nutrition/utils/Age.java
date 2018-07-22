/**
 * 
 */
package org.opensrp.web.nutrition.utils;

import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 * @author proshanto
 */
public class Age {
	
	public static int getApproximateAge(Date dob, Date currentEventDate) {
		return Interval.getInterval(dob, currentEventDate);
		
	}
	
	public static double getAgeInDays(Date dob, Date eventDate) {
		long diffInMillies = Math.abs(eventDate.getTime() - dob.getTime());
		double diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
		return diff;
	}
}
