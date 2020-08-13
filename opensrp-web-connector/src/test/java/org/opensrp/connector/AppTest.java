package org.opensrp.connector;

import java.util.Random;

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
		int number = new Random().nextInt(999999);
		String s = String.format("%06d", number);
		System.err.println(s + "23455");
		assertTrue(true);
	}
}
