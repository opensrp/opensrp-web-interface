package org.opensrp.common.dto;

public class UpazilaInfoDTO {

	private Integer id;

	private String name;

	private String collectedHousehold;

	private String collectedPopulation;

	private String targetedPopulation;

	private String remainingPopulation;

	private String progress;

	private String regress;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCollectedHousehold() {
		return collectedHousehold;
	}

	public void setCollectedHousehold(String collectedHousehold) {
		this.collectedHousehold = collectedHousehold;
	}

	public String getCollectedPopulation() {
		return collectedPopulation;
	}

	public void setCollectedPopulation(String collectedPopulation) {
		this.collectedPopulation = collectedPopulation;
	}

	public String getTargetedPopulation() {
		return targetedPopulation;
	}

	public void setTargetedPopulation(String targetedPopulation) {
		this.targetedPopulation = targetedPopulation;
	}

	public String getRemainingPopulation() {
		return remainingPopulation;
	}

	public void setRemainingPopulation(String remainingPopulation) {
		this.remainingPopulation = remainingPopulation;
	}

	public String getProgress() {
		return progress;
	}

	public void setProgress(String progress) {
		this.progress = progress;
	}

	public String getRegress() {
		return regress;
	}

	public void setRegress(String regress) {
		this.regress = regress;
	}
}
