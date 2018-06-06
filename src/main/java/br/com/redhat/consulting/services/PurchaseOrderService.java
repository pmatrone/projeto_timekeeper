package br.com.redhat.consulting.services;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import br.com.redhat.consulting.config.TransactionalMode;
import br.com.redhat.consulting.dao.PurchaseOrderDao;
import br.com.redhat.consulting.model.Person;
import br.com.redhat.consulting.model.PurchaseOrder;
import br.com.redhat.consulting.util.FreeMarkerUtil;
import br.com.redhat.consulting.util.GeneralException;
import br.com.redhat.consulting.model.PurchaseOrderStatusEnum;

public class PurchaseOrderService {
    @Inject
    private PurchaseOrderDao purchaseOrderDao;
    
    @Inject
    private PersonService personService;
    
    @Inject
    private EmailService emailService;
    
    public List<PurchaseOrder> findAllPurchaseOrders(Integer partnerOrganizationId, Boolean purchaseOrderNotEmpty) throws GeneralException {
        return purchaseOrderDao.findAllPurchaseOrders(partnerOrganizationId, purchaseOrderNotEmpty);
    }
    
    @TransactionalMode
    public void persist(PurchaseOrder purchaseOrder) throws GeneralException {
    	Date today = new Date();
        
        if (purchaseOrder.getId() != null) {
        	purchaseOrder.setRegistered(today);
        	purchaseOrder.setLastModification(today);
        	
        	if(purchaseOrder.getpurchaseOrder() != null)
        		purchaseOrder.setStatusEnum(PurchaseOrderStatusEnum.CREATED);
        	else
        		purchaseOrder.setStatusEnum(PurchaseOrderStatusEnum.IN_PROGRESS);
        	
        	purchaseOrderDao.update(purchaseOrder);
        } 
        else
        {
        	purchaseOrder.setRegistered(today);
        	purchaseOrder.setLastModification(today);
        	purchaseOrderDao.insert(purchaseOrder);
        	
        	sendEmailNewPurchaseOrder(purchaseOrder);
        }
    }
    
    public void sendEmailNewPurchaseOrder(PurchaseOrder purchaseOrder) throws GeneralException {
        Map<String, Object> root = new HashMap<>();

        Person person = this.personService.findById(purchaseOrder.getPerson().getId());

        String adminName = System.getProperty("timekeeper.admin.name", "Admin");
        root.put("name", adminName);
        root.put("partnerOrganization", person.getPartnerOrganization().getName());
        root.put("project", purchaseOrder.getTask().getProject().getName());
        root.put("task", purchaseOrder.getTask().getName());
        root.put("consultant", purchaseOrder.getPerson().getName());
        root.put("totalHours", purchaseOrder.getTotalHours() == null ? "" : purchaseOrder.getTotalHours());
        root.put("unitValue", purchaseOrder.getUnitValue() == null ? "" : purchaseOrder.getUnitValue());

        String text = FreeMarkerUtil.processTemplate("confirmation_new_purchase_order.ftl", root);
        if (text != null) {
            String email = System.getProperty("timekeeper.admin.mail", "paulo.alves@fabricads.com.br");
            String emailTitle = System.getProperty("timekeeper.po.email.title", "[Timekeeper] New Purchase Order");
            emailService.sendPlain(email, emailTitle,  text);
        }
    }
    
    public List<PurchaseOrder> getPurchaseOrdersByConsult(Integer taskId, Integer personId) throws GeneralException {
    	return purchaseOrderDao.findAllPurchaseOrdersByConsult(taskId, personId);
    }
    
    public void finishPurchaseOrder(Integer purchaseOrderId) throws GeneralException {
    	PurchaseOrder po =  purchaseOrderDao.findById(purchaseOrderId);
    	po.setStatusEnum(PurchaseOrderStatusEnum.FINISHED);
    	purchaseOrderDao.update(po);
    }
    
    public PurchaseOrder getPurchaseOrder(Integer purchaseOrderId) throws GeneralException {
    	PurchaseOrder purchaseOrder =  purchaseOrderDao.findById(purchaseOrderId);

    	return purchaseOrder;
    }
    
}
