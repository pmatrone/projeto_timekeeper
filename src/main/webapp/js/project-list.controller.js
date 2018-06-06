var projectApp = angular.module("project_ctrl");


projectApp.controller("project_list_controller", function($scope, $http, $window, projectService, $log) {

    $scope.loading = true;
    
    //functions
    $scope.disable = disableProject;
    $scope.enable = enableProject;
    $scope.delete = deleteProject;
    $scope.gridListProjects = gridListProjects;
    
    activate();
    
    function activate() {
    	gridListProjects();
        
    }
	
    
    function gridListProjects () {
    	
    	var projectsListStatusId = 1;
    	
    	if($scope.list_disabledProjects == true)
    		projectsListStatusId = 2;
    	
        var getSuccess = function (response) {
            $log.info(response);
            $scope.projects = response;
            $scope.loading = false;
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = projectService.getAllProjectsByStatus(projectsListStatusId)
            .success(getSuccess)
            .error(getError);

    }

    
	function disableProject (projectId) {
		
		var getSuccess = function (response) {
			reloadPage();
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = projectService.disableProject(projectId)
            .success(getSuccess)
            .error(getError);
        
    }
    
    
    function enableProject (projectId) {
    	
    	var getSuccess = function (response) {
    		reloadPage();
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = projectService.enableProject(projectId)
            .success(getSuccess)
            .error(getError);
        
    }
    
    function deleteProject (projectId) {
    	
    	var getSuccess = function (response) {
    		reloadPage()
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = projectService.deleteProject(projectId)
            .success(getSuccess)
            .error(getError);
        
    }
    
    function reloadPage(){
    	$window.location.reload();
    }

});