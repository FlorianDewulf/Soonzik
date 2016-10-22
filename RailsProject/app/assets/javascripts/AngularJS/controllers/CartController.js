SoonzikApp.controller('CartCtrl', ['$scope', 'SecureAuth', 'HTTPService', '$timeout', 'NotificationService', '$rootScope', '$location', function ($scope, SecureAuth, HTTPService, $timeout, NotificationService, $rootScope, $location) {

	$scope.loading = true;
	$scope.totalPrice = 0;
	$scope.albums = [];
	$scope.listAlbums = [];
	$scope.listMusics = [];

	$scope.showCart = function() {
		if (!$rootScope.user) { $location.path('/', true);return; }

		SecureAuth.securedTransaction(function (key, id) {

			var parameters = [
				{ key: "user_id", value: id },
				{ key: "secureKey", value: key }
			];

			HTTPService.showCart(parameters).then(function(response) {
				$scope.carts = response.data.content;

				if (Object.prototype.toString.call( $scope.carts ) === '[object Array]') {
					var priceAlbum = 0;
					for (var i = 0; i < $scope.carts.length ; i++) {
						for (var j = 0; j < $scope.carts[i].albums.length ; j++) {
							$scope.listAlbums.push({ cart_id: $scope.carts[i].id, album: $scope.carts[i].albums[j] });
							priceAlbum += $scope.carts[i].albums[j].price;
						}
					}


					var priceMusics = 0;
					for (var i = 0; i < $scope.carts.length ; i++) {
						for (var j = 0; j < $scope.carts[i].musics.length ; j++) {
							$scope.listMusics.push({ cart_id: $scope.carts[i].id, music: $scope.carts[i].musics[j] });
							priceMusics += $scope.carts[i].musics[j].price;
						}
					}

					$scope.totalPrice = priceAlbum + priceMusics;

				}
				$scope.loading = false;

			}, function(responseError) {
				NotificationService.error($rootScope.labels.FILE_CART_LOAD_ERROR_MESSAGE);
			});
		});
	}

	$scope.deleteItem = function (cart_id) {
		SecureAuth.securedTransaction(function(key, id) {

			var parameters = [
				{ key: "secureKey" ,value: key },
				{ key: "user_id", value: id },
				{ key: "id", value: cart_id }
			];

			HTTPService.destroyItem(parameters).then(function(response) {
				for (var indexAlbum in $scope.listAlbums) {
					if ($scope.listAlbums[indexAlbum].cart_id == cart_id) {
						$scope.totalPrice -= $scope.listAlbums[indexAlbum].album.price;
						$scope.listAlbums.splice(indexAlbum, 1);
						break;
					}
				}
				for (var indexMusic in $scope.listMusics) {
					if ($scope.listMusics[indexMusic].cart_id == cart_id) {
						$scope.totalPrice -= $scope.listMusics[indexMusic].music.price;
						$scope.listMusics.splice(indexMusic, 1);
						break;
					}
				}
				NotificationService.success($rootScope.labels.FILE_CART_DELETE_SUCCESS_MESSAGE);
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_CART_DELETE_ITEM_ERROR_MESSAGE);
			});

		});
	}

	$scope.toPayment = function() {
		document.location.href = "/purchase/cart/";
	}

}]);
