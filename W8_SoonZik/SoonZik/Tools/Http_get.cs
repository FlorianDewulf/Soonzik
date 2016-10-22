using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;
using SoonZik.Models;

namespace SoonZik.Tools
{
    public class Http_get
    {
        static string url = Singleton.Instance.url;
        //public static string url = "http://api.lvh.me:3000/";

        public static async Task<User> get_user_by_username(string username)
        {
            var user = (User)await get_object_find(new User(), "users/find?attribute[username]=" + username);
            return user;
        }

        public static async Task<User> get_user_by_id(string id)
        {
            var user = (User)await get_object(new User(), "users/" + id);
            return user;
        }

        public static async Task<Genre> get_genre_by_id(int id)
        {
            var genre = (Genre)await get_object(new Genre(), "genres/" + id.ToString());
            return genre;
        }

        public static async Task<Pack> get_pack_by_id(int id)
        {
            var pack = (Pack)await get_object(new Pack(), "packs/" + id.ToString());
            return pack;
        }

        public static async Task<News> get_news_by_id(int id)
        {
            var news = (News)await get_object(new News(), "news/" + id.ToString() + "?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));
            return news;
        }

        public static async Task<News> get_news_by_id_and_language(int id, string language)
        {
            var news = (News)await get_object(new News(), "news/" + id.ToString() + "?language=" + language + "&user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));
            return news;
        }

        public static async Task<Album> get_album_by_id(int id)
        {
            var album = (Album)await get_object(new Album(), "albums/" + id.ToString() +  "?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));
            return album;
        }

        public static async Task<Ambiance> get_ambiance_by_id(int id)
        {
            var ambiance = (Ambiance)await get_object(new Ambiance(), "ambiances/" + id.ToString());
            return ambiance;
        }

        public static async Task<Music> get_music_by_id(int id)
        {
            var music = (Music)await get_object(new Music(), "musics/" + id.ToString());
            return music;
        }
        
        // THIS FUNC DO NOT DESERIALIZE (used to destroycart fyi)
        public static async Task<string> get_data(string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("code").ToString();
                // if success: code=202
                return json;
            }
            catch (WebException ex)
            {
                exception = ex;
            }

            // A VIRER
            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur de suppression").ShowAsync();
            // A VIRER
            return null;
        }

        public static async Task<string> get_note(string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();
                return json;
            }
            catch (WebException ex)
            {
                exception = ex;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de la note").ShowAsync();
            return null;
        }


        // DESERIALIZE AND EVERYTHING
        public static async Task<object> get_object(object Object, string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();
                if (json != "{}") // for the cart
                    return JsonConvert.DeserializeObject(json, Object.GetType());
                return null;
            }
            catch (WebException ex)
            {
                exception = ex;
            }

            // A VIRER
            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de données").ShowAsync();
            // ---
            return null;
        }

        public static async Task<object> get_search_result(object Object, string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();

                if (json == "[]")
                {
                    await new MessageDialog("Rien ne correspond à votre recherche").ShowAsync();
                    return null;
                }
                return JsonConvert.DeserializeObject(json, Object.GetType());
                

            }
            catch (WebException ex)
            {
                exception = ex;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la recherche").ShowAsync();
            return null;
        }

        // COPY PASTE CAUSE FIND GIVES ME AN ARAY OF USER AND ITS NO GOOD
        public static async Task<object> get_object_find(object Object, string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();

                // Substring json to remove [ and ] (Array)
                return JsonConvert.DeserializeObject(json.Substring(1, json.Length - 2), Object.GetType());
            }
            catch (WebException ex)
            {
                exception = ex;
            }

            //if (exception != null)
            //    await new MessageDialog(exception.Message, "Get Object Error").ShowAsync();
            return null;
        }
    }
}
