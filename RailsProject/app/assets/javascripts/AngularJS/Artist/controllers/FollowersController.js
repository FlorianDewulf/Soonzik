SoonzikArtistApp.controller('FollowersCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout) {
	$scope.loading = true;
	$scope.user = false;
	$scope.list = [];
	$scope.total = 0;

	$scope.initFunc = function() {
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}
		if ($scope.user != false) {
			reload($scope.user.id);
		}
	}

	var reload = function(user_id) {
		HTTPService.getFollowers(user_id).then(function(response) {
			var arr = response.data.content;

			$scope.total = arr.length;

			if (arr.length > 7) {
				arr.splice(7);
			}

			if (arr.length != 0 && $scope.list.length == 0) {
				$scope.list = arr;
			} else if (arr.length != 0 && arr[0].id != $scope.list[0].id) {
				$scope.list = arr;
			}
			$scope.loading = false;

			$timeout(function() { reload(user_id); }, 50000);
		}, function(error) {
			NotificationService.error("An error occured while loading you last followers");
		});
	}
}]);