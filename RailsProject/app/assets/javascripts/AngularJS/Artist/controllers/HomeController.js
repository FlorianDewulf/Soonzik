SoonzikArtistApp.controller('HomeCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$timeout', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout) {
	$scope.loading = {
		music: true,
		album: true,
		pack: true,
		note: true,
		battle: true,
		commentaries: true,
		tweets: true
	};

	$scope.user = false;

	$scope.battles = {
		current: [],
		past: []
	}

	$scope.commentaries = [];
	$scope.tweets = [];

	$scope.values = {
		music: {
			data: [],
			xkey: "music_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell of last week (total) "]
		},
		album: {
			data: [],
			xkey: "album_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell of last week (total) "]
		},
		pack: {
			data: [],
			xkey: "pack_title",
			ykeys: ["total_sell", "total_sell_partial", "lastweek", "lastweek_partial"],
			labels: ["Sell (total) ", "Sell partial bundle (total) ", "Sell of last week (total) ", "Sell of partial bundle last week (total) "]
		},
		note_musics: {
			data: [],
			xkey: "album_title",
			ykeys: ["total_sell", "lastweek"],
			labels: ["Sell (total) ", "Sell of last week (total) "]
		},
		note_musics: {
			data: [],
			xkey: "music_title",
			ykeys: ["note"],
			labels: ["Note (average) "]
		},
		note_albums: {
			data: [],
			xkey: "album_title",
			ykeys: ["note"],
			labels: ["Note (average) "]
		}
	}

	$scope.initHome = function() {
		var current_user = SecureAuth.getCurrentUser();
		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}

		HTTPService.getStats().then(function(response) {
			$scope.values.music.data = response.data.music;
			$scope.values.album.data = response.data.album;
			$scope.values.pack.data = response.data.pack;
			$scope.loading.music = false;
			$scope.loading.album = false;
			$scope.loading.pack = false;

			// To format informations for the line chart
			data_music_notes = [];
			for (var i = 0 ; i < response.data.notes.album.length ; i++) {
				for (var j = 0 ; j < response.data.notes.album[i].musics.length ; j++) {
					data_music_notes.push({
						music_title: response.data.notes.album[i].musics[j].name,
						note: response.data.notes.album[i].musics[j].note
					});
				}
			}
			$scope.values.note_musics.data = data_music_notes;

			// To format informations for the line chart
			data_album_notes = [];
			if (response.data.notes.album.length > 0) {
				data_album_notes.push({
					album_title: "All albums",
					note: response.data.notes.average
				});
			}
			for (var i = 0 ; i < response.data.notes.album.length ; i++) {
				data_album_notes.push({
					album_title: response.data.notes.album[i].name,
					note: response.data.notes.album[i].average
				});
			}
			$scope.values.note_albums.data = data_album_notes;
			$scope.loading.note = false;
		}, function(error) {
			NotificationService.error("Error while loading statistics. Try again later.");
		});

		loadBattles();
	}

	var loadBattles = function() {
		var now = new Date();
		var tmpArray = [];

		// First part
		var parameter = [{ key: "attribute[artist_one_id]", value: $scope.user.id }];
		HTTPService.findBattles(parameter).then(function(response) {

			for (var i = 0 ; i < response.data.content.length ; i++) {
				var tmpDate = new Date(response.data.content[i].date_end.replace(/\-/g, "/"));

				response.data.content[i].votesValue = false;
				tmpArray.push(response.data.content[i]);
				if (now > tmpDate) {
					$scope.battles.past.push(response.data.content[i]);
				} else {
					$scope.battles.current.push(response.data.content[i]);
				}
			}

			// Second part
			var parameter = [{ key: "attribute[artist_two_id]", value: $scope.user.id }];
			HTTPService.findBattles(parameter).then(function(response) {

				for (var i = 0 ; i < response.data.content.length ; i++) {
					var tmpDate = new Date(response.data.content[i].date_end.replace(/\-/g, "/"));

					response.data.content[i].votesValue = false;
					tmpArray.push(response.data.content[i]);
					response.data.content[i].votesValue = {
						artist_one: 0,
						artist_two: 0
					}
					if (now > tmpDate) {
						$scope.battles.past.push(response.data.content[i]);
					} else {
						$scope.battles.current.push(response.data.content[i]);
					}
				}

				for (var battleIndex in tmpArray) {
					var votes = [
						{ value: 0, label: tmpArray[battleIndex].artist_one.username },
						{ value: 0, label: tmpArray[battleIndex].artist_two.username }
					];

					// For each votes
					for (var voteIndex in tmpArray[battleIndex].votes) {
						// fill the votes object
						if (tmpArray[battleIndex].votes[voteIndex].artist_id == tmpArray[battleIndex].artist_one.id) {
							votes[0].value++;
						} else if (tmpArray[battleIndex].votes[voteIndex].artist_id == tmpArray[battleIndex].artist_two.id) {
							votes[1].value++;
						}
					}

					// if no votes, no values
					if (votes[0].value == 0 && votes[1].value == 0) {
						tmpArray[battleIndex].votesValue = [];
					} else {
						tmpArray[battleIndex].votesValue = votes;
					}
				}
				$scope.loading.battle = false;
			}, function(error) {
				NotificationService.error("Error while loading the battles. Try again later.")
			});
		}, function(error) {
			NotificationService.error("Error while loading the battles. Try again later.")
		});

		HTTPService.getLastComments().then(function(response) {
			$scope.commentaries = response.data;
			for (var i = 0 ; i < $scope.commentaries.length ; i++) {
				$scope.commentaries[i].created_at = new Date($scope.commentaries[i].created_at.replace(/\-/g, "/"));
			}
			$scope.loading.commentaries = false;
		}, function(error) {
			NotificationService.error("Error while loading the commentaries. Try again later.")
		});

		HTTPService.getLastTweets().then(function(response) {
			$scope.tweets = response.data;
			for (var i = 0 ; i < $scope.tweets.length ; i++) {
				$scope.tweets[i].created_at = new Date($scope.tweets[i].created_at.replace(/\-/g, "/"));
			}
			$scope.loading.tweets = false;
		}, function(error) {
			NotificationService.error("Error while loading the commentaries. Try again later.")
		});
	}
}]);
