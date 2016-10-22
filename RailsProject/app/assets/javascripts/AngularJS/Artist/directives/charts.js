SoonzikArtistApp.directive('charts', function() {
  return {
  	restrict: 'E',
  	scope: {
      'typeChart': '=',
      'values': '=',
      'xkey': '=',
      'ykeys': '=',
    	'labels': '='
    },
  	link: function ($scope, $element, attrs) {
      if ($scope.values.length == 0) {
        $element.html("No values are currently available");
        return;
      }

      var w1 = $element.parent().width();
      var w2 = $scope.values.length * 30 * 2; // two bars

      $element.width(((w1 > w2) ? w1 : w2) + "px");

      if ($scope.typeChart == "bar") {
        for (var i = 0 ; i < $scope.values.length ; i++) {
          for (var yindex in $scope.ykeys) {
            $scope.values[i][$scope.ykeys[yindex] ] = ~~($scope.values[i][$scope.ykeys[yindex] ] * 100) / 100;
          }
        }
        Morris.Bar({
          element: $element,
          data: $scope.values,
          xkey: $scope.xkey,
          ykeys: $scope.ykeys,
          labels: $scope.labels
        });
        $element.height("400px");
      } else if ($scope.typeChart == "line") {
        Morris.Line({
          element: $element,
          data: $scope.values,
          xkey: $scope.xkey,
          ykeys: $scope.ykeys,
          labels: $scope.labels
        });
        $element.height("400px");
      } else {
        var total = 0;
        for (var i in $scope.values) {
          total += $scope.values[i].value;
        }
        Morris.Donut({
          element: $element,
          data: $scope.values,
          formatter: function (x) { return (Math.round((x / total * 100) * 100) / 100) + "%"}
        });
      }
		}
  };
});

