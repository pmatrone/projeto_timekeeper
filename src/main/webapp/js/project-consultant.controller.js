var projectApp = angular.module("project_ctrl");


projectApp.controller("project-consultant_controller", function($scope, $timeout, $http, projectService, $routeParams,
        $filter, $log, consultantService, personService, purchaseOrderService, $rootScope) {
    $scope.selected = false;
    $scope.noResults = false;
    
    $scope.temp_consultant = { name: "" };
    $scope.temp_task = { consultants:[] };
    $scope.purchaseOrder = {};
    //$scope.purchaseOrderToSave = [];
    
    //functions
    $scope.saveAssociateConsultants = saveAssociateConsultants;
    $scope.cancel = cancel;
    $scope.update = update;
    $scope.addConsultant = addConsultant;
    $scope.removeConsultant = removeConsultant;
    //$scope.selectedConsultant = selectedConsultant;
    
    activate();
    
    function activate() {
    	getProject();
    	getAllConsultants();
    }
	
    function getProject () {
    	var userId = $rootScope.user.id;
    	
        var getSuccess = function (response) {
            $scope.project = response;
            $log.debug("Achou um projeto com o id " + $routeParams.projectId);
            $log.debug($scope.project);
            
            getTasksByProject($scope.project.id);
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        }

        $scope.loadingPromise = projectService.getProject($routeParams.projectId)
            .success(getSuccess)
            .error(getError);
    }
    
    function getTasksByProject (projectId) {
    	var userId = $rootScope.user.id;
    	
        var getSuccess = function (response) {
        	$scope.tasks = response;
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        }

        $scope.loadingPromise = projectService.getTasksByProjectId(projectId)
            .success(getSuccess)
            .error(getError);
    }
    
    function getAllConsultants () {
    	var userId = $rootScope.user.id;
    	
        var getSuccess = function (response) {
            $scope.consultants=response;
            $log.debug("Find the following consultants: ");
            $log.debug($scope.consultants);
        }

        var getError = function (response) {
            $log.error("An error has occured while trying to retrieve consultants")
            $log.error(error.data);
        }

        $scope.loadingPromise = consultantService.getAll()
            .success(getSuccess)
            .error(getError);
    }
    
    
    function saveAssociateConsultants () {
    	
    	$log.debug($scope.temp_task);
    	
    	//savePurchaseOrders();
    	
        var getSuccess = function (response) {
        	$scope.saved = true;
            $scope.error_msg = null;
            limpar();
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        }

        $scope.loadingPromise = projectService.associateConsultants($scope.temp_task)
            .success(getSuccess)
            .error(getError);

    }
    /*
    function savePurchaseOrders () {
    	
    	angular.forEach($scope.purchaseOrderToSave, function(purchaseOrder, key) {
    		var getSuccess = function (response) {
            	$scope.saved = true;
                limpar();
            }

            var getError = function (response) {
            	$scope.error_msg = data;
            }

            $scope.loadingPromise = purchaseOrderService.save(purchaseOrder)
                .success(getSuccess)
                .error(getError);
    		});

    }
    
    function selectedConsultant (consultant) {
    	
    	getPurchaseOrderByConsult($scope.temp_consultant.id);

    }
    */
    function addConsultant () {
    	if ($scope.temp_consultant.id != null){
            //getConsultant($scope.temp_consultant.id);
    		
    		var consultAlreadyExist = $filter('findById')($scope.temp_task.consultants, $scope.temp_consultant.id);
    		
    		if (consultAlreadyExist == null) {
                $scope.temp_consultant.purchaseOrder = $scope.purchaseOrder;
                $scope.temp_task.consultants.push($scope.temp_consultant);
            }
    		
            $scope.temp_consultant = { name: "" };
    		
    	}else{
    		$scope.error_msg = "Consultant and Purchase Order are required";
    	}
    }
    
    function removeConsultant(consultant) {
        idx = $scope.temp_task.consultants.indexOf(consultant);
        if (idx > -1) {
            $scope.temp_task.consultants.splice(idx, 1);
        }
    }
    /*
    function removeConsultantPurchaseOrder (purchaseOrder){
        idx = $scope.purchaseOrderToSave.indexOf(consultant);
        if (idx > -1) {
        	$scope.purchaseOrderToSave.splice(idx, 1);
        }
    }
    
    function setPurchaseOrder(consultant) {
        console.log($scope.purchaseOrder);
        var createPurchaseConsultant = {person: consultant, purchaseOrder: $scope.purchaseOrder, totalHours: $scope.totalHours, project: $scope.project, unitValue: null, purchaseOrder: $scope.purchaseOrder.purchaseOrder, partnerOrganization: consultant.organization};
    	$scope.purchaseOrderToSave.push(createPurchaseConsultant);
    }
    */
    function getConsultant (consultantId){
        personService.getPersonById(consultantId).then(function(response){
        	setPurchaseOrder(response.data)
        })
    }
    
    $scope.getByTaskAndPerson = function() {
        var getSuccess = function (response) {
            if (response.purchaseOrders.length == 0) {
                $scope.listpurchaseOrders = [ { "purchaseOrder": "" } ];
                $scope.purchaseOrder = { purchaseOrder: "" };
            } else {
                $scope.listpurchaseOrders = response.purchaseOrders;
                $scope.purchaseOrder = response.purchaseOrders[0];
            }
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        }

        $scope.loadingPromise = purchaseOrderService.getByTaskAndPerson($scope.temp_task.id, $scope.temp_consultant.id)
            .success(getSuccess)
            .error(getError);
    }
    
    function update (){
    	$log.info("You have selected an item!!!");
        $scope.selected=true;
        
        var getSuccess = function (response) {
            $log.debug(response);
            $scope.temp_task=response;
        }

        var getError = function (response) {
        	$scope.error_msg = data;
        }

        $scope.loadingPromise = projectService.getTaskBy($scope.project.id,$scope.temp_task.id)
            .success(getSuccess)
            .error(getError);
    }
    
    function cancel (){
        limpar();
    }
    
    function limpar(){
        $scope.temp_consultant = { name: "" };
        $scope.temp_task = { consultants : [] };
        $scope.selected = false;
        $scope.listpurchaseOrders = [ ];
        $scope.purchaseOrder = {};

        $timeout(function(){
            $scope.save=false;
        	},500);
    	}limpar();

	});