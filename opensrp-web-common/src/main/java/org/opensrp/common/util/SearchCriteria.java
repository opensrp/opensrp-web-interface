package org.opensrp.common.util;

public class SearchCriteria {
	
	public static String getSearchCriteria(SearchBuilder searchBuilder) {
		String queryCOndition = "";
		
		if (searchBuilder.getDivision() != null && !searchBuilder.getDivision().isEmpty()) {
			queryCOndition += " and division = :division ";
		}
		if (searchBuilder.getDistrict() != null && !searchBuilder.getDistrict().isEmpty()) {
			queryCOndition += " and district = :district ";
		}
		if (searchBuilder.getUpazila() != null && !searchBuilder.getUpazila().isEmpty()) {
			queryCOndition += " and upazila = :upazila ";
		}
		if (searchBuilder.getUnion() != null && !searchBuilder.getUnion().isEmpty()) {
			queryCOndition += " and unions = :unions ";
		}
		if (searchBuilder.getWard() != null && !searchBuilder.getWard().isEmpty()) {
			queryCOndition += " and ward = :ward ";
		}
		if (searchBuilder.getMauzapara() != null && !searchBuilder.getMauzapara().isEmpty()) {
			queryCOndition += " and mauza_para = :mauza_para ";
		}
		if (searchBuilder.getSubunit() != null && !searchBuilder.getSubunit().isEmpty()) {
			queryCOndition += " and subunit = :subunit";
		}
		if (searchBuilder.getProvider() != null && !searchBuilder.getProvider().isEmpty()) {
			queryCOndition += " and provider = :provider ";
		}
		
		return queryCOndition;
	}
}
