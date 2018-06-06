var purchaseOrderApp = angular.module("purchaseOrder_ctrl", [ "ngRoute", "ngResource", "ui.bootstrap", "servicesApp", "timekeeperApp", "validation.match" ]);
//var purchaseOrderApp = angular.module("purchaseOrder_ctrl");

purchaseOrderApp.controller("purchaseOrder_form_ctrl", function($filter, $scope, $http, $window, $routeParams, $q, organizationService, projectService, personService, purchaseOrderService) {

	$scope.loading = true;
	$scope.data = {};
	$scope.selectedConsultant = [];
	
	var purchaseOrderId = $routeParams.purchaseOrderId;
	
	// functions
	$scope.selectProject = getTasksByProjectId;
	$scope.save = save;

	activate();

	function activate() {
		loadPartnerOrganizations();
		getProjects();
		
		if(purchaseOrderId != null)
			loadPurchaseOrder(purchaseOrderId);
	}
	
	function loadPurchaseOrder(purchaseOrderId) {

		var getSuccess = function(response) {
			$scope.data = response;
			$scope.selectedConsultant.push(response.person);
			$scope.listConsultants = $scope.selectedConsultant;
			$scope.loading = false;
		}
		var getError = function(response) {
			$scope.error_msg = response;
		}

		$scope.loadingPromise = purchaseOrderService.getPurchaseOrder(purchaseOrderId)
		.success(getSuccess)
		.error(getError);

	}

	function loadPartnerOrganizations() {

		var organizationStatusId = 1;

		var getSuccess = function(response) {
			$scope.listPartners = response;
			$scope.loading = false;
		}

		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

		$scope.loadingPromise = organizationService.getOrganizationsByStatus(organizationStatusId)
		.success(getSuccess)
		.error(getError);

	}

	function getProjects() {

		var projectStatusId = 1;

		var getSuccess = function(response) {
			$scope.listProjects = response;
			$scope.loading = false;
		}
		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

		$scope.loadingPromise = projectService.getAllProjectsByStatus(projectStatusId)
		.success(getSuccess)
		.error(getError);

	}
	
	function getConsultantByProject(listTasksId) {

		var getSuccess = function(response) {
			$scope.listConsultants = response;
			$scope.loading = false;
		}

		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

		$scope.loadingPromise = personService.getConsultantsByTasks(listTasksId)
	    .then(function(response) {
	    	$scope.listConsultants = response.data;
	      })
	    .catch(function(err){
	          return $q.reject(err);
	        });

	}
	
	function getTasksByProjectId(project) {
		
		projectService.getTasksByProjectId(project.id)
	    .then(function(response) {
	    	listTasks = response.data;
	    	getConsultantByProject(response.data)
	      })
	    .catch(function(err){
	          return $q.reject(err);
	        });

	}
	
	function save(data) {
		
		var getSuccess = function(response) {
			$scope.listConsultants = response;
			$scope.loading = false;
		}

		var getError = function(response) {
			$scope.error_msg = response;
			$scope.loading = false;
		}

		$scope.loadingPromise = purchaseOrderService.save(data)
	    .then(function(response) {
	    	$scope.saved = true;
	      })
	    .catch(function(err){
	          return $q.reject(err);
	        });

	}

});
