SoonzikApp.factory('HTTPService', ['$http', '$location', 'Upload', function ($http, $location, Upload) {

  var url = "http://lvh.me:3000"
	var api_url = "http://api.lvh.me:3000"

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
      return $http.get(api_url + '/messages/conversation/' + user_id + urlParametersFormat(parameters));
    },
    getProfile: function (user_id, parameters) {
      return $http.get(api_url + '/users/' + user_id + urlParametersFormat(parameters));
    },
    getFullProfile: function (user_id) { 
      return $http.get(url + '/users/' + user_id + '/edit.json');
    },
    getFriends: function (user_id, parameters) {
    	return $http.get(api_url + '/users/' + user_id + '/friends' + urlParametersFormat(parameters))
    },
    getFollowers: function (user_id, parameters) {
      return $http.get(api_url + '/users/' + user_id + '/followers' + urlParametersFormat(parameters))
    },
    getFollows: function (user_id, parameters) {  
      return $http.get(api_url + '/users/' + user_id + '/follows' + urlParametersFormat(parameters))
    },
    isArtist: function (user_id, parameters) {  
    	return $http.get(api_url + '/users/' + user_id + '/isartist' + urlParametersFormat(parameters))
    },
    updateUser: function (parameters) {
      return $http.post(api_url + '/users/update', parameters)
    },
    uploadProfileImage: function (file, parameters, progressFunction, successFunction, errorFunction) {
      parameters.type = "image";
      Upload.upload({
        url: api_url + '/users/upload',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    uploadBackgroundImage: function (file, parameters, progressFunction, successFunction, errorFunction) {
      parameters.type = "background";
      Upload.upload({
        url: api_url + '/users/upload',
        fields: parameters,
        file: file
      }).progress(progressFunction)
      .success(successFunction)
      .error(errorFunction);
    },
    indexPacks: function(parameters) {
      return $http.get(api_url + '/packs' + urlParametersFormat(parameters));
    },
    findPacks: function (parameters) {
      return $http.get(api_url + '/packs/find' + urlParametersFormat(parameters));
    },
    showPack: function(id, parameters) {  
      return $http.get(api_url + '/packs/' + id + urlParametersFormat(parameters))
    },
    indexNews: function(parameters) {
      return $http.get(api_url + '/news' + urlParametersFormat(parameters));
    },
    findNews: function(parameters) {
      return $http.get(api_url + '/news/find' + urlParametersFormat(parameters));
    },
    showNews: function(id, parameters) {  
      return $http.get(api_url + '/news/' + id + urlParametersFormat(parameters))
    },
    showComment: function(newsId, parameters) {
      return $http.get(api_url + '/news/' + newsId + '/comments' + urlParametersFormat(parameters));
    },
    addComment: function(id, parameters) {
      return $http.post(api_url + '/news/addcomment/' + id, parameters);
    },
    findBattles: function (parameters) {
      return $http.get(api_url + '/battles/find' + urlParametersFormat(parameters));
    },
    indexBattles: function (parameters) {
      return $http.get(api_url + '/battles' + urlParametersFormat(parameters));
    },
    showBattles: function (id, parameters) {  
      return $http.get(api_url + '/battles/' + id + urlParametersFormat(parameters));
    },
    voteBattle: function (battleId, parameters) {
      return $http.post(api_url + '/battles/' + battleId + '/vote', parameters);
    },
    getMP3musicURL: function(id, parameters) {
      return api_url + '/musics/get/' + id + urlParametersFormat(parameters);
    },
    getPlaylist: function(id, parameters) { 
      return $http.get(api_url + '/playlists/' + id + urlParametersFormat(parameters));
    },
    findPlaylist: function(parameters) {
      return $http.get(api_url + '/playlists/find' + urlParametersFormat(parameters));
    },
    destroyPlaylist: function(parameters) {
      return $http.get(api_url + "/playlists/destroy" + urlParametersFormat(parameters));
    },
    deleteFromPlaylist: function(parameters) {
      return $http.get(api_url + "/musics/delfromplaylist" + urlParametersFormat(parameters));
    },
    follow: function(parameters) {
      return $http.post(api_url + "/users/follow", parameters);
    },
    unfollow: function(parameters) {
      return $http.post(api_url + "/users/unfollow", parameters);
    },
    getMusic: function(id, parameters) {  
      return $http.get(api_url + "/musics/" + id + urlParametersFormat(parameters));
    },
    savePlaylist: function(parameters) {
      return $http.post(api_url + "/playlists/save", parameters);
    },
    addToPlaylist: function(parameters) {
      return $http.post(api_url + "/musics/addtoplaylist", parameters);
    },
    getListeningAround: function(lat, lng, range, parameters) {
      return $http.get(api_url + "/listenings/around/" + lat.toFixed(3) + "/" + lng.toFixed(3) + "/" + Math.round(range) + urlParametersFormat(parameters));     
    },
    addListening: function(parameters) {
      return $http.post(api_url + "/listenings/save", parameters);
    },
    search: function(parameters) {
      return $http.get(api_url + "/search" + urlParametersFormat(parameters));
    },
    getAmbiances: function(parameters) { 
      return $http.get(api_url + "/ambiances" + urlParametersFormat(parameters));
    },
    getAmbiance: function(id, parameters) { 
      return $http.get(api_url + "/ambiances/" + id + urlParametersFormat(parameters));
    },
    getInfluences: function(parameters) { 
      return $http.get(api_url + "/influences" + urlParametersFormat(parameters));
    },
    getGenre: function(id, parameters) {
      return $http.get(api_url + "/genres/" + id + urlParametersFormat(parameters));
    },
    findTweet: function(parameters) {
      return $http.get(api_url + "/tweets/find" + urlParametersFormat(parameters));
    },
    saveTweet: function(parameters) {
      return $http.post(api_url + "/tweets/save", parameters);
    },
    getMusicNotes: function(parameters) {
      return $http.get(api_url + "/musics/getNotes" + urlParametersFormat(parameters));
    },
    setMusicNote: function(id, note, parameters) {
      return $http.post(api_url + "/musics/" + id + "/note/" + note, parameters);
    },
    getAlbum: function(id, parameters) {  
      return $http.get(api_url + "/albums/" + id + urlParametersFormat(parameters));
    },
    linkSocial: function(parameters) {
      return $http.post(api_url + "/users/linkSocial", parameters);
    },
    getIdentities: function(parameters) {
      return $http.get(api_url + "/users/getIdentities" + urlParametersFormat(parameters))
    },
    getAlbumComments: function(id, parameters) {
      return $http.get(api_url + "/albums/" + id + "/comments" + urlParametersFormat(parameters))
    },
    addAlbumComment: function(id, parameters) {
      return $http.post(api_url + '/albums/addcomment/' + id, parameters);
    },
    findNotif: function(parameters) {
      return $http.get(api_url + "/notifications/find" + urlParametersFormat(parameters));
    },
    readNotif: function(id, parameters) {
      return $http.post(api_url + "/notifications/" + id + "/read", parameters);
    },
    friend: function(parameters) {
      return $http.post(api_url + "/users/addfriend", parameters);
    },
    unfriend: function(parameters) {
      return $http.post(api_url + "/users/delfriend", parameters);
    },
    getCart: function(id, parameters) {
      return $http.get(api_url + "/carts/"+ id, parameters);
    },
    showCart: function(parameters) {
      return $http.get(api_url + "/carts/my_cart/" + urlParametersFormat(parameters));
    },
    addToCart: function(parameters) {
      return $http.post(api_url + "/carts/save", parameters);
    },
    destroyItem: function(parameters) {
      return $http.get(api_url + "/carts/destroy/" + urlParametersFormat(parameters));
    },
    buyCart: function(parameters) {
      return $http.post(api_url + "/purchases/buycart/", parameters);
    },
    savePack: function(parameters) {
      return $http.post(api_url + "/purchases/buycart", parameters);
    },
    getConcerts: function(parameters) {
      return $http.get(api_url + "/concerts" + urlParametersFormat(parameters))
    },
    findConcerts: function(parameters) {
      return $http.get(api_url + "/concerts/find" + urlParametersFormat(parameters))
    },
    getMyMusic: function(parameters) {
      return $http.get(api_url + "/users/getmusics" + urlParametersFormat(parameters))
    },
    getFlux: function(parameters) {
      return $http.get(api_url + "/tweets/flux" + urlParametersFormat(parameters));
    },
    getSuggestion: function(parameters) {
      return $http.get(api_url + "/suggest" + urlParametersFormat(parameters))
    },
    likeResource: function(parameters) {
      return $http.post(api_url + "/likes/save", parameters);
    },
    removeLike: function(parameters) {
      return $http.get(api_url + "/likes/destroy" + urlParametersFormat(parameters));
    },
    addFeedback: function(parameters) {
      return $http.post(api_url + "/feedbacks/save", parameters);
    },
    postMusicalPast: function(parameters) {
      return $http.post(api_url + '/musicalPast', parameters)
    },
    getCoordination: function(address) {
      return $http.get('http://maps.google.com/maps/api/geocode/json?address=' + encodeURIComponent(address) + '&sensor=false')
    }
  }
}]);
