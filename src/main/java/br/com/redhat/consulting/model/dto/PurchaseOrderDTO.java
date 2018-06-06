package br.com.redhat.consulting.model.dto;

import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import br.com.redhat.consulting.model.PurchaseOrder;
import br.com.redhat.consulting.model.PurchaseOrderStatusEnum;

@JsonIgnoreProperties(ignoreUnknown=true)
public class PurchaseOrderDTO {
	private Integer id;
	private TaskDTO task;
	private Integer status;
	private PersonDTO person;
	private ProjectDTO project;
	private PartnerOrganizationDTO partnerOrganization;
	private BigDecimal purchaseOrder;
	private BigDecimal totalHours;
	private BigDecimal unitValue;
	private Date registered;
	private Date lastModification;

	public PurchaseOrderDTO() {}

	public PurchaseOrderDTO(PurchaseOrder purchaseOrder) {
		this.id = purchaseOrder.getId();
		this.status = purchaseOrder.getStatus();
		this.totalHours = purchaseOrder.getTotalHours();
		this.purchaseOrder = purchaseOrder.getpurchaseOrder();
		this.unitValue = purchaseOrder.getUnitValue();
		this.registered = purchaseOrder.getRegistered();
		this.lastModification = purchaseOrder.getLastModification();
		if (purchaseOrder.getTask() != null)
			this.task = new TaskDTO(purchaseOrder.getTask());
		
		if (purchaseOrder.getPerson() != null)
			this.person = new PersonDTO(purchaseOrder.getPerson());
	}
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public BigDecimal getTotalHours() {
		return totalHours;
	}
	
	public BigDecimal getpurchaseOrder() {
		return purchaseOrder;
	}

	public void setpurchaseOrder(BigDecimal purchaseOrder) {
		this.purchaseOrder = purchaseOrder;
	}

	public void setTotalHours(BigDecimal totalHours) {
		this.totalHours = totalHours;
	}
	
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public PurchaseOrderStatusEnum getStatusEnum() {
        return PurchaseOrderStatusEnum.find(getStatus());
    }
    
    @JsonIgnore
    public void setStatusEnum(PurchaseOrderStatusEnum poStatusEnum) {
        setStatus(poStatusEnum.getId());
    }
    
    public String getStatusDescription() {
        return getStatusEnum().getDescription();
    }

	public BigDecimal getUnitValue() {
		return unitValue;
	}

	public void setUnitValue(BigDecimal unitValue) {
		this.unitValue = unitValue;
	}

	public Date getRegistered() {
		return registered;
	}

	public void setRegistered(Date registered) {
		this.registered = registered;
	}

	public Date getLastModification() {
		return lastModification;
	}

	public void setLastModification(Date lastModification) {
		this.lastModification = lastModification;
	}
	
    public TaskDTO getTask() {
		return task;
	}

	public void setTask(TaskDTO task) {
		this.task = task;
	}

	public PersonDTO getPerson() {
		return person;
	}

	public void setPerson(PersonDTO person) {
		this.person = person;
	}

	public ProjectDTO getProject() {
		return project;
	}

	public void setProject(ProjectDTO project) {
		this.project = project;
	}

	public PartnerOrganizationDTO getPartnerOrganization() {
		return partnerOrganization;
	}

	public void setPartnerOrganization(PartnerOrganizationDTO partnerOrganization) {
		this.partnerOrganization = partnerOrganization;
	}

	public PurchaseOrder toParchaseOrder() {
    	PurchaseOrder po = new PurchaseOrder();

    	po.setId(id);
    	po.setpurchaseOrder(purchaseOrder);
    	po.setTotalHours(totalHours);
    	po.setUnitValue(unitValue);

        return po;
    }

	@Override
	public String toString() {
		return getClass().getName() + " [id="  + "]";
	}

}
