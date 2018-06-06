var purchaseOrderApp = angular.module("purchaseOrder_ctrl", [ "ngRoute", "ngResource", "ui.bootstrap", "servicesApp", "timekeeperApp", "validation.match" ]);

/* ********************************************************
 * 
 * Purchase Order Controllers
 * 
 * ********************************************************
 */

purchaseOrderApp.controller("purchaseOrder_listing_ctrl", function($filter, $scope, $http, $window, timecardService) {
	
    $scope.list_enabled = 1;
    $scope.loading = true;
    
    $scope.refresh = function() {
    	$http.get('svc/purchase-order/list').success(function(data) {
			console.log("$scope.purchaseOrders =>");
			console.log(data["msg"]);
			console.log(data["purchaseOrders"]);
    		$scope.purchaseOrders = data;
    		$scope.loading = false;
    	});
    };
    $scope.refresh();
	
	function formatData(data){
		var y = data.substring(0,4);
		var m = data.substring(5,7);
		var d = data.substring(8,10);
		m--;
		return $filter('date')(new Date(y,m,d), 'dd/MM/yyyy');
	}
	
});
