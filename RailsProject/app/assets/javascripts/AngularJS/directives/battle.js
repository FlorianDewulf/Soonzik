SoonzikApp.directive('battle', [function() {

	var drawMyDonut = function($element, values) {
		if (values.length == 0) {
			$element.html("Currently no votes");
			return;
    }

		var w = $element.parent().width();

		$element.width(w - 10 + "px");

		var total = 0;
		for (var index in values) {
			total += values[index].value;
		}

		Morris.Donut({
		  element: $element,
		  data: values,
		  formatter: function (x) { return (Math.round((x / total * 100) * 100) / 100) + "%"}
		});
	}

	return {
		restrict: 'E',
		scope: {
			'battleValues': '='
		},
		link: function ($scope, $element, attr) {
			$(window).resize(function() {
				$element.html("");
      	drawMyDonut($element, $scope.battleValues);
    	});

    	$scope.$watch('battleValues', function(newValue, oldValue) {
				$element.html("");
    		drawMyDonut($element, newValue);
      }, true);

     	drawMyDonut($element, $scope.battleValues);
		}
	};
}]);