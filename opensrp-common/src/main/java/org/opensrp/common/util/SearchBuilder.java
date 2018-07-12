package org.opensrp.common.util;

import org.springframework.stereotype.Component;

@Component
public class SearchBuilder {
	
	private String division;
	
	private String district;
	
	private String upazila;
	
	private String union;
	
	private String ward;
	
	private String subunit;
	
	private String mauzapara;
	
	private String provider;
	
	private String name;
	
	private String userName;
	
	private String search;
	
	private String year;
	
	public SearchBuilder() {
		
	}
	
	public SearchBuilder clear() {
		this.setDivision("");
		this.setDistrict("");
		this.setUpazila("");
		this.setUnion("");
		this.setWard("");
		this.setSubunit("");
		this.setMauzapara("");
		this.setProvider("");
		this.setName("");
		this.setSearch("");
		this.setYear("");
		this.setUserName("");
		return this;
		
	}
	
	public String getYear() {
		return year;
	}
	
	public SearchBuilder setYear(String year) {
		this.year = year;
		return this;
	}
	
	public String getDivision() {
		return division;
	}
	
	public SearchBuilder setDivision(String division) {
		this.division = division;
		return this;
	}
	
	public String getDistrict() {
		return district;
	}
	
	public SearchBuilder setDistrict(String district) {
		this.district = district;
		return this;
	}
	
	public String getUpazila() {
		return upazila;
	}
	
	public SearchBuilder setUpazila(String upazila) {
		this.upazila = upazila;
		return this;
	}
	
	public String getUnion() {
		return union;
	}
	
	public SearchBuilder setUnion(String union) {
		this.union = union;
		return this;
	}
	
	public String getWard() {
		return ward;
	}
	
	public SearchBuilder setWard(String ward) {
		this.ward = ward;
		return this;
	}
	
	public String getSubunit() {
		return subunit;
	}
	
	public SearchBuilder setSubunit(String subunit) {
		this.subunit = subunit;
		return this;
	}
	
	public String getMauzapara() {
		return mauzapara;
	}
	
	public SearchBuilder setMauzapara(String mauzapara) {
		this.mauzapara = mauzapara;
		return this;
	}
	
	public String getProvider() {
		return provider;
	}
	
	public SearchBuilder setProvider(String provider) {
		this.provider = provider;
		return this;
	}
	
	public String getName() {
		return name;
	}
	
	public SearchBuilder setName(String name) {
		this.name = name;
		return this;
	}
	
	public String getSearch() {
		return search;
	}
	
	public SearchBuilder setSearch(String search) {
		this.search = search;
		return this;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public SearchBuilder setUserName(String userName) {
		this.userName = userName;
		return this;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((district == null) ? 0 : district.hashCode());
		result = prime * result + ((division == null) ? 0 : division.hashCode());
		result = prime * result + ((mauzapara == null) ? 0 : mauzapara.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((provider == null) ? 0 : provider.hashCode());
		result = prime * result + ((search == null) ? 0 : search.hashCode());
		result = prime * result + ((subunit == null) ? 0 : subunit.hashCode());
		result = prime * result + ((union == null) ? 0 : union.hashCode());
		result = prime * result + ((upazila == null) ? 0 : upazila.hashCode());
		result = prime * result + ((userName == null) ? 0 : userName.hashCode());
		result = prime * result + ((ward == null) ? 0 : ward.hashCode());
		result = prime * result + ((year == null) ? 0 : year.hashCode());
		return result;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SearchBuilder other = (SearchBuilder) obj;
		if (district == null) {
			if (other.district != null)
				return false;
		} else if (!district.equals(other.district))
			return false;
		if (division == null) {
			if (other.division != null)
				return false;
		} else if (!division.equals(other.division))
			return false;
		if (mauzapara == null) {
			if (other.mauzapara != null)
				return false;
		} else if (!mauzapara.equals(other.mauzapara))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (provider == null) {
			if (other.provider != null)
				return false;
		} else if (!provider.equals(other.provider))
			return false;
		if (search == null) {
			if (other.search != null)
				return false;
		} else if (!search.equals(other.search))
			return false;
		if (subunit == null) {
			if (other.subunit != null)
				return false;
		} else if (!subunit.equals(other.subunit))
			return false;
		if (union == null) {
			if (other.union != null)
				return false;
		} else if (!union.equals(other.union))
			return false;
		if (upazila == null) {
			if (other.upazila != null)
				return false;
		} else if (!upazila.equals(other.upazila))
			return false;
		if (userName == null) {
			if (other.userName != null)
				return false;
		} else if (!userName.equals(other.userName))
			return false;
		if (ward == null) {
			if (other.ward != null)
				return false;
		} else if (!ward.equals(other.ward))
			return false;
		if (year == null) {
			if (other.year != null)
				return false;
		} else if (!year.equals(other.year))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return "SearchBuilder [division=" + division + ", district=" + district + ", upazila=" + upazila + ", union="
		        + union + ", ward=" + ward + ", subunit=" + subunit + ", mauzapara=" + mauzapara + ", provider=" + provider
		        + ", name=" + name + ", userName=" + userName + ", search=" + search + ", year=" + year + "]";
	}
	
}
