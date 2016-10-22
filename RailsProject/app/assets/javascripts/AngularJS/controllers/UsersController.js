SoonzikApp.controller('UsersCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', 'Upload', 'Facebook', '$rootScope', '$location', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $timeout, Upload, Facebook, $rootScope, $location) {
	$scope.loading = true;

	$scope.user = false;
	$scope.show = { style: "", tweets: { my: [], others: [] } };
	$scope.tweet = {
		input: ""
	}
	$scope.form = { user: {}, identities: { facebook: null, twitter: null, google: null, soundcloud: null }, address: {} };
	$scope.formError = {
		user: {
			email: false,
			fname: false,
			lname: false,
			image: false,
			description: false,
			birthday: false,
			phoneNumber: false,
			facebook: false,
			twitter: false,
			googlePlus: false,
			newsletter: false,
			language: false,
			background: false,
			password: false
		},
		address: {
			numberStreet: false,
			complement: false,
			street: false,
			city: false,
			country: false,
			zipcode: false
		}
	};
	$scope.tooltip = false;
	$scope.selectedMusic = null;
	$scope.myPlaylists = [];

	$scope.isFBLogged = false;
	$scope.facebookReady = false;


	// For the select of date
	$scope.currentYear = (new Date().getFullYear());
	$scope.months = $rootScope.labels.FILE_USER_MONTHS_INFORMATION;
	$scope.days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];

	$scope.showInit = function () {
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
			$scope.user.followers = [];
			$scope.user.friends = [];
		}
		var id = null;

    	SecureAuth.securedTransaction(function(key, user_id) {
	        var parameters = [
	          { key: "secureKey", value: key },
	          { key: "user_id", value: user_id }
	        ];
			HTTPService.getProfile($routeParams.id, parameters).then(function(profile) {
				/*- Begin get Profile -*/

				var dataProfile = profile.data.content;
				// Initialisation of the user profile
				$scope.show.user = {
					id: dataProfile.id,
					username: dataProfile.username,
					image: dataProfile.image,
					facebook: linkToNothing(dataProfile.facebook),
					twitter: linkToNothing(dataProfile.twitter),
					googlePlus: linkToNothing(dataProfile.googlePlus)
				}
				id = dataProfile.id;

				if (dataProfile.background != null) {
					$scope.show.style = "background: url('assets/usersImage/backgrounds/" + dataProfile.background + "')";
				}

				/* Now I have the username so I get the tweets during the rest of the informations */

				var paramsTweet = [
					{ key: encodeURIComponent("attribute[user_id]"), value: id },
					{ key: encodeURIComponent("order_by_desc[]"), value: "created_at" },
					{ key: "limit", value: 20 },
		        	{ key: "secureKey", value: key },
		        	{ key: "user_id", value: user_id }
				];

				HTTPService.findTweet(paramsTweet).then(function(response) {
					$scope.show.tweets.my = response.data.content;

				}, function(error) {
					NotificationService.error("");
				});

				/* Other informations */

				HTTPService.isArtist(id, parameters).then(function(artistInformation) {
					/*- Begin isArtist -*/

					// Initialisation of the artist profile [if is one]
					$scope.show.user.isArtist = artistInformation.data.content.artist;
					if ($scope.show.user.isArtist == true) {
						$scope.show.user.topFive = artistInformation.data.content.topFive;
						$scope.show.user.albums = artistInformation.data.content.albums;
					}


					if ($scope.user != false && $scope.show.user.isArtist == true) {
						var note_array_id = []

						for (var i = 0 ; i < $scope.show.user.albums.length ; i++) {
							for (var j = 0 ; j < $scope.show.user.albums[i].musics.length ; j++) {
								note_array_id.push($scope.show.user.albums[i].musics[j].id);
								$scope.show.user.albums[i].musics[j].goldenStars = null;
							}
						}

						var noteParameters = [
							{ key: "user_id", value: $scope.user.id },
							{ key: "arr_id", value: "[" + encodeURI(note_array_id) + "]" },
							{ key: "secureKey", value: key },
							{ key: "user_id", value: user_id }
						]

						HTTPService.getMusicNotes(noteParameters).then(function(response) {
							for (var i = 0 ; i < $scope.show.user.albums.length ; i++) {
								for (var j = 0 ; j < $scope.show.user.albums[i].musics.length ; j++) {
									for (var k = 0 ; k < response.data.content.length ; k++) {
										if (response.data.content[k].music_id == $scope.show.user.albums[i].musics[j].id) {
											$scope.show.user.albums[i].musics[j].note = response.data.content[k].note;
										}
									}
								}
							}
						}, function(error) {
							NotificationService.error($rootScope.labels.FILE_USER_GET_NOTES_ERROR_MESSAGE);
						});
					}


					HTTPService.getFollowers(id, parameters).then(function(followersInformation) {
						/*- Begin getFollowers -*/

						// Load the followers of the user
						$scope.show.user.followers = followersInformation.data.content;

						// remove loading animation
						$scope.loading = false;

						/*- End getFollowers -*/
					}, function(error) {
						// error management to do
						NotificationService.error($rootScope.labels.FILE_USER_GET_FOLLOWERS_ERROR_MESSAGE);
					});

					HTTPService.getFriends(id, parameters).then(function(friendsInformation) {
						/*- Begin getFollowers -*/

						// Load the followers of the user
						$scope.show.user.friends = friendsInformation.data.content;

						// remove loading animation
						$scope.loading = false;

						/*- End getFollowers -*/
					}, function(error) {
						// error management to do
						NotificationService.error($rootScope.labels.FILE_USER_GET_FRIENDS_ERROR_MESSAGE);
					});

					/* get our follows (for the follow button) */
					if ($scope.user != false) {
						HTTPService.getFollows($scope.user.id, parameters).then(function(followersInformation) {
							// Load the followers of the user
							$scope.user.followers = followersInformation.data.content;
						}, function(error) {
							NotificationService.error($rootScope.labels.FILE_USER_GET_FOLLOWS_ERROR_MESSAGE);
						});
						HTTPService.getFriends($scope.user.id, parameters).then(function(friendsInformation) {
							// Load the followers of the user
							$scope.user.friends = friendsInformation.data.content;
						}, function(error) {
							NotificationService.error($rootScope.labels.FILE_USER_GET_FRIENDS_ERROR_MESSAGE);
						});
					}

					var playlistParams = [
						{ key: "secureKey", value: key },
						{ key: "user_id", value: user_id },
						{ key: "attribute[user_id]", value: $scope.user.id }
					];

					HTTPService.findPlaylist(playlistParams).then(function(playlistResponse) {
						$scope.show.playlists = playlistResponse.data.content;
						$scope.myPlaylists = playlistResponse.data.content;

						for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
							$scope.myPlaylists[i].check = false;
						}

						for (var i = 0 ; i < $scope.show.playlists.length ; i++) {
							var duration = 0;

							for (var j = 0 ; j < $scope.show.playlists[i].musics.length ; j++) {
								duration += $scope.show.playlists[i].musics[j].duration;
							}

							$scope.show.playlists[i].duration = duration;
						}
					}, function(error) {
						// error management to do
						NotificationService.error($rootScope.labels.FILE_USER_GET_PLAYLISTS_ERROR_MESSAGE);
					});

					/*- End isArtist -*/
				}, function(error) {
					// error management to do
					NotificationService.error($rootScope.labels.FILE_USER_PROFILE_ERROR_MESSAGE);
				})

				/*- End get Profile -*/
			}, function(error) {
				// error management to do
				NotificationService.error($rootScope.labels.FILE_USER_PROFILE_ERROR_MESSAGE);
			});
		});
	}

	function	linkToNothing(value) {
		if (value == null)
			return "#"
		else
			return value;
	}

	// ----

	$scope.editInit = function() {
		if (!$rootScope.user) { $location.path('/', true);return; }

		var id = $routeParams.id;
		var current_user = SecureAuth.getCurrentUser();

		$scope.function_submit = HTTPService.updateUser;

		/**
		 * Watch for Facebook to be ready.
		 * There's also the event that could be used
		 */
		$scope.$watch(
			function() {
				return Facebook.isReady();
			},
			function(newVal) {
				if (newVal)
					$scope.facebookReady = true;
			}
		);

		if (current_user.id != id) {
			NotificationService.error($rootScope.labels.FILE_USER_EDITION_ERROR_MESSAGE);
			$timeout(function() {
				document.location.pathname = "/";
			}, 1000);
		} else {
			HTTPService.getFullProfile(id).then(function(profile) {
				// Need a new route with security to get a profile with all informations
				var dataProfile = profile.data;

				// Initialisation of the user profile
				$scope.form.user = dataProfile;
				if (typeof dataProfile.address !== "undefined") {
					$scope.form.address = dataProfile.address;
				}
				//$scope.form.address = dataProfile;
				birthday = dataProfile.birthday.split('-');
				$scope.form.user["birthday(1i)"] = birthday[0];
				$scope.form.user["birthday(2i)"] = birthday[1];
				$scope.form.user["birthday(3i)"] = birthday[2];
				$scope.form.user.password = "";

				if (typeof $scope.form.user.address !== "undefined") {
					$scope.form.address = $scope.form.user.address;
					delete $scope.form.user.address;
				}

				SecureAuth.securedTransaction(function (key, user_id) {
					HTTPService.getIdentities([{ key: 'secureKey', value: key }, { key: 'user_id', value: user_id }]).then(function(response) {
						var identity = response.data.content;

						for (var i = 0 ; i < identity.length ; i++) {
							$scope.form.identities[identity[i].provider] = identity[i].uid;
						}

						$scope.loading = false;
					}, function(error) {
						// Do nothing
					});
				}, function(error) {
					// do nothing
				});
			}, function (error) {
				// error management to do
				NotificationService.error($rootScope.labels.FILE_USER_PROFILE_ERROR_MESSAGE);
			});
		}
	}

	/*
	**
	** INTERACTION CALLBACK
	**
	*/

	$scope.submitForm = function(type) {
		var parameters = false;
		if (type == "user") {
			var parameters = { user: jQuery.extend(true, {}, $scope.form.user) };//deep copy of the user object
			delete parameters.user.username; // it can't be modified
			if (parameters.user.password.length == 0) {// we won't forced the user to put its password everytime
				delete parameters.user.password;
			}
		} else if (type == "address" && typeof $scope.form.address !== "undefined") {
			var parameters = { address: $scope.form.address };//deep copy of the user object
		}

		if (parameters != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				parameters.secureKey = key;
				parameters.user_id = user_id;
				// We send this function to be executed after getting the secure key
				$scope.function_submit(parameters).then(function(response) {
					NotificationService.success($rootScope.labels.FILE_USER_UPDATE_SUCCESS_MESSAGE);
				}, function (responseError) {
					//if the update fail

					if (typeof responseError.data.content.user !== "undefined") {
						// Iterate on error
						for (var key in $scope.formError.user) {
							if (typeof responseError.data.content.user[key] !== "undefined") {
								$scope.formError.user[key] = responseError.data.content.user[key];
							} else {
								$scope.formError.user[key] = false;
							}
						}
					}
					if (typeof responseError.data.content.address !== "undefined") {
						// Iterate on error
						for (var key in $scope.formError.address) {
							if (typeof responseError.data.content.address[key] !== "undefined") {
								$scope.formError.address[key] = responseError.data.content.address[key];
							} else {
								$scope.formError.address[key] = false;
							}
						}
					}
					NotificationService.error($rootScope.labels.FILE_USER_ERROR_OCCURED_MESSAGE);
				});
			});
		}
	}

	$scope.uploadAvatar = function($file) {
		if ($file && $file.length) {
			for (var i = 0; i < $file.length; i++) {
				var file = $file[i];

				SecureAuth.securedTransaction(function (key, user_id) {
					HTTPService.uploadProfileImage(file, { secureKey: key, user_id: user_id }, function (evt) {
						var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
					}, function (data, status, headers, config) {
						$scope.form.user.image = data.content.image;
						$rootScope.$broadcast('user:changeImg', { url: data.content.image });
					}, function (error) {
						$scope.formError.user.image = error;
					});
				});
			}
		}
	}

	$scope.uploadBackground = function($file) {
		if ($file && $file.length) {
			for (var i = 0; i < $file.length; i++) {
				var file = $file[i];
				// need to define a route to upload image

				SecureAuth.securedTransaction(function (key, user_id) {
					HTTPService.uploadBackgroundImage(file, { secureKey: key, user_id: user_id }, function (evt) {
						var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
					}, function (data, status, headers, config) {
						$scope.form.user.background = data.content.background;
					}, function (error) {
						$scope.formError.user.background = error;
					});
				});
			}
		}
	}

	$scope.follow = function() {
		if ($scope.user != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				var parameters = {
					secureKey: key,
					user_id: user_id,
					follow_id: $scope.show.user.id
				};
				HTTPService.follow(parameters).then(function(followResponse) {
					$scope.user.followers.push($scope.show.user);
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_FOLLOW_ERROR_MESSAGE);
				});
			});
		}
	}

	$scope.friend = function() {
		if ($scope.user != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				var parameters = {
					secureKey: key,
					user_id: user_id,
					friend_id: $scope.show.user.id
				};
				HTTPService.friend(parameters).then(function(friendResponse) {
					$scope.user.friends.push($scope.show.user);
					$rootScope.$broadcast("chat:friend", $scope.show.user);
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_FRIEND_ERROR_MESSAGE);
				});
			});
		}
	}

	$scope.unfollow = function() {
		if ($scope.user != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				var parameters = {
					secureKey: key,
					user_id: user_id,
					follow_id: $scope.show.user.id
				};
				HTTPService.unfollow(parameters).then(function(followResponse) {
					for (var i = 0; i < $scope.user.followers.length ; i++) {
						if ($scope.user.followers[i].id == $scope.show.user.id) {
							$scope.user.followers.splice(i, 1);
							break;
						}
					}
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_UNFOLLOW_ERROR_MESSAGE);
				});
			});
		}
	}

	$scope.unfriend = function() {
		if ($scope.user != false) {
			SecureAuth.securedTransaction(function (key, user_id) {
				var parameters = {
					secureKey: key,
					user_id: user_id,
					friend_id: $scope.show.user.id
				};
				HTTPService.unfriend(parameters).then(function(friendResponse) {
					$rootScope.$broadcast("chat:unfriend", $scope.show.user);
					for (var i = 0; i < $scope.user.friends.length ; i++) {
						if ($scope.user.friends[i].id == $scope.show.user.id) {
							$scope.user.friends.splice(i, 1);
							break;
						}
					}
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_UNFRIEND_ERROR_MESSAGE);
				});
			});
		}
	}

	$scope.comment = function(username) {
		$("#inputTweet").focus();
		$scope.tweet.input = "@" + username + " ";
	}

	$scope.sendTweet = function() {
		if ($scope.tweet.input.length < 140) {

			var parameters = {
				msg: $scope.tweet.input,
				user_id: $scope.show.user.id
			}

			SecureAuth.securedTransaction(function(key, user_id) {
				parameters.user_id = user_id;
				parameters.secureKey = key;
				HTTPService.saveTweet(parameters).then(function(response) {
					$scope.show.tweets.my.unshift(response.data.content);
					$scope.tweet.input = "";
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_SAVE_TWEET_ERROR_MESSAGE);
				});
			});

		} else {
			NotificationService.info($rootScope.labels.FILE_USER_TWEET_TOO_LONG_ERROR_MESSAGE);
		}
	}

	$scope.reloadTweet = function() {
		$scope.loading_tweet = true;

    	SecureAuth.securedTransaction(function(key, id) {
			var paramsTweet = [
				{ key: encodeURIComponent("attribute[user_id]"), value: $scope.show.user.id },
				{ key: encodeURIComponent("order_by_desc[]"), value: "created_at" },
				{ key: "limit", value: 20 },
				{ key: "offset", value: $scope.show.tweets.my.length },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];

			HTTPService.findTweet(paramsTweet).then(function(response) {
				$scope.show.tweets.my = $scope.show.tweets.my.concat(response.data.content);
				$timeout(function() {
					$scope.loading_tweet = false;
				}, 1000);
			}, function(error) {
				NotificationService.error("");
			});
		});
	}

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

	$scope.addToPlaylist = function() {
		var playlist = false;

		for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
			if ($scope.myPlaylists[i].check == true)
				playlist = $scope.myPlaylists[i];
		}

		if ($scope.user != false && $scope.selectedMusic != false && playlist != false) {
			SecureAuth.securedTransaction(function(key, user_id) {
				var parameters = {
					secureKey: key,
					user_id: user_id,
					id: $scope.selectedMusic.id,
					playlist_id: playlist.id
				};
				HTTPService.addToPlaylist(parameters).then(function(response) {
					NotificationService.success("The music '" + $scope.selectedMusic.title + "' has been added to the playlist");
					$rootScope.$broadcast("player:addToPlaylist", { playlist: playlist, music: $scope.selectedMusic });
					$scope.selectedMusic = false;
					$scope.tooltip = false;
					playlist.check = false;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_USER_ADD_PLAYLIST_ERROR_MESSAGE);
				});
			});
		}
	}

	$scope.selectMusic = function(music) {
		if ($scope.selectedMusic == music) {
			$scope.selectedMusic = false;
		} else {
			$scope.selectedMusic = music;
		}
	}

	$scope.setTooltip = function(value) {
		$scope.tooltip = value;
		if ($scope.tooltip != false) {
			for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
				for (var j = 0 ; j < $scope.myPlaylists[i].musics.length ; j++) {
					if (value.id == $scope.myPlaylists[i].musics[j].id) {
						$scope.myPlaylists[i].check = true;
					}
				}
			}
		} else {
			for (var i = 0 ; i < $scope.myPlaylists.length ; i++) {
 				$scope.myPlaylists[i].check = false;
			}
			$scope.selectMusic(false);
		}
	}

	/**************************************/

	/* 
	**
	** SOCIAL NETWORK
	**
	*/
			
	Facebook.getLoginStatus(function(response) {
		if (response.status == 'connected') {
			$scope.isFBLogged = true;
		}
	});
	
	/**
	 * IntentLogin
	 */
	$scope.IntentLogin = function() {
		if (!$scope.isFBLogged && $scope.facebookReady) {
			Facebook.login(function(response) {
				if (response.status == 'connected') {
					$scope.me();
				}
			});
		} else if ($scope.isFBLogged && $scope.facebookReady) {
			$scope.me();
		}
	};
	 
 /**
	* me 
	*/
	$scope.me = function() {
		Facebook.api('/me', function(response) {
			/**
			 * Using $scope.$apply since this happens outside angular framework.
			 */
			$scope.$apply(function() {
				SecureAuth.securedTransaction(function (key, user_id) {
					var parameters = { secureKey: key, user_id: user_id, uid: response.id, provider: "facebook" };
					
					HTTPService.linkSocial(parameters).then(function() {
						$scope.isFBLogged = true;
						$scope.form.identities.facebook = response.id;
					}, function(error) {
						if (error.status == 409) {
							NotificationService.error($rootScope.labels.FILE_USER_FB_LINKED_ERROR_MESSAGE);
						} else {
							NotificationService.error($rootScope.labels.FILE_USER_FB_LINK_ERROR_MESSAGE);
						}
					});
				});
			});
			
		});
	};

	$scope.googleCallback = function() {
		$scope.$on('event:google-plus-signin-success', function (event, authResult) {
			$scope.onSignInCallback(authResult);
		});
	}

	$scope.onSignInCallback = function(authResult){
		// Set the access token on the JavaScript API Client
		gapi.auth.setToken(authResult);
		// Load G+
		gapi.client.load('plus', 'v1').then(function() {
			// Get uid
			gapi.client.plus.people.get({
		    'userId': 'me'
		  }).then(function(res) {
		  	$scope.$apply(function() {
					SecureAuth.securedTransaction(function (key, user_id) {
						var parameters = { secureKey: key, user_id: user_id, uid: res.result.id, provider: "google" };
						
						HTTPService.linkSocial(parameters).then(function() {
							$scope.form.identities.google = res.result.id;
						}, function(error) {
							if (error.status == 409) {
								NotificationService.error($rootScope.labels.FILE_USER_GOOGLE_LINKED_ERROR_MESSAGE);
							} else {
								NotificationService.error($rootScope.labels.FILE_USER_GOOGLE_LINK_ERROR_MESSAGE);
							}
						});
					});
				});
		  }, function(err) {
		  	NotificationService.error($rootScope.labels.FILE_USER_GOOGLE_CONNECTION_ERROR_MESSAGE);
		  });
		}, function(error) {
	  	NotificationService.error($rootScope.labels.FILE_USER_GOOGLE_CONNECTION_ERROR_MESSAGE);
		});
	}

	/* Utils function */

	$scope.range = function(n) {
		if (n > 0) {
			return new Array(Math.round(n));
		} else {
			return [];
		}
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

	$scope.isaFollower = function() {
		if ($scope.user != false) {
			for (var i = 0; i < $scope.user.followers.length ; i++) {
				if ($scope.user.followers[i].id == $scope.show.user.id)
					return true;
			}
		}
		return false;
	}

	$scope.isaFriend = function() {
		if ($scope.user != false) {
			for (var i = 0; i < $scope.user.friends.length ; i++) {
				if ($scope.user.friends[i].id == $scope.show.user.id)
					return true;
			}
		}
		return false;
	}

	$scope.connectSoundcloud = function() {
		if ($scope.form.identities.soundcloud != null) {
			musicalPast($scope.form.identities.soundcloud);
		} else {
			SC.initialize({
			  client_id: 'db36f7eba19a44ee1ee56b04d7327753',
			  redirect_uri: 'http://lvh.me:3000/callback.html' 
			});

			SC.connect().then(function() {
			  return SC.get('/me');
			}).then(function(me) {
				musicalPast(me.id);
			}).catch(function(error) {
			  NotificationService.error('Error: ' + error.message);
			});
		}
	}

	var musicalPast = function(soundcloud_id) {
		SecureAuth.securedTransaction(function (key, user_id) {
			var parameters = { secureKey: key, user_id: user_id, soundcloud_id: soundcloud_id };
			HTTPService.postMusicalPast(parameters).then(function(response) {
				NotificationService.success($rootScope.labels.FILE_USER_MUSICAL_PAST_SUCCESS_MESSAGE);
			}, function(error) {
	  		NotificationService.error($rootScope.labels.FILE_USER_MUSICAL_PAST_ERROR_MESSAGE);
			});
	  }, function(err) {
	  	NotificationService.error($rootScope.labels.FILE_USER_SOUNDCLOUD_CONNECTION_ERROR_MESSAGE);
	  });
	}

}]);