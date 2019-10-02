package org.opensrp.common.util;

public class CheckboxHelperUtil {
	
	public CheckboxHelperUtil() {
		
	}
	
	public static String checkCheckedBox(int[] selectedPermissions, int current) {
		System.out.println("FFF:"+current);
		if (selectedPermissions != null) {
			for (int i : selectedPermissions) {
				System.out.println(""+i+" -- "+ selectedPermissions );
				if (i == current) {
					return "checked";
				}
			}
		}
		return "";
		
	}
}
