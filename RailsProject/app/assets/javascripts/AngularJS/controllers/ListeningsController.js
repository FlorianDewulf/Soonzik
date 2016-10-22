SoonzikApp.controller('ListeningsCtrl', ['$scope', "$routeParams", 'SecureAuth', 'HTTPService', 'NotificationService', 'uiGmapGoogleMapApi', '$timeout', '$rootScope', '$location', function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, uiGmapGoogleMapApi, $timeout, $rootScope, $location) {

	// To avoid too much update when the range is modify
	var callbackID = 0;

	// For the blue circle effect and the update
	$scope.countBeforeUpdate = 5;
	$scope.isUpdating = false;
	$scope.lastUpdate = null;
	$scope.lastClicked = null;

	// Some Data
	$scope.position = {
		coords: {
			latitude: 0,
			longitude: 0
		}
	}

	$scope.loading = true;
	$scope.place = null;
	$scope.location = -1;
	$scope.model = {
		range: 50
	}

	$scope.circle = {
    center: {
      latitude: 0,
      longitude: 0
    },
    radius: 50000,
    stroke: {
      color: '#333',
      weight: 2,
      opacity: 0.5
    },
    fill: {
      color: '#EEE',
      opacity: 0.3
    },
    geodesic: true, // optional: defaults to false
    clickable: true, // optional: defaults to true
    editable: false, // optional: defaults to false
    visible: true // optional: defaults to true
  }

	$scope.circleZone = {
    center: {
      latitude: 0,
      longitude: 0
    },
    radius: 0,
    stroke: {
      color: '#008CBA',
      weight: 2,
      opacity: 0.2
    },
    fill: {
      color: '#008CBA',
      opacity: 0.1
    },
    geodesic: true, // optional: defaults to false
    clickable: false, // optional: defaults to true
    editable: false, // optional: defaults to false
    visible: true, // optional: defaults to true
    wait: false
  }

  // Init function
	$scope.init = function() {
		if (navigator.geolocation) {
			$scope.loading = false;
			$scope.location = 1;
			navigator.geolocation.getCurrentPosition(function(position) {
				$scope.position = position;

				uiGmapGoogleMapApi.then(function(maps) {
					////// Google map is loaded
					$scope.lastUpdate = new Date();

					SecureAuth.securedTransaction(function(key, id) {
						var params = [
							{ key: "secureKey", value: key },
							{ key: "user_id", value: id }
						];

						HTTPService.getListeningAround(position.coords.latitude, position.coords.longitude, $scope.model.range, params).then(function(response) {
							var marks = [];

							for (var i = 0 ; i < response.data.content.length && i < 10 ; i++) {
								var obj = response.data.content[i];
								marks.push(generateCursor(obj));
							}

							$scope.map = {
								center: {
									latitude: position.coords.latitude,
									longitude: position.coords.longitude
								},
								zoom: 9,
						    markers: marks
							};
							$scope.circle.center = { latitude: position.coords.latitude, longitude: position.coords.longitude };
							$scope.circleZone.center = { latitude: position.coords.latitude, longitude: position.coords.longitude };
							$scope.location = 2;
							$('.marker_labels').each(function(element) {
								element.hide();
							});
						}, function(error) {
							NotificationService.error($rootScope.labels.FILE_LISTENING_AROUND_ERROR_MESSAGE);
						});
					});

					$timeout(zoneMove, 200);

				});
				//////
			});
		} else {
			$scope.location = 0;
		}
	}

	// To generate an unique new object
	var generateCursor = function(obj) {
		var tmp = {
      latitude: obj.latitude,
      longitude: obj.longitude,
      idKey: obj.id,
      show: false,
      range: obj.distance,
      date: obj.created_at,
      object: obj
    };

    return tmp;
	}

	$scope.clickOnMarker = function(evt, evtName, data) {
		var lastID = ($scope.lastClicked) ? $scope.lastClicked.idKey : -1;
		if ($scope.lastClicked)
		{
	  	$('.marker' + $scope.lastClicked.object.music.id).parent().hide();
			$scope.lastClicked.options = {};
			$scope.lastClicked = null;
	  }
		if (data && lastID != data.idKey) {
	    data.options = {
	    	animation: 2,
	    	labelClass: 'marker_labels',
	    	labelAnchor: '60 0',
	    	labelContent: "<p class='marker_block', id='marker" + data.object.music.id + "'><a class='link_marker' href='/albums/" + data.object.music.album.id + "'>" + data.object.music.title + "</a>" + $rootScope.labels.FILE_LISTENING_INPOPUP_LISTENED_LABEL + "<a href='/users/" + data.object.user.id + "'>" + data.object.user.username + "</a></p>" +
	    	"<p>" + data.object.created_at + "</p>"
	    };
	  	$scope.lastClicked = data;
		}
  	$('.marker' + data.object.music.id).show();
		$('.link_marker').on('click', function(event) {
			event.preventDefault();
			$location.path($(event.target).attr('href'), true);
		});
	}

	// Callback of the slider
	$scope.changeRange = function() {
		if ($scope.model.range * 1000 < $scope.circle.radius) {
			var marks = JSON.parse(JSON.stringify($scope.map.markers));

			for (var i = 0 ; i < marks.length ; i++) {
				if (marks[i].range > $scope.model.range) {
					marks.splice(i, 1);
					i--;
				}
			}

			$scope.map.markers = marks;
		} else if ($scope.model.range * 1000 > $scope.circle.radius) {
			waitForFinalEvent(function(){
				updateZone();
			}, 500, "event" + callbackID);
		}
		$scope.circle.radius = $scope.model.range * 1000;
		$scope.countBeforeUpdate = 5;
	}

	// To avoid the spam of event
	var waitForFinalEvent = (function () {
	  var timers = {};
	  return function (callback, ms, uniqueId) {
	    if (timers[uniqueId]) {
	      clearTimeout (timers[uniqueId]);
	    }
	    timers[uniqueId] = setTimeout(callback, ms);
	  };
	})();

	// The timeout function
	var zoneMove = function() {
		$scope.$apply(function() {
			if ($scope.circleZone.radius >= $scope.circle.radius && $scope.circleZone.wait == false) {
				$scope.countBeforeUpdate--;
				if ($scope.countBeforeUpdate == 0) {
					if ($scope.isUpdating == false) {
						updateZone();
					}
					$scope.countBeforeUpdate = 5;
				}
				$scope.circleZone.radius = -1500;
			}
			
			$scope.circleZone.radius = Math.min($scope.circle.radius, $scope.circleZone.radius + 1500);

			if ($scope.circleZone.wait == true) {
				$scope.circleZone.wait = false;
			} else if ($scope.circleZone.radius >= $scope.circle.radius) {
				$scope.circleZone.wait = true;
			}
		});
		$timeout(zoneMove, 200);
	}

	// To update the data with a new range for example or because of time
	var updateZone = function() {
		$scope.isUpdating = true;

		SecureAuth.securedTransaction(function(key, id) {
			var params = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id },
				{ key: "from", value: $scope.lastUpdate.getTime() }
			];

			HTTPService.getListeningAround($scope.position.coords.latitude, $scope.position.coords.longitude, $scope.model.range, params).then(function(response) {

				$scope.lastUpdate = new Date();
				// Update
				if (response.data.content.length > 0) {
					var marks = [];
					for (var i = 0 ; (i < 10) && (i < 10 - response.data.content) && (i < $scope.map.markers.length) ; i++) {
						marks.push($scope.map.markers[i]);
					}
					for (var i = 0 ; i < (10 - marks.length) && i < response.data.content.length ; i++) {
						var obj = response.data.content[i];
						marks.push(generateCursor(obj));
					}
					$scope.map.markers = marks;
				}
				$scope.isUpdating = false;
			}, function(error) {

			});
		});
	}

}]);