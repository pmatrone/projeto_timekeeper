var projectApp = angular.module("project_ctrl");


projectApp.controller("project-cs_controller", function($rootScope, $scope, $http, $window, projectService) {

    $scope.loading = true;
    
    activate();
    
    function activate() {
    	gridProjectsCs();
        
    }
	
    function gridProjectsCs () {
    	
    	var userId = $rootScope.user.id;
    	
        var getSuccess = function (response) {
            $scope.projects = response;
            $scope.loading = false;
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = projectService.getallProjectsByConsultant(userId)
            .success(getSuccess)
            .error(getError);

    };

});