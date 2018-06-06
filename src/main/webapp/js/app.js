var timekeeperApp = angular.module("timekeeperApp", 
			[ 
				'smart-table','ngSanitize', 'ngCsv',"ngRoute", "ngResource", "ui.bootstrap",'patternfly',
				"servicesApp", "org_ctrl", "person_ctrl", 
				"project_ctrl", "timecard_ctrl", "timekeeperControllers"
			]);

			//purchaseOrder_ctrl
timekeeperApp.config([ "$routeProvider", function($routeProvider) {

	console.log("app");
	$routeProvider.
	
	when("/persons", {
	    templateUrl : "persons.html",
	}).
	
	when("/person-new", {
	    templateUrl : "person-new.html",
	}).
	
	when("/person/:personId", {
	    templateUrl: "person-edit.html",
	}).
	
	when("/profile/:personId", {
	    templateUrl: "profile.html",
	}).
	
	when("/timecards", {
		templateUrl : "timecards.html",
	}).

	when("/dashboard", {
		templateUrl : "dashboard.html",
	}).

	when("/timecards-partner", {
		templateUrl : "timecards-partner.html",
	}).

	when("/timecard-partner-view/:tcId", {
		templateUrl : "timecard-partner-view.html",
	}).

	when("/timecards-cs", {
	    templateUrl : "timecards-cs.html",
	}).

	when("/timecard-new/:projectId", {
	    templateUrl : "timecard-new2.html",
	}).

	when("/timecard-view/:tcId", {
	    templateUrl : "timecard-table-view.html",
	}).
	when("/timecard-edit/:tcId", {
	    templateUrl : "timecard-edit.html",
	}).
	
	when("/projects", {
		templateUrl : "project-list.html",
	}).
	
	when("/project-new", {
	    templateUrl : "project-form.html",
	}).
	
	when("/project/:projectId", {
	    templateUrl: "project-form.html",
	}).

    when("/project-timecard", {
        templateUrl : "project-timecard.html",
    }).
	
    when("/projects-cs", {
        templateUrl : "projects-cs.html",
    }).
    
    when("/project-consultants/:projectId", {
        templateUrl : "project-consultants.html",
    }).
	
	when("/organizations", {
		templateUrl : "organizations.html",
	}).

	when("/organization-new", {
		templateUrl : "organization-new.html",
	}).
	
    when("/organization/:orgId", {
    	templateUrl: "organization-edit.html",
    }).
    
    when("/organization/:orgId", {
        templateUrl: "organization-edit.html",
    }).
    
    when("/purchase-orders/new", {
        templateUrl: "purchase-order-form.html",
    }).
    
	when("/purchase-orders/:purchaseOrderId", {
	    templateUrl: "purchase-order-form.html",
	}).
	
	when("/purchase-orders", {
		templateUrl : "purchase-order-list.html",
	});
	
}]);

/* ********************************************************
 * 
 * Utilitarios e variaveis globais
 * 
 * ********************************************************
 */

timekeeperApp.controller("menu_ctrl", function(MessageService, $scope, $rootScope, $window, $http, $location) {
    console.log("rootScope.user = ")
	console.log($rootScope.user);
    if ($rootScope.user != null) {
        $scope.user = $rootScope.user;

        $scope.role = function(roles) {
            for (var i = 0; i < roles.length; i++) {
                if (roles[i] == $scope.user.role.shortName) {
                    return true;
                }
            }
        };

    
    } else {
        console.log("user is null, authentication required.");
        $window.location.href = "pub.html";
    }
    
    
    $scope.logout = function() {
        $http.get("svc/auth/logout").
        success(function(data, status, header, config) {
            sessionStorage.removeItem("user");
            $window.location.href = "pub.html";
        });
    };
	
	$scope.getClass = function (path) {
		return ($location.path().substr(0, path.length) === path) ? 'active' : '';
	}
});

timekeeperApp.controller("message_ctrl", function(MessageService, $scope) {
    $scope.hasMessages = function() {
        return MessageService.hasMessages();
    };
    
    $scope.clearMessages = function() {
        MessageService.clearMessages();
    };
    
});


timekeeperApp.directive('float', function() {
	return {
		require : 'ngModel',
		link : function(scope, ele, attr, ctrl) {
			ctrl.$parsers.unshift(function(viewValue) {
				return parseFloat(viewValue, 10);
			});
		}
	};
});
timekeeperApp.directive('fileModel', [ '$parse', function($parse) {
    return {
        restrict : 'A',
        link : function(scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;

            element.bind('change', function() {
                scope.$apply(function() {
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
} ]);

timekeeperApp.filter('findById', function() {
    return function(input, id) {
      var i=0, len=input.length;
      for (; i<len; i++) {
        if (+input[i].id == +id) {
          return input[i];
        }
      }
      return null;
    }
});

timekeeperApp.filter('findByName', function() {
    return function(input, name) {
        var i=0, len=input.length;
        for (; i<len; i++) {
            if (input[i].name == name) {
                return input[i];
            }
        }
        return null;
    }
});

timekeeperApp.filter('dateDiffInDays', function () {
    var magicNumber = (1000 * 60 * 60 * 24);

    return function (fromDate, toDate) {
      if(toDate && fromDate){
        var num = (toDate - fromDate) / magicNumber;
        var dayDiff = Math.ceil(num);
        return dayDiff;
      }
    };
});

timekeeperApp.filter('dateNumOfWeeks', function () {
    return function (fromDate, toDate) {
        if(toDate && fromDate){
            var week1 = fromDate.getWeek();
            var week2 = toDate.getWeek();
            var weekDiff = week2 - week1 + 1;
            return weekDiff;
        }
    };
});

timekeeperApp.filter("uniqueID", function(){
  return function(data) {
    if(angular.isArray(data)) {
      var result = [];
      for(var i=0; i<data.length; i++) {
		var found = false;
        for(var j=0; j<result.length && found==false; j++) {
			if(data[i].id==result[j].id){
				console.log("iguais");
				found=true;
			}
		}
		if(found==false){
			result.push(data[i]);
		}
      }
      if(result.length > 0) {
        return result;
      }
    }
    return [];
  }
})

timekeeperApp.filter('sumOfValue', function () {
    return function (data, key) {
        if (typeof (data) === 'undefined' && typeof (key) === 'undefined') {
            return 0;
        }
        var sum = 0;
        for (var i = 0; i < data.length; i++) {
            var num = parseFloat(data[i][key]);
            if (isNaN(num))
                continue;
            sum = sum + num;
        }
        return sum;
    };
});



// from http://weeknumber.net/how-to/javascript
// used on timecard pages, to calculate the number of weeks to present to the user.
Date.prototype.getWeek = function() { 
    var date = new Date(this.getTime()); 
    date.setHours(0, 0, 0, 0); 
    // Thursday in current week decides the year. 
    date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7); 
    // January 4 is always in week 1. 
    var week1 = new Date(date.getFullYear(), 0, 4); 
    // Adjust to Thursday in week 1 and count number of weeks from date to week1. 
    return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000 - 3 + (week1.getDay() + 6) % 7) / 7); 
}


timekeeperApp.factory('authHttpResponseInterceptor',['$q','$location', '$window', 'MessageService', function($q, $location, $window, MessageService){
    return {
        response: function(response){
            if (response.status === 401) {
                console.log("Response 401");
            } else if (response.status === 403) {
                console.log("Response 403");
            }
            return response || $q.when(response);
        },
        responseError: function(rejection) {
            if (rejection.status === 401) {
                console.log("Response Error 401",rejection);
                $window.location.href = "pub.html";
            } else if (rejection.status === 400) {
                console.log("Response Error 400",rejection);
            } else if (rejection.status === 403) {
                MessageService.setMessages(rejection.data.message);
                console.log("Response Error 403", rejection);
            }
            return $q.reject(rejection);
        }
    }
}]);

timekeeperApp.config(['$httpProvider',function($httpProvider) {
    //Http Intercpetor to check auth failures for xhr requests
    $httpProvider.interceptors.push('authHttpResponseInterceptor');
}]);

timekeeperApp.run(function($rootScope, $window, MessageService) {

    $rootScope.$on( "$routeChangeStart", function(event, next, current) {
        MessageService.clearMessages();
    });
    
    $rootScope.user = JSON.parse(sessionStorage.getItem("user"));
    var user2 = JSON.parse(sessionStorage.getItem("user"));
    
	$rootScope.states= [{
		"id": "AC",
		"name": "Acre"
	},
	     {
		"id": "AL",
		"name": "Alagoas"
	},
	     {
		"id": "AM",
		"name": "Amazonas"
	},
	     {
		"id": "AP",
		"name": "Amapá"
	},
	     {
		"id": "BA",
		"name": "Bahia"
	},
	     {
		"id": "CE",
		"name": "Ceará"
	},
	     {
		"id": "DF",
		"name": "Distrito Federal"
	},
	     {
		"id": "ES",
		"name": "Espírito Santo"
	},
	     {
		"id": "GO",
		"name": "Goiás"
	},
	     {
		"id": "MA",
		"name": "Maranhão"
	},
	     {
		"id": "MG",
		"name": "Minas Gerais"
	},
	     {
		"id": "MS",
		"name": "Mato Grosso do Sul"
	},
	     {
		"id": "MT",
		"name": "Mato Grosso"
	},
	     {
		"id": "PA",
		"name": "Pará"
	},
	     {
		"id": "PB",
		"name": "Paraíba"
	},
	     {
		"id": "PE",
		"name": "Pernambuco"
	},
	     {
		"id": "PI",
		"name": "Piauí"
	},
	     {
		"id": "PR",
		"name": "Paraná"
	},
	     {
		"id": "RJ",
		"name": "Rio de Janeiro"
	},
	     {
		"id": "RN",
		"name": "Rio Grande do Norte"
	},
	     {
		"id": "RO",
		"name": "Rondônia"
	},
	     {
		"id": "RR",
		"name": "Roraima"
	},
	     {
		"id": "RS",
		"name": "Rio Grande do Sul"
	},
	     {
		"id": "SC",
		"name": "Santa Catarina"
	},
	     {
		"id": "SE",
		"name": "Sergipe"
	},
	     {
		"id": "SP",
		"name": "São Paulo"
	},
	     {
		"id": "TO",
		"name": "Tocantins"
	}];
});

