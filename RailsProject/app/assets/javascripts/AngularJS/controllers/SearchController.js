SoonzikApp.controller('SearchCtrl', ['$scope', "$routeParams", "HTTPService", "NotificationService", "$location", "$rootScope", 'SecureAuth', function ($scope, $routeParams, HTTPService, NotificationService, $location, $rootScope, SecureAuth) {

	$scope.searchParam = {
		value: $routeParams.value
	};
	$scope.loading = true;
	$scope.box = {
		all: true,
		users: true,
		artists: true,
		musics: true,
		albums: true,
		packs: true
	}
	$scope.result = {
		user: [],
		album: [],
		artist: [],
		music: [],
		artist: [],
		pack: []
	}

	$scope.initSearch = function() {
		$scope.loading = true;
		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
			  { key: "secureKey", value: key },
			  { key: "user_id", value: id },
			  { key: "query", value: $scope.searchParam.value }
			];

			HTTPService.search(parameters).then(function(response) {
				$scope.result = response.data.content;
				$scope.loading = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_SEARCH_REQUEST_ERROR_MESSAGE);
			});
		});
	}

	$scope.changeBox = function(key) {
		if (key == "all") {
			$scope.box.users = $scope.box.all;
			$scope.box.artists = $scope.box.all;
			$scope.box.musics = $scope.box.all;
			$scope.box.albums = $scope.box.all;
			$scope.box.packs = $scope.box.all;
		} else {
			$scope.box.all = $scope.box.users && $scope.box.artists && $scope.box.musics && $scope.box.albums && $scope.box.packs;
		}
	}

	$scope.newSearch = function() {
		$location.path('/search/' + encodeURIComponent($scope.searchParam.value))
	}

	$scope.formatDuration = function(duration) {
  	var min = ~~(duration / 60);
  	var sec = duration % 60;

  	if (min.toString().length == 1)
  		min = "0" + min;
  	if (sec.toString().length == 1)
  		sec = "0" + sec;
  	return min + ":" + sec;
	}

}]);