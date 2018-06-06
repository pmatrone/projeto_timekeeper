package br.com.redhat.consulting.services;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ejb.Asynchronous;
import javax.ejb.Schedule;
import javax.ejb.Singleton;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.redhat.consulting.model.Person;
import br.com.redhat.consulting.model.Project;
import br.com.redhat.consulting.model.Timecard;
import br.com.redhat.consulting.model.TimecardEntry;
import br.com.redhat.consulting.model.dto.ConsumedPercentageDTO;
import br.com.redhat.consulting.util.FreeMarkerUtil;
import br.com.redhat.consulting.util.GeneralException;

@Singleton
public class AlertService {
    private static Logger LOG = LoggerFactory.getLogger(AlertService.class);
    
    @Inject
    private ProjectService projectService;
    
    @Inject
    private TimecardService timeCardService;

    @Inject
    private PersonService personService;

    @Inject
    private EmailService emailService;

    @Schedule(dayOfWeek = "Thu", hour = "14", minute="03")
    private void alertManagerNoEntriesProjects() {
        LOG.debug("Schedule - Alert Manager no entries project");

        List<Project> projects = projectService.findNoEntriesThisWeekProjects();
        ManagerProjects previousManager = null;
        List<ManagerProjects> managers = new ArrayList<ManagerProjects>();

        for (Project project : projects) {
            if (previousManager == null) {
                previousManager = new ManagerProjects();
                previousManager.setManager(project.getProjectManager());
                managers.add(previousManager);
            }

            if (previousManager.getManager().getId().intValue() == project.getProjectManager().getId().intValue()) {
                previousManager.addProject(project);
            } else {
                previousManager = new ManagerProjects();
                previousManager.setManager(project.getProjectManager());
                previousManager.addProject(project);
                managers.add(previousManager);
            }
        }

        for (ManagerProjects managerProjects : managers) {
            sendNoEntriesEmail(managerProjects.getManager(), managerProjects.getProjects());
        }

    }
    

    @Schedule(dayOfWeek = "Tue", hour = "19", minute="47")
    private void alertPmsEndProject() throws GeneralException {
        LOG.debug("Schedule - Alert Consult fill out the timecards.");
        
        List<Integer> intList = new ArrayList<Integer>();
        intList.add(90);
        intList.add(60);
        intList.add(45);
        intList.add(30);
        
        for(int days : intList) {
        	List<Project> listProjects = projectService.findProjectByDaysToEnd(days);
        	
        	ManagerProjects previousManager = null;
            List<ManagerProjects> managers = new ArrayList<ManagerProjects>();

            for (Project project : listProjects) {
                if (previousManager == null) {
                    previousManager = new ManagerProjects();
                    previousManager.setManager(project.getProjectManager());
                    managers.add(previousManager);
                }

                if (previousManager.getManager().getId().intValue() == project.getProjectManager().getId().intValue()) {
                    previousManager.addProject(project);
                } else {
                    previousManager = new ManagerProjects();
                    previousManager.setManager(project.getProjectManager());
                    previousManager.addProject(project);
                    managers.add(previousManager);
                }
            }

            for (ManagerProjects managerProjects : managers) {
            	sendPmsDaysToEndProjectEmail(managerProjects.getManager(), managerProjects.getProjects(), days);
            }
        	
        }

    }
    
    @Schedule(dayOfWeek="Mon, Tue, Wed, Thu, Fri", hour="19", minute="0")
    private void alertPmsEndProjectHours() throws GeneralException {
    	List<Person> managers = personService.findProjectMangers();
    	
    	for(Person manager: managers) {
    		List<Project> projects = projectService.findByPMAndStatus(manager.getId(), true);
    		List<ConsumedPercentageDTO> consumedProjects = new ArrayList<ConsumedPercentageDTO>();
    		
    		List<Project> projectsTeste = new ArrayList<Project>();
    		projectsTeste.addAll(projects);
    		projectsTeste.addAll(projects);
    		
    		for(Project project: projectsTeste) {
        		Double totalHours = projectService.countTotalHours(project.getId());
        		Double totalConsumedHours = projectService.countTotalConsumedHours(project.getId());
        		
        		if (totalHours > 0) {
        			DecimalFormat df = new DecimalFormat("#.##");
        			Double percentage = Double.valueOf(df.format((totalConsumedHours.doubleValue() / totalHours.doubleValue()) * 100));
    	    		
    	    		if ((percentage >= 50 && percentage < 52) || 
    	    			(percentage >= 75 && percentage < 77) ||
    	    			(percentage >= 90 && percentage < 92)) {
    	    			ConsumedPercentageDTO consumedPercentage = new ConsumedPercentageDTO();
    	    			consumedPercentage.setProject(project.getName());
    	    			consumedPercentage.setTotalHours(totalHours);
    	    			consumedPercentage.setConsumedHours(totalConsumedHours);
    	    			consumedPercentage.setConsumedPercentage(percentage.toString());
    	    			
    	    			consumedProjects.add(consumedPercentage);
    	    		}
        		}
        	}
    		
    		if (consumedProjects.size() > 0) {
	    		Map<String, Object> root = new HashMap<>();
	            root.put("name", manager.getName());
	            root.put("projects", consumedProjects);
	
	            String text = FreeMarkerUtil.processTemplate("projects_consumed_hours.ftl", root);
	            if (text != null)
	                emailService.sendPlain(manager.getEmail(), "Projects have consumed more then 50% of hours.", text);
    		}
    	}
    }
    
    @Schedule(dayOfWeek = "Tue", hour = "18", minute="41")
    private void alertConsultantDailyTimeCard() throws GeneralException {
    	
    	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    	DateFormat weekDay = new SimpleDateFormat("EE");
    	Calendar ca = Calendar.getInstance();
    	String  weekDayString = weekDay.format(ca.getTime());
    	String today = df.format(ca.getTime());
    	
    	List<Person> findConsultantsInActiveProjects = personService.findConsultantsAndActiveProjects();
    	
    	for(Person person : findConsultantsInActiveProjects) {
    		
    		List<Timecard> listTimeCards = person.getTimecards();
    			
    			List<Project> listProjects = new ArrayList<Project>();
    			List<String> listEmails = new ArrayList<String>();
    		
    			for(Timecard timeCard : listTimeCards) {
    				
    				TimecardEntry timeCardEntry = timeCardService.findTimeCardEntriesByTimeCardAndDate(today, timeCard.getId());
    				
    				if(timeCardEntry == null) {
    					listProjects.add(timeCard.getProject());
    					listEmails.add(person.getEmail());
    				}
    				
    			}
    			
    			if(weekDayString == "Qui" || weekDayString == "Sex") {
    				int types[] = {3};
    				List<Person> responsiblesOrg = personService.findByOrgAndType(person.getPartnerOrganization(), types);
    				
    				for(Person orgManager : responsiblesOrg)
    					listEmails.add(orgManager.getEmail());
    					
    			}
    			
    			if(listProjects.size() > 0)
    				sendDailyTimeCardReminder(listProjects, person, listEmails);
    				
    	}
    	
    }
    
    private void sendDailyTimeCardReminder(List<Project> listProjects, Person consultant, List<String> emailTo) {
        Map<String, Object> root = new HashMap<>();
        root.put("name", consultant.getName());
        root.put("projects", listProjects);

        String text = FreeMarkerUtil.processTemplate("daily_reminder_timecard.ftl", root);
        
        if (text != null) 
            emailService.sendPlains(emailTo.toArray(new String[0]), "Daily TimeCard Reminder", text);
        

    }
    
    private void sendPmsDaysToEndProjectEmail(Person manager, List<Project> project, int daysToEnd) {
        Map<String, Object> root = new HashMap<>();
        root.put("name", manager.getName());
        root.put("projects", project);
        root.put("daysToEnd", daysToEnd);

        String text = FreeMarkerUtil.processTemplate("projects_about_to_end.ftl", root);
        if (text != null) {
            emailService.sendPlain(manager.getEmail(), "Projects about to end.", text);
        }

    }

    private void sendNoEntriesEmail(Person manager, List<Project> projects) {
        Map<String, Object> root = new HashMap<>();
        root.put("name", manager.getName());
        root.put("projects", projects);

        String text = FreeMarkerUtil.processTemplate("no_entries_week_project.ftl", root);
        if (text != null) {
            emailService.sendPlain(manager.getEmail(), "Projects with no entries this week", text);
        }

    }

    private class ManagerProjects {
        private Person manager;
        private List<Project> projects = new ArrayList<Project>();

        public Person getManager() {
            return manager;
        }

        public void setManager(Person manager) {
            this.manager = manager;
        }

        public List<Project> getProjects() {
            return projects;
        }

        public void addProject(Project project) {
            this.projects.add(project);
        }
    }

    @Asynchronous
    public void alertSubmittedTimecard(Timecard timecard) {
        Project project = timecard.getProject();
        Person manager = project.getProjectManager();
        Person consultant = timecard.getConsultant();

        Map<String, Object> root = new HashMap<>();
        root.put("managerName", manager.getName());
        root.put("consultantName", consultant.getName());
        root.put("projectName", project.getName());

        String text = FreeMarkerUtil.processTemplate("submitted_timecard.ftl", root);
        if (text != null) {
            emailService.sendPlain(manager.getEmail(), "Timecard submitted", text);
        }
    }

    @Schedule(dayOfWeek = "Fri", hour = "8")
    private void alertConsultantWeeklyTimecard() {
        LOG.debug("Schedule - Alert Consultant weekly timecard");

        List<Person> findConsultantsInActiveProjects = personService.findConsultantsAndActiveProjects();
        for (Person consultant : findConsultantsInActiveProjects) {
            sendConsultantWeeklyTimecardEmail(consultant);
        }
    }

    @Schedule(dayOfWeek = "Mon, Tue, Wed, Thu, Fri", hour = "8")
    private void alertIntegratorManagerAcceptTimecard() throws GeneralException {
        LOG.debug("Schedule - Alert Integrator manager to accept/sync timecard");

        List<Timecard> pendingTimecard = timeCardService.findPending();
        for (Timecard pending : pendingTimecard) {
            Calendar calendar = Calendar.getInstance();
            calendar.set(Calendar.DAY_OF_MONTH, 1);
            if (pending.getTimecardEntries().get(0).getDay().after(calendar.getTime())) {
                sendIntegratorManagerAcceptTimeCard(pending);
            }
        }
    }

    private void sendIntegratorManagerAcceptTimeCard(Timecard timecard) throws GeneralException {
    	List<Person> redHatManagers = personService.findProjectMangers();
    	List<String> redHatManagersEmails = new ArrayList();
    	
    	for(Person p : redHatManagers) {
    		redHatManagersEmails.add(p.getEmail());
    	}
    	
        Map<String, Object> root = new HashMap<>();
        root.put("project_name", timecard.getProject().getName());
        root.put("Consultant_name", timecard.getConsultant().getName());

        String text = FreeMarkerUtil.processTemplate("integrator_manager_accept_timecard.ftl", root);
        if (text != null) {
            emailService.sendPlains(redHatManagersEmails.toArray(new String[0]), "Accept timecard reminder", text);
        }
    }

    private void sendConsultantWeeklyTimecardEmail(Person consultant) {
        Map<String, Object> root = new HashMap<>();
        root.put("name", consultant.getName());
        // TODO
//        consultant.getPersonTasks()
//        root.put("projects", consultant.getProjects());

        String text = FreeMarkerUtil.processTemplate("consultant_weekly_timecard.ftl", root);
        if (text != null) {
            emailService.sendPlain(consultant.getEmail(), "Weekly timecard reminder", text);
        }
    }

    @Schedule(hour = "0", minute = "1")
    private void disableJustEndedProjects() {
        LOG.debug("Schedule - Disable just ended projects");

        List<Project> projects = projectService.findAndDisableJustEndedProjects();
        for (Project project : projects) {
            sendJusEndedProjectEmail(project);
        }
    }

    private void sendJusEndedProjectEmail(Project project) {
        Person manager = project.getProjectManager();
        Map<String, Object> root = new HashMap<>();
        root.put("name", manager.getName());
        root.put("project", project);

        String text = FreeMarkerUtil.processTemplate("just_ended_project.ftl", root);
        if (text != null) {
            emailService.sendPlain(manager.getEmail(), "Project has just ended", text);
        }
    }

}
