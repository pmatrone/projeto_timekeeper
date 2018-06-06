(function(){
    'use strict';
    /** Services Module */
    var servicesApp = angular.module("servicesApp");

    /** Project Service 
     *  responsable for the communication with the project rest endpoint
     */
    servicesApp.factory("timecardService",timecardService);
    function timecardService( $http){
        var service = {};
        var endpoint="svc/timecard";
        
        /**
         * Get project by id
         */
        service.getAllByPm=function(pm){
            return $http.get(endpoint+"/list?pm="+pm);
        };

         /**
         * Get project by id
         */
        service.setOnPA=function(id){
            return $http.post(endpoint+"/on-pa/"+id);
        };


        /**
         * Get project by id
         */
        service.getAllByPartner=function(){
            return $http.get(endpoint+"/list-partner");
        };

        /**
         * Get timecard by project id
         */
        service.getTimecardByProjects=function(){
            return $http.get(endpoint+"/project");
        };

        /**
         * Compare timecard by project id
         */
        service.compareTimeCard=function(file, sucessCallback, errorCallback){
            var formData = new FormData();
            formData.append('inputFile', file);
            return $http.post(endpoint+"/project-compare", formData, {
                headers : {
                    'Content-Type' : undefined
                }
            });
        };
        
        /**
         * Get project
         */
        service.get= function(id){
            return $http.get("svc/project/"+id+"/tc");
            
        };


        service.getById=function(id){
             return $http.get(endpoint + '/'+id);
        };

        service.getByConsultant=function(id){
            return $http.get(endpoint+"/list-cs?id="+id);
        }

        service.getPending=function(id){
            return $http.get(endpoint+"/list-pending");
        }

        return service;
    }
})();