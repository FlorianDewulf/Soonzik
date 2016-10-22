SoonzikApp.controller('TooltipCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope', function ($scope, SecureAuth, HTTPService, NotificationService, $rootScope) {
	$scope.loading = false;

	$scope.tooltipMusic = null;
	$scope.tooltipPlaylist = null;
	$scope.tooltipCallbackAdd = function() {};
	$scope.tooltipCallbackReplace = function() {};
	$scope.tooltipCallbackSaveCurrent = function() {};
	$scope.state = 1;
	$scope.type = 1;
	$scope.idShare = { str: null };
	$scope.objShare = { str: null };
	$scope.playlist = null;

	$scope.input = {
		name: ""
	};

	/**
	 * TYPE: 1 -> Pop for music
	 * TYPE: 2 -> Pop for Save a playlist as a new one
	 * TYPE: 3 -> Pop for sharing
	 * TYPE: 4 -> Pop for the saved playlists in the player
	 * TYPE: 5 -> Pop for delete yes/no
	 * TYPE: 6 -> Pop for the current playlist save
	 */

	$scope.tooltipInit = function(music, t, additionalParams) {
		$scope.tooltipMusic = music;
		$scope.type = t;
		if (t == 2) {
			$scope.playlist = additionalParams;
		} else if (t == 3) {
			if (typeof additionalParams !== 'string') {
				$scope.objShare = additionalParams;
				$scope.$watchCollection('objShare', function(newVersion, oldVersion) {
					$scope.idShare.str = newVersion.str;
				});
			} else {
				$scope.idShare.str = additionalParams;
			}
		} else if (t == 4) {
			$scope.tooltipPlaylist = additionalParams[0];
			$scope.tooltipCallbackAdd = additionalParams[1];
			$scope.tooltipCallbackReplace = additionalParams[2];
		} else if (t == 5) {
			$scope.tooltipPlaylist = additionalParams;
		} else if (t == 6) {
			$scope.tooltipCallbackSaveCurrent = additionalParams;
		}
	}

	$scope.managePlaylist = function(playlist) {
		// add ou destroy
		SecureAuth.securedTransaction(function (key, user_id) {
			if (playlist.check) {
	  		var parameters = {
	  			secureKey: key,
	  			user_id: user_id,
					id: $scope.tooltipMusic.id,
					playlist_id: playlist.id
	  		};
	  		HTTPService.addToPlaylist(parameters).then(function(response) {
	  			$rootScope.$broadcast("player:addToPlaylist", { playlist: playlist, music: $scope.tooltipMusic });
	  		}, function(error) {
	  			playlist.check = !playlist.check;
	  			NotificationService.error($rootScope.labels.FILE_TOOLTIP_ADD_PLAYLIST_ERROR_MESSAGE);
	  		});
			} else {
				var parameters = [
					{ key: "user_id", value: user_id },
					{ key: "secureKey", value: key },
					{ key: "id", value: $scope.tooltipMusic.id },
					{ key: "playlist_id", value: playlist.id }
				];
				HTTPService.deleteFromPlaylist(parameters).then(function(response) {
	  			// Nothing to do
	  		}, function(error) {
	  			playlist.check = !playlist.check;
	  			NotificationService.error($rootScope.labels.FILE_TOOLTIP_ADD_PLAYLIST_ERROR_MESSAGE);
	  		});
			}
		});
	}

	$scope.savePlaylist = function() {
		if ($scope.input.name == "") return
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var parameters = {
  			secureKey: key,
  			user_id: user_id,
  			playlist: {
  				name: $scope.input.name,
  				user_id: user_id
  			}
  		};
  		HTTPService.savePlaylist(parameters).then(function(response) {
  			var musics = [];
  			var duration = 0;

  			for (var i = 0 ; i < $scope.playlist.musics.length ; i++) {
  				musics.push($scope.playlist.musics[i]);
  				duration += $scope.playlist.musics[i].duration;
  				SecureAuth.securedTransaction(function(key, user_id) {
			  		var parameters = {
			  			secureKey: key,
			  			user_id: user_id,
		  				id: $scope.playlist.musics[i].id,
		  				playlist_id: response.data.content.id
			  		};
			  		HTTPService.addToPlaylist(parameters).then(function(response) {
			  		}, function(error) {
			  			NotificationService.error("Error while saving a new music");
			  		});
			  	});
  			}
  			
				NotificationService.success("The playlist '" + $scope.input.name + "' has been created");
  			$scope.input.name = "";
				var pl = response.data.content;
				pl.musics = musics;
				pl.duration = duration;
  			$rootScope.$broadcast("player:newPlaylist", pl);
				$rootScope.tooltip = false;
  		}, function(error) {
  			NotificationService.error($rootScope.labels.FILE_TOOLTIP_SAVE_PLAYLIST_ERROR_MESSAGE);
  		});
  	});
  }

	$scope.changeState = function(state) {
		$scope.state = state;
	}

	$scope.listen = function() {
		$rootScope.$broadcast('player:play', { song: $scope.tooltipMusic });
		$rootScope.tooltip = false;
	}

	$scope.addMusicToCurrentPlaylist = function() {
		$rootScope.playlist.push({ title: $scope.tooltipMusic.title, id: $scope.tooltipMusic.id, obj: $scope.tooltipMusic });
		$rootScope.tooltip = false;
	}

  $scope.removePlaylist = function() {
  	var playlistToRemove = null;

  	for (var indexOfMyPlaylist in $rootScope.myPlaylists) {
			if ($rootScope.myPlaylists[indexOfMyPlaylist].id == $scope.tooltipPlaylist) { playlistToRemove = $rootScope.myPlaylists[indexOfMyPlaylist]; }
  	}

  	if (playlistToRemove) {
	  	SecureAuth.securedTransaction(function(key, user_id) {
	  		var params = [
	  			{ key: "id", value: playlistToRemove.id},
	  			{ key: "user_id", value: user_id},
	  			{ key: "secureKey", value: key }
	  		];
	  		HTTPService.destroyPlaylist(params).then(function() {
	        $rootScope.$broadcast("deletePlaylist", playlistToRemove);
	  			for (var indexOfMyPlaylist in $rootScope.myPlaylists) {
	  				if ($rootScope.myPlaylists[indexOfMyPlaylist].id == playlistToRemove.id) {
	  					$rootScope.myPlaylists.splice(indexOfMyPlaylist, 1);
	  					break;
	  				}
	  			}
	  		}, function(error) {
	  			NotificationService.error($rootScope.labels.FILE_PLAYER_DELETE_PLAYLIST_ERROR_MESSAGE + playlistToRemove.name);
	  		});
	  	});
	  }
  }

  $scope.saveNewPlaylistFromCurrent = function() {
		if ($scope.input.name == "") return
		$scope.tooltipCallbackSaveCurrent($scope.input.name);
		$rootScope.tooltip = false;
  }

}]);