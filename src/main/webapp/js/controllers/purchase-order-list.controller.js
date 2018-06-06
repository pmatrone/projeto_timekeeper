'use strict';

timekeeperApp.controller('purchaseOrderListController', function($filter, $scope, $http, $window, purchaseOrderService, organizationService) {
    $scope.loading = true;
    $scope.listPartners = {};
    $scope.list_partnerOrganization = { id: 0 };
    $scope.list_notEmptyPurchaseOrder = false;

    $scope.purchaseOrders = {
        msg: "",
        purchaseOrders: []
    };
    
    function init() {
        $scope.list();
        $scope.listPartnerOrganizations();
    }

    $scope.list = function list() {
        $scope.loading = true;
        var getSuccess = function (response) {
            $scope.purchaseOrders.msg = response["msg"];
            $scope.purchaseOrders.purchaseOrders = response["purchaseOrders"];
            $scope.loading = false;
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        var partnerOrganizationId = $scope.list_partnerOrganization == null ? 0 : $scope.list_partnerOrganization.id;
        $scope.loadingPromise = purchaseOrderService.list(partnerOrganizationId, $scope.list_notEmptyPurchaseOrder)
            .success(getSuccess)
            .error(getError);
    }
    
    $scope.finish = function finish(purchaseOrderId) {
        $scope.loading = true;
        var getSuccess = function (response) {
        	$scope.loading = false;
        	$scope.saved = true;
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = purchaseOrderService.finishPO(purchaseOrderId)
            .success(getSuccess)
            .error(getError);
    }

    $scope.listPartnerOrganizations = function() {
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

    init();
});