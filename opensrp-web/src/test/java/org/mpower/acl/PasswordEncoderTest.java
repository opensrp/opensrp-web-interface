package org.mpower.acl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;

import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoderTest {
	
	@Test
	public void dd() {
		System.err.println(new BCryptPasswordEncoder().encode("admin"));
	}
	
	@Test
	public void testGetDigitFormNumber() {
		int number = 85634; // = some int
		List<Integer> digits = new ArrayList<Integer>();
		while (number > 0) {
			
			digits.add((number % 10));
			number = number / 10;
		}
		Collections.reverse(digits);
		
		for (int i = 1; i < digits.size() - 1; i++) {
			System.err.println(digits.get(i));
		}
	}
	
	@Test
	public void dateList() {
		int startYear = 2017;
		int currentYear = Calendar.getInstance().get(Calendar.YEAR);
		
		int yearDiff = currentYear - startYear;
		
	}
}
