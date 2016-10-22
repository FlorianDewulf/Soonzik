using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using Windows.UI.Popups;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.HttpRequest.HttpExtensions;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.HttpRequest
{
    public class HttpRequestGet
    {
        #region Attribute

        private const string ApiUrl = "http://soonzikapi.herokuapp.com/";

        #endregion

        #region Method Get

        public async Task<object> FindUser(object myObject, string element)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + "users/find?attribute[username]=" + element);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetListNews(object myObject, string element, string userLan)
        {
            var request = (HttpWebRequest)WebRequest.Create(ApiUrl + element + "?language=" + userLan);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetListObject(object myObject, string element)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + element);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetObject(object myObject, string element, string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + element + "/" + id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetArtist(object myObject, string element, string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + element + "/" + id + "/" + "isartist");
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> Search(object myObject, string element)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + "search?query=" + element);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetUserKey(string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + "getKey/" + id);
            return await DoRequest(request);
        }

        public async Task<object> GetSocialToken(string id, string socialNetwork)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + "getSocialToken/" + id + "/" + socialNetwork);
            return await DoRequest(request);
        }

        public async Task<object> Find(object myObject, string type, string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + type + "/find?attribute[user_id]=" + id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetMusic(string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + "musics/get/" + id);
            return await DoRequest(request);
        }

        public async Task<object> GetFollows(object myObject, string element, string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + element + "/" + id + "/follows");
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetFriends(object myObject, string element, string id)
        {
            var request = (HttpWebRequest) WebRequest.Create(ApiUrl + element + "/" + id + "/friends");
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetListenerAroundMe(object myObject, string lat, string lon, string range)
        {
            var request =
                (HttpWebRequest) WebRequest.Create(ApiUrl + "listenings/around/" + lat + "/" + lon + "/" + range);
            return await DoRequestForObject(myObject, request);
        }

        #endregion

        #region Method Get Secure        
        

        public async Task<object> GetIdentities(object myObject, string id, string sha256)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "users/getIdentities" + "?secureKey=" + sha256 + "&user_id=" + id);
            return await DoRequestForObject(myObject, request);
        }


        public async Task<object> GetSecureNews(object myObject, string element, string id, string sha256,
            User user)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + element + "/" + id + "?secureKey=" + sha256 + "&user_id=" + user.id + "&language=" + user.language);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetListObjectSecure(object myObject, string element, string sha256, string id)
        {
            var request = (HttpWebRequest)WebRequest.Create(ApiUrl + element + "?secureKey=" + sha256 + "&user_id=" + id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetSecureObject(object myObject, string element, string id, string sha256,
            string userId)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + element + "/" + id + "?secureKey=" + sha256 + "&user_id=" + userId);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetAllMusicForUser(object myObj, string sha256, string id)
        {
            var request =
                (HttpWebRequest) WebRequest.Create(ApiUrl + "users/getmusics?secureKey=" + sha256 + "&user_id=" + id);
            return await DoRequestForObject(myObj, request);
        }

        public async Task<object> GetSuggest(object myObject, string type)
        {
            var request =
                (HttpWebRequest) WebRequest.Create(ApiUrl + "suggestv2?type=" + type);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetItemFromCarts(object myObject, string sha256, User myUser)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "carts/my_cart?secureKey=" + sha256 + "&user_id=" + myUser.id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<string> DeleteFromCart(Carts myCart, string sha256, User myUser)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "carts/destroy?id=" + myCart.id + "&secureKey=" + sha256 + "&user_id=" +
                                      myUser.id);
            return await DoRequest(request);
        }

        public async Task<string> DeletePlaylist(Playlist myPlaylist, string sha256, User myUser)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "playlists/destroy?id=" + myPlaylist.id + "&secureKey=" + sha256 +
                                      "&user_id=" + myUser.id);
            return await DoRequest(request);
        }

        public async Task<string> DeleteMusicFromPlaylist(Playlist myPlaylist, Music theMusic, string sha256,
            User myUser)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "musics/delfromplaylist?id=" + theMusic.id + "&playlist_id=" +
                                      myPlaylist.id + "&secureKey=" + sha256 + "&user_id=" + myUser.id);
            return await DoRequest(request);
        }

        public async Task<object> GetConversation(User FriendUser, string sha256, User myUser, object myObject)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "messages/conversation/" + FriendUser.id + "?secureKey=" + sha256 +
                                      "&user_id=" + myUser.id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<string> DestroyLike(string element, string objId, string sha256, string userId)
        {
            var request =
                (HttpWebRequest)
                    WebRequest.Create(ApiUrl + "likes/destroy?like[typeObj]=" + element + "&like[obj_id]=" + objId +
                                      "&secureKey=" + sha256 + "&user_id=" + userId);
            return await DoRequest(request);
        }

        public async Task<object> FindConversation(object myObj, string sha256, string userId)
        {
            var request =
                (HttpWebRequest) WebRequest.Create(ApiUrl + "messages/find?secureKey=" + sha256 + "&user_id=" + userId);
            return await DoRequestForObject(myObj, request);
        }

        #endregion

        #region Method Request

        private static async Task<string> DoRequest(HttpWebRequest request)
        {
            request.Method = HttpMethods.Get;
            request.Accept = "application/json;odata=verbose";
            try
            {
                var response = (HttpWebResponse) await request.GetResponseAsync();
                var streamResponse = response.GetResponseStream();
                string data;
                using (var reader = new StreamReader(streamResponse))
                    data = reader.ReadToEnd();
                return data;
            }
            catch (WebException ex)
            {
                var reader = new StreamReader(ex.Response.GetResponseStream());
                var responseString = reader.ReadToEnd();
                Debug.WriteLine(responseString);
                return responseString;
            }
            return null;
        }

        private static async Task<object> DoRequestForObject(object myObject, HttpWebRequest request)
        {
            request.Method = HttpMethods.Get;
            request.Accept = "application/json;odata=verbose";
            try
            {
                var response = (HttpWebResponse) await request.GetResponseAsync();
                var streamResponse = response.GetResponseStream();
                string data;
                using (var reader = new StreamReader(streamResponse))
                    data = reader.ReadToEnd();
                if (myObject.GetType() == typeof (UserMusic))
                {
                    var stringJson = JObject.Parse(data).SelectToken("content").ToString();
                    stringJson = JObject.Parse(stringJson).SelectToken("musics").ToString();
                    var listMusic = JsonConvert.DeserializeObject(stringJson, new List<Music>().GetType());
                    stringJson = JObject.Parse(data).SelectToken("content").ToString();
                    stringJson = JObject.Parse(stringJson).SelectToken("albums").ToString();
                    var listAlbum = JsonConvert.DeserializeObject(stringJson, new List<Album>().GetType());
                    stringJson = JObject.Parse(data).SelectToken("content").ToString();
                    stringJson = JObject.Parse(stringJson).SelectToken("packs").ToString();
                    var listPack = JsonConvert.DeserializeObject(stringJson, new List<Pack>().GetType());

                    var obj = new UserMusic();
                    obj.ListMusiques = (List<Music>) listMusic;
                    obj.ListPack = (List<Pack>) listPack;
                    obj.ListAlbums = (List<Album>) listAlbum;
                    return obj;
                }
                else
                {
                    var stringJson = JObject.Parse(data).SelectToken("content").ToString();
                    return JsonConvert.DeserializeObject(stringJson, myObject.GetType());
                }
            }
            catch (Exception ex)
            {
                var we = ex.InnerException as WebException;
                if (we != null)
                {
                    new MessageDialog("RespCallback Exception raised! Message:{0}" + we.Message).ShowAsync();
                    Debug.WriteLine("Status:{0}", we.Status);
                }
                else
                    throw;
            }
            return null;
        }

        #endregion
    }
}