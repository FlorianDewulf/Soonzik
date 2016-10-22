SoonzikArtistApp.controller('TourCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', function ($scope, SecureAuth, HTTPService, NotificationService, $timeout) {

	$scope.form = {
		open: false,
		value: {
			concert: {
				planification: "",
				url: ""
			},
			address: {
				numberStreet: "",
				complement: "",
				street: "",
				city: "",
				country: "",
				zipcode: ""
			}
		}
	}

	$scope.errors = {
		address: {
			numberStreet: false,
			complement: false,
			street: false,
			city: false,
			country: false,
			zipcode: false
		},
		concert: {
			planification: false,
			url: false
		}
	}

	$scope.concerts = []

	$scope.tourInit = function() {
		var today = new Date();

		$scope.form.value.concert.planification = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0);
	}

	$scope.openCloseForm = function(value) {
		$scope.form.open = value;
	}

	$scope.create = function() {
		$scope.errors = {
			address: {
				numberStreet: false,
				complement: false,
				street: false,
				city: false,
				country: false,
				zipcode: false
			},
			concert: {
				planification: false,
				url: false
			}
		}

		HTTPService.addConcert($scope.form.value).then(function(response) {
			$scope.form.value = {
				concert: {
					planification: "",
					url: ""
				},
				address: {
					numberStreet: "",
					complement: "",
					street: "",
					city: "",
					country: "",
					zipcode: ""
				}
			}
		
			var today = new Date();
			$scope.form.value.concert.planification = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0);

			$scope.concerts.push(response.data);
		}, function(error) {
			if (typeof error.data.address !== "undefined") {
				$scope.errors.address = error.data.address;
			}
			if (typeof error.data.concert !== "undefined") {
				$scope.errors.concert = error.data.concert;
			}
		});
	}

}]);