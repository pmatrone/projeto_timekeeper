package br.com.redhat.consulting.services;

import java.util.Date;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.redhat.consulting.dao.PersonDao;
import br.com.redhat.consulting.model.PartnerOrganization;
import br.com.redhat.consulting.model.Person;
import br.com.redhat.consulting.model.PersonType;
import br.com.redhat.consulting.model.filter.PersonSearchFilter;
import br.com.redhat.consulting.util.GeneralException;
import br.com.redhat.consulting.util.Util;

public class PersonService {
    private static Logger LOG = LoggerFactory.getLogger(PersonService.class);
    
    @Inject
    private PersonDao personDao;
    
    public void insert(Person person) throws GeneralException {
        Date today = new Date();
        person.setRegistered(today);
        person.setLastModification(today);
        personDao.insert(person);
    }
    
    public List<Person> findProjectMangers() throws GeneralException {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setEnabled(true);
        filter.setPersonTypeEnum(PersonType.MANAGER_REDHAT);
        res = personDao.find(filter);
        return res;
    }
    
    public List<Person> findPersons(Boolean enabled) throws GeneralException {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setPersonTypes(new int[]{PersonType.CONSULTANT_PARTNER.getId(), PersonType.MANAGER_REDHAT.getId(), PersonType.CONSULTANT_REDHAT.getId(), PersonType.MANAGER_PARTNER.getId()});
        if (enabled != null)
            filter.setEnabled(enabled);
        res = personDao.find(filter);
        return res;
    }
    
    public List<Person> findConsultants() throws GeneralException {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setPersonTypeEnum(PersonType.CONSULTANT_PARTNER);
        filter.setEnabled(true);
        res = personDao.find(filter);
        return res;
    }
    
    public Person findById(Integer id)  {
        Person person = personDao.findById(id);
        return person;
    }
    
    public Person findByIdWithTasks(Integer id) throws GeneralException  {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setId(id);
        res = personDao.find(filter);
        Person person = null;
        if (res.size() > 0)
            person = res.get(0);
        return person;
    }
    
    public Person findByIdEnabled(Integer id) throws GeneralException  {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setId(id);
        filter.setEnabled(true);
        res = personDao.find(filter);
        Person person = null;
        if (res.size() > 0)
            person = res.get(0);
        return person;
    }
    
    public void disable(Integer personId) throws GeneralException {
        Person person = findById(personId);
        person.setEnabled(false);
        personDao.update(person);
    }
    
    public void enable(Integer personId) throws GeneralException {
        Person person = findById(personId);
        person.setEnabled(true);
        personDao.update(person);
    }
    
    public void remove(Integer personId) throws GeneralException {
        personDao.remove(personId);
    }
    
    public void persist(Person person) throws GeneralException {
        Date today = new Date();
        if (StringUtils.isNotEmpty(person.getPassword())) {
            person.setPassword(Util.hash(person.getPassword()));
        }
        if (person.getId() != null) {
            if (StringUtils.isEmpty(person.getPassword())) {
                // need to get the encoded password as the user didn't change it
                Person personEnt = findById(person.getId());
                person.setPassword(personEnt.getPassword());
            }
            person.setLastModification(today);
            personDao.update(person);
        } else {
            person.setRegistered(today);
            person.setLastModification(today);
            personDao.insert(person);
        }
    }

    public Person findByName(String name) throws GeneralException {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setName(name);
        res = personDao.find(filter);
        Person person = null;
        if (res.size() > 0)
            person = res.get(0);
        return person;
    }
    
    public List<Person> findByOrgAndType(PartnerOrganization partnerOrganization, int[] types) throws GeneralException {
    	PersonSearchFilter filter = new PersonSearchFilter();
    	filter.setPartnerOrganization(partnerOrganization);
    	filter.setPersonTypes(types);
    	List<Person> persons = personDao.find(filter);
    	return persons;
    	
    }
    
    
    public Person findByEmail(String email) throws GeneralException {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setEmail(email);
        filter.setEnabled(true);
        res = personDao.find(filter);
        Person person = null;
        if (res.size() > 0)
            person = res.get(0);
        return person;
    }

    public List<Person> findPersonsById(List<Integer> consultantsId) throws GeneralException {
        List<Person> res = null;
        PersonSearchFilter filter = new PersonSearchFilter();
        filter.setPersonIds(consultantsId);
        filter.setEnabled(true);
        res = personDao.find(filter);
        return res;
    }
    
    public List<Person> findConsultantsAndActiveProjects() {
    	List<Person> consultants = personDao.findConsultantsAndActiveProjects();
    	return consultants;
    }
    
}
