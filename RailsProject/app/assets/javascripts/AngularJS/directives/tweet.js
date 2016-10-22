SoonzikApp.directive('tweet', [function() {
	var reg = /(@)(\w{3,40})/g

	return {
		restrict: 'E',
		scope: {
			'tweetMsg': '='
		},
		link: function($scope, $element, attr) {
			var t = $scope.tweetMsg;
			$element.html(t.replace(reg, "<a href='/users/$2'>$1$2</a>"));
		}
	};
}]);