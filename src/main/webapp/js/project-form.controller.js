var projectApp = angular.module("project_ctrl");

projectApp.controller("project-form_controller", function($scope, $filter, projectService, personService, $routeParams) {


	$scope.project = {};
	$scope.project.enabled = true;
	
	$scope.temp_task = {};
	$scope.temp_task.name = "";
	$scope.temp_task.dissociateOfProject = true;
	$scope.list_tasks = [];

	$scope.taskType = {};
	$scope.tasks_to_remove = [];
	$scope.taskType.id = -1;
	$scope.taskType.name;
	
	$scope.dateOptions = {"show-weeks" : false};
	
	var projectId = $routeParams.projectId;
	
	//functions
	$scope.openStartDataPicker = openStartDataPicker;
	$scope.openEndDataPicker = openEndDataPicker;
	$scope.saveProject = saveProject;
	$scope.addTask = addTask;
	$scope.removeTask = removeTask;

	activate();

	function activate() {
		getProjectManagers();
		getTasksType();
		
		if(projectId != null)
			loadProject(projectId);

	}
	
	function loadProject(projectId) {

		var getSuccess = function(response) {
			$scope.project = response;
			$scope.list_tasks = $scope.project.tasksDTO;
		}

		var getError = function(response) {
			$scope.error_msg = response;
		}

		$scope.loadingPromise = projectService.getProject(projectId)
		.success(getSuccess)
		.error(getError);

	}

	function getProjectManagers() {

		var getSuccess = function(response) {
			console.log(response);
			$scope.pms = response;
		}

		var getError = function(response) {
			$scope.error_msg = response;
		}

		$scope.loadingPromise = personService.getProjectManagers()
		.success(getSuccess)
		.error(getError);

	}

	function getTasksType() {

		var getSuccess = function(response) {
			$scope.taskTypes = response;
		}

		var getError = function(response) {
			$scope.error_msg = response;
		}

		$scope.loadingPromise = projectService.getTasksType().success(
				getSuccess).error(getError);

	}

	function saveProject(project) {

		project.tasksDTO = $scope.list_tasks;
		project.tasksToRemove = $scope.tasks_to_remove;
		
		if(projectId != null)
			formatDate(project);

		var getSuccess = function(response) {
			$scope.saved = true;
			$scope.prj_name = project.name;
		}

		var getError = function(response) {
			$scope.error_msg = response;
		}

		$scope.loadingPromise = projectService.saveProject(project)
		.success(getSuccess)
		.error(getError);

	}
	
	function formatDate(project) {

        if(project.endDate instanceof Date){
        	project.endDate.setMinutes(project.endDate.getMinutes() - project.endDate.getTimezoneOffset());
        }
        if(project.initialDate instanceof Date){
        	project.initialDate.setMinutes(project.initialDate.getMinutes() - project.initialDate.getTimezoneOffset());
        }

	}

	function openStartDataPicker($event) {

		$event.preventDefault();
		$event.stopPropagation();
		$scope.openedStartDate = true;

	}
	
	function openEndDataPicker($event) {

		$event.preventDefault();
		$event.stopPropagation();
		$scope.openedEndDate = true;

	}
	
	function addTask() {

		var taskAlreadyExist = $filter('findByName')($scope.list_tasks, $scope.temp_task.name);
		var taskNameIsNotEmpty = $scope.temp_task.name.trim() != "" ? true : false;
		
		if (!taskAlreadyExist && taskNameIsNotEmpty) {
			
			var taskType = $filter('findById')($scope.taskTypes, $scope.taskType.id);
			
			if (taskType != null) {
				$scope.temp_task.taskType = taskType.id;
			}
			
			$scope.list_tasks.push($scope.temp_task);
			$scope.temp_task = {};
			$scope.temp_task.dissociateOfProject = true;
			$scope.temp_task.name = "";
		}

	}
	
	function removeTask(task) {

	       idx = $scope.list_tasks.indexOf(task);
	        if (idx > -1) {
	            $scope.list_tasks.splice(idx, 1);
	            if (task.id != null) {
	                $scope.tasks_to_remove.push(task.id);
	            }
	        }

	}
	

});