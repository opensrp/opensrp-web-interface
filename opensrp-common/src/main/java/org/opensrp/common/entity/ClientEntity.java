package org.opensrp.common.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.codehaus.jackson.annotate.JsonProperty;
import org.exolab.castor.types.DateTime;
import org.springframework.stereotype.Service;

@Service
@Entity
@Table(name = "clientEntity", schema = "core")
public class ClientEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "clientEntity_id_seq")
	@SequenceGenerator(name = "clientEntity_id_seq", sequenceName = "clientEntity_id_seq", allocationSize = 1)
	private int id;

	@JsonProperty
	private String baseEntityId;
	@JsonProperty
    private String firstName;
    @JsonProperty
    private String middleName;
    @JsonProperty
    private String lastName;
    @JsonProperty
    private DateTime birthdate;
    @JsonProperty
    private DateTime deathdate;
    @JsonProperty
    private Boolean birthdateApprox;
    @JsonProperty
    private Boolean deathdateApprox;
    @JsonProperty
    private String gender;
    @JsonProperty
    private String clientType;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getBaseEntityId() {
		return baseEntityId;
	}

	public void setBaseEntityId(String baseEntityId) {
		this.baseEntityId = baseEntityId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getMiddleName() {
		return middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public DateTime getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(DateTime birthdate) {
		this.birthdate = birthdate;
	}

	public DateTime getDeathdate() {
		return deathdate;
	}

	public void setDeathdate(DateTime deathdate) {
		this.deathdate = deathdate;
	}

	public Boolean getBirthdateApprox() {
		return birthdateApprox;
	}

	public void setBirthdateApprox(Boolean birthdateApprox) {
		this.birthdateApprox = birthdateApprox;
	}

	public Boolean getDeathdateApprox() {
		return deathdateApprox;
	}

	public void setDeathdateApprox(Boolean deathdateApprox) {
		this.deathdateApprox = deathdateApprox;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getClientType() {
		return clientType;
	}

	public void setClientType(String clientType) {
		this.clientType = clientType;
	}
	
}

