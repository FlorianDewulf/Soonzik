SoonzikApp.directive('selectOnClick', [function() {
    return {
        restrict: 'A',
        scope: {
            'selectOnClick': '&'
        },
        link: function ($scope, $element, attr) {
            $element.on("click", function() {
                $element.select();
            });
        }
    };
}]);