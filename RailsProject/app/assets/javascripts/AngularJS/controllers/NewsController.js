SoonzikApp.controller('NewsCtrl', ['$scope', '$routeParams', 'SecureAuth', 'HTTPService', 'NotificationService', "$rootScope", function ($scope, $routeParams, SecureAuth, HTTPService, NotificationService, $rootScope) {

	$scope.loading = true;
	$scope.resourceName = "news"

	// For the pagination
	$scope.index = {
		currentPage: 1,
		totalPage: 1,
		resources: []
	};

	$scope.resourcesCommentaries = [];
	$scope.commentLoading = false;
	$scope.show = {
		news: null,
		contentCommentary : ""
	};

	var newsPerPage = 20;

	$scope.initIndexNews = function() {
		$scope.index.currentPage = ($rootScope.toInt($routeParams.page) == 0 ? 1 : $rootScope.toInt($routeParams.page));

		SecureAuth.securedTransaction(function(key, id) {
			var countParams = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id },
				{ key: "count", value: "true" }
			];
			// For pagination
			HTTPService.indexNews(countParams).then(function(response) {
				var numberResults = response.data.content;

				if (typeof numberResults != "undefined") {
					$scope.index.totalPage = ~~(numberResults / newsPerPage) + 1;
				} else {
					$scope.index.totalPage = 1;
				}
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_LOAD_ERROR_MESSAGE);
			});

			// Get news
			var parameters = [
				{ key: "order_by_desc[]", value: "created_at" },
		  		{ key: "offset", value: ($scope.index.currentPage - 1) * 20 },
		  		{ key: "limit", value: newsPerPage },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id },
			];

			HTTPService.findNews(parameters).then(function(response) {
				$scope.index.resources = response.data.content;

				for (var indexNews in $scope.index.resources) {
					if ($scope.index.resources[indexNews].content.length > 170) {
						$scope.index.resources[indexNews].content = $scope.index.resources[indexNews].content.substr(0, 170) + "...";
					}
				}

				$scope.index.totalPage = Math.floor($scope.index.resources.length / 20 + 1);

				$scope.loading = false;
			}, function (error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_LOAD_ERROR_MESSAGE);
			});
		});
	}

	$scope.initShowNews = function() {
		var newsId = $routeParams.id;
		$rootScope.likes = {
			count: 0,
			isLiked: false
		};

		SecureAuth.securedTransaction(function(key, id) {
			var params = [
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
			];
			HTTPService.showNews(newsId, params).then(function(response) {
				$scope.show.news = response.data.content;
				$rootScope.likes = { count: response.data.content.likes, isLiked: response.data.content.hasLiked };
				$scope.showComments();

				$(window).scroll(function() {
					if($(window).scrollTop() + $(window).height() == $(document).height() && $scope.newsLoading == false) {
						$scope.$apply(function() {
							$scope.newsLoading = true;
							$scope.showComments();
						});
					}
				});

				$scope.loading = false;
			}, function (error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_ONE_NEWS_ERROR_MESSAGE);
			});
		});
	}

	/*
	 *
	 * Because we need the DOM
	 * 
	 */
	$scope.initSocialAPI = function() {
		// Share Twitter
		!function(d,s,id)
    {
      var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
      if(!d.getElementById(id)){
        js=d.createElement(s);
        js.id=id;
        js.src=p+'://platform.twitter.com/widgets.js';
        fjs.parentNode.insertBefore(js,fjs);
      }
    }(document, 'script', 'twitter-wjs');

    // Share Google Plus 
  	(function() {
  		var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
      po.src = 'https://apis.google.com/js/client:plusone.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    })();
	}

	$scope.showComments = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters = [
				{ key: "offset", value: $scope.resourcesCommentaries.length },
				{ key: "limit", value: 20 },
				{ key: "order_reverse", value: true },
				{ key: "secureKey", value: key },
				{ key: "user_id", value: id }
	  		];

			HTTPService.showComment($scope.show.news.id, parameters).then(function(response) {
				$scope.resourcesCommentaries = $scope.resourcesCommentaries.concat(response.data.content);
				$scope.commentLoading = false;
			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_LOAD_COMMENT_ERROR_MESSAGE);
			});
		});
	}

	$scope.postComment = function() {
		SecureAuth.securedTransaction(function(key, id) {
			var parameters =
		  		{	secureKey: key,
			  		user_id: id,
			  		content: $scope.show.contentCommentary
			  	};

			HTTPService.addComment($scope.show.news.id, parameters).then(function(response) {

				$scope.resourcesCommentaries.unshift(response.data.content);
				$scope.show.contentCommentary = "";

			}, function(error) {
				NotificationService.error($rootScope.labels.FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE);
			});
		});
	}

}]);