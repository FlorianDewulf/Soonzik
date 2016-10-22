SoonzikApp.controller("PlayerCtrl", ["$scope", "$rootScope", "HTTPService", "NotificationService", "SecureAuth", function ($scope, $rootScope, HTTPService, NotificationService, SecureAuth) {

  $scope.geolocDisplay = false;
  $scope.geoloc = false;
  $scope.position = {
    latitude: 0,
    longitude: 0
  }

  $scope.activeUrl = null;
  $scope.user = false;

  $scope.loaded = false;
  $scope.loading = true;

  $scope.paused = true;
  $scope.shuffle = false;
  $scope.volume = 1.0;
  $scope.oldvolume = 0.0;

  $scope.time = 0;
  $scope.timeFormated = "";

  $scope.indexPlaylist = 0;

  $scope.infomusic = { current: false, playlist: false };
  $scope.toDelete = false;
  $scope.newItem = { name: "" }
  $scope.newPlaylistFromCurrent = { name: "" }
  $scope.more = { btn: false };
  $scope.tmpUrlCurrentPlaylist = { str: "" };

  function n(n){
    return n > 9 ? "" + n: "0" + n;
  }

  function updateTime() {
    var val = Math.round($scope.wavesurfer.getCurrentTime(), 0);
    if (val != $scope.time) {
      $scope.time = val;
      var duration = Math.round($scope.wavesurfer.getDuration(), 0);
      $scope.timeFormated = $scope.formatedDuration(val) + "/" + $scope.formatedDuration(duration);
      if ($scope.$root.$$phase != '$apply' && $scope.$root.$$phase != '$digest') {
        $scope.$apply();
      }
    }
  }

  $scope.initPlayer = function() {
  	var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
      $scope.geolocDisplay = true;
		}

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        $scope.$apply(function() {
          $scope.geoloc = true;
          $scope.position = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          }
        });
      });
    }

  	$("#sliderVolume").slider({
      orientation: "vertical",
      range: "min",
      min: 0,
      max: 100,
      value: 100,
      slide: function( event, ui ) {
        $scope.volume = ui.value / 100;
        $scope.wavesurfer.setVolume($scope.volume);
        $scope.$apply();
      }
    });

    $(window).resize(resizeHiddenPlaylist);
    resizeHiddenPlaylist();
  }

  $scope.$on('player:play', function(event, data) {
    var dataObject = { title: data.song.title, id: data.song.id, obj: data.song };
    $scope.loaded = false;
    
    var inArray = isInPlaylist(dataObject);

    if (inArray !== false) {
    	$scope.indexPlaylist = inArray;
    } else {
    	$rootScope.playlist.push(dataObject);
    	$scope.indexPlaylist = $rootScope.playlist.length - 1;
    }
    $scope.tmpUrlCurrentPlaylist.str = $scope.tmpPlaylistLink();
    
    securePlay(dataObject);
  });

  $scope.$on('wavesurferInit', function (e, wavesurfer) {
	  $scope.wavesurfer = wavesurfer;

	  $scope.wavesurfer.on('play', function () {
      $scope.paused = false;
	  });

	  $scope.wavesurfer.on('pause', function () {
      $scope.paused = true;
	  });

	  $scope.wavesurfer.on('finish', function () {
	  	$scope.indexPlaylist++;
	  	if (($scope.indexPlaylist == $rootScope.playlist.length && $scope.shuffle == false) ||
	  		($scope.shuffle == true && $rootScope.playlist.length <= 1)) {
	      $scope.paused = true;
	      $scope.wavesurfer.stop(0);
	      $scope.timeFormated = "";
        $scope.indexPlaylist = 0;
        $scope.wavesurfer.empty();
	  	} else {
	  		if ($scope.shuffle == true) {
		  		var nextTrack = 0;
		  		do
		  			nextTrack = Math.abs(Math.random() * ($rootScope.playlist.length - 1))
		  		while (nextTrack != $scope.indexPlaylist - 1);
		  		$scope.indexPlaylist = nextTrack;
	  		}

        securePlay($rootScope.playlist[$scope.indexPlaylist]);
	  	}
      $scope.$apply();
	  });

	  $scope.wavesurfer.on('audioprocess', updateTime);
	  $scope.wavesurfer.on('seek', updateTime);
	  $scope.wavesurfer.on('ready', function () {
      $scope.loaded = true;
      updateTime();
      $scope.wavesurfer.play();
	  });
  });

  $scope.$on('player:addPlaylist', function(event, data) {
    var musicArray = data.list;

    for (var i = 0 ; i < musicArray.length ; i++) {
      if (isInPlaylist(musicArray[i]) == false)
        $rootScope.playlist.push({ title: musicArray[i].title, id: musicArray[i].id, obj: musicArray[i] });
    }

    if ($scope.paused == true && $rootScope.playlist.length > 0 && $scope.indexPlaylist == 0) {
      securePlay($rootScope.playlist[$scope.indexPlaylist]);
    }
  });

  $scope.$on("player:newPlaylist", function(event, data) {
    data.extend = false;
    data.share = false;
    data.url = 'http://lvh.me:3000/playlists/' + data.id;
    $rootScope.myPlaylists.push(data);
  });

  $scope.$on("player:addToPlaylist", function(event, data) {
    for (var i = 0 ; i < $rootScope.myPlaylists.length ; i++) {
      if ($rootScope.myPlaylists[i].id == data.playlist.id) {
        $rootScope.myPlaylists[i].musics.push(data.music);
        $rootScope.myPlaylists[i].duration += data.music.duration;
        return;
      }
    }
  })

  $scope.play = function (url) {
    if (!$scope.wavesurfer) {
      return;
    }
    $scope.activeUrl = url;

    $scope.wavesurfer.load($scope.activeUrl);
  };

  $scope.isPlaying = function (url) {
    return url == $scope.activeUrl;
  };

  $scope.isVolumeOn = function() {
  	var value = $scope.volume * 100;

  	if (parseInt(value) == 0)
  		return false;
  	return true;
  }

  $scope.displayPlaylist = function() {
  	if ($("#currentPlaylist").css("right") != "0px") {
	  	$("#currentPlaylist").css("right", 0);
  	} else {
	  	$("#currentPlaylist").css("right", -$("#currentPlaylist").width() - 100);
  	}
  }

  $scope.cleanPlaylist = function() {
	  $rootScope.playlist = [];
  	$scope.indexPlaylist = 0;
  }

  $scope.removeMusicFromPlaylist = function(index) {
	  $rootScope.playlist.splice(index, 1);
	  if (($scope.indexPlaylist == $rootScope.playlist.length && $scope.shuffle == false) ||
  		($scope.shuffle == true && $rootScope.playlist.length <= 1)) {
      $scope.paused = true;
      $scope.wavesurfer.seekTo(0);
      $scope.timeFormated = "";
      $scope.pausePlayer();
  	} else {
  		if ($scope.shuffle == true) {
	  		var nextTrack = 0;
	  		do
	  			nextTrack = Math.abs(Math.random() * ($rootScope.playlist.length - 1))
	  		while (nextTrack != $scope.indexPlaylist - 1);
	  		$scope.indexPlaylist = nextTrack;
  		}
	    
      securePlay($rootScope.playlist[$scope.indexPlaylist]);
  	}
  }

  var isInPlaylist = function(compareObject) {
  	for (var i = 0 ; i < $rootScope.playlist.length ; i++) {
  		if (compareObject.id == $rootScope.playlist[i].id)
  			return i;
  	}
  	return false;
  }

  var resizeHiddenPlaylist = function() {
  	var height = $(window).height();
  	var width = $(window).width();

  	$("#currentPlaylist").width(width);
  	$("#currentPlaylist").height(height - 60);

  	if ($("#currentPlaylist").css("right") != "0px") {
	  	$("#currentPlaylist").css("right", -$("#currentPlaylist").width() - 100);
  	}
  }

  $scope.previous = function() {
    if ($scope.indexPlaylist == 0) {
      if ($rootScope.playlist.length > 1) {
        $scope.indexPlaylist = $rootScope.playlist.length - 1;
        securePlay($rootScope.playlist[$scope.indexPlaylist]);
      }
    } else {
      $scope.indexPlaylist--;
      securePlay($rootScope.playlist[$scope.indexPlaylist]);
    }
  }

  $scope.pausePlayer = function() {
  	if ($scope.loaded && $scope.wavesurfer) {
  		if ($scope.paused == true && $scope.wavesurfer.getCurrentTime() == 0) {
  			$scope.playFromPlaylist($scope.indexPlaylist);
  		} else {
  			$scope.wavesurfer.playPause();
  		}
  	}
  }

  $scope.next = function() {
    if ($scope.indexPlaylist < $rootScope.playlist.length - 1) {
      $scope.indexPlaylist++;
      securePlay($rootScope.playlist[$scope.indexPlaylist]);
    } else {
      $scope.indexPlaylist = 0;
      $scope.wavesurfer.stop();
      $scope.wavesurfer.empty();
    }
  }

  $scope.playFromPlaylist = function(index) {
  	$scope.indexPlaylist = index;
  	securePlay($rootScope.playlist[$scope.indexPlaylist]);
  }

  $scope.formatedDuration = function(duration) {
    var minutes = Math.floor(duration / 60);
    var seconds = duration - minutes * 60;
    return n(minutes) + ":" + n(seconds);
  }

  $scope.infoForMusic = function(music, panel) {
  	if (panel == "current") {
  		$scope.infomusic.current = music;
  	} else {
  		$scope.infomusic.playlist = music;
  	}
  }

  $scope.addToCurrentPlaylist = function(playlist_musics) {
  	for (var i = 0 ; i < playlist_musics.length ; i++) {
  		var isIn = false;
  		for (var j = 0 ; j < $rootScope.playlist.length ; j++) {
  			if ($rootScope.playlist[j].obj.id == playlist_musics[i].id) { isIn = true; }
  		}
  		if (!isIn) {
  			$rootScope.playlist.push({ title: playlist_musics[i].title, id: playlist_musics[i].id, obj: playlist_musics[i] });
  		}
  	}
  }

  $scope.replaceToCurrentPlaylist = function(playlist_musics) {
  	var paused = $scope.paused;
  	$scope.wavesurfer.stop();
	  $scope.wavesurfer.seekTo(0);
  	$scope.wavesurfer.load("");
  	$scope.wavesurfer.empty();
  	$rootScope.playlist = [];
  	for (var i = 0 ; i < playlist_musics.length ; i++) {
  		$rootScope.playlist.push({ title: playlist_musics[i].title, id: playlist_musics[i].id, obj: playlist_musics[i] });
  	}
  	$scope.indexPlaylist = 0;
  	if (paused == false) {
  		$scope.playFromPlaylist(0);
  	}
  }

  $scope.removeFromPlaylist = function(music, playlist) {
  	SecureAuth.securedTransaction(function(key, user_id) {
  		var parameters = [
  			{ key: "id", value: music.id},
  			{ key: "playlist_id", value: playlist.id},
  			{ key: "user_id", value: user_id},
  			{ key: "secureKey", value: key }
  		];
  		HTTPService.deleteFromPlaylist(parameters).then(function() {
  			for (var i = 0 ; i < playlist.musics.length ; i++) {
  				if (playlist.musics[i].id == music.id) {
  					playlist.musics.splice(i, 1);
            if (typeof $rootScope.tooltip !== "string" && music.id == $rootScope.tooltip.id) { playlist.check = false; }
  					break;
  				}
  			}
  		}, function(error) {
  			NotificationService.error($rootScope.labels.FILE_PLAYER_REMOVE_FROM_PLAYLIST_ERROR_MESSAGE);
  		});
  	});
  }

  $scope.createPlaylist = function() {
    if ($scope.newItem.name.length > 0 && $scope.user != false) {
      SecureAuth.securedTransaction(function(key, user_id) {
        var parameters = {
          secureKey: key,
          user_id: user_id,
          playlist: {
            name: $scope.newItem.name,
            user_id: user_id
          }
        };
        $scope.newItem.name = "";
        HTTPService.savePlaylist(parameters).then(function(response) {
          var playlist = response.data.content;

          $rootScope.$broadcast("newPlaylist", playlist);
          playlist.extend = false;
          playlist.share = false;
          playlist.url = 'http://lvh.me:3000/playlists/' + playlist.id;
          playlist.duration = 0;
        }, function(error) {
          NotificationService.error($rootScope.labels.FILE_PLAYER_SAVE_IN_PLAYLIST_ERROR_MESSAGE);
        });
      });
    }
  }

  var securePlay = function(music) {
    if ($scope.user != false) {
      SecureAuth.securedTransaction(function(key, user_id) {
        $scope.play(HTTPService.getMP3musicURL(music.id, [{ key: "user_id", value: user_id}, { key: "secureKey", value: key }]));
      });
      if ($scope.geoloc) {
        SecureAuth.securedTransaction(function(key, user_id) {
          var params = {
            user_id: user_id,
            secureKey: key,
            listening: {
              user_id: user_id,
              music_id: music.id,
              latitude: $scope.position.latitude,
              longitude: $scope.position.longitude
            }
          }
          HTTPService.addListening(params).then(function(response) {
          }, function(error) {
            NotificationService.error($rootScope.labels.FILE_PLAYER_GEOLOC_MUSIC_ERROR_MESSAGE)
          });
        });
      }
    } else {
      $scope.play(HTTPService.getMP3musicURL(music.id, null));
    }
  }

  $scope.moreClick = function() {
    $scope.more.btn = !$scope.more.btn;
  }


  $scope.tmpPlaylistLink = function() {
    var url = "http://lvh.me:3000/playlists/tmp:";

    for (var i = 0 ; i < $rootScope.playlist.length ; i++) {
      url += $rootScope.playlist[i].id + ";";
    }

    return url;
  }

  $scope.savePlaylistFromCurrent = function(playlistName) {
    if ($scope.user != false && playlistName.length > 0) {
      SecureAuth.securedTransaction(function(key, user_id) {
        var parameters = {
          secureKey: key,
          user_id: user_id,
          playlist: {
            name: playlistName,
            user_id: user_id
          }
        };
        HTTPService.savePlaylist(parameters).then(function(response) {
          var playlist = response.data.content;

          playlist.extend = false;
          playlist.share = false;
          playlist.url = 'http://lvh.me:3000/playlists/' + playlist.id;
          playlist.duration = 0;
          $rootScope.myPlaylists.push(playlist);

          for (var i = 0 ; i < $rootScope.playlist.length ; i++) {
            playlist.musics.push($rootScope.playlist[i].obj);
            saveMusicInPlaylist(playlist, $rootScope.playlist[i]);
          }
        }, function(error) {
          NotificationService.error($rootScope.labels.FILE_PLAYER_SAVE_IN_PLAYLIST_ERROR_MESSAGE);
        });
      });
    }
  }

  var saveMusicInPlaylist = function(playlist, music) {
    SecureAuth.securedTransaction(function(key, user_id) {
      var parameters = {
        secureKey: key,
        user_id: user_id,
        id: music.id,
        playlist_id: playlist.id
      };
      HTTPService.addToPlaylist(parameters).then(function(response) {
        playlist.duration += music.obj.duration;
      }, function(error) {
        NotificationService.error($rootScope.labels.FILE_PLAYER_SAVE_IN_PLAYLIST_ERROR_MESSAGE);
      });
    });
  }

  $scope.activateLocation = function() {
    $scope.geoloc = !$scope.geoloc;

    if ($scope.geoloc && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        $scope.position = {
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        }
      });
    }
  }
}]);