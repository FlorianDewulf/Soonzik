SoonzikApp.directive('autoScrollBottom', [function() {

	return function ($scope, $element, attr) {
		if ($scope.$last){
    	$element.parent().scrollTop($element.parent().prop("scrollHeight"));
  	}
	}
}]);