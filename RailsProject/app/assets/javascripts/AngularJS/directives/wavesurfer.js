SoonzikApp.directive('wavesurfer', function () {
  return {
    restrict: 'E',

    link: function ($scope, $element, $attrs) {
      var wavesurfer = null;
      $element.css('display', 'block');

      var options = angular.extend({ container: $element[0] }, $attrs);
      wavesurfer = WaveSurfer.create(options);

      if ($attrs.url) {
        wavesurfer.load($attrs.url, $attrs.data || null);
      }

      $scope.$emit('wavesurferInit', wavesurfer);

      $(window).resize(function() {
        if (wavesurfer != null) {
          waves = $("canvas", $element);
          for (var waveIndex = 0 ; waveIndex < waves.length ; waveIndex++) {
            $(waves[waveIndex]).width($element.width());
            $(waves[waveIndex]).height("100%");
          }
          $("wave > wave").width((wavesurfer.getCurrentTime() / wavesurfer.getDuration()) * $element.width());
          wavesurfer.drawer.width = $element.width();
        }
      });
    }
  };
});