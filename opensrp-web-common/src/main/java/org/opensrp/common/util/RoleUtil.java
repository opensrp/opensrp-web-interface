/**
 * 
 */
package org.opensrp.common.util;

/**
 * @author proshanto
 */
public class RoleUtil {
	
	public static boolean containsRole(String role) {
		
		for (DefaultRole c : DefaultRole.values()) {
			if (c.name().equalsIgnoreCase(role) && !c.name().equalsIgnoreCase("Admin") && !c.name().equalsIgnoreCase("SS")) {
				return true;
			}
		}
		
		return false;
	}
}
