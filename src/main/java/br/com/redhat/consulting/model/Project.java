package br.com.redhat.consulting.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.envers.Audited;

@Entity
@Table(name="project")
@Audited
@DynamicUpdate
public class Project extends AbstractEntity {

    private static final long serialVersionUID = 1L;

    private String name;
    private String description;

    // oracle PA number
    private Integer paNumber;
    
    // Red Hat project manager
    private Person projectManager;
    private Boolean enabled;
    private Boolean usePMSubstitute;

    private Date initialDate;
    private Date endDate;
    
    private Date registered;
    private Date lastModification;
    
    private List<Timecard> timecards = new ArrayList<>();
    private List<Task> tasks = new ArrayList<>();
    
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="id_project")
    public Integer getId() {
        return super.getId();
    }

    @NotNull
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name="description")
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    @Column(name="pa_number")
    @NotNull
    public Integer getPaNumber() {
        return paNumber;
    }

    public void setPaNumber(Integer paNumber) {
        this.paNumber = paNumber;
    }

    @OneToOne
    @JoinColumn(name="id_pm")
    @NotNull
    public Person getProjectManager() {
        return projectManager;
    }

    public void setProjectManager(Person projectManager) {
        this.projectManager = projectManager;
    }

//    @ManyToMany(cascade=CascadeType.MERGE)
//    @JoinTable(name="person_project", joinColumns=@JoinColumn(name="id_project"), inverseJoinColumns=@JoinColumn(name="id_person"))
//    public Set<Person> getConsultants() {
//        return consultants;
//    }
//
//    public void setConsultants(Set<Person> consultants) {
//        this.consultants = consultants;
//    }
//    
//    public void addConsultant(Person consultant) {
//        consultants.add(consultant);
//    }

    @Column(name="enabled")
    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean active) {
        this.enabled = active;
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

    @OneToMany(mappedBy="project")
    public List<Timecard> getTimecards() {
        return timecards;
    }

    public void setTimecards(List<Timecard> timecards) {
        this.timecards = timecards;
    }

    @Temporal(TemporalType.DATE)
    @Column(name="initial_date")
    @NotNull
    public Date getInitialDate() {
        return initialDate;
    }

    public void setInitialDate(Date initialDate) {
        this.initialDate = initialDate;
    }

    @Temporal(TemporalType.DATE)
    @Column(name="end_date")
    @NotNull
    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    @Column(name="use_pm_substitute")
    public Boolean isUsePMSubstitute() {
        return usePMSubstitute;
    }

    public void setUsePMSubstitute(Boolean usePMSubstitute) {
        this.usePMSubstitute = usePMSubstitute;
    }


    @OneToMany(mappedBy="project",fetch=FetchType.EAGER)
    public List<Task> getTasks() {
        return tasks;
    }

    public void setTasks(List<Task> tasks) {
        this.tasks = tasks;
    }
    
    public void addTask(Task task) {
        this.tasks.add(task);
        task.setProject(this);
    }

    @Override
    public String toString() {
        return "Project [id=" + getId() + ", name=" + name + ", paNumber=" + paNumber + ", pm=" + projectManager + "]";
    }
    
    

    
}
