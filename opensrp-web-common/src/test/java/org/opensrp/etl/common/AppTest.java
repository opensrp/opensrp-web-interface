package org.opensrp.etl.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class AppTest extends TestCase {
	
	/**
	 * Create the test case
	 *
	 * @param testName name of the test case
	 */
	
	private final static SimpleDateFormat getYYYYMMDDHHMMSSFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	public AppTest(String testName) {
		super(testName);
	}
	
	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(AppTest.class);
	}
	
	/**
	 * Rigourous Test :-)
	 */
	public void testApp() {
		assertTrue(true);
		try {
			Date d = getYYYYMMDDHHMMSSFormat.parse("2020-11-30 14:30");
			
			System.err.println(d.getTime() + ":" + System.currentTimeMillis());
			
			LocalDateTime now = LocalDateTime.now();
			System.err.println(now.getMinute());
			System.err.println(now.getHour());
		}
		catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
