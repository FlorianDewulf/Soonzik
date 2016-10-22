SoonzikArtistApp.factory('HTTPService', ['$http', '$location', 'Upload', function ($http, $location, Upload) {

	var url = "lvh.me:3000"

  function urlParametersFormat(array) {
    if (typeof array === "undefined" || array == null || array.length == 0)
      return "";

    parameters = ""
    for (var index in array) {
      if (index == 0) {
        parameters += "?"
      } else {
        parameters += "&"
      }
      parameters += array[index].key + "=" + array[index].value
    }
    return parameters;
  }

  return {
    getLastMessages: function (user_id, parameters) {
      return $http.get("http://api." + url + '/messages/conversation/' + user_id + urlParametersFormat(parameters));
    },
    getProfile: function (user_id) {
      return $http.get("http://api." + url + '/users/' + user_id);
    },
    getFullProfile: function (user_id) {
      return $http.get("http://" + url + '/users/' + user_id + '/edit.json');
    },
    getFriends: function (user_id) {
    	return $http.get("http://api." + url + '/users/' + user_id + '/friends')
    },
    getFollowers: function (user_id) {
      return $http.get("http://api." + url + '/users/' + user_id + '/followers')
    },
    getFollows: function (user_id) {
      return $http.get("http://api." + url + '/users/' + user_id + '/follows')
    },
    isArtist: function (user_id) {
    	return $http.get("http://api." + url + '/users/' + user_id + '/isartist')
    },
    updateUser: function (parameters) {
      return $http.post("http://api." + url + '/users/update', parameters)
    },
    uploadProfileImage: function (file, parameters, progressFunction, successFunction, errorFunction) {
      parameters.type = "image";
      Upload.upload({
        url: "http://api." + url + '/users/upload',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    uploadBackgroundImage: function (file, parameters, progressFunction, successFunction, errorFunction) {
      parameters.type = "background";
      Upload.upload({
        url: "http://api." + url + '/users/upload',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    findPacks: function (parameters) {
      return $http.get("http://api." + url + '/packs/find' + urlParametersFormat(parameters));
    },
    findBattles: function (parameters) {
      return $http.get("http://api." + url + '/battles/find' + urlParametersFormat(parameters));
    },
    showBattles: function (id) {
      return $http.get("http://api." + url + '/battles/' + id);
    },
    voteBattle: function (battleId, parameters) {
      return $http.post("http://api." + url + '/battles/' + battleId + '/vote', parameters);
    },
    getMP3musicURL: function(id, parameters) {
      return "http://api." + url + '/musics/get/' + id + urlParametersFormat(parameters);
    },
    getPlaylist: function(id) {
      return $http.get("http://api." + url + '/playlists/' + id);
    },
    findPlaylist: function(parameters) {
      return $http.get("http://api." + url + '/playlists/find' + urlParametersFormat(parameters));
    },
    follow: function(parameters) {
      return $http.post("http://api." + url + "/users/follow", parameters);
    },
    unfollow: function(parameters) {
      return $http.post("http://api." + url + "/users/unfollow", parameters);
    },
    getStats: function() {
      return $http.get("http://artist." + url + "/stats.json");
    },
    getLastComments: function() {
      return $http.get("http://artist." + url + "/comments.json");
    },
    getLastTweets: function() {
      return $http.get("http://artist." + url + "/tweets.json");
    },
    addConcert: function(parameters) {
      return $http.post("http://artist." + url + "/tour/addconcert.json", parameters);
    },
    findMusics: function(parameters) {
      return $http.get("http://api." + url + "/musics/find" + urlParametersFormat(parameters));
    },
    findAlbums: function(parameters) {
      return $http.get("http://api." + url + "/albums/find" + urlParametersFormat(parameters));
    },
    uploadMusic: function (file, parameters, progressFunction, successFunction, errorFunction) {
      Upload.upload({
        url: "http://artist." + url + '/musics/upload.json',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    indexInfluences: function() {
      return $http.get("http://api." + url + "/influences");
    },
    updateMusic: function(parameters) {
      return $http.post("http://artist." + url + "/musics/updateMusic.json", parameters);
    },
    addAlbum: function (file, parameters, progressFunction, successFunction, errorFunction) {
      Upload.upload({
        url: "http://artist." + url + '/musics/createAlbum.json',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    updateAlbum: function (file, parameters, progressFunction, successFunction, errorFunction) {
      Upload.upload({
        url: "http://artist." + url + '/musics/updateAlbum.json',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    getLanguages: function() {
      return $http.get("http://api." + url + "/languages");
    },
    getPropose: function() {
      return $http.get("http://artist." + url + "/musics/getPropose");
    },
    setPropose: function(parameters) {
      return $http.post("http://artist." + url + "/musics/proposeAlbums", parameters);
    },
    indexAmbiances: function() {
      return $http.get("http://api." + url + "/ambiances");
    }
  }
}]);
