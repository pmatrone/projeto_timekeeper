(function(){
    'use strict';
    
    var servicesApp = angular.module("servicesApp");
    
    servicesApp.factory("personService", personService);
    
    function personService($http){
    	
        var service = {};
        var endpoint="svc/person";
        
        service.getProjectManagers = function(){
            return $http.get(endpoint + '/pms');
        };
        
        service.getPersonById = function(personId){
            return $http.get(endpoint + "/" + personId)
        };
        
        service.getPersonsByStatus = function(personStatusId){
            return $http.get(endpoint + '/list?e=' + personStatusId);
        };
        
        service.getConsultantsByTasks = function(listTasksId){
            return $http.post(endpoint + '/consultants/tasks', listTasksId);
        };
        
        service.disablePerson = function(personId){
            return $http.get(endpoint + "/" + personId + "/disable");
        };
        
        service.enablePerson = function(personId){
            return $http.get(endpoint + "/" + personId + "/enable");
        };
        
        service.deletePerson = function(personId){
            return $http.get(endpoint + "/" + personId + "/delete");
        };

        return service;
    }
})();