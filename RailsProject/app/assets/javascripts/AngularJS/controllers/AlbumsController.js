SoonzikApp.controller('AlbumsCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope) {
	$scope.loading = true;
	$scope.album = {};

	$scope.resourceName = "albums"

	$rootScope.likes = {
		count: 0,
		isLiked: false
	};

	$scope.commentariesOffset = 0;
	$scope.resourcesCommentaries = [];
	$scope.commentLoading = true;
	$scope.comment = {
		value: ""
	};
	$scope.goldenLock = false;

	$scope.initAlbum = function() {
		var id = $routeParams.id;

		SecureAuth.securedTransaction(function (key, user_id) {
			var parameters = [
				{ key: "user_id", value: user_id },
				{ key: "secureKey", value: key }
			];

			HTTPService.getAlbum(id, parameters).then(function(response) {
				$scope.album = response.data.content;
				$rootScope.likes.count = $scope.album.likes;
				$rootScope.likes.isLiked = $scope.album.hasLiked;
				$scope.loadComments();

				if ($rootScope.user != false) {
					var note_array_id = []

					for (var j = 0 ; j < $scope.album.musics.length ; j++) {
						note_array_id.push($scope.album.musics[j].id);
						$scope.album.musics[j].goldenStars = null;
					}

					var noteParameters = [
						{ key: "user_id", value: $rootScope.user.id },
						{ key: "arr_id", value: "[" + encodeURI(note_array_id) + "]" },
						{ key: "secureKey", value: key }
					]

					HTTPService.getMusicNotes(noteParameters).then(function(response) {
						for (var j = 0 ; j < $scope.album.musics.length ; j++) {
							for (var k = 0 ; k < response.data.content.length ; k++) {
								if (response.data.content[k].music_id == $scope.album.musics[j].id) {
									$scope.album.musics[j].note = response.data.content[k].note;
									$scope.album.musics[j].album = $scope.album;
								}
							}
						}
					}, function(error) {
						NotificationService.error($rootScope.labels.FILE_ALBUM_GET_NOTES_ERROR_MESSAGE);
					});
				}

				$(window).scroll(function() {
					if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.commentLoading == false) {
						$scope.$apply(function() {
							$scope.commentLoading = true;
							$scope.loadComments();
						});
					}
				});

				$scope.loading = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_ALBUM_GET_ALBUM_ERROR_MESSAGE);
			});
		});
	}

  $scope.uploadAddToPlaylist = function(music, playlist) {
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var parameters = {
  			secureKey: key,
  			user_id: user_id,
				id: music.id,
				playlist_id: playlist.id
  		};
  		HTTPService.addToPlaylist(parameters).then(function(response) {
  			NotificationService.success($rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_NOTIF_SUCCESS_PART_ONE + music.title + $rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_NOTIF_SUCCESS_PART_TWO);
  			$rootScope.$broadcast("player:addToPlaylist", { playlist: playlist, music: music });
  			$scope.selectedMusic = false;
  			$scope.tooltip = false;
  			playlist.original_check = true;
  			playlist.check = true;
  		}, function(error) {
  			NotificationService.error($rootScope.labels.FILE_ALBUM_ADD_PLAYLIST_ERROR_MESSAGE);
  		});
  	});
  }

	$scope.setGolden = function(music, index) {
		if ($scope.goldenLock == false) {
			music.goldenStars = index;
		}
	}

	$scope.setNote = function(music) {
		$scope.goldenLock = true;
		SecureAuth.securedTransaction(function (key, user_id) {
			HTTPService.setMusicNote(music.id, music.goldenStars, { user_id: user_id, secureKey: key }).then(function(response) {
				music.note = music.goldenStars;
				$scope.goldenLock = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_ALBUM_SET_NOTE_ERROR_MESSAGE);
			});
		});
	}

	$scope.range = function(n) {
		if (n > 0)
	  	return new Array(n);
	  else
	  	return []
  };

  $scope.formatTime = function(duration) {
  	var min = ~~(duration / 60);
  	var sec = duration % 60;

  	if (min.toString().length == 1)
  		min = "0" + min;
  	if (sec.toString().length == 1)
  		sec = "0" + sec;
  	return min + ":" + sec;
  }

  $scope.addAlbumToCart = function () {
		if (!$rootScope.user) { return; }
  	SecureAuth.securedTransaction(function (key, user_id) {
		var parameters = {
			secureKey: key,
			user_id: user_id,
			cart: {
				typeObj: "Album",
				obj_id: $scope.album.id,
				user_id: user_id
			}
		};
		HTTPService.addToCart(parameters).then(function(response) {
			NotificationService.success($rootScope.labels.FILE_ALBUM_ADD_ALBUM_MESSAGE + " " + $scope.album.id );
		
		}, function(repsonseError) {
			NotificationService.error($rootScope.labels.FILE_ALBUM_ADD_ALBUM_ERROR_MESSAGE);
		});
	});
  }

  $scope.addSongToCart = function(music) {
		if (!$rootScope.user) { return; }
  	SecureAuth.securedTransaction(function (key, user_id) {
			
			var parameters = {
				secureKey: key,
				user_id: user_id,
				cart: {
					typeObj: "Music",
					obj_id: music.id,
					user_id: user_id
				}
			};

			HTTPService.addToCart(parameters).then(function(response) {
				NotificationService.success($rootScope.labels.FILE_ALBUM_ADD_SONG_MESSAGE + " " + + music.id );
			
			}, function(repsonseError) {
				NotificationService.error($rootScope.labels.FILE_ALBUM_ADD_SONG_ERROR_MESSAGE);
			});
		});
  	$scope.loading = false;
  }

  $scope.loadComments = function() {
  	SecureAuth.securedTransaction(function (key, id) {
	  	var params = [
	  		{ key: "offset", value: $scope.commentariesOffset },
	  		{ key: "limit", value: 20 },
	  		{ key: "user_id", value: id },
	  		{ key: "secureKey", value: key }
	  	];
	  	HTTPService.getAlbumComments($scope.album.id, params).then(function(response) {
	  		$scope.resourcesCommentaries = $scope.resourcesCommentaries.concat(response.data.content);
	  		$scope.commentariesOffset = $scope.resourcesCommentaries.length;
				$scope.commentLoading = false;
	  	}, function(error) {
	  		NotificationService.error($rootScope.labels.FILE_ALBUM_LOAD_COMMENT_ERROR_MESSAGE);
	  	});
	});
  }

  $scope.sendComment = function() {
		if (!$rootScope.user) { return; }
  	SecureAuth.securedTransaction(function (key, user_id) {
		var parameters = { secureKey: key, user_id: user_id, content: $scope.comment.value };
		
		HTTPService.addAlbumComment($scope.album.id, parameters).then(function(response) {
			$scope.resourcesCommentaries.unshift(response.data.content);
			$scope.commentariesOffset++;
			$scope.comment.value = "";
		}, function (responseError) {
			NotificationService.error($rootScope.labels.FILE_ALBUM_SEND_COMMENT_ERROR_MESSAGE);
		});
	});
  }
}]);