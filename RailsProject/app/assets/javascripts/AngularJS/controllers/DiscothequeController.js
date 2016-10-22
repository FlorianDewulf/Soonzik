SoonzikApp.controller('DiscothequeCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$rootScope', 'NotificationService', '$modal', '$location', function ($scope, SecureAuth, HTTPService, $rootScope, NotificationService, $modal, $location) {

	$scope.loading = true;
	$scope.user = false;
	$scope.mymusic = { musics: [], albums: [], packs: [] };
	$scope.display = {
		selection: 'grid'
	}
	$scope.gridSelectedItem = {
		object: null,
		type: null
	};

	$scope.tooltip = false;
	$scope.selectedMusic = null;
	$scope.myPlaylists = [];

	$scope.discoInit = function() {
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}
		if ($scope.user == false) {
			$location.path('/', true);
			$scope.loading = false;
			return;
		} else {
			SecureAuth.securedTransaction(function(key, user_id) {
		  		var params = [
		  			{ key: "user_id", value: user_id},
		  			{ key: "secureKey", value: key }
		  		];
		  		HTTPService.getMyMusic(params).then(function(response) {
		  			$scope.mymusic = response.data.content;

		  			var arr_mus_id = [];
		  			var arr_alb_id = [];
		  			var arr_pack_id = [];

		  			/*
							GET NOTE MUSICS
		  			*/
		  			for (var i = 0 ; i < $scope.mymusic.musics.length ; i++) {
		  				arr_mus_id.push($scope.mymusic.musics[i].id);
		  			}
		  			var noteParametersMusics = [
						{ key: "user_id", value: $scope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(arr_mus_id) + "]" }
					]

					if (arr_mus_id.length > 0) {
						HTTPService.getMusicNotes(noteParametersMusics, params).then(function(response) {
				  			for (var ibis = 0 ; ibis < $scope.mymusic.musics.length ; ibis++) {
				  				// iteration on notes
				  				for (var jbis = 0 ; jbis < response.data.content.length ; jbis++) {
				  					if (response.data.content[jbis].music_id == $scope.mymusic.musics[ibis].id) {
				  						$scope.mymusic.musics[ibis].note = response.data.content[jbis].note;
						  				$scope.mymusic.musics[ibis].goldenStars = $scope.mymusic.musics[ibis].note;
						  				break;
						  			}
					  			}
				  			}
				  		}, function(error) {
				  			NotificationService.error($rootScope.labels.FILE_DISCOTHEQUE_GET_NOTES_ERROR_MESSAGE);
				  		});
					}

			  		/*
							GET NOTE ALBUMS
			  		*/
		  			for (var i = 0 ; i < $scope.mymusic.albums.length ; i++) {
		  				for (var j = 0 ; j < $scope.mymusic.albums[i].musics.length ; j++) {
		  					arr_alb_id.push($scope.mymusic.albums[i].musics[j].id);
		  				}
		  			}

		  			var noteParametersAlbums = [
						{ key: "user_id", value: $scope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(arr_alb_id) + "]" },
						{ key: "user_id", value: user_id},
		  				{ key: "secureKey", value: key }
					];

					if (arr_alb_id.length > 0) {
						HTTPService.getMusicNotes(noteParametersAlbums).then(function(response) {
				  			for (var ibis = 0 ; ibis < $scope.mymusic.albums.length ; ibis++) {
				  				for (var jbis = 0 ; jbis < $scope.mymusic.albums[ibis].musics.length ; jbis++) {

				  					// iteration on notes
				  					for (var kbis = 0 ; kbis < response.data.content.length ; kbis++) {
					  					if (response.data.content[kbis].music_id == $scope.mymusic.albums[ibis].musics[jbis].id) {
						  					$scope.mymusic.albums[ibis].musics[jbis].note = response.data.content[kbis].note;
						  					$scope.mymusic.albums[ibis].musics[jbis].goldenStars = $scope.mymusic.albums[ibis].musics[jbis].note;
						  					break;
						  				}
						  			}
				  				}
				  			}
				  		}, function(error) {
				  			NotificationService.error($rootScope.labels.FILE_DISCOTHEQUE_GET_NOTES_ERROR_MESSAGE);
				  		});
					}


			  		/*
							GET NOTE PACKS
			  		*/
		  			
		  			for (var i = 0 ; i < $scope.mymusic.packs.length ; i++) {
		  				for (var j = 0 ; j < $scope.mymusic.packs[i].albums.length ; j++) {
			  				for (var k = 0 ; k < $scope.mymusic.packs[i].albums[j].musics.length ; k++) {
			  					arr_pack_id.push($scope.mymusic.packs[i].albums[j].musics[k].id);
			  				}
			  			}
		  			}

		  			var noteParametersPacks = [
						{ key: "user_id", value: $scope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(arr_pack_id) + "]" },
						{ key: "user_id", value: user_id},
		  				{ key: "secureKey", value: key }
					];

					if (arr_pack_id.length > 0) {
			  			HTTPService.getMusicNotes(noteParametersPacks).then(function(response) {
				  			for (var ibis = 0 ; ibis < $scope.mymusic.packs.length ; ibis++) {
				  				for (var jbis = 0 ; jbis < $scope.mymusic.packs[ibis].albums.length ; jbis++) {
					  				for (var kbis = 0 ; kbis < $scope.mymusic.packs[ibis].albums[jbis].musics.length ; kbis++) {

					  					// iteration on notes
					  					for (var lbis = 0 ; lbis < response.data.content.length ; lbis++) {
						  					if (response.data.content[lbis].music_id == $scope.mymusic.packs[ibis].albums[jbis].musics[kbis].id) {
							  					$scope.mymusic.packs[ibis].albums[jbis].musics[kbis].note = response.data.content[lbis].note;
							  					$scope.mymusic.packs[ibis].albums[jbis].musics[kbis].goldenStars = $scope.mymusic.packs[ibis].albums[jbis].musics[kbis].note;
							  					break;
							  				}
							  			}

					  					
					  				}
					  			}
				  			}
				  		
				  		}, function(error) {
				  			NotificationService.error($rootScope.labels.FILE_DISCOTHEQUE_GET_NOTES_ERROR_MESSAGE);
				  		});
			  		}


					$scope.loading = false;
		  		}, function(error) {
		  			NotificationService.error($rootScope.labels.FILE_DISCOTHEQUE_GET_MUSICS_ERROR_MESSAGE);
		  		});

				var findPlaylistParams = [
					{ key: "attribute[user_id]", value: $scope.user.id },
					{ key: "user_id", value: user_id},
	  				{ key: "secureKey", value: key }
				];
				HTTPService.findPlaylist(findPlaylistParams).then(function(response) {
					$scope.myPlaylists = response.data.content;
					for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
						$scope.myPlaylists[i].check = false;
					}
					$scope.$on('newPlaylist', function(event, data) {
						playlist = JSON.parse(JSON.stringify(data));
						playlist.check = false;
						$scope.myPlaylists.push(playlist);
					});
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_FIND_PLAYLIST_ERROR_MESSAGE + playlist.name);
				});
			});
		}
	}

	$scope.download = function(music) {
		SecureAuth.securedTransaction(function (key, user_id) {
			var url = HTTPService.getMP3musicURL(music.id, [{ key: "user_id", value: user_id}, { key: "secureKey", value: key }, { key: "download", value: "true" }]);
			var win = window.open(url, '_blank');
		});
	}

	// Utils

	$scope.setGolden = function(music, index) {
		music.goldenStars = index;
	}

	$scope.setNote = function(music) {
		if ($scope.user != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				HTTPService.setMusicNote(music.id, music.goldenStars, { user_id: user_id, secureKey: key }).then(function(response) {
					music.note = music.goldenStars;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_SET_NOTE_ERROR_MESSAGE);
				});
			});
		} else {
			NotificationService.info($rootScope.labels.FILE_USER_NEED_LOGIN_ERROR_MESSAGE);
		}
	}

	$scope.selectObject = function(obj, type) {
		$scope.gridSelectedItem.object = obj;
		$scope.gridSelectedItem.type = type;
	}


	// For the edition of a music
	$scope.openAlbum = function(album) {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/views/discotheque/modal_album.html.haml',
      controller: 'ModalInstanceAlbumCtrl',
      resolve: {
      	album: function() {
      		return album;
      	},
      	download: function() {
      		return $scope.download;
      	}
      }
    });
    modalInstance.result.then(function () {
    }, function () {
    });
	}

	// For the edition of a music
	$scope.openPack = function(pack) {
    var modalInstance = $modal.open({
      templateUrl: '/assets/AngularJS/views/discotheque/modal_pack.html.haml',
      controller: 'ModalInstancePackCtrl',
      resolve: {
      	pack: function() {
      		return pack;
      	}
      }
    });
    modalInstance.result.then(function (album) {
    	$scope.openAlbum(album);
    }, function () {
    });
	}
}]);


/*
	*****************************
	The modal for album
	*****************************
*/

SoonzikApp.controller('ModalInstanceAlbumCtrl', ["$scope", "$modalInstance", "album", 'download', function ($scope, $modalInstance, album, download) {
	$scope.album = album;
	$scope.download = download;

	// On the save button
  $scope.ok = function () {
		$modalInstance.close();
  };

  // On the background click
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}]);


/*
	*****************************
	The modal for pack
	*****************************
*/

SoonzikApp.controller('ModalInstancePackCtrl', ["$scope", "$modalInstance", "pack", function ($scope, $modalInstance, pack) {
	$scope.pack = pack;

	// On the save button
  $scope.ok = function (album) {
		$modalInstance.close(album);
  };

  // On the background click
  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}]);