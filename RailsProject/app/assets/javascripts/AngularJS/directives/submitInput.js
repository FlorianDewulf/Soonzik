SoonzikApp.directive('submitInput', ["$parse", function($parse) {
  return {
  	restrict: 'A',
  	scope: {
  		'submitInput': '&'
  	},
  	link: function (scope, $element, attrs) {
  		$element.keydown(function (t) {
  			if (event.keyCode == 13) {
  				scope.submitInput();
  			}
  		});
    }
  };
}]);

