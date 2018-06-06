package br.com.redhat.consulting.dao;

import java.util.Date;
import java.util.List;

import javax.enterprise.context.RequestScoped;
import javax.persistence.TypedQuery;

import br.com.redhat.consulting.model.Timecard;
import br.com.redhat.consulting.model.TimecardStatusEnum;
import br.com.redhat.consulting.model.filter.TimecardSearchFilter;

@RequestScoped
public class TimecardDao extends BaseDao<Timecard, TimecardSearchFilter> {

    private TimecardSearchFilter filter;
    
    protected void configQuery(StringBuilder query, TimecardSearchFilter filter, List<Object> params) {
        this.filter = filter;
        if (filter.getId() != null) {
            query.append(" and ENT.id = ? ");
            params.add(filter.getId());
        }
        
        if (filter.getProject() != null && filter.getProject().getId() != null) {
            query.append(" and ENT.project.id = ? ");
            params.add(filter.getProject().getId());
        }
        
        if (filter.getConsultant() != null && filter.getConsultant().getId() != null) {
            query.append(" and ENT.consultant.id = ? ");
            params.add(filter.getConsultant().getId());
        }
        
        if (filter.getOnPA() == true) {
            query.append(" and ENT.onPA is false ");
           // params.add(false);
        }
        
        if (filter.getInitDate() != null && filter.getEndDate() != null) {
            query.append(" and ENT2.day between ? and ? ");
            params.add(filter.getInitDate());
            params.add(filter.getEndDate());
        }
        
        if (filter.getStatus() != null) {
            query.append(" and ENT.status = ? ");
            params.add(filter.getStatus());
        }

        query.append(getOrderBy());

    }
    
    protected void addJoinToFromClause(StringBuilder ql) { 
        if (filter.isClausulasJoinPesquisa()) {
            ql.append(" join fetch ent.timecardEntries");
        }
    }

    
    public Long countByDate(Integer projectId, Integer consultantId, Date startDate, Date endDate) {
        String qryStr = "select count(tce.id) from Timecard tc inner join tc.timecardEntries tce "
                + "where tc.project.id = ?0 "
                + "  and tc.consultant.id = ?1 "
                + "  and tce.day between ?2 and ?3";
        TypedQuery<Long> qry = getEntityManager().createQuery(qryStr, Long.class);
        qry.setParameter(0, projectId);
        qry.setParameter(1, consultantId);
        qry.setParameter(2, startDate);
        qry.setParameter(3, endDate);
        Long res = qry.getSingleResult();
        return res; 
    }
    
    public Long countByConsultantAndProject(Integer projectId, Integer consultantId) {
        String qryStr = "select count(tce.id) from Timecard tc inner join tc.timecardEntries tce "
                + "where tc.project.id = ?0 "
                + "  and tc.consultant.id = ?1 ";
        TypedQuery<Long> qry = getEntityManager().createQuery(qryStr, Long.class);
        qry.setParameter(0, projectId);
        qry.setParameter(1, consultantId);
        Long res = qry.getSingleResult();
        return res; 
    }
    
    public Long countByTask(Integer taskId) {
        String qryStr = "select count(tce.id) from Timecard tc inner join tc.timecardEntries tce "
                + "where tce.task.id = ?0 ";
        TypedQuery<Long> qry = getEntityManager().createQuery(qryStr, Long.class);
        qry.setParameter(0, taskId);
        Long res = qry.getSingleResult();
        return res; 
    }
    
    public List<Timecard> getByOrganization(Integer orgId) {
         TypedQuery<Timecard> findAllQuery = getEntityManager()
         .createQuery("SELECT DISTINCT t from Timecard t "
         +"inner join FETCH t.timecardEntries INNER JOIN FETCH "
         +"t.consultant c INNER JOIN FETCH c.partnerOrganization where c.partnerOrganization.id=?0 ", Timecard.class);
         findAllQuery.setParameter(0, orgId);
         return findAllQuery.getResultList();
    }
    
    public List<Timecard> findByStatus(TimecardStatusEnum timecardStatus) {
        /*
       select distinct tc.*, tce.* from timecard tc
       left join timecard_entry tce on tc.id_timecard = tce.id_timecard
       left join project pj on pj.id_project = tc.id_project
       left join person pn on pn.id_person = tc.id_consultant
       where tc.id_project = 2 and tc.status = 2;
         */
       TypedQuery<Timecard> findAllQuery = getEntityManager()
               .createQuery("SELECT DISTINCT tc FROM Timecard tc" +
                       " LEFT JOIN FETCH tc.timecardEntries tce" +
                       " LEFT JOIN FETCH tc.project p" +
                       " LEFT JOIN FETCH tc.consultant c" +
                       " WHERE tc.status = :timecardStatus", Timecard.class);
       findAllQuery.setParameter("timecardStatus", timecardStatus.getId());
       return findAllQuery.getResultList();
   }

    public List<Timecard> findByIdProjectAndStatus(Integer projectId, TimecardStatusEnum timecardStatus) {
         /*
        select distinct tc.*, tce.* from timecard tc
        left join timecard_entry tce on tc.id_timecard = tce.id_timecard
        left join project pj on pj.id_project = tc.id_project
        left join person pn on pn.id_person = tc.id_consultant
        where tc.id_project = 2 and tc.status = 2;
          */
        TypedQuery<Timecard> findAllQuery = getEntityManager()
                .createQuery("SELECT DISTINCT tc FROM Timecard tc" +
                        " LEFT JOIN FETCH tc.timecardEntries tce" +
                        " LEFT JOIN FETCH tc.project p" +
                        " LEFT JOIN FETCH tc.consultant c" +
                        " WHERE tc.project.id = :projectId AND tc.status = :timecardStatus", Timecard.class);
        findAllQuery.setParameter("projectId", projectId);
        findAllQuery.setParameter("timecardStatus", timecardStatus.getId());
        return findAllQuery.getResultList();
    }
}
