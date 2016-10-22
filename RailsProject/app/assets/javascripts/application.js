// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require ./player/wavesurfer.min.js
//= require ./tools/better-date.js
//= require ./tools/sha256.js
//= require ./tools/messenger.min.js
//= require ./tools/messenger-theme-future.js
//= require ./tools/raphael-min.js
//= require ./tools/morris.min.js
//= require ./tools/lodash.min.js
//= require ./tools/sdk-3.0.0.js
//= require angular
//= require angular-animate
//= require angular-cookies
//= require angular-route
//= require angular-resource
//= require ./tools/angular-facebook.js
//= require ./tools/google-plus-signin.js
//= require ./AngularJS/app.js.erb
//= require ./AngularJS/controllers/AlbumsController.js
//= require ./AngularJS/controllers/BattlesController.js
//= require ./AngularJs/controllers/CartController.js
//= require ./AngularJs/controllers/ConcertsController.js
//= require ./AngularJS/controllers/ChatController.js
//= require ./AngularJS/controllers/DiscothequeController.js
//= require ./AngularJS/controllers/ExplorerController.js
//= require ./AngularJS/controllers/FeedbacksController.js
//= require ./AngularJS/controllers/FriendController.js
//= require ./AngularJS/controllers/HeaderController.js
//= require ./AngularJS/controllers/IndexController.js
//= require ./AngularJS/controllers/ListeningsController.js
//= require ./AngularJS/controllers/NewsController.js
//= require ./AngularJS/controllers/NotificationsController.js
//= require ./AngularJS/controllers/PackController.js
//= require ./AngularJS/controllers/PlayerController.js
//= require ./AngularJS/controllers/PlaylistsController.js
//= require ./AngularJS/controllers/SearchController.js
//= require ./AngularJS/controllers/TooltipController.js
//= require ./AngularJS/controllers/UsersController.js
//= require ./AngularJS/directives/autofocus.js
//= require ./AngularJS/directives/autoscrollbottom.js
//= require ./AngularJS/directives/battle.js
//= require ./AngularJS/directives/clickOutside.js
//= require ./AngularJS/directives/loading.js
//= require ./AngularJS/directives/music.js
//= require ./AngularJS/directives/onScroll.js
//= require ./AngularJS/directives/selectOnClick.js
//= require ./AngularJS/directives/submitInput.js
//= require ./AngularJS/directives/wavesurfer.js
//= require ./AngularJS/directives/orbit.js
//= require ./AngularJS/directives/tweet.js
//= require ./AngularJS/services/SecureAuth.js
//= require ./AngularJS/services/HTTPService.js
//= require ./AngularJS/services/NotificationService.js
//= require ./tools/ng-file-upload-bower-4.2.0/ng-file-upload-all.min.js
//= require ./tools/loading-bar.min.js
//= require ./tools/mm-foundation-tpls-0.6.0.min.js
//= require ./tools/checklist-model.js
//= require ./tools/angular-drag-and-drop-lists.min.js
//= require ./tools/angular-maps.min.js
// require_tree .

$(function(){ $(document).foundation(); });

$(document).ready(function() {
	$(".removeInfo").each(function() {
		$(this).click(function() {
			$(this).parent().remove();
		});
	});
});
