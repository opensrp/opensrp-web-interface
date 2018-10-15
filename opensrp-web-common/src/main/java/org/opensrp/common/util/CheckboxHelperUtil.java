package org.opensrp.common.util;

public class CheckboxHelperUtil {
	
	public CheckboxHelperUtil() {
		
	}
	
	public static String checkCheckedBox(int[] selectedPermissions, int current) {
		if (selectedPermissions != null) {
			for (int i : selectedPermissions) {
				if (i == current) {
					return "checked";
				}
			}
		}
		return "";
		
	}
}
