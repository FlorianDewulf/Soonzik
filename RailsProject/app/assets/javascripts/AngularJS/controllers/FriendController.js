SoonzikApp.controller('FriendCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', "$rootScope", '$location', function ($scope, SecureAuth, HTTPService, NotificationService, $rootScope, $location) {

$scope.loading = true;

	$scope.initFoundation = function () {
		$(document).foundation();
	}

	$scope.showFriends = function() {
		if (!$rootScope.user) { $location.path('/', true);return; }
		var current_user = SecureAuth.getCurrentUser();

		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];
			HTTPService.getFriends(current_user.id, parameters).then(function(response) {
				$scope.friends = response.data.content;
			}, function (error) {
				NotificationService.error($rootScope.labels.FILE_FRIEND_LOAD_FRIENDS_ERROR_MESSAGE);
			});
		});

		$scope.Friend = true;
	}
	$scope.loading = false;

}]);
