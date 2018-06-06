package br.com.redhat.consulting.model;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.envers.Audited;

@Entity
@Table(name = "purchase_order")
@Audited
@DynamicUpdate
public class PurchaseOrder extends AbstractEntity {

	private static final long serialVersionUID = -7278705411657538500L;
	
	private BigDecimal purchaseOrder;
	private BigDecimal totalHours;
	private BigDecimal unitValue;
	private Integer status;
	private Date registered;
	private Date lastModification;
	private Person person;
	private Task task;
	
	public PurchaseOrder() {}
	
	public PurchaseOrder(Integer id) {
		setId(id);
	}
	
	public PurchaseOrder(BigDecimal purchaseOrder, BigDecimal totalHours,
			BigDecimal unitValue, Date registered, Date lastModification) {
		super();
		this.purchaseOrder = purchaseOrder;
		this.totalHours = totalHours;
		this.unitValue = unitValue;
		this.registered = registered;
		this.lastModification = lastModification;
	}
	
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="id_purchase_order")
    public Integer getId() {
        return super.getId();
    }
    
	
	@Column(name="purchase_order")
	public BigDecimal getpurchaseOrder() {
		return purchaseOrder;
	}

	public void setpurchaseOrder(BigDecimal purchaseOrder) {
		this.purchaseOrder = purchaseOrder;
	}

	@Column(name="total_hours")
	public BigDecimal getTotalHours() {
		return totalHours;
	}

	public void setTotalHours(BigDecimal totalHours) {
		this.totalHours = totalHours;
	}
	
    @OneToOne
    @JoinColumn(name="id_person")
    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
	
    @ManyToOne(fetch=FetchType.EAGER)
	@JoinColumn(name="id_task", nullable=true)
    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

	@Column(name="unit_value")
	public BigDecimal getUnitValue() {
		return unitValue;
	}

	public void setUnitValue(BigDecimal unitValue) {
		this.unitValue = unitValue;
	}
	
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Transient
    public PurchaseOrderStatusEnum getStatusEnum() {
        return PurchaseOrderStatusEnum.find(getStatus());
    }
    
    @Transient
    public String getStatusDescription() {
        return getStatusEnum().getDescription();
    }
    
    public void setStatusEnum(PurchaseOrderStatusEnum projectStatusEnum) {
        setStatus(projectStatusEnum.getId());
    }

	@Column(name="registration_date")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getRegistered() {
		return registered;
	}

	public void setRegistered(Date registered) {
		this.registered = registered;
	}

	@Column(name="last_modification")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getLastModification() {
		return lastModification;
	}

	public void setLastModification(Date lastModification) {
		this.lastModification = lastModification;
	}
    /*
    @OneToMany(mappedBy="purchaseOrder",fetch=FetchType.EAGER)
    public List<Task> getTasks() {
        return tasks;
    }

    public void setTasks(List<Task> tasks) {
        this.tasks = tasks;
    }
    
    public void addTask(Task task) {
        this.tasks.add(task);
        task.setPurchaseOrder(this);
    }
*/
	/**
	 * null some attributes, so when this person is copied to a personDTO some
	 * attributes are not sent to the rest responde for security reasons.
	 */
	public void nullifyAttributes() {
		setTotalHours(null);
		setUnitValue(null);
		setRegistered(null);
		setLastModification(null);
	}

	@Override
	public String toString() {
		return "PurchaseOrder [id=" + getId() + "]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((getId() == null) ? 0 : getId().hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		PurchaseOrder other = (PurchaseOrder) obj;
		if (getId() == null) {
			if (other.getId() != null)
				return false;
		} else if (!getId().equals(other.getId()))
			return false;
		return true;
	}

}
