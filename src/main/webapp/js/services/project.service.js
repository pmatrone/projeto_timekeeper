(function(){
    'use strict';
    /** Services Module */
    var servicesApp = angular.module("servicesApp");
    

    servicesApp.factory("projectService", projectService);
    
    
    function projectService($http){
        var service = {};
        var endpoint="svc/project";
        
        service.getProject = function(id){
            return $http.get(endpoint + '/' + id);
        };

        service.getTasksByProjectId = function(id){
            return $http.get(endpoint + '/' + id + "/tasks");
        };

        service.getTaskBy = function(projectId,taskId){
            return $http.get(endpoint + '/' + projectId + "/task/"+taskId);
        }
        
        service.getAllProjectsByStatus = function(projectStatusId){
            return $http.get(endpoint + '/list?e=' + projectStatusId);
        };
        
        service.getallProjectsByConsultant = function(userId){
            return $http.get(endpoint + '/list-by-cs?cs=' + userId);
        };
        
        service.disableProject = function(projectId){
            return $http.get(endpoint + "/" + projectId + "/disable");
        };
        
        service.enableProject = function(projectId){
            return $http.get(endpoint + "/" + projectId + "/enable");
        };
        
        service.deleteProject = function(projectId){
            return $http.get(endpoint + "/" + projectId + "/delete");
        };
        
        service.saveProject = function(project){
            return $http.post(endpoint + "/save", project);
        };
        
        service.associateConsultants = function(project){
            return $http.post(endpoint + "/associate-consultants", project);
        };
        
        service.getTasksType = function(){
            return $http.get(endpoint + "/task_types");
        };
        
        service.getProjectByPartnerId = function(partnerId){
            return $http.get(endpoint + "/task_types");
        };

        return service;
    }
})();