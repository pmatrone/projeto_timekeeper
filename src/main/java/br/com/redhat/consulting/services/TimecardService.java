package br.com.redhat.consulting.services;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

import javax.inject.Inject;

import br.com.redhat.consulting.model.dto.PersonDTO;
import br.com.redhat.consulting.model.dto.ProjectDTO;
import br.com.redhat.consulting.model.dto.TimecardDTO;
import br.com.redhat.consulting.model.dto.TimecardEntryDTO;
import br.com.redhat.consulting.util.TimecardEntryDateComparator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import br.com.redhat.consulting.config.TransactionalMode;
import br.com.redhat.consulting.dao.TimecardDao;
import br.com.redhat.consulting.dao.TimecardEntryDao;
import br.com.redhat.consulting.model.Person;
import br.com.redhat.consulting.model.Project;
import br.com.redhat.consulting.model.Timecard;
import br.com.redhat.consulting.model.TimecardEntry;
import br.com.redhat.consulting.model.TimecardStatusEnum;
import br.com.redhat.consulting.model.filter.TimecardSearchFilter;
import br.com.redhat.consulting.util.GeneralException;

public class TimecardService {
	private static Logger LOG = LoggerFactory.getLogger(TimecardService.class);

	@Inject
	private TimecardDao timecardDao;

	@Inject
	private ProjectService projectService;

	@Inject
	private TimecardEntryDao tcEntryDao;

	public List<Timecard> findByConsultant(Integer personId) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		Person consultant = new Person();
		consultant.setId(personId);
		filter.setConsultant(consultant);
		filter.setClausulasJoinPesquisa(true);
		// timecardDao.setOrderBy("order by day");
		timecardDao.setDistinct(true);
		// timecardDao.setOrderBy("");
		List<Timecard> res = timecardDao.find(filter);
		return res;
	}

	public TimecardEntry findTimeCardEntriesByTimeCardAndDate(String todayDate, Integer timeCardId)
			throws GeneralException {
		TimecardEntry timeCardEntry = tcEntryDao.findTimeCardEntriesByTimeCardAndDate(todayDate, timeCardId);
		return timeCardEntry;
	}

	public Timecard findByIdAndConsultant(Integer tcId, Integer consultantId) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setId(tcId);
		Person consultant = new Person();
		consultant.setId(consultantId);
		filter.setConsultant(consultant);
		filter.setClausulasJoinPesquisa(true);
		List<Timecard> res = timecardDao.find(filter);
		Timecard tc = null;
		if (res.size() > 0)
			tc = res.get(0);
		return tc;
	}

	public Long countByConsultantAndProject(Integer consultantId, Integer projectId) throws GeneralException {
		Long res = timecardDao.countByConsultantAndProject(projectId, consultantId);
		return res;
	}

	public Long countByTask(Integer taskId) throws GeneralException {
		Long res = timecardDao.countByTask(taskId);
		return res;
	}

	public Long countByDate(Integer consultantId, Integer projectId, Date initDate, Date endDate)
			throws GeneralException {
		Long res = timecardDao.countByDate(projectId, consultantId, initDate, endDate);
		return res;
	}

	public List<Timecard> findByStatus(Integer statusId) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setStatus(statusId);
		List<Timecard> res = timecardDao.find(filter);
		return res;
	}

	public List<Timecard> findAll() throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setClausulasJoinPesquisa(true);
		timecardDao.setDistinct(true);
		List<Timecard> res = timecardDao.find(filter);
		return res;
	}

	public List<Timecard> findPending() throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setClausulasJoinPesquisa(true);
		filter.setOnPA(true);
		timecardDao.setDistinct(true);
		List<Timecard> res = timecardDao.find(filter);
		return res;
	}

	public List<Timecard> findByOrganization(Integer orgId) throws GeneralException {

		List<Timecard> res = timecardDao.getByOrganization(orgId);
		return res;
	}

	public List<Timecard> findByProject(Integer prjId) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		Project project = new Project();
		project.setId(prjId);
		filter.setProject(project);
		List<Timecard> res = timecardDao.find(filter);
		return res;
	}

	public List<TimecardDTO> findByProjectIdAndStatus(Integer projectId, TimecardStatusEnum timecardStatus)
			throws GeneralException {

		List<Timecard> timecardList = new ArrayList<Timecard>();

		if (projectId > 0)
			timecardList = timecardDao.findByIdProjectAndStatus(projectId, timecardStatus);
		else
			timecardList = timecardDao.findByStatus(timecardStatus);

		List<TimecardDTO> tcDtoList = new ArrayList<TimecardDTO>();
		if (timecardList != null) {
			for (Timecard timecard : timecardList) {
				TimecardDTO timecardDTO = new TimecardDTO(timecard);

				List<TimecardEntryDTO> timecardEntryDTOList = timecard.getTimecardEntries().stream()
						.map(timecardEntry -> new TimecardEntryDTO(timecardEntry, timecardEntry.getTask()))
						.collect(Collectors.toList());

				timecardDTO.setConsultantDTO(new PersonDTO(timecard.getConsultant()));
				timecardDTO.setProjectDTO(new ProjectDTO(timecard.getProject()));
				timecardEntryDTOList.sort(new TimecardEntryDateComparator());
				timecardDTO.setFirstDate(timecardEntryDTOList.get(0).getDay());
				timecardDTO.setLastDate(timecardEntryDTOList.get(timecardEntryDTOList.size() - 1).getDay());
				timecardDTO.setTimecardEntriesDTO(timecardEntryDTOList);
				timecardDTO.setConsultantDTO(new PersonDTO(timecard.getConsultant()));
				tcDtoList.add(timecardDTO);
			}
		}
		return tcDtoList;
	}

	@TransactionalMode
	public void persist(Timecard timecard) throws GeneralException {
		timecard.setOnPA(false);
		if (timecard.getId() != null) {
			timecardDao.update(timecard);
		} else {
			timecardDao.insert(timecard);
		}
		for (TimecardEntry tcEntry : timecard.getTimecardEntries()) {
			if (tcEntry.getId() != null) {
				tcEntry.setTimecard(timecard);
				tcEntryDao.update(tcEntry);
			} else {
				tcEntry.setTimecard(timecard);
				tcEntryDao.insert(tcEntry);
			}
		}
	}

	public Timecard findById(Integer tcId) {
		return timecardDao.findById(tcId);
	}

	public void delete(Integer tcId) throws GeneralException {
		timecardDao.remove(tcId);
	}

	public void delete(Integer tcId, Integer consultantId) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setId(tcId);
		filter.setConsultant(new Person());
		filter.getConsultant().setId(consultantId);
		filter.setClausulasJoinPesquisa(true);
		List<Timecard> res = timecardDao.find(filter);
		if (res.size() > 0) {
			Timecard tc = res.get(0);
			timecardDao.remove(tc);
		} else {
			LOG.warn("Consultant " + consultantId + " tried to delete timecard (" + tcId
					+ ") assigned to a different consultant");
		}
	}

	public void approve(Integer tcId, String commentPM) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setId(tcId);
		filter.setStatusEnum(TimecardStatusEnum.SUBMITTED);
		List<Timecard> res = timecardDao.find(filter);
		Timecard tc = null;
		if (res.size() > 0) {
			tc = res.get(0);
			tc.setOnPA(false);
			tc.setStatusEnum(TimecardStatusEnum.APPROVED);
			tc.setCommentPM(commentPM);
			timecardDao.update(tc);
		}
	}

	public void setOnPa(Integer tcId) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setId(tcId);
		List<Timecard> res = timecardDao.find(filter);
		Timecard tc = null;
		if (res.size() > 0) {
			tc = res.get(0);
			tc.setOnPA(true);
			timecardDao.update(tc);
		}
	}

	public void reject(Integer tcId, String commentPM) throws GeneralException {
		TimecardSearchFilter filter = new TimecardSearchFilter();
		filter.setId(tcId);
		filter.setStatusEnum(TimecardStatusEnum.SUBMITTED);
		List<Timecard> res = timecardDao.find(filter);
		Timecard tc = null;
		if (res.size() > 0) {
			tc = res.get(0);
			tc.setStatusEnum(TimecardStatusEnum.REJECTED);
			tc.setCommentPM(commentPM);
			timecardDao.update(tc);
		}

	}

	public List<ProjectDTO> compareTimecard(List<String[]> allRows) throws GeneralException, ParseException {

		List<Project> listProjects = projectService.findAll(true);
		List<ProjectDTO> projectDto = new ArrayList<ProjectDTO>();

		for (Project project : listProjects) {
			List<TimecardDTO> timecardDTOList = findByProjectIdAndStatus(project.getId(), TimecardStatusEnum.APPROVED);

			if (timecardDTOList.size() > 0) {
				final List<String> importantColumns = Arrays.asList("Project", "Task", "Item Date", "Employee Number",
						"Quantity");
				Map<String, Integer> columnPosition = new HashMap<String, Integer>() {
					{
						importantColumns.forEach(columnName -> put(columnName, null));
					}
				};

				// Populate position of fields in tsv file.
				if (allRows != null && !allRows.isEmpty()) {
					String[] firstLine = allRows.get(0);
					for (int i = 0; i < firstLine.length; i++) {
						if (columnPosition.containsKey(firstLine[i])) {
							columnPosition.put(firstLine[i], i);
						}
					}
				}

				for (String[] row : allRows) {
					final String projectNumber = row[columnPosition.get("Project")]; // Project Id
					if (projectNumber.equals("Project")) { // Ignore first line of file.
						continue;
					}
					final String task = row[columnPosition.get("Task")]; // Task Id, format example "1.0"
					String dateString = row[columnPosition.get("Item Date")]; // Date. format example "20-SEP-2016"
					dateString = formatDate(dateString);
					final String employeeNumber = row[columnPosition.get("Employee Number")]; // Employee Id
					final String quantityHours = row[columnPosition.get("Quantity")]; // Quantity of hours reported
					final DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy", Locale.US);
					final Date date = dateFormat.parse(dateString);
					timecardDTOList.stream().parallel()
							.filter(timecardDTO -> timecardDTO.getConsultant().getOraclePAId()
									.equals(Integer.valueOf(employeeNumber)))
							.forEach(timecardDTO -> timecardDTO.getTimecardEntriesDTO().stream().parallel()
									.filter(timecardEntryDTO -> timecardEntryDTO.getTaskDTO().getTaskType().equals(
											Double.valueOf(task).intValue()) && timecardEntryDTO.getDay().equals(date)
											&& timecardEntryDTO.getWorkedHours().equals(new Double(quantityHours)))
									.forEach(timecardEntryDTO -> timecardEntryDTO.setTimecardCompare("ok")));
				}

				// Set all itens with null to red class.
				timecardDTOList.stream()
						.forEach(timecardDTO -> timecardDTO.getTimecardEntriesDTO().stream()
								.filter(timecardEntryDTO -> timecardEntryDTO.getTimecardCompare() == null)
								.forEach(timecardEntryDTO -> timecardEntryDTO.setTimecardCompare("error")));

				ProjectDTO prjDto = new ProjectDTO(timecardDTOList.get(0).getProject().toProject());
				prjDto.setTimecardsDTO(timecardDTOList);
				projectDto.add(prjDto);
			}

		}
		return projectDto;
	}

	public String formatDate(String dateString) throws GeneralException {

		if (dateString.contains("JAN"))
			return dateString.replace("JAN", "01");
		if (dateString.contains("FEB"))
			return dateString.replace("FEB", "02");
		if (dateString.contains("MAR"))
			return dateString.replace("MAR", "03");
		if (dateString.contains("APR"))
			return dateString.replace("APR", "04");
		if (dateString.contains("MAY"))
			return dateString.replace("MAY", "05");
		if (dateString.contains("JUN"))
			return dateString.replace("JUN", "06");
		if (dateString.contains("JUL"))
			return dateString.replace("JUL", "07");
		if (dateString.contains("AUG"))
			return dateString.replace("AUG", "08");
		if (dateString.contains("SEP"))
			return dateString.replace("SEP", "09");
		if (dateString.contains("OCT"))
			return dateString.replace("OCT", "10");
		if (dateString.contains("NOV"))
			return dateString.replace("NOV", "11");
		if (dateString.contains("DEC"))
			return dateString.replace("DEC", "12");

		return dateString;

	}

}
