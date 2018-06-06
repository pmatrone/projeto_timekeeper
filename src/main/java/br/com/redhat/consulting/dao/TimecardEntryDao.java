package br.com.redhat.consulting.dao;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.enterprise.context.RequestScoped;
import javax.persistence.TypedQuery;

import br.com.redhat.consulting.config.TransactionalMode;
import br.com.redhat.consulting.model.TimecardEntry;
import br.com.redhat.consulting.model.filter.TimecardEntrySearchFilter;

@RequestScoped
public class TimecardEntryDao extends BaseDao<TimecardEntry, TimecardEntrySearchFilter> {
	
    public TimecardEntry findTimeCardEntriesByTimeCardAndDate(String today, Integer timeCardId) {
    	
    	DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    	String jql = "select t from TimecardEntry t where t.day = :todayDate and t.timecard.id = :timeCardId";
    	
        try {
            Date dt = df.parse(today);
            TypedQuery<TimecardEntry> query = getEntityManager().createQuery(jql, TimecardEntry.class);
            query.setParameter("todayDate", dt);
            query.setParameter("timeCardId", timeCardId);
            
            TimecardEntry res = query.getSingleResult() ;
            return res;

         } catch(Exception e){
        	 return null;
         } 
    	
        
    }

}
