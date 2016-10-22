SoonzikApp.controller('HeaderCtrl', ['$scope', "$routeParams", "$location", "SecureAuth", "HTTPService", "$timeout", "NotificationService", '$rootScope', '$cookies', '$window', function ($scope, $routeParams, $location, SecureAuth, HTTPService, $timeout, NotificationService, $rootScope, $cookies, $window) {

	$scope.menuOpen = false;
	$scope.search = {
		value: ""
	};
	$scope.user = false;
	$scope.tweets = [];
	$scope.notifs = [];

	$scope.initHeader = function() {
		$("#inputSearch").keydown(function (t) {
			if (event.keyCode == 13) {
				$scope.sendSearch();
			}
		});

		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

		$scope.$on('user:changeImg', function(event, data) {
			$("#profilePicture").attr("src", "/assets/usersImage/avatars/" + data.url)
		});

		
		if ($scope.user) {
			$scope.newNotif(true);
		}
	}

	$scope.switchMenu = function() {
		$scope.menuOpen = !$scope.menuOpen;
	}

	$scope.sendSearch = function() {
		$location.path('/search/' + encodeURIComponent($scope.search.value));
	}

	$scope.closeMenu = function() {
		$scope.menuOpen = false;
	}

	$scope.newNotif = function(firstLoop) {
		SecureAuth.securedTransaction(function (key, user_id) {
			var params = [
				{ key: "user_id", value: user_id },
				{ key: "secureKey", value: key },
				{ key: "attribute[read]", value: false },
				{ key: "limit", value: 10 }
			];
			HTTPService.findNotif(params).then(function(response) {
				tmp_notif = response.data.content;

				if (firstLoop == true) {
					$scope.notifs = tmp_notif;
					$scope.$on('notif:askNew', function() { $rootScope.$broadcast('notif:getNews', $scope.notifs); });
					$scope.$on('notif:read', function(event, data) {
						for (var i = 0 ; i < $scope.notifs.length ; i++) {
							if ($scope.notifs[i].id == data) { $scope.notifs[i].read = true; }
						}
					});
				} else {
					var newNotif = [];
					if ($scope.notifs.length == 0) {
						newNotif = tmp_notif;
					} else {
						var limit = 0
						for (var i = 0 ; i < tmp_notif.length ; i++) {
							if (tmp_notif[i].id == $scope.notifs[0].id) {
								limit = i;
							}
						}
						newNotif = tmp_notif.splice(0, limit);
					}

					if (newNotif.length > 0) {
						$scope.notifs = newNotif.concat($scope.notifs);
						$rootScope.$broadcast('notif:new', newNotif);
						NotificationService.info("You have " + newNotif.length + " new Notifications")
					}
				}
				$timeout(function() {
					$scope.newNotif(false);
				}, 15000);
			}, function(error) {
				$timeout(function() {
					$scope.newNotif(false);
				}, 20000);
			});
		});
	}

	$scope.countNotRead = function() {
		var count = 0;
		for (var i = 0 ; i < $scope.notifs.length ; i++) {
			if ($scope.notifs[i].read == false) { count++; }
		}
		return count;
	}

	$scope.chooseLanguage = function(lang) {
		if ($scope.user) {
			SecureAuth.securedTransaction(function(key, id) {
				var params = {
					secureKey: key,
					user_id: id,
					user: {
						language: lang
					}
				};

				HTTPService.updateUser(params).then(function(response) {
					$window.location.reload();
				}, function(error) {
					Notification.error(labels.FILE_MENU_LANGUAGE_ERROR_LABEL);
				});
			});
		} else {
			$cookies.put("language", lang);
			$window.location.reload();
		}
	}

}]);