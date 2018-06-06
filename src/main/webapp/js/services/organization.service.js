(function(){
    'use strict';
    
    var servicesApp = angular.module("servicesApp");
    
    servicesApp.factory("organizationService", organizationService);
    
    function organizationService($http){
        var service = {};
        var endpoint="svc/organization";
        
        service.getOrganizationsByStatus = function(organizationStatusId){
            return $http.get('svc/organization/list?e=' + organizationStatusId);
        };

        return service;
    }
})();