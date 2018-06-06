'use strict';

timekeeperApp.controller('purchaseOrderFormController', function($filter, $scope, $http, $window, $routeParams, purchaseOrderService, organizationService, projectService, personService) {
    $scope.loading = true;
    $scope.saved = false;
    $scope.data = {};
    //$scope.listPartners = {};
    $scope.listProjects = {};
    $scope.listTasks = {};
    $scope.listConsultants = {};

    var purchaseOrderId = $routeParams.purchaseOrderId;

    function init() {
        //listPartnerOrganizations();
        listProjects();

        if(purchaseOrderId != null)
            loadPurchaseOrder(purchaseOrderId);
    }

    function loadPurchaseOrder(purchaseOrderId) {
        var getSuccess = function(response) {
            $scope.data = response;

            $scope.listTaskByProject(true);
            var project = response.project;
            var task = response.task;
            var person = response.person;

            /*
            
            $scope.selectedConsultant.push(response.person);
            $scope.listConsultants = $scope.selectedConsultant;
            $scope.loading = false;
*/
        }
        var getError = function(response) {
            console.log(response);
            //$scope.error_msg = response;
        }

        $scope.loadingPromise = purchaseOrderService.get(purchaseOrderId)
            .success(getSuccess)
            .error(getError);

    }
/*
    function listPartnerOrganizations() {
        $scope.loading = true;
        var getSuccess = function(response) {
            $scope.listPartners = response;
            $scope.loading = false;
        }

        var getError = function(response) {
            $scope.error_msg = response;
            $scope.loading = false;
        }

        $scope.loadingPromise = organizationService.getOrganizationsByStatus(1)
            .success(getSuccess)
            .error(getError);
    }
*/
    function listProjects() {
        $scope.loading = true;
        var getSuccess = function(response) {
            $scope.listProjects = response;
            $scope.loading = false;
        }

        var getError = function(response) {
            $scope.error_msg = response;
            $scope.loading = false;
        }

        $scope.loadingPromise = projectService.getAllProjectsByStatus(1)
            .success(getSuccess)
            .error(getError);
    }

    init();

    $scope.listTaskByProject = function(loadTask) {
        $scope.loading = true;
        var getSuccess = function(response) {
            $scope.listTasks = response;
            $scope.loading = false;

            if (typeof loadTask !== 'undefined')
                $scope.listConsultantByTask();
        }

        var getError = function(response) {
            $scope.error_msg = response;
            $scope.loading = false;
        }

        $scope.loadingPromise = projectService.getTasksByProjectId($scope.data.project.id)
            .success(getSuccess)
            .error(getError);
    }

    $scope.listConsultantByTask = function() {
        var getSuccess = function(response) {
			$scope.listConsultants = response.consultants;
			$scope.loading = false;
		}

		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

        $scope.loadingPromise = projectService.getTaskBy($scope.data.project.id, $scope.data.task.id)
            .success(getSuccess)
            .error(getError);
        /*
        var getSuccess = function(response) {
			$scope.listConsultants = response;
			$scope.loading = false;
		}

		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

        $scope.loadingPromise = personService.getConsultantsByTasks({ listTasksId: [ task ] })
            .success(getSuccess)
            .error(getError);
            */
    }

    $scope.save = function(data) {
        console.log("save data");
        console.log(data);

        $scope.loading = true;
		var getSuccess = function(response) {
			$scope.loading = false;
	    	$scope.saved = true;
		}

		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

        $scope.loadingPromise = purchaseOrderService.save(data)
            .success(getSuccess)
            .error(getError);
	}
});