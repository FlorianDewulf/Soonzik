SoonzikApp.controller('PlaylistsCtrl', ['$scope', "$rootScope", "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, $rootScope, $routeParams, SecureAuth, HTTPService, NotificationService) {
	$scope.loading = true;

	$scope.id = false;
	$scope.tmp = false;
	$scope.playlist_obj = { id: null, name: null, musics: [], user: null }
	$scope.newItem = { name: "" }

	$scope.showInit = function() {
		var id = $routeParams.id;

		if ($.isNumeric(id)) {
			$scope.id = parseInt(id);
		} else if (/tmp:(\d*;)+/.test(id)) {
			$scope.id = id.substring(4).split(";");
			$scope.tmp = true;

			for (var i = 0 ; i < $scope.id.length ; i++) {
				if ($scope.id[i].length == 0 || $rootScope.toInt($scope.id[i]) == false) {
					$scope.id.splice(i, 1);
					i--;
				} else {
					$scope.id[i] = $rootScope.toInt($scope.id[i]);
				}
			}
		} else {
			NotificationService.error($rootScope.labels.FILE_PLAYLIST_BAD_ARGUMENT_ERROR_MESSAGE);
		}

		if ($scope.id != false)
			loadMusics();
	}

	var loadMusics = function() {
		if ($scope.tmp) {
			$scope.playlist_obj.id = $routeParams.id;
			$scope.playlist_obj.name = $rootScope.labels.FILE_PLAYLIST_TMP_NAME_LABEL;
			for (var i = 0 ; i < $scope.id.length ; i++) {
				getMusic($scope.id[i], i);
			}
		} else {
			SecureAuth.securedTransaction(function(key, id) {
				var parameters = [
				  { key: "secureKey", value: key },
				  { key: "user_id", value: id }
				];
				HTTPService.getPlaylist($scope.id, parameters).then(function(response) {
					$scope.playlist_obj = response.data.content;
					$scope.loading = false;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_PLAYLIST_GET_PLAYLIST_ERROR_MESSAGE);
				});
			});
		}
	}

	var getMusic = function(id, index) {
		SecureAuth.securedTransaction(function(key, user_id) {
			var parameters = [
			  { key: "secureKey", value: key },
			  { key: "user_id", value: user_id },
			  { key: "attribute[user_id]", value: $rootScope.user.id }
			];
			HTTPService.getMusic(id).then(function(response) {
				$scope.playlist_obj.musics[index] = response.data.content;
				if (index + 1 == $scope.id.length) {
					$scope.loading = false;
				}
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_PLAYLIST_GET_MUSIC_ERROR_MESSAGE + i);
			});
		});
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
  
  $scope.saveTooltip = function() {
  	if ($scope.tooltip == false || $scope.tooltip.type != "save") {
  		$scope.tooltip = { type: "save" };
  	} else {
  		$scope.tooltip = false;
  	}
  }

	$scope.listenPlaylist = function() {
		$rootScope.$broadcast("player:addPlaylist", { list: $scope.playlist_obj.musics });
	}

	$scope.$on("newPlaylist", function(event, data) {
		$rootScope.myPlaylists.push(data);
	});

	$scope.$on("deletePlaylist", function(event, data) {
		for (var i = 0 ; i < $rootScope.myPlaylists.length ; i++) {
			if (data.id == $rootScope.myPlaylists[i].id) {
				$rootScope.myPlaylists.splice(i, 1);
				break;
			}
		}
	});
}]);