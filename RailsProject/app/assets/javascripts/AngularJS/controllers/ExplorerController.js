SoonzikApp.controller('ExplorerCtrl', ['$scope', "$routeParams", "HTTPService", "NotificationService", "$timeout", "$location", "$rootScope", 'SecureAuth', function ($scope, $routeParams, HTTPService, NotificationService, $timeout, $location, $rootScope, SecureAuth) {

	$scope.loading = true;
	$scope.loadingGenre = false;
	$scope.selectedInfluence = null;
	$scope.selectedGenre = null;
	$scope.selectedAmbiance = null;

	$scope.influences = [];
	$scope.ambiances = [];
	$scope.genreWindow = { onTheLeft: false, displayable: false };
	$scope.influenceWindow = { onTheLeft: false, displayable: false };
	$scope.ambianceWindow = { onTheLeft: false, displayable: false };

	$scope.state = 0;

	$scope.currentPage = 1;
	$scope.totalPage = 0;

	$scope.explorerInit = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];
			HTTPService.getInfluences(parameters).then(function(response) {
				$scope.influences = response.data.content;

				if (typeof $routeParams.influence !== "undefined") {
					for (var i = 0 ; i < $scope.influences.length ; i++) {
						if ($scope.influences[i].id == $routeParams.influence) {
							$scope.chooseInfluence($scope.influences[i]);
							break;
						}
					}
					if ($scope.selectedInfluence != null && typeof $routeParams.genre !== "undefined") {
						$scope.chooseGenre({ id: $routeParams.genre });
					}
				}

				$scope.loading = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_EXPLORER_GET_INFLUENCES_ERROR_MESSAGE);
			});

			HTTPService.getAmbiances(parameters).then(function(response) {
				$scope.ambiances = response.data.content;

				if (typeof $routeParams.ambiance !== "undefined") {
					for (var i = 0 ; i < $scope.ambiances.length ; i++) {
						if ($scope.ambiances[i].id == $routeParams.ambiance) {
							$scope.chooseAmbiance($scope.ambiances[i]);
							break;
						}
					}
				}

				$scope.loading = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_EXPLORER_GET_AMBIANCES_ERROR_MESSAGE);
			});
		});
	}

	$scope.influencesInit = function() {
		$scope.state = 1;
	}

	$scope.genresInit = function() {
		$scope.state = 2;
	}

	$scope.chooseInfluence = function(influence) {
		$scope.selectedInfluence = influence;
		$location.path('/explorer/influence/' + $scope.selectedInfluence.id, false);
		$scope.state = 1;
		$scope.influenceOpen();
	}

	$scope.chooseAmbiance = function(ambiance) {
		$scope.selectedAmbiance = ambiance;
		$location.path('/explorer/ambiance/' + $scope.selectedAmbiance.id, false);
		$scope.state = 1;
		$scope.ambianceOpen();
		HTTPService.getAmbiance(ambiance.id).then(function(response) {
			$scope.selectedAmbiance = response.data.content;
			$scope.loading = false;
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_EXPLORER_GET_AMBIANCE_ERROR_MESSAGE);
		});
	}

	$scope.chooseGenre = function(genre) {
		$scope.state = 2;
		$scope.loadingGenre = true;
		$scope.currentPage = 1;

		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];
			var countParams = [
				{ key: "count", value: "true" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			]

			HTTPService.getGenre(genre.id, countParams).then(function(response) {
				$scope.totalPage = $rootScope.toInt(response.data.content);
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_EXPLORER_GET_GENRE_ERROR_MESSAGE);
			});

			HTTPService.getGenre(genre.id, parameters).then(function(response) {
				$scope.selectedGenre = response.data.content;
				$location.path('/explorer/influence/' + $scope.selectedInfluence.id + "/" + $scope.selectedGenre.id, false);
				$scope.loadingGenre = false;
				$scope.genreOpen();
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_EXPLORER_GET_GENRE_ERROR_MESSAGE);
			});
		});
	}

	$scope.influenceOpen = function() {
		$scope.genreWindow = { onTheLeft: false, displayable: false };
		$scope.influenceWindow = { onTheLeft: false, displayable: true };
		$timeout(function() {
			$scope.influenceWindow.onTheLeft = true;
		}, 200);
	}

	$scope.ambianceOpen = function() {
		$scope.genreWindow = { onTheLeft: false, displayable: false };
		$scope.influenceWindow = { onTheLeft: false, displayable: false };
		$timeout(function() {
			$scope.ambianceWindow.onTheLeft = true;
		}, 200);
	}

	$scope.genreOpen = function() {
		$scope.influenceWindow = { onTheLeft: false, displayable: false };
		$scope.genreWindow = { onTheLeft: false, displayable: true };
		$timeout(function() {
			$scope.genreWindow.onTheLeft = true;
		}, 200);
	}

	$scope.reset = function() {
		$scope.selectedInfluence = null;
		$scope.selectedGenre = null;
		$scope.state = 0;
		$scope.loadingGenre = false;
		$scope.genreWindow = { onTheLeft: false, displayable: false };
		$scope.influenceWindow = { onTheLeft: false, displayable: false };
		$scope.ambianceWindow = { onTheLeft: false, displayable: false };
		$location.path('/explorer/', false);
	}

	$scope.resetInfluence = function() {
		if ($scope.state != 1) {
			$scope.selectedGenre = null;
			$scope.state = 1;
			$scope.loadingGenre = false;
			$scope.genreWindow = { onTheLeft: false, displayable: false };
			$scope.influenceOpen();
			$location.path('/explorer/influence/' + $scope.selectedInfluence.id, false);
		}
	}

  $scope.formatTime = function(duration) {
  	var min = ~~(duration / 60);
  	var sec = duration % 60;

  	if (min.toString().length == 1)
  		min = "0" + min;
  	if (sec.toString().length == 1)
  		sec = "0" + sec;
  	return min + ":" + sec;
  }

	/* Utils function */

  $scope.shadeColor = function(color, percent) {   
    var f = parseInt(color.slice(1),16),t=percent<0?0:255,p=percent<0?percent*-1:percent,R=f>>16,G=f>>8&0x00FF,B=f&0x0000FF;
    return "#"+(0x1000000+(Math.round((t-R)*p)+R)*0x10000+(Math.round((t-G)*p)+G)*0x100+(Math.round((t-B)*p)+B)).toString(16).slice(1);
	}

}]);