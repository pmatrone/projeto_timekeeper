var projectApp = angular.module("project_ctrl", [ "ngRoute", "ngResource", "ui.bootstrap", "servicesApp", "timekeeperApp" ]);


// retrieve a specific task name given a task id
projectApp.filter('taskName', function() {
    return function(input, id) {
        var i=0, len=input.length;
        for (; i<len; i++) {
            if (input[i].id == id) {
                return input[i].name;
            }
        }
        return null;
    }
});
