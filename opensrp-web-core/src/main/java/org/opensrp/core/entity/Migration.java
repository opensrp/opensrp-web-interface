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
@Table(name = "migration", schema = "core")
public class Migration implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "migration_id_seq")
	@SequenceGenerator(name = "migration_id_seq", sequenceName = "migration_id_seq", allocationSize = 1)
	private int id;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "migration_date")
	private Date migrationDate;
	
	@Column(name = "member_name")
	private String memberName;
	
	@Column(name = "member_contact")
	private String memberContact;
	
	@Column(name = "member_id_in")
	private String memberIDIn;
	
	@Column(name = "member_id_out")
	private String memberIDOut;
	
	@Column(name = "hh_name_in")
	private String HHNameIn;
	
	@Column(name = "hh_name_out")
	private String HHNameOut;
	
	@Column(name = "hh_contact_out")
	private String HHContactOut;
	
	@Column(name = "hh_contact_in")
	private String HHContactIn;
	
	@Column(name = "division_out")
	private String divisionOut;
	
	@Column(name = "division_in")
	private String divisionIn;
	
	@Column(name = "district_out")
	private String districtOut;
	
	@Column(name = "district_in")
	private String districtIn;
	
	@Column(name = "upazila_out")
	private String upazilaOut;
	
	@Column(name = "upazila_in")
	private String upazilaIn;
	
	@Column(name = "pourasava_out")
	private String pourasavaOut;
	
	@Column(name = "pourasava_in")
	private String pourasavaIn;
	
	@Column(name = "union_out")
	private String unionOut;
	
	@Column(name = "union_in")
	private String unionIn;
	
	@Column(name = "village_out")
	private String villageOut;
	
	@Column(name = "village_in")
	private String villageIn;
	
	@Column(name = "village_id_out")
	private String villageIDOut;
	
	@Column(name = "village_id_in")
	private String villageIDIn;
	
	@Column(name = "branch_id_out")
	private String BranchIDOut;
	
	@Column(name = "branch_id_in")
	private String branchIDIn;
	
	@Column(name = "sk_out")
	private String SKOut;
	
	@Column(name = "sk_in")
	private String SKIn;
	
	@Column(name = "ss_out")
	private String SSOut;
	
	@Column(name = "ss_in")
	private String SSIn;
	
	@Column(name = "number_of_member_out")
	private String numberOfMemberOut;
	
	@Column(name = "number_of_member_in")
	private String numberOfMemberIn;
	
	@Column(name = "relation_with_hh_out")
	private String relationWithHHOut;
	
	@Column(name = "relation_with_hh_in")
	private String relationWithHHIn;
	
	private String status;
	
	@Column(name = "is_member")
	private String isMember;
	
	@Column(name = "relational_id_in")
	private String relationalIdIn;
	
	@Column(name = "relational_id_out")
	private String relationalIdOut;
	
	@Column(name = "member_type")
	private String memberType;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "dob")
	private Date dob;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATED_DATE", updatable = false)
	@CreationTimestamp
	private Date created = new Date();
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFIED_DATE", insertable = true, updatable = true)
	@UpdateTimestamp
	private Date updated = new Date();
	
	@Column(name = "base_entity_id")
	private String baseEntityId;
	
	@Column(name = "district_id_out")
	private String districtIdOut;
	
	@Column(name = "district_id_in")
	private String districtIdIn;
	
	@Column(name = "mother_id")
	private String motherId;
	
	@Column(name = "division_id_out")
	private String divisionIdOut;
	
	@Column(name = "division_id_in")
	private String divisionIdIn;
	
	private Long timestamp;
	
	public int getId() {
		return id;
	}
	
	public Date getMigrationDate() {
		return migrationDate;
	}
	
	public void setMigrationDate(Date migrationDate) {
		this.migrationDate = migrationDate;
	}
	
	public String getMemberName() {
		return memberName;
	}
	
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	
	public String getMemberContact() {
		return memberContact;
	}
	
	public void setMemberContact(String memberContact) {
		this.memberContact = memberContact;
	}
	
	public String getMemberIDIn() {
		return memberIDIn;
	}
	
	public void setMemberIDIn(String memberIDIn) {
		this.memberIDIn = memberIDIn;
	}
	
	public String getMemberIDOut() {
		return memberIDOut;
	}
	
	public void setMemberIDOut(String memberIDOut) {
		this.memberIDOut = memberIDOut;
	}
	
	public String getHHNameIn() {
		return HHNameIn;
	}
	
	public void setHHNameIn(String hHNameIn) {
		HHNameIn = hHNameIn;
	}
	
	public String getHHNameOut() {
		return HHNameOut;
	}
	
	public void setHHNameOut(String hHNameOut) {
		HHNameOut = hHNameOut;
	}
	
	public String getHHContactOut() {
		return HHContactOut;
	}
	
	public void setHHContactOut(String hHContactOut) {
		HHContactOut = hHContactOut;
	}
	
	public String getHHContactIn() {
		return HHContactIn;
	}
	
	public void setHHContactIn(String hHContactIn) {
		HHContactIn = hHContactIn;
	}
	
	public String getDivisionOut() {
		return divisionOut;
	}
	
	public void setDivisionOut(String divisionOut) {
		this.divisionOut = divisionOut;
	}
	
	public String getDivisionIn() {
		return divisionIn;
	}
	
	public void setDivisionIn(String divisionIn) {
		this.divisionIn = divisionIn;
	}
	
	public String getDistrictOut() {
		return districtOut;
	}
	
	public void setDistrictOut(String districtOut) {
		this.districtOut = districtOut;
	}
	
	public String getDistrictIn() {
		return districtIn;
	}
	
	public void setDistrictIn(String districtIn) {
		this.districtIn = districtIn;
	}
	
	public String getUpazilaOut() {
		return upazilaOut;
	}
	
	public void setUpazilaOut(String upazilaOut) {
		this.upazilaOut = upazilaOut;
	}
	
	public String getUpazilaIn() {
		return upazilaIn;
	}
	
	public void setUpazilaIn(String upazilaIn) {
		this.upazilaIn = upazilaIn;
	}
	
	public String getPourasavaOut() {
		return pourasavaOut;
	}
	
	public void setPourasavaOut(String pourasavaOut) {
		this.pourasavaOut = pourasavaOut;
	}
	
	public String getPourasavaIn() {
		return pourasavaIn;
	}
	
	public void setPourasavaIn(String pourasavaIn) {
		this.pourasavaIn = pourasavaIn;
	}
	
	public String getUnionOut() {
		return unionOut;
	}
	
	public void setUnionOut(String unionOut) {
		this.unionOut = unionOut;
	}
	
	public String getUnionIn() {
		return unionIn;
	}
	
	public void setUnionIn(String unionIn) {
		this.unionIn = unionIn;
	}
	
	public String getVillageOut() {
		return villageOut;
	}
	
	public void setVillageOut(String villageOut) {
		this.villageOut = villageOut;
	}
	
	public String getVillageIn() {
		return villageIn;
	}
	
	public void setVillageIn(String villageIn) {
		this.villageIn = villageIn;
	}
	
	public String getVillageIDOut() {
		return villageIDOut;
	}
	
	public void setVillageIDOut(String villageIDOut) {
		this.villageIDOut = villageIDOut;
	}
	
	public String getVillageIDIn() {
		return villageIDIn;
	}
	
	public void setVillageIDIn(String villageIDIn) {
		this.villageIDIn = villageIDIn;
	}
	
	public String getBranchIDOut() {
		return BranchIDOut;
	}
	
	public void setBranchIDOut(String branchIDOut) {
		BranchIDOut = branchIDOut;
	}
	
	public String getBranchIDIn() {
		return branchIDIn;
	}
	
	public void setBranchIDIn(String branchIDIn) {
		this.branchIDIn = branchIDIn;
	}
	
	public String getSKOut() {
		return SKOut;
	}
	
	public void setSKOut(String sKOut) {
		SKOut = sKOut;
	}
	
	public String getSKIn() {
		return SKIn;
	}
	
	public void setSKIn(String sKIn) {
		SKIn = sKIn;
	}
	
	public String getSSOut() {
		return SSOut;
	}
	
	public void setSSOut(String sSOut) {
		SSOut = sSOut;
	}
	
	public String getSSIn() {
		return SSIn;
	}
	
	public void setSSIn(String sSIn) {
		SSIn = sSIn;
	}
	
	public String getNumberOfMemberOut() {
		return numberOfMemberOut;
	}
	
	public void setNumberOfMemberOut(String numberOfMemberOut) {
		this.numberOfMemberOut = numberOfMemberOut;
	}
	
	public String getNumberOfMemberIn() {
		return numberOfMemberIn;
	}
	
	public void setNumberOfMemberIn(String numberOfMemberIn) {
		this.numberOfMemberIn = numberOfMemberIn;
	}
	
	public String getRelationWithHHOut() {
		return relationWithHHOut;
	}
	
	public void setRelationWithHHOut(String relationWithHHOut) {
		this.relationWithHHOut = relationWithHHOut;
	}
	
	public String getRelationWithHHIn() {
		return relationWithHHIn;
	}
	
	public void setRelationWithHHIn(String relationWithHHIn) {
		this.relationWithHHIn = relationWithHHIn;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public Date getCreated() {
		return created;
	}
	
	public Date getUpdated() {
		return updated;
	}
	
	public String getIsMember() {
		return isMember;
	}
	
	public void setIsMember(String isMember) {
		this.isMember = isMember;
	}
	
	public String getMemberType() {
		return memberType;
	}
	
	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}
	
	public Date getDob() {
		return dob;
	}
	
	public void setDob(Date dob) {
		this.dob = dob;
	}
	
	public String getRelationalIdIn() {
		return relationalIdIn;
	}
	
	public void setRelationalIdIn(String relationalIdIn) {
		this.relationalIdIn = relationalIdIn;
	}
	
	public String getRelationalIdOut() {
		return relationalIdOut;
	}
	
	public void setRelationalIdOut(String relationalIdOut) {
		this.relationalIdOut = relationalIdOut;
	}
	
	public String getBaseEntityId() {
		return baseEntityId;
	}
	
	public void setBaseEntityId(String baseEntityId) {
		this.baseEntityId = baseEntityId;
	}
	
	public String getDistrictIdOut() {
		return districtIdOut;
	}
	
	public void setDistrictIdOut(String districtIdOut) {
		this.districtIdOut = districtIdOut;
	}
	
	public String getDistrictIdIn() {
		return districtIdIn;
	}
	
	public void setDistrictIdIn(String districtIdIn) {
		this.districtIdIn = districtIdIn;
	}
	
	public String getMotherId() {
		return motherId;
	}
	
	public void setMotherId(String motherId) {
		this.motherId = motherId;
	}
	
	public String getDivisionIdOut() {
		return divisionIdOut;
	}
	
	public void setDivisionIdOut(String divisionIdOut) {
		this.divisionIdOut = divisionIdOut;
	}
	
	public String getDivisionIdIn() {
		return divisionIdIn;
	}
	
	public void setDivisionIdIn(String divisionIdIn) {
		this.divisionIdIn = divisionIdIn;
	}
	
	public Long getTimestamp() {
		return timestamp;
	}
	
	public void setTimestamp(Long timestamp) {
		this.timestamp = timestamp;
	}
	
}
