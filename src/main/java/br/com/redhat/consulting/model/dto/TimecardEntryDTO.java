package br.com.redhat.consulting.model.dto;

import java.util.Date;

import br.com.redhat.consulting.model.Task;
import br.com.redhat.consulting.model.TimecardEntry;

public class TimecardEntryDTO  {

    private Integer id;
    private TimecardDTO timecard;
    private Date day;
    private Double workedHours;
    private String workDescription;
    private TaskDTO task;
    private String timecardCompare;
    
    public TimecardEntryDTO() { }
    
    public TimecardEntryDTO(TimecardDTO timecard, Date day, Double workedHours) {
        this.timecard = timecard;
        this.day = day;
        this.workedHours = workedHours;
    }

    public TimecardEntryDTO(TimecardEntry tce) {
        this.id = tce.getId();
        this.day = tce.getDay();
        this.workedHours = tce.getWorkedHours();
        this.workDescription = tce.getWorkDescription();
    }

    public TimecardEntryDTO(TimecardEntry tce, Task task) {
        this.id = tce.getId();
        this.day = tce.getDay();
        this.workedHours = tce.getWorkedHours();
        this.workDescription = tce.getWorkDescription();
        this.task = new TaskDTO(task);
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getDay() {
        return day;
    }

    public void setDay(Date day) {
        this.day = day;
    }

    public Double getWorkedHours() {
        return workedHours;
    }

    public void setWorkedHours(Double workedHours) {
        this.workedHours = workedHours;
    }
    
    public TimecardDTO getTimecard() {
        return timecard;
    }

    public void setTimecard(TimecardDTO timecard) {
        this.timecard = timecard;
    }

    public String getWorkDescription() {
        return workDescription;
    }

    public void setWorkDescription(String workDescription) {
        this.workDescription = workDescription;
    }

    public TaskDTO getTaskDTO() {
        return task;
    }

    public void setTaskDTO(TaskDTO task) {
        this.task = task;
    }

    public String getTimecardCompare() {
        return timecardCompare;
    }

    public void setTimecardCompare(String timecardCompare) {
        this.timecardCompare = timecardCompare;
    }

    @Override
    public String toString() {
        return "TimecardEntryDTO [day=" + day + ", workedHours=" + workedHours + ", workDescription=" + workDescription + ", task=" + task
                + "]";
    }

    public TimecardEntry toTimecardEntry() {
        TimecardEntry tce = new TimecardEntry();
        tce.setId(id);
        tce.setDay(day);
        tce.setWorkedHours(workedHours);
        tce.setWorkDescription(workDescription);
        return tce;
    }

}
