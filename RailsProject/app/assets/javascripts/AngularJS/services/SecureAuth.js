SoonzikApp.factory('SecureAuth', ['$http', '$routeParams', '$location', '$cookies', '$timeout', '$rootScope', 'NotificationService', function ($http, $routeParams, $location, $cookies, $timeout, $rootScope, NotificationService) {

	var api_url = "http://api.lvh.me:3000";
  var isUsed = false;
  var last_update = null;
  var last_key = null;

  return {
      getCurrentUser: function () {
      	var user = { id: null, token: null, username: null }
      	if (typeof $cookies.get("user_id") !== "undefined")
      		user.id = $cookies.get("user_id");
      	if (typeof $cookies.get("user_token") !== "undefined")
      		user.token = $cookies.get("user_token");
        if (typeof $cookies.get("user_username") !== "undefined")
          user.username = $cookies.get("user_username");
      	return user;
      },
      securedTransaction: function(securedFunctionSuccess) {
        if (isUsed) {
          var that = this;
          $timeout(function() {
            that.securedTransaction(securedFunctionSuccess);
          }, 500);
        } else {
          d = new Date();
          var user = $rootScope.user;

          if (user != false && (last_update == null || last_update < d.getTime() || last_key == null) && user.id != null && user.token != null) {
            isUsed = true;
            /*
             * If we need a valid token
             */
    		    $http.get(api_url + '/getKey/' + user.id).then(function (json) {
              isUsed = false;

    		    	var key_obj = new jsSHA(user.token + json.data.key, "TEXT");
    					var key = key_obj.getHash("SHA-256", "HEX");
              
              last_update = Date.parse(json.data.last_update);
              last_key = key;
    		    	
    		    	securedFunctionSuccess(key, user.id);
    		    }, function(error) {
              isUsed = false;
              NotificationService.error($rootScope.labels.FILE_SECURITY_FAILED);
            });
            /********************************/
          } else {
            /*
             * If we have a valid token
             */
            if (user == false) {
              securedFunctionSuccess(last_key, null);
            } else {
              securedFunctionSuccess(last_key, user.id);
            }
          }
        }
      },
      getLanguage: function() {
        if (typeof $cookies.get("language") !== "undefined") {
          return $cookies.get("language");
        } else {
          return "EN";
        }
      }
  }
}]);