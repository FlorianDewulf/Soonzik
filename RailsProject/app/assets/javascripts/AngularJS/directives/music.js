SoonzikApp.directive('music', ["$rootScope", function($rootScope) {
	return {
		restrict: 'E',
		scope: {
			"musicObject": "="
		},
		link: function ($scope, $element, attr) {
			$element.on("click", function() {
				$rootScope.$broadcast('player:play', { song: $scope.musicObject });
			});
		}
	};
}]);