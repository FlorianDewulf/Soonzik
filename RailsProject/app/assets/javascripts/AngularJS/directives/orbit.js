SoonzikApp.directive('afterRenderRepeat', [function() {
	return {
		restrict: 'A',
		link: function($scope, $element, attr) {
			if ($scope.$last){
				$(document).foundation();
			}
		}
	};
}]);