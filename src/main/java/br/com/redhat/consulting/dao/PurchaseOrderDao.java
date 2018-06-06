package br.com.redhat.consulting.dao;

import java.util.List;

import javax.enterprise.context.RequestScoped;
import javax.persistence.TypedQuery;

import br.com.redhat.consulting.config.TransactionalMode;
import br.com.redhat.consulting.model.PurchaseOrder;
import br.com.redhat.consulting.model.PurchaseOrderStatusEnum;
import br.com.redhat.consulting.model.filter.PurchaseOrderSearchFilter;

@RequestScoped
public class PurchaseOrderDao extends BaseDao<PurchaseOrder, PurchaseOrderSearchFilter> {
	@TransactionalMode
	public List<PurchaseOrder> findAllPurchaseOrders(Integer partnerOrganizationId, Boolean purchaseOrderNotEmpty) {
		Integer statusFinishedId = PurchaseOrderStatusEnum.FINISHED.getId();
		Integer statusCreateId = PurchaseOrderStatusEnum.CREATED.getId();
		Integer statusInProgressId = PurchaseOrderStatusEnum.IN_PROGRESS.getId();
		
        StringBuilder jql = new StringBuilder();
        String notEmpty = purchaseOrderNotEmpty ? " (" + statusFinishedId + ")" : " ( " + statusCreateId + "," + statusInProgressId + ")";
        TypedQuery<PurchaseOrder> query = null;
        
        if (partnerOrganizationId > 0) {
        	jql.append(" SELECT po FROM PurchaseOrder po left join fetch po.person p left join fetch p.partnerOrganization o WHERE o.id = :partnerOrganizationId AND po.purchaseOrder" + notEmpty);
        	query = getEntityManager().createQuery(jql.toString(), PurchaseOrder.class);
        	query.setParameter("partnerOrganizationId", partnerOrganizationId);
        } else {
        	jql.append(" SELECT po FROM PurchaseOrder po WHERE po.status in " + notEmpty);
        	query = getEntityManager().createQuery(jql.toString(), PurchaseOrder.class);
        }

        return query.getResultList();
    }
	
	public List<PurchaseOrder> findAllPurchaseOrdersByConsult(Integer taskId, Integer personId) {
        String jql = "SELECT po FROM PurchaseOrder po where po.task.id = :task and po.person.id = :person";
        TypedQuery<PurchaseOrder> query= getEntityManager().createQuery(jql, PurchaseOrder.class);
        
        query.setParameter("task", taskId);
        query.setParameter("person", personId);
        
        List<PurchaseOrder> res = query.getResultList();
        
        return res;
    }
	
	public PurchaseOrder findById(Integer id) {
		String jql = "SELECT po FROM PurchaseOrder po left join fetch po.task t left join fetch t.project where po.id = :purchaseOrderId";
        TypedQuery<PurchaseOrder> query= getEntityManager().createQuery(jql, PurchaseOrder.class);
        query.setParameter("purchaseOrderId", id);
        List<PurchaseOrder> res = query.getResultList();
        PurchaseOrder po = null;
        if (res != null && res.size() > 0)
            po = res.get(0);
        return po;
	}
}
