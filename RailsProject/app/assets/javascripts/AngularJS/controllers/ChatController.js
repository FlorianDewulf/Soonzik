SoonzikApp.controller('ChatCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', "$rootScope", function ($scope, SecureAuth, HTTPService, $timeout, $rootScope) {
	var sizeChatWindow = 260;

	$scope.available = false;
	$scope.reduced = false;

	$scope.current_user = SecureAuth.getCurrentUser();
	$scope.filter = { username: "" }
	$scope.onWindows = [];
	$scope.message = {};
	$scope.onlineFriends = []
	$scope.showMiniWindow = { value: false };

	$scope.conversationStyle = { width: "auto" }

	var onlineFriendsCall = false;
	var listFriendsCall = false;
	var timeSynchronizationCall = 200;

	/* BEGIN/ Websocket logic */
	if (typeof WebSocketRails !== "undefined") {
		$scope.available = true;
		var dispatcher = new WebSocketRails('lvh.me:3000/websocket');

		dispatcher.on_open = function(data) {
			dispatcher.trigger('who_is_online', {});
			dispatcher.bind('onlineFriends', function(data) {
				var response = JSON.parse(data);
		    $scope.onlineFriends = response.message;
		    onlineFriendsCall = true;
		  });
		  dispatcher.bind("newMsg", newMessage);
		  dispatcher.bind("newOnlineFriends", newFriendOn);
		  dispatcher.bind("newOfflineFriends", newFriendOff);
		  dispatcher.bind('connection_closed', function() {
		  	$timeout(function() {
			  	dispatcher = new WebSocketRails('lvh.me:3000/websocket');
				}, 5000);
			})
		}

		var newMessage = function(data) {
			var response = JSON.parse(data);

			if (typeof response !== "undefined" &&
					typeof response.from !== "undefined") {

				if ((typeof $scope.message[response.from] == "undefined" && isInFriendList(response.from) != false) ||
						(typeof $scope.message[response.from] != "undefined" && isOpen(response.from))) {
					$scope.open_chat(isInFriendList(response.from));
				} else if (typeof $scope.message[response.from] == "undefined" && isInFriendList(response.from) == false) {
					return;
				}
				$scope.message[response.from].messagesText.push({ extern: true, value: response.message });
		    $scope.$digest();
	  	}
		}

		var newFriendOn = function(data) {
			var response = JSON.parse(data);

			for (var index in $rootScope.friends) {
				if ($rootScope.friends[index].id == response.idFriend && $rootScope.friends[index].online == false) {
					$rootScope.friends[index].online = true;
		    	$scope.$digest();
					return;
				}
			}
		}

		var newFriendOff = function(data) {
			var response = JSON.parse(data);

			for (var index in $rootScope.friends) {
				if ($rootScope.friends[index].id == response.idFriend && $rootScope.friends[index].online == true) {
					$rootScope.friends[index].online = false;
		    	$scope.$digest();
					return;
				}
			}
		}

		// check les gens qui passe en ligne / hors ligne grace à l'event de connexion
		// -> Prendre en compte les onlines / offline (bouger d'objet)
		// -> Charger les derniers messages

		/*-- END/ Websocket logic --*/

		//-------------------------------------------------------------------

		/* Private method */

		var canItBeBig = function (arrayWindows) {
			var width = $(window).width() - 320;	// 320 = 210 (size of friend list) + margin left of the screen
			var numberMaxWindowOpened = ~~(width / sizeChatWindow); //to get an int and not a float
			var currentlyOpened = 0;

			for (var index in arrayWindows) {
				if (arrayWindows[index].opened == true && arrayWindows[index].maximized == true)
					currentlyOpened++;
			}
			if (currentlyOpened >= numberMaxWindowOpened)
				return false;
			return true;
		}

		var calcWidth = function (arrayWindows) {
			var width = 0;
			var miniWindow = false;

			for (var index in arrayWindows) {
				if (arrayWindows[index].maximized == true && arrayWindows[index].opened == true)
					width += 260;
				else if (arrayWindows[index].maximized == false && arrayWindows[index].opened == true)
					miniWindow = true;
			}

			$scope.conversationStyle.width = width + (miniWindow ? 45 : 0);
		}

		var isInFriendList = function (from_username) {
			for (var index in $rootScope.friends) {
				if ($rootScope.friends[index].username == from_username) {
					return $rootScope.friends[index];
				}
			}
			return false;
		}

		var timeoutSynchronization = function () {
			if (onlineFriendsCall == true && listFriendsCall == true) {
				for (var index in $rootScope.friends) {
					for (var indexOnline in $scope.onlineFriends) {
						if ($rootScope.friends[index].id == $scope.onlineFriends[indexOnline]) {
							$rootScope.friends[index].online = true;
						}
					}
					$scope.onWindows.push({
						friend: $rootScope.friends[index],
						maximized: false,
						opened: false,
						loading: false
					});
				}
				if ($scope.onWindows.length > 0)
					r_secureLoop(0)
			} else {
				timeSynchronizationCall += 150;
				$timeout(timeoutSynchronization, timeSynchronizationCall);
			}
		}

		var r_secureLoop = function(index) {
			SecureAuth.securedTransaction(function (key, user_id) {
				$scope.onWindows[index].loading = true;
				waiting = false;
				var parameters = [{
					key: "secureKey", value: key
				}, {
					key: "user_id", value: user_id
				}];
				HTTPService.getLastMessages($scope.onWindows[index].friend.id, parameters).then(function(messages) {
					if (typeof $scope.message[$scope.onWindows[index].friend.username] === "undefined")
						$scope.message[$scope.onWindows[index].friend.username] = { value: "", messagesText: [] };

					for (var i in messages.data.content) {
						$scope.message[$scope.onWindows[index].friend.username].messagesText.push({ extern: (messages.data.content[i].user_id == $scope.current_user.id) ? false : true, value: messages.data.content[i].msg });
					}
					$scope.onWindows[index].loading = false;

					if (index + 1 < $scope.onWindows.length)
						r_secureLoop(index + 1);
					else
						return;
				}, function(error) {
					$scope.onWindows[index].loading = false;
					if (index + 1 < $scope.onWindows.length)
						r_secureLoop(index + 1);
					else
						return;
					$scope.message[$scope.onWindows[index].friend.username] = $rootScope.labels.FILE_CHAT_GET_MESSAGE_ERROR_MESSAGE;
				});
			});
		}

		var isOpen = function(username) {
			for (var index in $rootScope.friends) {
				if ($rootScope.friends[index].friend == username && $rootScope.friends[index].opened == false) {
					return false;
				}
			}
			return true;
		}

		//-------------------------------------------------------------------

		/*-- BEGIN/ Angular callback --*/

		// ng-init call
		$scope.chatInit = function() {
			SecureAuth.securedTransaction(function(key, id) {

				var parameters = [
					{ key: "secureKey", value: key },
					{ key: "user_id", value: id }
				];

				HTTPService.getFriends($scope.current_user.id).then(function(friendsResponse) {
					$rootScope.friends = friendsResponse.data.content;
					for (var index in $rootScope.friends) {
						$rootScope.friends[index].online = false;
					}
					$scope.$on('chat:friend', function(event, data) {
						var friend = JSON.parse(JSON.stringify(data));
						friend.online = false;
						$rootScope.friends.push(friend);
						dispatcher.trigger('who_is_online', {});
					});
					$scope.$on('chat:unfriend', function(event, data) {
						for (var i = 0 ; i < $rootScope.friends.length ; i--) {
							if ($rootScope.friends[i].id == data.id) {
								$rootScope.friends.splice(i, 1);
								break;
							}
						}
					});
					listFriendsCall = true;
				}, function(error) {
					// TODO
				});
			});
		}

		// ng-click call
		$scope.open_chat = function(friend) {
			var selectedObject = null;
			for (var index in $scope.onWindows) {
				if ($scope.onWindows[index].friend.id == friend.id) {
					selectedObject = $scope.onWindows[index];
				}
			}

			var big = canItBeBig($scope.onWindows);

			if (big == false) {
				for (var index in $scope.onWindows) {
					if ($scope.onWindows[index].friend.id != friend.id) {
						$scope.onWindows[index].maximized = false;
					}
				}
			}

			if (selectedObject == null) {
				selectedObject = {
					friend: friend,
					maximized: true,
					opened: true,
					loading: false
				};
				$scope.onWindows.push(selectedObject);
				if (typeof $scope.message[friend.username] === "undefined")
					$scope.message[friend.username] = { value: "", messagesText: [] };
			} else {
				selectedObject.opened = true;
				selectedObject.maximized = true;
			}

			calcWidth($scope.onWindows);
		}

		// submit-input call
		$scope.sendMsg = function(friend) {
			var isThereChar = false;

			for (var i = 0 ; i < $scope.message[friend.username].value.length ; i++) {
				if ($scope.message[friend.username].value[i] != ' ' && $scope.message[friend.username].value[i] != '\t') {
					isThereChar = true;
					break;
				}
			}

			if (isThereChar != false && $scope.message[friend.username].value.length > 0) {
				var sendMsg = {
					messageValue: $scope.message[friend.username].value,
					toWho: friend.id
				}
				$scope.message[friend.username].messagesText.push({ extern: false, value: sendMsg.messageValue });
				dispatcher.trigger('messages.send', sendMsg)
			}
			$scope.message[friend.username].value = "";
			var contentFriend = $("#userchat-" + friend.id + " .content");
			contentFriend.scrollTop(contentFriend.prop("scrollHeight"));
			$scope.$digest();
		}

		// Synchronize informations
		$timeout(timeoutSynchronization, timeSynchronizationCall);

		// ng-click call
		$scope.closeChat = function(friendWindow) {
			friendWindow.opened = false;
			friendWindow.maximized = true;

			var nbConv = 0;

			for (var index in $scope.onWindows) {
				if ($scope.onWindows[index].opened == true && $scope.onWindows[index].maximized == true) {
					nbConv++;
				}
			}

			if (nbConv == 0 && $scope.miniChat().length > 0) {
				for (var index in $scope.onWindows) {
					if ($scope.onWindows[index].opened == true && $scope.onWindows[index].maximized == false) {
						$scope.onWindows[index].maximized = true;
					}
				}
			}

			calcWidth($scope.onWindows);
		}

		$scope.expandReduceChat = function() {
			$scope.reduced = !$scope.reduced;
		}

		// click-click call
		$scope.openMiniChat = function() {
			$scope.showMiniWindow.value = true;
		}

		// click-outside call
		$scope.closeMiniChat = function() {
			$scope.showMiniWindow.value = false;
		}

		// ng-if call
		$scope.miniChat = function() {
			var list = []
			for (var index in $scope.onWindows) {
				if ($scope.onWindows[index].opened == true && $scope.onWindows[index].maximized == false) {
					list.push($scope.onWindows[index]);
				}
			}
			return list;
		}

		// onScroll call
		$scope.loadMoreMessages = function(friendWindow) {
			var friend = friendWindow.friend;
			SecureAuth.securedTransaction(function (key, user_id) {
				friendWindow.loading = true;
				var parameters = [{
					key: "secureKey", value: key
				}, {
					key: "user_id", value: user_id
				}, {
					key: "offset", value: $scope.message[friend.username].messagesText.length
				}];
				HTTPService.getLastMessages(friend.id, parameters).then(function(messages) {
					var newArray = [];
					for (var i in messages.data.content) {
						newArray.push({ extern: (messages.data.content[i].user_id == $scope.current_user.id) ? false : true, value: messages.data.content[i].msg });
					}
					$timeout(function(){
						friendWindow.loading = false;
						$scope.message[friend.username].messagesText = newArray.concat($scope.message[friend.username].messagesText);
					}, 1000);
				}, function(error) {
					$scope.message[friend.username].messagesText.push({extern: true, value: $rootScope.labels.FILE_CHAT_GET_MESSAGE_ERROR_MESSAGE});
					friendWindow.loading = false;
				});
			});
		}
	}

	/*-- END/ Angular callback --*/
}]);