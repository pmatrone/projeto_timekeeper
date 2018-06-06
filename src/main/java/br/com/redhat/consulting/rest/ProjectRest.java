package br.com.redhat.consulting.rest;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import br.com.redhat.consulting.model.*;
import br.com.redhat.consulting.model.dto.*;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.redhat.consulting.config.Authenticated;
import br.com.redhat.consulting.services.PersonService;
import br.com.redhat.consulting.services.ProjectService;
import br.com.redhat.consulting.services.PurchaseOrderService;
import br.com.redhat.consulting.services.TaskService;
import br.com.redhat.consulting.services.TimecardService;
import br.com.redhat.consulting.util.GeneralException;
import br.com.redhat.consulting.util.Util;

@RequestScoped
@Path("/project")
@Authenticated
public class ProjectRest {

    private static Logger LOG = LoggerFactory.getLogger(ProjectRest.class);

    @Inject
    private ProjectService projectService;

    @Inject
    private TimecardService timecardService;

    @Inject
    private PersonService personService;	

    @Inject
    private TaskService taskService;
    
    @Inject
    private PurchaseOrderService purchaseOrderService;

    @Context
    private HttpServletRequest httpReq;

    @Path("/list")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response listProjectsByPM(@QueryParam("by-pm") Integer pmId, @QueryParam("e") @DefaultValue("1") Integer listType) {
        return listProjects(null, null, listType);
    }

    public Response listProjects(Integer pmId, Integer consultantId, Integer listType) {
        List<Project> projects = null;
        List<ProjectDTO> projectsDto = null;
        Response.ResponseBuilder response = null;
        PersonDTO loggedUser = Util.loggedUser(httpReq);
        try {
            int LIST_ENABLED = 1;
            Boolean listOnlyEnabled = null;
            if (listType == LIST_ENABLED)
                listOnlyEnabled = true;
            if (pmId != null)
                projects = projectService.findByPM(pmId);
            else if (consultantId != null)
                projects = projectService.findByConsultant(consultantId);
            else if (loggedUser.isAdminOrProjectManager())
                projects = projectService.findAll(listOnlyEnabled);
            if (projects == null || projects.size() == 0) {
                Map<String, Object> responseObj = new HashMap<>();
                responseObj.put("msg", "No projects found");
                responseObj.put("projects", new ArrayList());
                response = Response.ok(new ArrayList());
            } else {
                projectsDto = new ArrayList<ProjectDTO>(projects.size());
                for (Project project : projects) {
                	
                	
                    Person pm = project.getProjectManager();
                    pm.nullifyAttributes();

              
                    PersonDTO pmDto = new PersonDTO(pm);
                	
                    ProjectDTO prjDto = new ProjectDTO(project);
                    if (loggedUser.isAdminOrProjectManager()) {
//                        int qty = project.getConsultants().size();
//                        prjDto.setQtyConsultants(qty);
                    }
                    List<TimecardDTO> timecardDTOS = timecardService.findByProjectIdAndStatus(project.getId(), TimecardStatusEnum.APPROVED);
                    prjDto.setApprovedTimecards(timecardDTOS != null && !timecardDTOS.isEmpty());
                    projectsDto.add(prjDto);
                    prjDto.setProjectManagerDTO(pmDto);
                }
                response = Response.ok(projectsDto);
            }
        } catch (GeneralException e) {
            LOG.error("Error to find projects.", e);
            Map<String, String> responseObj = new HashMap<>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/list-by-cs-fill")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "partner_consultant" })
    public Response listByConsultantToFill(@QueryParam("cs") Integer consultantId) {
        List<Project> projects = null;
        List<ProjectDTO> projectsDto = null;
        Response.ResponseBuilder response = null;
        PersonDTO loggedUser = Util.loggedUser(httpReq);
        try {
            if (consultantId != null)
                projects = projectService.findByConsultantToFill(consultantId);
            if (projects == null || projects.size() == 0) {
                /*Map<String, Object> responseObj = new HashMap<>();
                responseObj.put("msg", "No projects found");
                responseObj.put("projects", new ArrayList());*/
                response = Response.ok(new ArrayList());
            } else {
                projectsDto = new ArrayList<ProjectDTO>(projects.size());
                for (Project project : projects) {
                    // se projeto nao tem timecards, entao nao foi lancado
                    // nenhum, pode lancar novo timecard
                    // OU verifica se o ultimo timecardentry lancado e menor que
                    // a data fim do projeto

                    //if (project.getTimecards().size() == 0 || projectService.checkProjectCanFillMoreTimecards(project.getId())) {
                    LOG.debug(loggedUser.getName() + " can fill more timecards to project: " + project.getName());
                    ProjectDTO prjDto = new ProjectDTO(project);
                    projectsDto.add(prjDto);
                    /*} else {
                        LOG.debug(loggedUser.getName() + " CANNOT fill new timecards to project: " + project.getName());
                    }*/
                }
                response = Response.ok(projectsDto);
            }
        } catch (GeneralException e) {
            LOG.error("Error to find projects.", e);
            Map<String, String> responseObj = new HashMap<>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/{projectId}/tasks")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response tasks(@PathParam("projectId") Integer projectId) {
        List<TaskDTO> tasksDto = null;
        List<Task> tasks = null;
        Response.ResponseBuilder response = null;
        try {
            if (projectId != null)
                tasks = taskService.findByProject(projectId);
            if (tasks == null || tasks.size() == 0) {
                Map<String, Object> responseObj = new HashMap<>();
                responseObj.put("msg", "No tasks found");
                responseObj.put("projects", new ArrayList());
                response = Response.ok(new ArrayList());
            } else {
                tasksDto = new ArrayList<TaskDTO>(tasks.size());
                for (Task task : tasks) {
                    TaskDTO taskDto = new TaskDTO(task);
                    tasksDto.add(taskDto);
                }
                response = Response.ok(tasksDto);
            }
        } catch (GeneralException e) {
            LOG.error("Error to find tasks by project id: " + projectId, e);
            Map<String, String> responseObj = new HashMap<>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/{projectId}/task/{taskId}")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response taskByID(@PathParam("taskId") Integer taskId) {
    	Task task = null;

        Response.ResponseBuilder response = null;
        try {
            if (taskId != null)
            	task = taskService.findByIdWithConsultants(taskId);
            if (task == null) {
                Map<String, String> responseObj = new HashMap<>();
                responseObj.put("error", "Project " + taskId + " not found.");
                response = Response.status(Response.Status.NOT_FOUND).entity(responseObj);
            } else {
            	TaskDTO tasksDto = new TaskDTO(task);
            	List<Person> persons = task.getConsultants();
            	List<PersonDTO> personDTOs = new ArrayList<PersonDTO>(persons.size());
            	for(Person p: persons) {
            		PersonDTO person = new PersonDTO(p);
            		
            		//find PO
            		List<PurchaseOrder> po = this.purchaseOrderService.getPurchaseOrdersByConsult(taskId, p.getId());
            		if (po.size() > 0)
            			person.setPurchaseOrder(new PurchaseOrderDTO(po.get(0)));
            		
            		personDTOs.add(person);
            	}
            	tasksDto.setConsultants(personDTOs);
                response = Response.ok(tasksDto);
            }
        } catch (Exception e) {
            LOG.error("Error to find tasks by project id: " + taskId, e);
            Map<String, String> responseObj = new HashMap<>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }
    
    @Path("/list-by-cs")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin", "partner_consultant" })
    public Response listProjectsByConsultant(@QueryParam("cs") Integer consultantId) {
        return listProjects(null, consultantId, 1);
    }

    @Path("/{pr}")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response get(@PathParam("pr") @DefaultValue("-1") int projectId) {
        Project projectEnt = null;
        Response.ResponseBuilder response = null;
        try {
            projectEnt = projectService.findByIdWithConsultantsAndTasks(projectId);
            if (projectEnt == null) {
                Map<String, String> responseObj = new HashMap<>();
                responseObj.put("error", "Project " + projectId + " not found.");
                response = Response.status(Response.Status.NOT_FOUND).entity(responseObj);
            } else {
                Person pm = projectEnt.getProjectManager();
                pm.nullifyAttributes();

                ProjectDTO projectDto = new ProjectDTO(projectEnt);
                PersonDTO pmDto = new PersonDTO(pm);
                projectDto.setProjectManagerDTO(pmDto);
//                for (Person consultant : projectEnt.getConsultants()) {
//                    consultant.nullifyAttributes();
//                    PersonDTO consultantDto = new PersonDTO(consultant);
//                    PartnerOrganizationDTO orgDto = new PartnerOrganizationDTO(consultant.getPartnerOrganization());
//                    consultantDto.setOrganization(orgDto);
//                    Long qtyTimecards = timecardService.countByConsultantAndProject(consultant.getId(), projectId);
//                    consultantDto.setDissociateOfProject(qtyTimecards < 1);
//                    for (PersonTask constask : consultant.getPersonTasks()) {
//                        Task task = constask.getTask();
//                        TaskDTO taskDto = new TaskDTO(task);
//                        consultantDto.addTask(taskDto);
//                    }
//                    projectDto.addConsultant(consultantDto);
//                }
                for (Task task : projectEnt.getTasks()) {
                    TaskDTO taskDto = new TaskDTO(task);
                    Long qtyTimecardEntries = timecardService.countByTask(task.getId());
                    taskDto.setDissociateOfProject(qtyTimecardEntries < 1);
                    projectDto.addTask(taskDto);
                }
                response = Response.ok(projectDto);
            }
        } catch (Exception e) {
            LOG.error("Error to find project.", e);
            Map<String, String> responseObj = new HashMap<>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/{pr}/tc")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin", "partner_consultant" })
    public Response getWithTimecards(@PathParam("pr") @DefaultValue("-1") int projectId) {
        Project projectEnt = null;
        Response.ResponseBuilder response = null;
        PersonDTO loggedUser = Util.loggedUser(httpReq);
        try {
            projectEnt = projectService.findByIdAndConsultant(projectId, loggedUser.getId());
            if (projectEnt == null) {
                Map<String, String> responseObj = new HashMap<>();
                responseObj.put("error", "Project " + projectId + " not found.");
                response = Response.status(Response.Status.NOT_FOUND).entity(responseObj);
            } else {
                Person pm = projectEnt.getProjectManager();
                pm.nullifyAttributes();

                PersonDTO pmDto = new PersonDTO(pm);
                ProjectDTO projectDto = new ProjectDTO(projectEnt);
                projectDto.setProjectManagerDTO(pmDto);

                Date lastFilledDate = projectService.lastFilledTimecard(projectId);
                LOG.info(projectId + " ultimo dia preenchido " + lastFilledDate);
                projectDto.setLastFilledDay(lastFilledDate);

                for (Task task : taskService.findByConsultantAndProject(projectId,loggedUser.getId())) {
                    TaskDTO taskDto = new TaskDTO(task);
                    projectDto.addTask(taskDto);
                }
                response = Response.ok(projectDto);
            }
        } catch (Exception e) {
            LOG.error("Error to find project.", e);
            Map<String, String> responseObj = new HashMap<>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/save")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @POST
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response save(ProjectDTO projectDto) {
        Response.ResponseBuilder builder = null;
        try {
            if (projectDto != null && StringUtils.isBlank(projectDto.getName())) {
                Map<String, String> responseObj = new HashMap<String, String>();
                responseObj.put("error", "Project name must not be empty.");
                builder = Response.status(Response.Status.CONFLICT).entity(responseObj);
                return builder.build();
            }
            Project projectEnt = projectService.findByName(projectDto.getName());
            if (projectEnt != null && (projectEnt.getId() != projectDto.getId())) {
                Map<String, String> responseObj = new HashMap<String, String>();
                responseObj.put("error", "Project with duplicated name: " + projectDto.getName());
                builder = Response.status(Response.Status.CONFLICT).entity(responseObj);
            } else {
                projectEnt = projectDto.toProject();

                for (TaskDTO taskDto : projectDto.getTasksDTO()) {
                    Task task = taskDto.toTask();
                    projectEnt.addTask(task);
                }
                taskService.removeById(projectDto.getTasksToRemove());
                projectService.persist(projectEnt);
                builder = Response.ok(projectDto);
            }
        } catch (ConstraintViolationException e) {
            builder = createViolationResponse("Error to insert project.", e.getConstraintViolations());
        } catch (Exception e) {
            LOG.error("Error to insert project.", e);
            builder = Response.status(Response.Status.BAD_REQUEST).entity(Util.jsonMessageResponse("error", e.getMessage()));
        }
        return builder.build();
    }

    @Path("/associate-consultants")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @POST
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response associateTasksToConsultant(TaskDTO taskDTO) {
        Response.ResponseBuilder builder = null;
        try {
            if (taskDTO == null || taskDTO.getId() == null || taskDTO.getId() == 0) {
                Map<String, String> responseObj = new HashMap<String, String>();
                responseObj.put("error", "No project submitted");
                builder = Response.status(Response.Status.NOT_FOUND).entity(responseObj);
            } else {
                LOG.debug("saved consultants to task:" + taskDTO.getId());
                Task task = taskService.findByIdWithConsultants(taskDTO.getId());
                if (task != null) {
                	//this cleans the join table so we can add the updated date to it
                	task.getConsultants().clear();
                	//List<Person>persons= new ArrayList<Person>(taskDTO.getConsultants().size());
                    for(PersonDTO consultant : taskDTO.getConsultants()){
                    	//save PO
                    	PurchaseOrder po = null;
                    	PurchaseOrderDTO poConsultant = consultant.getPurchaseOrder();
                    	
                    	if(poConsultant != null) {
                    		
                    		if (consultant.getPurchaseOrder().getId() == null || consultant.getPurchaseOrder().getId() == 0) {
                    			po = new PurchaseOrder();
                    			po.setUnitValue(consultant.getPurchaseOrder().getUnitValue());
                    			po.setTotalHours(consultant.getPurchaseOrder().getTotalHours());
                    			po.setPerson(consultant.toPerson());
                    			po.setTask(task);
                    		
                    			this.purchaseOrderService.persist(po);
                    		} //else po = consultant.getPurchaseOrder().toParchaseOrder();
                    	}
                    		
                    	
                    	
                    	
                    	task.addConsultant(consultant.toPerson());
                    	//persons.add(consultant.toPerson());
                    	LOG.info("Saving consultant : " + consultant.getName()+" to the task "+task.getName());
                    }
                    //task.getConsultants().retainAll(persons);
                    taskService.save(task);
                } else {
                    LOG.error("User manipulated task id " + taskDTO.getId());

                }
                builder = Response.ok(Util.jsonMessageResponse("error", "Consultants sucessfully associated to tasks."));
            }
        } catch (ConstraintViolationException e) {
            builder = createViolationResponse("Error to associate consultants to tasks.", e.getConstraintViolations());
        } catch (Exception e) {
            LOG.error("Error to associate consultants to tasks.", e);
            Map<String, String> responseObj = new HashMap<String, String>();
            responseObj.put("error", e.getMessage());
            builder = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return builder.build();
    }

    @Path("/{pd}/disable")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response disable(@PathParam("pd") @DefaultValue("-1") int projectId) {
        Response.ResponseBuilder response = null;
        try {
            projectService.disable(projectId);
            response = Response.ok();
        } catch (GeneralException e) {
            LOG.error("Error to disable organization.", e);
            Map<String, String> responseObj = new HashMap<String, String>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/task_types")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response taskTypes() {
        Response.ResponseBuilder response = null;
        TaskTypeEnum[] vs = TaskTypeEnum.values();
        List<Map<String, String>> l = new ArrayList<>();
        for (TaskTypeEnum t : vs) {
            Map<String, String> values = new HashMap<>(vs.length * 2);
            values.put("id", "" + t.getId());
            values.put("name", t.getDescription());
            l.add(values);
        }
        response = Response.ok(l);
        return response.build();
    }

    @Path("/{pd}/enable")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response enable(@PathParam("pd") @DefaultValue("-1") int projectId) {
        Response.ResponseBuilder response = null;
        try {
            projectService.enable(projectId);
            response = Response.ok();
        } catch (GeneralException e) {
            LOG.error("Error to insert organization.", e);
            Map<String, String> responseObj = new HashMap<String, String>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    @Path("/{pd}/delete")
    @Produces(MediaType.APPLICATION_JSON)
    @GET
    @RolesAllowed({ "redhat_manager", "admin" })
    public Response delete(@PathParam("pd") @DefaultValue("-1") int projectId) {
        Response.ResponseBuilder response = null;
        try {
            projectService.remove(projectId);
            response = Response.ok();
        } catch (GeneralException e) {
            LOG.error("Error to insert organization.", e);
            Map<String, String> responseObj = new HashMap<String, String>();
            responseObj.put("error", e.getMessage());
            response = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
        }
        return response.build();
    }

    /**
     * Creates a JAX-RS "Bad Request" response including a map of all violation
     * fields, and their message. This can then be used by clients to show
     * violations.
     *
     * @param violations
     *            A set of violations that needs to be reported
     * @return JAX-RS response containing all violations
     */
    private Response.ResponseBuilder createViolationResponse(String msg, Set<ConstraintViolation<?>> violations) {
        LOG.info("Validation completed for Pedido: " + msg + " . " + violations.size() + " violations found: ");

        Map<String, String> responseObj = new HashMap<String, String>();

        for (ConstraintViolation<?> violation : violations) {
            responseObj.put(violation.getPropertyPath().toString(), violation.getMessage());
        }

        return Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
    }

}
