SoonzikApp.controller('ConcertsCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', '$rootScope', '$routeParams', function ($scope, SecureAuth, HTTPService, $timeout, $rootScope, $routeParams) {

	$scope.loading = true;
	$scope.indexView = { concerts: [] };
	$scope.modelObj = {
		user: { username: "" },
		address: { country: "" }
	}

	$scope.initIndex = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "order_by_desc[]", value: "planification" },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id },
			];

			HTTPService.findConcerts(parameters).then(function(response) {
				$scope.indexView.concerts = []
				var concerts = response.data.content;
				var now = new Date();
				for (var i = 0 ; i < concerts.length ; i++) {
					var d = new Date(concerts[i].planification.replace(/\-/g, "/"));
					if (d < now) {
						break;
					} else {
						concerts[i].displayed = true;
						concerts[i].map = false;
						getAndFillCoord(concerts[i]);
						$scope.indexView.concerts.push(concerts[i]);
					}
				}
				$scope.indexView.concerts.reverse();
				$scope.loading = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_CONCERT_FIND_CONCERT_ERROR_MESSAGE);
			});
		}, function(error) {
			NotificationService.error($rootScope.labels.FILE_CONCERT_FIND_CONCERT_ERROR_MESSAGE);
		});
	}

	/* Utils function */

	$scope.formatAddress = function(address) {
		return address.numberStreet + " " + address.street + ", " + address.zipcode + " " + address.city + ", " + address.country;
	}

	$scope.displayMap = function(concert) {
		concert.displayed = !concert.displayed;
	}

	var getAndFillCoord = function(obj) {
		HTTPService.getCoordination($scope.formatAddress(obj.address)).then(function(results) {
	    obj.map = {
				center: {
	    		latitude: results.data.results[0].geometry.location.lat,
	    		longitude: results.data.results[0].geometry.location.lng
	    	},
				zoom: 15,
		    marker: {
		    	idKey: 1,
		    	coords: {
		    		latitude: results.data.results[0].geometry.location.lat,
		    		longitude: results.data.results[0].geometry.location.lng
		    	}
		    }
			};
	  }, function() {
	  	console.log("error");
	  });
	}
}]);
