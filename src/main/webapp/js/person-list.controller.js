var projectApp = angular.module("person_ctrl");

projectApp.controller("person_list_controller", function($scope, $filter, projectService, personService, $routeParams) {
	//functions
	$scope.getTimecard = getTimecard;
	$scope.disable = disablePerson;
	$scope.enable = enablePerson;
	$scope.delete = deletePerson;
	$scope.refresh = reloadPage;	
	
	activate();

	function activate() {
		getListPersons();
	}
	
	function getTimecard(person) {
		$scope.buttonTimecardText="Processing";
		$scope.buttonEnable=false;
		
		timecardService.getByConsultant(person.id).then(function(response){
			var timecards = [];
			var timecardsData = response.data;
	
			var oraclepaidId = timecardsData[0].consultant.oraclePAId;
			var name = timecardsData[0].consultant.name;
			var pa=timecardsData[0].project.paNumber;
	
			for(var i=0 ; i < timecardsData.length ; i++){
	
				for(var j=0 ; j < timecardsData[i].timecardEntriesDTO.length ; j++){
					var task = timecardsData[i].timecardEntriesDTO[j].taskDTO.name;
					var day = timecardsData[i].timecardEntriesDTO[j].day;
					var hours = timecardsData[i].timecardEntriesDTO[j].workedHours;
					var description = timecardsData[i].timecardEntriesDTO[j].workDescription;
					var row = {
						oraclepaidId:oraclepaidId,
						name:name,
						pa:pa,
						task:task,
						day:formatData(day),
						hours:hours,
						description:description || ""
					};
					timecards.push(row);
				}
			}
			console.log(timecards);
			person.timecards=timecards;
			person.getHeader = function () {
				return ["0racle Paid ID", "Name","PA","Task","Data","Worked Hours","Description"]
			};
			person.buttonEnable=true;
		});
	}

	function formatData(data){
		var y = data.substring(0,4);
		var m = data.substring(5,7);
		var d = data.substring(8,10);
		m--;
		
		return $filter('date')(new Date(y,m,d), 'dd/MM/yyyy');
	}
	
	function getListPersons() {
    	var personStatusId = 1;
    	
    	if($scope.list_enabled == true)
    		personStatusId = 2;

		var getSuccess = function(response) {
			$scope.persons = response;
			$scope.loading = false;
		}

		var getError = function(response) {
			$scope.error_msg = response;
		}

		$scope.loadingPromise = personService.getPersonsByStatus(personStatusId)
		.success(getSuccess)
		.error(getError);
	}

	function disablePerson (personId) {
		var getSuccess = function (response) {
			reloadPage();
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = personService.disablePerson(personId)
            .success(getSuccess)
            .error(getError);
    }
    
    function enablePerson (personId) {
    	var getSuccess = function (response) {
    		reloadPage();
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = personService.enablePerson(personId)
            .success(getSuccess)
            .error(getError);
    }
    
    function deletePerson (personId) {
    	var getSuccess = function (response) {
    		reloadPage()
        }

        var getError = function (response) {
        	$scope.error_msg = response;
        	$scope.loading = false;
        }

        $scope.loadingPromise = personService.deletePerson(personId)
            .success(getSuccess)
            .error(getError);        
    }
    
    function reloadPage(){
    	activate();
    }

});