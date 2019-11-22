/**
 * 
 */
package org.opensrp.common.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author proshanto
 */
public class DateUtil {
	
	public static DateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd");
	
	private final static SimpleDateFormat getYYYYMMDDFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	private final static SimpleDateFormat getYYYYMMDDHHMMSSFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	private final static SimpleDateFormat getEddMMMyyyyhhmmssz = new SimpleDateFormat("E, dd MMM yyyy hh:mm:ss z");
	
	private final static SimpleDateFormat getYYYYMMDDTHHMMSSFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:sss");
	
	public enum Months {
		JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC
	}
	
	public static Date parseDate(String date) throws ParseException {
		try {
			return yyyyMMdd.parse(date);
		}
		catch (ParseException e) {}
		return null;
		
	}
	
	public static List<Integer> getYearList() {
		List<Integer> years = new ArrayList<Integer>();
		Integer startYear = 2017;
		Integer currentYear = Calendar.getInstance().get(Calendar.YEAR);
		int yearDiff = currentYear - startYear;
		for (int i = 0; i <= yearDiff; i++) {
			years.add(currentYear - i);
		}
		return years;
		
	}
	
	public static String getMonthName(int position) {
		return Months.values()[position].name();
		
	}
	
	public static Date getDateFromString(JSONObject doc, String key) throws ParseException, JSONException {
		Date date = null;
		if (doc.has(key) && !"null".equalsIgnoreCase(doc.getString(key)) && !doc.getString(key).isEmpty()) {
			date = getYYYYMMDDFormat.parse(doc.getString(key));
			return date;
		}
		return date;
	}
	
	public static Date getDateTimeFromString(JSONObject doc, String key) throws ParseException, JSONException {
		Date date = null;
		if (doc.has(key) && !"null".equalsIgnoreCase(doc.getString(key)) && !doc.getString(key).isEmpty()) {
			date = getYYYYMMDDHHMMSSFormat.parse(doc.getString(key));
		}
		return date;
	}
	
	public static Date getDateFromGMTString(JSONObject doc, String key) throws ParseException, JSONException {
		Date date = null;
		
		if (doc.has(key) && !"null".equalsIgnoreCase(doc.getString(key)) && !doc.getString(key).isEmpty()
		        && !"Invalid Date".equalsIgnoreCase(doc.getString(key))) {
			date = getEddMMMyyyyhhmmssz.parse(doc.getString(key));
			return getYYYYMMDDFormat.parse(getYYYYMMDDFormat.format(date));
		}
		return date;
	}

	public static Date getFirstDayOfMonth(Date date) {
		Calendar calendar = Calendar.getInstance();   // this takes current date
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		return calendar.getTime();
	}

	public static Date getDateTFromString(JSONObject doc, String key) throws ParseException, JSONException {
		Date date = null;
		if (doc.has(key) && !"null".equalsIgnoreCase(doc.getString(key)) && !doc.getString(key).isEmpty()) {
			date = getYYYYMMDDTHHMMSSFormat.parse(doc.getString(key));
			return date;
		}
		return date;
	}
	public static Date atEndOfDay(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR_OF_DAY, 23);
		calendar.set(Calendar.MINUTE, 59);
		calendar.set(Calendar.SECOND, 59);
		calendar.set(Calendar.MILLISECOND, 999);
		return calendar.getTime();
	}

	public static Date atStartOfDay(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		return calendar.getTime();
	}

}
