SoonzikApp.controller('BattlesCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', "$rootScope", function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope) {
	$scope.loading = true;
	$scope.resourceName = "battles";
	$scope.index = { resources: [], votes: [], voteCurrentUser: [], currentPage: 1, totalPage: 1 };
	$scope.show = { battle: null, artistOne: {}, artistTwo: {}, voteCurrentUser: false, randomVote: [] };
	$scope.currentUser = false;

	var BattlePerPage = 10;

	$scope.indexInit = function() {
		$scope.index.currentPage = ($rootScope.toInt($routeParams.page) == 0 ? 1 : $rootScope.toInt($routeParams.page));
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.currentUser = current_user;
		}

		SecureAuth.securedTransaction(function (key, id) {
			var parameters = [
				{ key: "limit", value: BattlePerPage },
				{ key: "offset", value: (($scope.index.currentPage - 1) * BattlePerPage) },
				{ key: "order_by_desc[]", value: "created_at" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];

			var countParameters = [
				{ key: "count", value: "true" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];

			HTTPService.indexBattles(countParameters).then(function(response) {
				var numberResults = response.data.content;

				if (typeof numberResults != "undefined") {
					$scope.index.totalPage = ~~(numberResults / BattlePerPage) + 1;
				} else {
					$scope.index.totalPage = 1;
				}

				HTTPService.findBattles(parameters).then(function(response) {
					var now = new Date();
					for (var i = 0 ; i < response.data.content.length ; i++) {
						var tmpDateBegin = new Date(response.data.content[i].date_begin.replace(/\-/g, "/"));
						var tmpDateEnd = new Date(response.data.content[i].date_end.replace(/\-/g, "/"));
						if (now < tmpDateEnd && tmpDateBegin < now) {
							$scope.index.resources.push(response.data.content[i]);
						}
					}

					// For each battles
					for (var battleIndex in $scope.index.resources) {
						var votes = [
							{ value: 0, label: $scope.index.resources[battleIndex].artist_one.username },
							{ value: 0, label: $scope.index.resources[battleIndex].artist_two.username }
						];

						// For each votes
						for (var voteIndex in $scope.index.resources[battleIndex].votes) {
							// fill the votes object
							if ($scope.index.resources[battleIndex].votes[voteIndex].artist_id == $scope.index.resources[battleIndex].artist_one.id) {
								votes[0].value++;
							} else if ($scope.index.resources[battleIndex].votes[voteIndex].artist_id == $scope.index.resources[battleIndex].artist_two.id) {
								votes[1].value++;
							}

							// fill the vote array of the current user
							if ($scope.currentUser != false && $scope.index.resources[battleIndex].votes[voteIndex].user_id == $scope.currentUser.id) {
								$scope.index.voteCurrentUser[$scope.index.resources[battleIndex].id] = $scope.index.resources[battleIndex].votes[voteIndex].artist_id;
							}
						}

						// if no votes, no values
						if (votes[0].value == 0 && votes[1].value == 0) {
							$scope.index.votes[$scope.index.resources[battleIndex].id] = [];
						} else {
							$scope.index.votes[$scope.index.resources[battleIndex].id] = votes;
						}

						// if no vote for the current user
						if (typeof $scope.index.voteCurrentUser[$scope.index.resources[battleIndex].id] === "undefined") {
							$scope.index.voteCurrentUser[$scope.index.resources[battleIndex].id] = false;
						}

					}

					timeLeftIndex();
					$scope.loading = false;
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_BATTLE_ERROR_MESSAGE);
				});
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_BATTLE_ERROR_MESSAGE);
			});
		});
	}

	$scope.showInit = function() {
		var id = $routeParams.id;
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.currentUser = current_user;
		}
		$scope.show.voteCurrentUser = false;

		SecureAuth.securedTransaction(function (key, user_id) {

			var parameters = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: user_id },
			];

			HTTPService.showBattles(id, parameters).then(function(response) {
				$scope.show.battle = response.data.content;
				if ($scope.show.battle.votes.length > 0) {
					$scope.show.votes = [
						{ value: 0, label: $scope.show.battle.artist_one.username },
						{ value: 0, label: $scope.show.battle.artist_two.username }
					];
					for (var voteIndex in $scope.show.battle.votes) {
						if ($scope.show.battle.votes[voteIndex].artist_id == $scope.show.battle.artist_one.id) {
							$scope.show.votes[0].value++;
						} else {
							$scope.show.votes[1].value++;
						}
						if ($scope.show.battle.votes[voteIndex].user_id == $scope.currentUser.id) {
							$scope.show.voteCurrentUser = $scope.show.battle.votes[voteIndex].artist_id;
						}
					}
				} else {
					$scope.show.votes = false;
				}

				// Get top 5 of artists
				HTTPService.isArtist($scope.show.battle.artist_one.id, parameters).then(function(artistInformation) {
					/*- Begin isArtist - artist 1 -*/

					// Initialisation of the artist profile [if is one]
					var isArtist = artistInformation.data.content.artist;
					if (isArtist == true) {
						$scope.show.artistOne.topFive = artistInformation.data.content.topFive;
						$scope.show.artistOne.albums = artistInformation.data.content.albums;
					}

					HTTPService.isArtist($scope.show.battle.artist_two.id, parameters).then(function(artistInformation) {
						/*- Begin isArtist - artist 2 -*/

						// Initialisation of the artist profile [if is one]
						var isArtist = artistInformation.data.content.artist;
						if (isArtist == true) {
							$scope.show.artistTwo.topFive = artistInformation.data.content.topFive;
							$scope.show.artistTwo.albums = artistInformation.data.content.albums;
						}
						timeLeftShow($scope.show.battle);
						$scope.loading = false;
					}, function(error) {	// error management of the second isArtist
						NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_ARTIST_TWO_ERROR_MESSAGE)
					});
				}, function(error) {	// error management of the first isArtist
					NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_ARTIST_ONE_ERROR_MESSAGE);
				});

				randomPeople(parameters);

			}, function(error) {	// error management of the showBattle call
				NotificationService.error($rootScope.labels.FILE_BATTLE_LOAD_BATTLE_ERROR_MESSAGE)
			});
		});
	}

	// callback vote

	$scope.indexVoteFor = function(battle, artist) {
		if ($scope.currentUser == false) {
			NotificationService.error($rootScope.labels.FILE_BATTLE_NEED_AUTHENTICATION_ERROR_MESSAGE);
			return;
		}
		if ($scope.index.voteCurrentUser[battle.id] == false || $scope.index.voteCurrentUser[battle.id] != artist.id) {
			SecureAuth.securedTransaction(function(key, id) {
				var parameters = {
					secureKey: key,
					user_id: id,
					artist_id: artist.id
				};
				HTTPService.voteBattle(battle.id, parameters).then(function(response) {
					// is there a previous vote ?
					var oldVote = true;
					// init the array of values
					if ($scope.index.votes[battle.id].length == 0) {
						$scope.index.votes[battle.id] = [
							{ value: 0, label: battle.artist_one.username },
							{ value: 0, label: battle.artist_two.username }
						];
						oldVote = false;
					}
					$scope.index.voteCurrentUser[battle.id] = artist.id;

					// iterate on battles
					for (var battleIndex in $scope.index.resources) {
						// If this is the good battle
						if ($scope.index.resources[battleIndex].id == battle.id) {
							// Iterate on the votes
							var voteHasBeenModified = false;
							for (var voteIndex in $scope.index.resources[battleIndex].votes) {
								// We modify the vote value
								if ($scope.index.resources[battleIndex].votes[voteIndex].user_id == $scope.currentUser.id) {
									$scope.index.resources[battleIndex].votes[voteIndex].artist_id = artist.id;

									// if you vote for the first
									if (artist.id == $scope.index.resources[battleIndex].artist_one.id) {
										$scope.index.votes[$scope.index.resources[battleIndex].id][0].value++;
										// if there is a previous vote, reduce the value for the other artist
										if (oldVote) {	$scope.index.votes[$scope.index.resources[battleIndex].id][1].value--;	}
									}
									else {		// if you vote for the second
										$scope.index.votes[$scope.index.resources[battleIndex].id][1].value++;
										// if there is a previous vote, reduce the value for the other artist
										if (oldVote) {	$scope.index.votes[$scope.index.resources[battleIndex].id][0].value--;	}
									}
									voteHasBeenModified = true;
									break;
								}
							}

							if (!voteHasBeenModified) {
								$scope.index.resources[battleIndex].votes.push({ artist_id: artist.id, id: response.data.content.id, user_id: $scope.currentUser.id});

								if (artist.id == $scope.index.resources[battleIndex].artist_one.id) {
									$scope.index.votes[$scope.index.resources[battleIndex].id][0].value++;
								} else {
									$scope.index.votes[$scope.index.resources[battleIndex].id][1].value++;
								}
							}
						}
					}
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_BATTLE_VOTE_ERROR_MESSAGE);
				});
			});
		} else {
			NotificationService.info($rootScope.labels.FILE_BATTLE_ALREADY_VOTED_ERROR_MESSAGE);
		}
	}

	$scope.showVoteFor = function(battle, artist) {
		if ($scope.currentUser == false) {
			NotificationService.error($rootScope.labels.FILE_BATTLE_NEED_AUTHENTICATION_ERROR_MESSAGE);
			return;
		}
		if ($scope.show.voteCurrentUser == false || $scope.show.voteCurrentUser != artist.id) {
			SecureAuth.securedTransaction(function(key, id) {
				var parameters = {
					secureKey: key,
					user_id: id,
					artist_id: artist.id
				};
				HTTPService.voteBattle(battle.id, parameters).then(function(response) {
					// is there a previous vote ?
					var oldVote = true;
					// init the array of values
					if ($scope.show.votes.length == 0) {
						$scope.show.votes = [
							{ value: 0, label: $scope.show.battle.artist_one.username },
							{ value: 0, label: $scope.show.battle.artist_two.username }
						];
						oldVote = false;
					}
					$scope.show.voteCurrentUser = artist.id;

					// Iterate on the votes
					for (var voteIndex in $scope.show.battle.votes) {
						// We modify the vote value
						if ($scope.show.battle.votes[voteIndex].user_id == $scope.currentUser.id) {
							$scope.show.battle.votes[voteIndex].artist_id = artist.id;

							// if you vote for the first
							if (artist.id == $scope.show.battle.artist_one.id) {
								$scope.show.votes[0].value++;
								// if there is a previous vote, reduce the value for the other artist
								if (oldVote) {	$scope.show.votes[1].value--;	}
							}
							else {		// if you vote for the second
								$scope.show.votes[1].value++;
								// if there is a previous vote, reduce the value for the other artist
								if (oldVote) {	$scope.show.votes[0].value--;	}
							}
						}
					}
				}, function(error) {
					NotificationService.error($rootScope.labels.FILE_BATTLE_VOTE_ERROR_MESSAGE);
				});
			});
		} else {
			NotificationService.info($rootScope.labels.FILE_BATTLE_ALREADY_VOTED_ERROR_MESSAGE);
		}
	}

	/* Utils function */

	$scope.voteClass = function(value, artist_id) {
		if (value == false) {
			return 'primary';
		} else if (value == artist_id) {
			return 'success';
		} else {
			return 'alert';
		}
	}

	$scope.voteText = function(value, artist_id) {
		if (value == false) {
			return $rootScope.labels.FILE_BATTLE_VOTETEXT_LABEL;
		} else if (value == artist_id) {
			return $rootScope.labels.FILE_BATTLE_VOTEDTEXT_LABEL;
		} else {
			return $rootScope.labels.FILE_BATTLE_CANCEL_TEXT_LABEL;
		}
	}

	var randomPeople = function(params) {
		var votes = $scope.show.battle.votes;
		var count = 0;
		var id_array = [];

		if (votes.length <= 6) {
			for (var indexVote in votes) {
				id_array.push(votes[indexVote].user_id);
			}
		} else {
			while (count < 6) {
				var randomNumber = ~~(Math.random() * votes.length);
				if ($.inArray(randomNumber, id_array)) {
					continue;
				} else {
					id_array.push(randomNumber);
					count++;
				}
			}
		}
		fillArray_rec($scope.show.randomVote, 0, id_array, (votes.length <= 6) ? votes.length : 6, params);
	}

	var fillArray_rec = function(array, index, id_array, limit, params) {
		if (id_array.length <= index)
			return;

		HTTPService.getProfile(id_array[index], params).then(function(profile) {
			array[index] = profile.data.content;
			if (index + 1 < limit) {
				fillArray_rec(array, index + 1, id_array, limit, params);
			}
		}, function(error) {
			array[index] = null;
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

	var timeLeftIndex = function() {
		var timer = setInterval(function() {
			for (var i = 0; i < $scope.index.resources.length; i++) {
				var now = new Date();
				var end_date = new Date($scope.index.resources[i].date_end.replace(/\-/g, "/"));

				if (end_date > now) {
					var left = end_date - now
				} else {
					var left = "Finish !";
				}

				var date = new Date(left);
				var day = date.getDay();
				var hours = date.getHours();
				var minutes = "0" + date.getMinutes();
				var seconds = "0" + date.getSeconds();
				var formattedTime = day + 'days ' + hours + 'h ' + minutes.substr(-2) + 'mn ' + seconds.substr(-2) + 's';

				$scope.index.resources[i].timeLeft = formattedTime;
				$scope.$apply();
			}
		}, 1000);
	}
	var timeLeftShow = function(battle) {
		var timer = setInterval(function() {
			var now = new Date();
			var end_date = new Date(battle.date_end.replace(/\-/g, "/"));

			if (end_date > now) {
				var left = end_date - now
			} else {
				var left = "Finish !";
			}

			var date = new Date(left);
			var day = date.getDay();
			var hours = date.getHours();
			var minutes = "0" + date.getMinutes();
			var seconds = "0" + date.getSeconds();
			var formattedTime = day + 'days ' + hours + 'h ' + minutes.substr(-2) + 'mn ' + seconds.substr(-2) + 's';

			battle.timeLeft = formattedTime;
			$scope.$apply();
		}, 1000);
	}

}]);
