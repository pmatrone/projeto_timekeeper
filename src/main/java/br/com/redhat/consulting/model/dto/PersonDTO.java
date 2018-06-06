package br.com.redhat.consulting.model.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import br.com.redhat.consulting.model.Person;
import br.com.redhat.consulting.model.RoleEnum;

import com.fasterxml.jackson.annotation.JsonIgnore;

public class PersonDTO  {

	private Integer id;
	private Integer oraclePAId;
	private String name;
	private String email;
	private String password;
	private String city;
	private String state;
	private String country;
	private Long telephone1;
	private Long telephone2;
	private PartnerOrganizationDTO organization;
    private PurchaseOrderDTO purchaseOrder;
	
	private RoleDTO role;
	
	private List<TimecardDTO> timecards = new ArrayList<>();
	private List<ProjectDTO> projects = new ArrayList<>();
	private List<TaskDTO> tasks = new ArrayList<>();
	private int numberOfProjects;
	
	// type: consultant partner, redhat manager
	private Integer personType;
	
	private boolean enabled;
	
	private Date registered;
	private Date lastModification;
	private String hash;
	private boolean dissociateOfProject;
	
	public PersonDTO() {}
	
	public PersonDTO(Person p) {
	    id = p.getId();
	    oraclePAId = p.getOraclePAId();
	    name = p.getName();
	    email = p.getEmail();
	    password = p.getPassword();
	    city = p.getCity();
	    state = p.getState();
	    country = p.getCountry();
	    telephone1 = p.getTelephone1();
	    telephone2 = p.getTelephone2();
	    personType = p.getPersonType();
	    enabled = p.isEnabled();
	    registered = p.getRegistered();
	    lastModification = p.getLastModification();
	}
	
    public PersonDTO(Integer oraclePAId, String name, String email, String city, String state, PartnerOrganizationDTO partnerOrganization) {
        this.oraclePAId = oraclePAId;
        this.name = name;
        this.email = email;
        this.city = city;
        this.state = state;
        this.organization = partnerOrganization;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

	public Integer getOraclePAId() {
		return oraclePAId;
	}

	public void setOraclePAId(Integer oraclePAId) {
		this.oraclePAId = oraclePAId;
	}

    public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

    public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

    public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

    public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

    public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public Long getTelephone1() {
		return telephone1;
	}

	public void setTelephone1(Long telephone1) {
		this.telephone1 = telephone1;
	}

	public Long getTelephone2() {
		return telephone2;
	}

	public void setTelephone2(Long telephone2) {
		this.telephone2 = telephone2;
	}

    public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
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
	
    public PartnerOrganizationDTO getOrganization() {
        return organization;
    }

    public void setOrganization(PartnerOrganizationDTO partnerOrganization) {
        this.organization = partnerOrganization;
    }

    public RoleDTO getRole() {
        return role;
    }

    public void setRoleDTO(RoleDTO role) {
        this.role = role;
    }
    
    public Integer getPersonType() {
        return personType;
    }

    public void setPersonType(Integer personType) {
        this.personType = personType;
    }
    
    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
    
    // consultant is the attribute name in the TimecardEntryDTO class
    public List<TimecardDTO> getTimecards() {
        return timecards;
    }

    public void setTimecardsDTO(List<TimecardDTO> timecards) {
        this.timecards = timecards;
    }

    public List<ProjectDTO> getProjects() {
        return projects;
    }

    public void setProjectsDTO(List<ProjectDTO> projects) {
        this.projects = projects;
    }
    
    public void addProject(ProjectDTO project) {
        projects.add(project);
    }

    public List<TaskDTO> getTasks() {
        return tasks;
    }

    public void setTasks(List<TaskDTO> tasks) {
        this.tasks = tasks;
    }
    
    public void addTask(TaskDTO task) {
        this.tasks.add(task);
    }

    public int getNumberOfProjects() {
        return numberOfProjects;
    }

    public void setNumberOfProjects(int numberOfProjects) {
        this.numberOfProjects = numberOfProjects;
    }

    public PurchaseOrderDTO getPurchaseOrder() {
		return purchaseOrder;
	}

	public void setPurchaseOrder(PurchaseOrderDTO purchaseOrder) {
		this.purchaseOrder = purchaseOrder;
	}

    @Override
	public String toString() {
		return "PersonDTO [id=" + getId() + ", name=" + name + ", email=" + email + "]";
	}

    public Person toPerson() {
        Person p = new Person();
        p.setId(id);
        p.setOraclePAId(oraclePAId);
        p.setName(name);
        p.setEmail(email);
        p.setPassword(password);
        p.setCity(city);
        p.setState(state);
        p.setCountry(country);
        p.setTelephone1(telephone1);
        p.setTelephone2(telephone2);
        p.setPersonType(personType);
        p.setEnabled(enabled);
        p.setRegistered(registered);
        p.setLastModification(lastModification);
        return p;
    }
    
    @JsonIgnore
    public boolean isAdminOrProjectManager() {
        RoleEnum currentRole = RoleEnum.find(getRole().getId());
        boolean permit = currentRole.equals(RoleEnum.ADMIN);
        permit = permit || currentRole.equals(RoleEnum.REDHAT_MANAGER);
        return permit;
    }

    @JsonIgnore
    public boolean isPartnerManager(){
        RoleEnum currentRole = RoleEnum.find(getRole().getId());
        boolean permit = currentRole.equals(RoleEnum.PARTNER_MANAGER);
        return permit;
    }

    public String getHash() {
        return hash;
    }

    public void setHash(String hash) {
        this.hash = hash;
    }

    public boolean isDissociateOfProject() {
        return dissociateOfProject;
    }

    public void setDissociateOfProject(boolean dissociateOfProject) {
        this.dissociateOfProject = dissociateOfProject;
    }
    
	
}
