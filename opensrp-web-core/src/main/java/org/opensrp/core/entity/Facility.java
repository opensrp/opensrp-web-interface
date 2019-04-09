package org.opensrp.core.entity;


import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "facility", schema = "core")
public class Facility implements Serializable {

	private static final long serialVersionUID = 1L;

	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "facility_id_seq")
	@SequenceGenerator(name = "facility_id_seq", sequenceName = "facility_id_seq", allocationSize = 1)
	private int id;

	@NotNull
	@Column(name = "name")
	private String name;

	
	@NotNull
	@Column(name = "hrm_id")
	private String hrmId;

	
	@Column(name = "latitude")
	private String latitude;
	
	
	@Column(name = "longitude")
	private String longitude;
	
	
	@Column(name = "division")
	private String division;
	
	
	@Column(name = "division_code")
	private String divisionCode;
	
	
	@Column(name = "district")
	private String district;
	
	
	@Column(name = "district_code")
	private String districtCode;
	
	
	@Column(name = "upazila")
	private String upazila;
	
	
	@Column(name = "upazila_code")
	private String upazilaCode;
	
	
	@Column(name = "union_name")
	private String union;
	
	
	@Column(name = "union_code")
	private String unionCode;
	
	
	@Column(name = "ward")
	private String ward;
	
	
	@Column(name = "ward_code")
	private String wardCode;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();



	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getHrmId() {
		return hrmId;
	}

	public void setHrmId(String hrmId) {
		this.hrmId = hrmId;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getDivision() {
		return division;
	}

	public void setDivision(String division) {
		this.division = division;
	}

	public String getDivisionCode() {
		return divisionCode;
	}

	public void setDivisionCode(String divisionCode) {
		this.divisionCode = divisionCode;
	}

	public String getDistrict() {
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public String getDistrictCode() {
		return districtCode;
	}

	public void setDistrictCode(String districtCode) {
		this.districtCode = districtCode;
	}


	public String getUpazila() {
		return upazila;
	}

	public void setUpazila(String upazila) {
		this.upazila = upazila;
	}

	public String getUpazilaCode() {
		return upazilaCode;
	}

	public void setUpazilaCode(String upazilaCode) {
		this.upazilaCode = upazilaCode;
	}

	public String getUnion() {
		return union;
	}

	public void setUnion(String union) {
		this.union = union;
	}

	public String getUnionCode() {
		return unionCode;
	}

	public void setUnionCode(String unionCode) {
		this.unionCode = unionCode;
	}

	public String getWard() {
		return ward;
	}

	public void setWard(String ward) {
		this.ward = ward;
	}

	public String getWardCode() {
		return wardCode;
	}

	public void setWardCode(String wardCode) {
		this.wardCode = wardCode;
	}

	public Date getCreated() {
		return created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public Date getUpdated() {
		return updated;
	}

	public void setUpdated(Date updated) {
		this.updated = updated;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((created == null) ? 0 : created.hashCode());
		result = prime * result
				+ ((district == null) ? 0 : district.hashCode());
		result = prime * result
				+ ((districtCode == null) ? 0 : districtCode.hashCode());
		result = prime * result
				+ ((division == null) ? 0 : division.hashCode());
		result = prime * result
				+ ((divisionCode == null) ? 0 : divisionCode.hashCode());
		result = prime * result + ((hrmId == null) ? 0 : hrmId.hashCode());
		result = prime * result + id;
		result = prime * result
				+ ((latitude == null) ? 0 : latitude.hashCode());
		result = prime * result
				+ ((longitude == null) ? 0 : longitude.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((union == null) ? 0 : union.hashCode());
		result = prime * result
				+ ((unionCode == null) ? 0 : unionCode.hashCode());
		result = prime * result
				+ ((upazila == null) ? 0 : upazila.hashCode());
		result = prime * result
				+ ((upazilaCode == null) ? 0 : upazilaCode.hashCode());
		result = prime * result + ((updated == null) ? 0 : updated.hashCode());
		result = prime * result + ((ward == null) ? 0 : ward.hashCode());
		result = prime * result
				+ ((wardCode == null) ? 0 : wardCode.hashCode());
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
		Facility other = (Facility) obj;
		if (created == null) {
			if (other.created != null)
				return false;
		} else if (!created.equals(other.created))
			return false;
		if (district == null) {
			if (other.district != null)
				return false;
		} else if (!district.equals(other.district))
			return false;
		if (districtCode == null) {
			if (other.districtCode != null)
				return false;
		} else if (!districtCode.equals(other.districtCode))
			return false;
		if (division == null) {
			if (other.division != null)
				return false;
		} else if (!division.equals(other.division))
			return false;
		if (divisionCode == null) {
			if (other.divisionCode != null)
				return false;
		} else if (!divisionCode.equals(other.divisionCode))
			return false;
		if (hrmId == null) {
			if (other.hrmId != null)
				return false;
		} else if (!hrmId.equals(other.hrmId))
			return false;
		if (id != other.id)
			return false;
		if (latitude == null) {
			if (other.latitude != null)
				return false;
		} else if (!latitude.equals(other.latitude))
			return false;
		if (longitude == null) {
			if (other.longitude != null)
				return false;
		} else if (!longitude.equals(other.longitude))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (union == null) {
			if (other.union != null)
				return false;
		} else if (!union.equals(other.union))
			return false;
		if (unionCode == null) {
			if (other.unionCode != null)
				return false;
		} else if (!unionCode.equals(other.unionCode))
			return false;
		if (upazila == null) {
			if (other.upazila != null)
				return false;
		} else if (!upazila.equals(other.upazila))
			return false;
		if (upazilaCode == null) {
			if (other.upazilaCode != null)
				return false;
		} else if (!upazilaCode.equals(other.upazilaCode))
			return false;
		if (updated == null) {
			if (other.updated != null)
				return false;
		} else if (!updated.equals(other.updated))
			return false;
		if (ward == null) {
			if (other.ward != null)
				return false;
		} else if (!ward.equals(other.ward))
			return false;
		if (wardCode == null) {
			if (other.wardCode != null)
				return false;
		} else if (!wardCode.equals(other.wardCode))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Facility [id=" + id + ", name=" + name + ", hrmId=" + hrmId
				+ ", latitude=" + latitude + ", longitude=" + longitude
				+ ", division=" + division + ", divisionCode=" + divisionCode
				+ ", district=" + district + ", districtCode=" + districtCode
				+ ", upazilla=" + upazila + ", upazillaCode=" + upazilaCode
				+ ", union=" + union + ", unionCode=" + unionCode + ", ward="
				+ ward + ", wardCode=" + wardCode + ", created=" + created
				+ ", updated=" + updated + "]";
	}

}

