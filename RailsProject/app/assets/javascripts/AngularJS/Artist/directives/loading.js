SoonzikArtistApp.directive('loading', function() {
	var templateSquare = '<div id="spinningSquaresG"><div id="spinningSquaresG_1" class="spinningSquaresG"></div><div id="spinningSquaresG_2" class="spinningSquaresG"></div><div id="spinningSquaresG_3" class="spinningSquaresG"></div><div id="spinningSquaresG_4" class="spinningSquaresG"></div><div id="spinningSquaresG_5" class="spinningSquaresG"></div><div id="spinningSquaresG_6" class="spinningSquaresG"></div><div id="spinningSquaresG_7" class="spinningSquaresG"></div><div id="spinningSquaresG_8" class="spinningSquaresG"></div></div>';
	var templateCircular = '<div id="circularG"><div id="circularG_1" class="circularG"></div><div id="circularG_2" class="circularG"></div><div id="circularG_3" class="circularG"></div><div id="circularG_4" class="circularG"></div><div id="circularG_5" class="circularG"></div><div id="circularG_6" class="circularG"></div><div id="circularG_7" class="circularG"></div><div id="circularG_8" class="circularG"></div></div>';
	var tmpl;

  return {
  	restrict: 'E',
  	scope: {
    	'loadingType': '='
    },
  	link: function (scope, $element, attrs) {
  		tmpl = scope.loadingType;
  		if (typeof tmpl === "undefined")
  			tmpl = 'circular';

  		$element.html((tmpl == 'circular') ? templateCircular : templateSquare);
		}
  };
});

