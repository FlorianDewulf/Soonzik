SoonzikApp.directive('autoFocus', [function() {
	return {
		restrict: 'A',
		link: function ($scope, $element, attr) {
			$element.focus();
		}
	};
}]);