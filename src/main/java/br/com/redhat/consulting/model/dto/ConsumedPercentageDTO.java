package br.com.redhat.consulting.model.dto;

public class ConsumedPercentageDTO {
	private String project;
	private Double totalHours;
	private Double consumedHours;
	private String consumedPercentage;
	
	public String getProject() {
		return project;
	}
	
	public void setProject(String project) {
		this.project = project;
	}
	
	public Double getTotalHours() {
		return totalHours;
	}
	
	public void setTotalHours(Double totalHours) {
		this.totalHours = totalHours;
	}
	
	public Double getConsumedHours() {
		return consumedHours;
	}
	
	public void setConsumedHours(Double consumedHours) {
		this.consumedHours = consumedHours;
	}
	
	public String getConsumedPercentage() {
		return consumedPercentage;
	}
	
	public void setConsumedPercentage(String consumedPercentage) {
		this.consumedPercentage = consumedPercentage;
	}
}
