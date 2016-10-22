SoonzikArtistApp.factory('SecureAuth', ['$http', '$location', '$cookies', '$timeout', function ($http, $location, $cookies, $timeout) {

	var url = "lvh.me:3000";
  var isUsed = false;

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
      securedTransaction: function(securedFunctionSuccess, securedFunctionError, test) {
        if (isUsed) {
          var that = this;
          $timeout(function() {
            that.securedTransaction(securedFunctionSuccess, securedFunctionError, test);
          }, 500);
        } else {
          isUsed = true;
        	var user = { id: null, token: null }
        	if (typeof $cookies.get("user_id") !== "undefined" &&
        			typeof $cookies.get("user_token") !== "undefined") {
  	        user.id = $cookies.get("user_id");
  	      	user.token = $cookies.get("user_token");
          }
  		    $http.get("http://api." + url + '/getKey/' + user.id).then(function (json) {
            isUsed = false;
  		    	var key_obj = new jsSHA(user.token + json.data.key, "TEXT");
  					var key = key_obj.getHash("SHA-256", "HEX");
  		    	
  		    	securedFunctionSuccess(key, user.id);
  		    }, function(error) {
            isUsed = false;
            securedFunctionError(error);
          });
        }
      }
  }
}]);