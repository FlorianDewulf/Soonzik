SoonzikApp.controller('FeedbackCtrl', ['$scope', 'SecureAuth', 'HTTPService', 'NotificationService', '$rootScope', function ($scope, SecureAuth, HTTPService, NotificationService, $rootScope) {
	$scope.feedback = {
		email: "",
		type_object: "",
		object: "",
		text: ""
	};

	$scope.options = [
		{ label: "", value: "" },
		{ label: $rootScope.labels.DISPLAY_FEEDBACK_TYPE_OBJ_BUG_LABEL, value: "bug" },
		{ label: $rootScope.labels.DISPLAY_FEEDBACK_TYPE_OBJ_PAYMENT_LABEL, value: "payment" },
		{ label: $rootScope.labels.DISPLAY_FEEDBACK_TYPE_OBJ_ACCOUNT_LABEL, value: "account" },
		{ label: $rootScope.labels.DISPLAY_FEEDBACK_TYPE_OBJ_OTHER_LABEL, value: "other" }
	];

	$scope.isSending = false;
	$scope.send = false;

	$scope.verifType = function() {
		if ($scope.feedback.type_object != "bug" && $scope.feedback.type_object != "payment" &&
				$scope.feedback.type_object != "account" && $scope.feedback.type_object != "other")
			$scope.feedback.type_object = "";
	}

	$scope.sendFeeback = function() {
		$scope.isSending = true;
		HTTPService.addFeedback($scope.feedback).then(function() {
			$scope.send = true;
			$scope.isSending = false;
		}, function(error) {
			NotificationService.error("labels.error.feedback");
			$scope.isSending = false;
		});
	}
}]);