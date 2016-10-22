SoonzikArtistApp.controller('PropositionCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout) {
	$scope.loading = true;
	$scope.loadingSave = false;
	$scope.albums = [];
	$scope.albumInPacks = [];

	$scope.propositionInit = function() {
		HTTPService.getPropose().then(function(response) {
			$scope.albums = response.data.albums;
			for (var i = 0 ; i < $scope.albums.length ; i++) {
				$scope.albums[i].baseValue = $scope.albums[i].getProposed;
			}
			$scope.albumInPacks = response.data.albumInPacks;
			$scope.loading = false;
		}, function(error) {
			NotificationService.error("Error while loading the informations");
		});
	}

	$scope.savePropose = function() {
		var arr_id = []
		var arr_obj = []
		$scope.loadingSave = true;

		for (var i = 0 ; i < $scope.albums.length ; i++) {
			if ($scope.albums[i].baseValue != $scope.albums[i].getProposed) {
				arr_id.push($scope.albums[i].id);
				arr_obj.push($scope.albums[i]);
			}
		}

		if (arr_id.length > 0) {
			HTTPService.setPropose({ arr_id: arr_id }).then(function(response) {
				for (var i = 0 ; i < arr_obj.length ; i++) {
					arr_obj[i].baseValue = !arr_obj[i].baseValue;
					arr_obj[i].getProposed = arr_obj[i].baseValue;
				}
				$scope.loadingSave = false;
			}, function(error) {
				NotificationService.error("An error occured while saving, please try later");
			});
		} else {
			$scope.loadingSave = false;
		}
	}
}]);