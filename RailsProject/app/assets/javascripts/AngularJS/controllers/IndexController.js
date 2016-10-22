SoonzikApp.controller('IndexCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', 'NotificationService', function ($scope, SecureAuth, HTTPService, $timeout, NotificationService) {

	$scope.loading = true;
	$scope.loadingRightSide = true;
	$scope.loading_tweet = false;
	$scope.currentUser = false;
	$scope.randomVote = [];
	$scope.votes = [
		{ value: 0, label: "" },
		{ value: 0, label: "" }
	];
	$scope.user = false;
	$scope.battles = [];
	$scope.packs = [];
	$scope.tweets = [];
	$scope.tweet = {
		input: ""
	}
	$scope.otherTweets = [];
	$scope.classLeftSide = {
		'medium-8': true
	}
	$scope.tab = 0;
	$scope.suggestions = [];

	$scope.selectedPack = { pack: null, display: false };

	/*
	**	Fonction d'init de foundation.
	**	+ Init Slider.
	*/

	$scope.initIndex = function () {
		var current_user = SecureAuth.getCurrentUser();
		var newsLoading = false;
		var packsLoading = false;
		var battlesLoading = false;

		if (current_user.id != null && current_user.token != null && current_user.username != null) {
			$scope.user = current_user;
		}
		$scope.classLeftSide['medium-8'] = ($scope.user != false);


		SecureAuth.securedTransaction(function(key, id) {
			/*
			**	Recupere les 3 dernieres news pour le slider.
			*/
			var parametersNews = [
				{ key: "limit", value: 6 },
				{ key: "order_by_desc[]", value: "created_at" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];
			HTTPService.findNews(parametersNews).then(function(news) {
				$scope.news = news.data.content;
				newsLoading = true;
				if (newsLoading && packsLoading && battlesLoading) { $scope.loading = false; }
			}, function (error) {
				NotificationService.error(labels.FILE_INDEX_NEWS_LOAD_ERROR_MESSAGE);
			});

			/*
			**	 Recupere les 4 derniers packs mis en ligne.
			*/

			var parameters = [
				{ key: "limit", value: 4 },
				{ key: "order_by_desc[]", value: "created_at" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];

			HTTPService.findPacks(parameters).then(function (packs) {
				var packs = packs.data.content;
				if (packs.length > 0) {
					checkPartial(packs);
					$scope.selectedPack = { pack: $scope.packs[0], display: true };
				}
				timeLeftPack();
				packsLoading = true;
				if (newsLoading && packsLoading && battlesLoading) { $scope.loading = false; }
			}, function (error) {
				NotificationService.error(labels.FILE_INDEX_PACKS_LOAD_ERROR_MESSAGE);
			});

			/*
			**	ShowBattleInfo --> Récupère la derniere battle mis en ligne.
			*/

			var parameters = [
				{key: "order_by_desc[]", value: "created_at"},
				{key: "limit", value: 2},
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			]
			HTTPService.findBattles(parameters).then(function(response) {
				if (response.data.content.length > 0) {
					$scope.battles = response.data.content;

					for (var i in $scope.battles) {
						var b = $scope.battles[i];
						var votes = [
							{ value: 0, width: 0 },
							{ value: 0, width: 0 },
						];

						if (b.votes.length > 0) {
							var totalVote = b.votes.length;
							for (var voteIndex in b.votes) {
								if (b.votes[voteIndex].artist_id == b.artist_one.id) {
									votes[0].value++;
								} else {
									votes[1].value++;
								}
							}
							b.votes = votes;
							b.votes[0].width = Math.max(Math.min(b.votes[0].value * 100 / totalVote, 95), 5);
							b.votes[1].width = Math.max(Math.min(b.votes[1].value * 100 / totalVote, 95), 5);
							b.votes[0].value = Math.round((b.votes[0].value * 100 / totalVote) * 100) / 100;
							b.votes[1].value = Math.round((b.votes[1].value * 100 / totalVote) * 100) / 100;
						} else {
							b.votes = [
								{ value: 0, width: 50 },
								{ value: 0, width: 50 },
							];
						}
					}
					battlesLoading = true;
					if (newsLoading && packsLoading && battlesLoading) { $scope.loading = false; }
				} else {
					battlesLoading = true;
					if (newsLoading && packsLoading && battlesLoading) { $scope.loading = false; }
				}
			}, function(error) {
				NotificationService.error(labels.FILE_INDEX_BATTLES_LOAD_ERROR_MESSAGE);
			});

			// Load the right column

			if ($scope.user != false) {
				var isFluxFinished = false;
				var isSuggestionFinished = false;
				var isTweetFinished = false;

				// Get the tweets of your follows
				HTTPService.getFlux([{ key: "secureKey", value: key }, { key: "user_id", value: id }]).then(function(response) {
					$scope.tweets = response.data.content;
					isFluxFinished = true;
					if (isFluxFinished && isSuggestionFinished && isTweetFinished) { $scope.loadingRightSide = false; }
				}, function(error) {
					NotificationService.error(labels.FILE_INDEX_FLUX_LOAD_ERROR_MESSAGE)
				});

				// Find the tweet who speak to you
				var paramsTweet = [
					{ key: encodeURIComponent("attribute[msg]"), value: encodeURIComponent("%" + $scope.user.username + "%") },
					{ key: "secureKey", value: key },
					{ key: "user_id", value: id }
				];
				HTTPService.findTweet(paramsTweet).then(function(response) {
					tmp_tweets = response.data.content;
					// Loop backward to splice inside
					for (var i = tmp_tweets.length - 1 ; i >= 0 ; i--) {
						if (tmp_tweets[i].user.id == id) {
							tmp_tweets.splice(i, 1);
						}
					}
					$scope.otherTweets = tmp_tweets;
					isTweetFinished = true;
					if (isFluxFinished && isSuggestionFinished && isTweetFinished) { $scope.loadingRightSide = false; }
				}, function(error) {
						NotificationService.error(labels.FILE_INDEX_FLUX_LOAD_ERROR_MESSAGE)
				});

				// Get the suggestion
				HTTPService.getSuggestion([{ key: "secureKey", value: key }, { key: "user_id", value: id }]).then(function(response) {
					$scope.suggestions = response.data.content;
					isSuggestionFinished = true;
					if (isFluxFinished && isSuggestionFinished && isTweetFinished) { $scope.loadingRightSide = false; }
				}, function(error) {
					NotificationService.error(labels.FILE_INDEX_SUGGESTION_LOAD_ERROR_MESSAGE)
				});
			}
		});
	}

	var timeLeftPack = function() {
		var now = new Date();

		for (var i = 0 ; i < $scope.packs.length ; i++) {
			var end = new Date($scope.packs[i].object.end_date.replace(/\-/g, "/"));
			var left = (end > now) ? end - now : "Finish !"

			if (left != "Finish !") {
				var date = new Date(left);
				var hours = date.getHours();
				var minutes = "0" + date.getMinutes();
				var seconds = "0" + date.getSeconds();
				left = hours + 'h' + minutes.substr(-2) + 'mn' + seconds.substr(-2) + 's';
			}
			$scope.packs[i].object.timeLeft = left;
		}
		$timeout(timeLeftPack, 1000);
	}

	$scope.comment = function(username) {
		$("#inputTweet").focus();
		$scope.tweet.input = "@" + username + " ";
	}

	$scope.sendTweet = function() {
		if ($scope.tweet.input.length < 140) {

			var parameters = {
				msg: $scope.tweet.input,
				user_id: $scope.user.id
			}

			SecureAuth.securedTransaction(function(key, user_id) {
				parameters.user_id = user_id;
				parameters.secureKey = key;
				HTTPService.saveTweet(parameters).then(function(response) {
					$scope.tweets.unshift(response.data.content);
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
		if ($scope.loading_tweet == false) {
			$scope.loading_tweet = true;

			SecureAuth.securedTransaction(function(key, id) {
				var paramsTweet = [
					{ key: encodeURIComponent("attribute[user_id]"), value: $scope.user.id },
					{ key: encodeURIComponent("order_by_desc[]"), value: "created_at" },
					{ key: "limit", value: 20 },
					{ key: "offset", value: $scope.tweets.length },
					{ key: "secureKey", value: key },
					{ key: "user_id", value: id }
				];

				HTTPService.findTweet(paramsTweet).then(function(response) {
					$scope.tweets = $scope.tweets.concat(response.data.content);
					$timeout(function() {
						$scope.loading_tweet = false;
					}, 1000);
				}, function(error) {
					NotificationService.error("");
				});
			});
		}
	}

	$scope.reloadPersonalTweet = function() {
		if ($scope.loading_tweet == false) {
			$scope.loading_tweet = true;

			SecureAuth.securedTransaction(function(key, id) {
				var paramsTweet = [
					{ key: encodeURIComponent("attribute[user_id]"), value: $scope.user.id },
					{ key: encodeURIComponent("order_by_desc[]"), value: "created_at" },
					{ key: "limit", value: 20 },
					{ key: "offset", value: $scope.otherTweets.length },
					{ key: encodeURIComponent("attribute[msg]"), value: encodeURIComponent("%" + $scope.user.username + "%") },
					{ key: "secureKey", value: key },
					{ key: "user_id", value: id },
				];

				HTTPService.findTweet(paramsTweet).then(function(response) {
					tmp_tweets = response.data.content;
					// Loop backward to splice inside
					for (var i = tmp_tweets.length - 1 ; i >= 0 ; i--) {
						if (tmp_tweets[i].user.id == id) {
							tmp_tweets.splice(i, 1);
						}
					}
					$scope.otherTweets = $scope.otherTweets.concat(tmp_tweets);
					$timeout(function() {
						$scope.loading_tweet = false;
					}, 1000);
				}, function(error) {
					NotificationService.error("");
				});
			});
		}
	}

	$scope.selectFlux = function() { $scope.tab = 0; }
	$scope.selectInteraction = function() { $scope.tab = 1; }
	$scope.selectPack = function(pack) { $scope.selectedPack.display = ($scope.selectedPack.display && $scope.selectedPack.pack == pack) ? false : true; $scope.selectedPack.pack = pack; }

	$scope.formatTime = function(duration) {
		var min = ~~(duration / 60);
		var sec = duration % 60;

		if (min.toString().length == 1)
			min = "0" + min;
		if (sec.toString().length == 1)
			sec = "0" + sec;
		return min + ":" + sec;
	}

	var checkPartial = function(packs) {
		for (var i = 0 ; i < packs.length ; i++) {
			var partial = packs[i].partial_albums;
			var partial_array = [];
			var partial_pack = [];

			for (var indexAlbums in packs[i].albums) {
				packs[i].albums[indexAlbums].partial = false;
				for (var indexPartial in partial) {
					if (partial[indexPartial].album_id == packs[i].albums[indexAlbums].id) { packs[i].albums[indexAlbums].partial = true; }
				}
				if (!packs[i].albums[indexAlbums].partial) { partial_array.push(packs[i].albums[indexAlbums]); }
				else { partial_pack.push(packs[i].albums[indexAlbums]); }
			}

			$scope.packs.push({ albumList: partial_pack, object: packs[i], partialList: partial_array });
		}
	}
}]);
