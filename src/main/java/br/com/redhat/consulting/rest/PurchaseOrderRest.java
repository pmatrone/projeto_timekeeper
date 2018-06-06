package br.com.redhat.consulting.rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.security.RolesAllowed;
import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.validation.ConstraintViolation;
import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.redhat.consulting.config.Authenticated;
import br.com.redhat.consulting.model.PurchaseOrder;
import br.com.redhat.consulting.model.Task;
import br.com.redhat.consulting.model.dto.ProjectDTO;
import br.com.redhat.consulting.model.dto.PurchaseOrderDTO;
import br.com.redhat.consulting.services.PurchaseOrderService;
import br.com.redhat.consulting.util.GeneralException;

@RequestScoped
@Path("/purchase-orders")
@Authenticated
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PurchaseOrderRest {

	private static Logger LOG = LoggerFactory.getLogger(PurchaseOrderRest.class);
	
	@Inject
	private PurchaseOrderService purchaseOrderService;
	
	@GET
	@Path("/")
	@RolesAllowed({ "redhat_manager", "admin" })
	public Response list(
			@QueryParam("oid") @DefaultValue("0") Integer partnerOrganizationId,
			@QueryParam("pos") @DefaultValue("false") Boolean purchaseOrderNotEmpty) {
		List<PurchaseOrder> purchaseOrders = null;
		List<PurchaseOrderDTO> purchaseOrdersDto = null;
		Response.ResponseBuilder response = null;
		
		try {
			purchaseOrders = purchaseOrderService.findAllPurchaseOrders(partnerOrganizationId, purchaseOrderNotEmpty);
			if (purchaseOrders.size() == 0) {
				Map<String, Object> responseObj = new HashMap<>();
				responseObj.put("msg", "No purchase order found");
				responseObj.put("purchaseOrders", new ArrayList<Object>());
				response = Response.ok(responseObj);
			} else {
				Map<String, Object> responseObj = new HashMap<>();
				
				purchaseOrdersDto = new ArrayList<PurchaseOrderDTO>(purchaseOrders.size());
				for (PurchaseOrder purchaseOrder : purchaseOrders) {
					PurchaseOrderDTO poDto = new PurchaseOrderDTO(purchaseOrder);
					
					purchaseOrdersDto.add(poDto);
				}
				
				responseObj.put("purchaseOrders", purchaseOrdersDto);
				response = Response.ok(responseObj);
			}
		} catch (GeneralException e) {
            String msg = "Error searching for all purchase orders.";
            LOG.error(msg, e);
		}
		
		return response.build();
	}
	
	@GET
	@Path("/{id}")
	@RolesAllowed({ "redhat_manager", "admin" })
	public Response get(@PathParam("id") Integer purchaseOrderId) {
		Response.ResponseBuilder response = null;
		try {
			PurchaseOrder purchaseOrder = purchaseOrderService.getPurchaseOrder(purchaseOrderId);
			PurchaseOrderDTO purchaseOrderDTO = new PurchaseOrderDTO(purchaseOrder);
			purchaseOrderDTO.setProject(new ProjectDTO(purchaseOrder.getTask().getProject()));
			
			response = Response.ok(purchaseOrderDTO);
		} catch (Exception e) {
            String msg = "Error searching for all purchase orders.";
            LOG.error(msg, e);
		}
		
		return response.build();
	}	
	
	@POST
	@Path("/")
	@RolesAllowed({ "redhat_manager", "admin" })
	public Response save(PurchaseOrderDTO purchaseOrder) {
		Response.ResponseBuilder builder = null;
		try {
			PurchaseOrder po = purchaseOrder.toParchaseOrder();
			Task task = purchaseOrder.getTask().toTask();
			task.setProject(purchaseOrder.getProject().toProject());
			po.setTask(task);
			po.setPerson(purchaseOrder.getPerson().toPerson());
			
			if (purchaseOrder.getId() == 0 || purchaseOrder.getId() == null) {
				List<PurchaseOrder> poExist = purchaseOrderService.getPurchaseOrdersByConsult(purchaseOrder.getTask().getId(), purchaseOrder.getPerson().getId());
				
				if(poExist.size() > 0) {
					  Map<String, String> responseObj = new HashMap<String, String>();
		              responseObj.put("error", "Consultant must not have duplicated purchase order for the same task" + po.getPerson().getName());
		                builder = Response.status(Response.Status.CONFLICT).entity(responseObj);
				} else {
					purchaseOrderService.persist(po);
					
					builder = Response.ok(purchaseOrder);
				}
			} else {
				purchaseOrderService.persist(po);
				
				builder = Response.ok(purchaseOrder);
			}
		} catch (GeneralException e) {
			String msg = "Error to insert purchase order.";
            LOG.error(msg, e);
            
            Map<String, String> responseObj = new HashMap<String, String>();
            responseObj.put("error", e.getMessage());
            
			builder = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
		} catch (Exception e) {
			String msg = "Error to insert purchase order.";
            LOG.error(msg, e);
            
            Map<String, String> responseObj = new HashMap<String, String>();
            responseObj.put("error", e.getMessage());
            builder = Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
		}
		
		return builder.build();
	} 
	
	@Path("/getByTask")
	@GET
	@RolesAllowed({ "redhat_manager", "admin" })
	public Response getByTaskAndPerson(@QueryParam("taskId") Integer taksId, @QueryParam("personId") Integer personId) {
		Response.ResponseBuilder response = null;

		try {
			Map<String, Object> responseObj = new HashMap<>();
			
			List<PurchaseOrder> listPurchaseOrders = purchaseOrderService.getPurchaseOrdersByConsult(taksId, personId);
			List<PurchaseOrderDTO> listPurchaseOrderDTO = new ArrayList<PurchaseOrderDTO>();
			
			for(PurchaseOrder po : listPurchaseOrders) {
				PurchaseOrderDTO purchaseOrderDTO = new PurchaseOrderDTO(po);
				
				listPurchaseOrderDTO.add(purchaseOrderDTO);
			}
			
			responseObj.put("purchaseOrders", listPurchaseOrderDTO);
			response = Response.ok(responseObj);
		} catch (Exception e) {
            String msg = "Error searching for all purchase orders.";
            LOG.error(msg, e);
		}
		
		return response.build();
	}
	
	@Path("/finishPo")
	@POST
	@RolesAllowed({ "redhat_manager", "admin" })
	public Response finishPurchaseOrder(Integer purchaseOrderId) {
		Response.ResponseBuilder response = null;

		try {
			purchaseOrderService.finishPurchaseOrder(purchaseOrderId);
			
			response = Response.ok();
		} catch (Exception e) {
            String msg = "Error searching for all purchase orders.";
            LOG.error(msg, e);
		}
		
		return response.build();
	}

    private Response.ResponseBuilder createViolationResponse(String msg, Set<ConstraintViolation<?>> violations) {
        LOG.info("Validation completed for Person: " + msg + " . " + violations.size() + " violations found: ");
        Map<String, String> responseObj = new HashMap<String, String>();
        for (ConstraintViolation<?> violation : violations) {
            responseObj.put("error", "Field " + violation.getPropertyPath().toString() + ": " + violation.getMessage());
        }
        return Response.status(Response.Status.BAD_REQUEST).entity(responseObj);
    }
}
