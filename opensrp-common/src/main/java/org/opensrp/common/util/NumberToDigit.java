package org.opensrp.common.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class NumberToDigit {
	
	public static List<Integer> getDigitFromNumber(int number) {
		
		List<Integer> digits = new ArrayList<Integer>();
		while (number > 0) {
			digits.add((number % 10));
			number = number / 10;
		}
		Collections.reverse(digits);
		
		return digits;
	}
}
