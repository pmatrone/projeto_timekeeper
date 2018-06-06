(function(){
    'use strict';
    
    var servicesApp = angular.module("servicesApp");
    
    servicesApp.factory("purchaseOrderService", purchaseOrderService);
    
    function purchaseOrderService($http){
        var service = {};
        var endpoint = "svc/purchase-orders/";
        
        service.list = function(oid, pos) {
            return $http.get(endpoint + "?oid=" + oid + "&pos=" + pos);
        }
        
        service.get = function(purchaseOrderId){
            return $http.get(endpoint + purchaseOrderId);
        };
        
        service.save = function(purchaseOrder){
            return $http.post(endpoint, purchaseOrder);
        };
        
        service.getProjectManagers = function(){
            return $http.get(endpoint + 'pms');
        };
        
        service.getByTaskAndPerson = function(taskId, personId){
            return $http.get(endpoint + "getByTask?taskId=" + taskId + "&personId=" + personId);
        };
        
        service.finishPO = function(purchaseOrderId){
            return $http.post(endpoint + "finishPo", purchaseOrderId);
        };

        return service;
    }
})();