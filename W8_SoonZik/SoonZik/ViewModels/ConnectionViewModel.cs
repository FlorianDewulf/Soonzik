using Newtonsoft.Json.Linq;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
using SoonZik.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Newtonsoft.Json;
using Facebook;
using Windows.Security.Authentication.Web;
using System.Dynamic;
using SoonZik.Common;
using Windows.Web.Http.Headers;
using Windows.Storage.Streams;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;

namespace SoonZik.ViewModels
{
    public class ConnectionViewModel : INotifyPropertyChanged
    {
        // FACEBOOK STUFF
        string AppId = "1663237633911112";
        private const string _permissions = "user_about_me";
        FacebookClient _fb = new FacebookClient();

        // CLASSIC STUFF
        private string _mail;
        public string mail
        {
            get { return _mail; }
            set
            {
                _mail = value;
                OnPropertyChanged("mail");
            }
        }

        private string _passwd;
        public string passwd
        {
            get { return _passwd; }
            set
            {
                _passwd = value;
                OnPropertyChanged("passwd");
            }
        }

        //public bool canUpdate
        //{
        //    get
        //    {
        //        if (mail == null && passwd == null)
        //            return false;
        //        return true;
        //    }
        //}

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        // Command bind to the xaml button
        public ICommand do_classic_connection
        {
            get;
            private set;
        }

        public ICommand do_facebook_connection
        {
            get;
            private set;
        }

        public ICommand do_twitter_connection
        {
            get;
            private set;
        }

        public ICommand do_google_connection
        {
            get;
            private set;
        }

        public ConnectionViewModel()
        {
            // Dev only
            mail = "user_four@gmail.com";
            passwd = "azertyuiop";
            do_classic_connection = new ConnectionCommand(this);
            do_facebook_connection = new RelayCommand(facebook_connection);
            do_twitter_connection = new RelayCommand(twitter_connection);
            do_google_connection = new RelayCommand(google_connection);
        }

        // Method called in the ConnectionCommand file
        public async void classic_connection()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                // HTTP_POST -> URL + DATA
                var response = await request.post_request("login", "email=" + mail + "&password=" + passwd);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Success")
                {
                    Get_User(response);
                    //await new MessageDialog("Email = " + mail + "\nPasswd = " + passwd, "Connexion OK").ShowAsync();
                    ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Home));
                }
                else
                    await new MessageDialog("Une erreur de combinaison E-mail/Mot de passe est survenue").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur de connexion au server").ShowAsync();
        }

        async void Get_User(string response)
        {
            Exception exception = null;

            try
            {
                User Current_User = new User();

                var json = JObject.Parse(response).SelectToken("content").ToString();
                Current_User = JsonConvert.DeserializeObject(json, typeof(User)) as User;

                // Singleton CALL
                Singleton.Instance.Current_user = Current_User;
                Singleton.Instance.compare_date = new DateTime();
            }
            catch (Exception e)
            {
                exception = e;
            }
            if (exception != null)
                await new MessageDialog("Erreur lors de la recuperation de l'utilisateur").ShowAsync();
        }

        // FACEBOOK CNX
        public async void facebook_connection()
        {
            var redirectUrl = "https://www.facebook.com/connect/login_success.html";
            try
            {
                //fb.AppId = facebookAppId;
                var loginUrl = _fb.GetLoginUrl(new
                {
                    client_id = AppId,
                    redirect_uri = redirectUrl,
                    scope = _permissions,
                    display = "popup",
                    response_type = "token"
                });

                var endUri = new Uri(redirectUrl);

                WebAuthenticationResult WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
                                                        WebAuthenticationOptions.None,
                                                        loginUrl,
                                                        endUri);
                if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
                {
                    var callbackUri = new Uri(WebAuthenticationResult.ResponseData.ToString());
                    var facebookOAuthResult = _fb.ParseOAuthCallbackUrl(callbackUri);
                    var accessToken = facebookOAuthResult.AccessToken;
                    if (String.IsNullOrEmpty(accessToken))
                    {
                        // User is not logged in, they may have canceled the login
                    }
                    else
                    {
                        // User is logged in and token was returned
                        //
                        //  GOGO SE LOG
                        //
                        facebook_LoginSucceded(accessToken);
                    }

                }
                //else if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
                //{
                //    throw new InvalidOperationException(" CANCEL ?? HTTP Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseErrorDetail.ToString());
                //}
                //else
                //{
                //    // The user canceled the authentication
                //}
            }
            catch (Exception ex)
            {
                //
                // Bad Parameter, SSL/TLS Errors and Network Unavailable errors are to be handled here.
                //
                // throw ex;

                new MessageDialog("Erreur lors de la connexion via Facebook").ShowAsync();

            }
        }
        private async void facebook_LoginSucceded(string accessToken)
        {
            Exception exception = null;

            try
            {


                dynamic parameters = new ExpandoObject();
                parameters.access_token = accessToken;
                parameters.fields = "id";

                dynamic result = await _fb.GetTaskAsync("me", parameters);
                parameters = new ExpandoObject();
                parameters.id = result.id;
                parameters.access_token = accessToken;

                // Store info... useless ??? yeah ...
                //Singleton.Instance.fb_id = result.id;
                //Singleton.Instance.fb_token = accessToken;

                // CALL social login
                social_connection(result.id, accessToken, "facebook");
            }
            catch (Exception e)
            {
                exception = e;
            }
            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la recuperation du profil facebook").ShowAsync();
        }

        // TWITTER CNX
        public async void twitter_connection()
        {
            try
            {
                string oauth_token = await GetTwitterRequestTokenAsync();
                string TwitterUrl = "https://api.twitter.com/oauth/authorize?oauth_token=" + oauth_token;

                System.Uri StartUri = new Uri(TwitterUrl);
                System.Uri EndUri = new Uri("http://MyW8appTwitterCallback.net");

                WebAuthenticationResult WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
                                                        WebAuthenticationOptions.None,
                                                        StartUri,
                                                        EndUri);
                if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
                {
                    // await new MessageDialog(WebAuthenticationResult.ResponseData.ToString()).ShowAsync();
                    await GetTwitterUserNameAsync(WebAuthenticationResult.ResponseData.ToString());

                    //isTwitterUserLoggedIn = true;
                }
                //else if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
                //{
                //    await new MessageDialog("HTTP Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseErrorDetail.ToString()).ShowAsync();
                //}
                //else
                //{
                //    await new MessageDialog("CANCEL ??Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseStatus.ToString()).ShowAsync();
                //}
            }
            catch (Exception Error)
            {
                new MessageDialog("Erreur lors de la connexion via Twitter").ShowAsync();
            }
        }

        private async Task<string> GetTwitterRequestTokenAsync()
        {
            //
            // Acquiring a request token
            //
            try
            {
                string TwitterUrl = "https://api.twitter.com/oauth/request_token";

                string nonce = GetNonce();
                string timeStamp = GetTimeStamp();
                string SigBaseStringParams = "oauth_callback=" + Uri.EscapeDataString("http://MyW8appTwitterCallback.net");
                SigBaseStringParams += "&" + "oauth_consumer_key=" + "ooWEcrlhooUKVOxSgsVNDJ1RK"; // CONSUMER KEY
                SigBaseStringParams += "&" + "oauth_nonce=" + nonce;
                SigBaseStringParams += "&" + "oauth_signature_method=HMAC-SHA1";
                SigBaseStringParams += "&" + "oauth_timestamp=" + timeStamp;
                SigBaseStringParams += "&" + "oauth_version=1.0";
                string SigBaseString = "GET&";
                SigBaseString += Uri.EscapeDataString(TwitterUrl) + "&" + Uri.EscapeDataString(SigBaseStringParams);
                string Signature = GetSignature(SigBaseString, "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan"); // TWITTER SECRET CONSUMER KEY

                TwitterUrl += "?" + SigBaseStringParams + "&oauth_signature=" + Uri.EscapeDataString(Signature);

                Windows.Web.Http.HttpClient httpClient = new Windows.Web.Http.HttpClient();
                string GetResponse = await httpClient.GetStringAsync(new Uri(TwitterUrl));


                string request_token = null;
                string oauth_token_secret = null;
                string[] keyValPairs = GetResponse.Split('&');

                for (int i = 0; i < keyValPairs.Length; i++)
                {
                    string[] splits = keyValPairs[i].Split('=');
                    switch (splits[0])
                    {
                        case "oauth_token":
                            request_token = splits[1];
                            break;
                        case "oauth_token_secret":
                            oauth_token_secret = splits[1];
                            break;
                    }
                }

                return request_token;
            }
            catch (Exception Error)
            {
                new MessageDialog("Erreur lors de la recuperation du profil Twitter").ShowAsync();
                return null;
            }
        }

        private async Task GetTwitterUserNameAsync(string webAuthResultResponseData)
        {
            //
            // Acquiring a access_token first
            //
            try
            {
                string responseData = webAuthResultResponseData.Substring(webAuthResultResponseData.IndexOf("oauth_token"));
                string request_token = null;
                string oauth_verifier = null;
                String[] keyValPairs = responseData.Split('&');

                for (int i = 0; i < keyValPairs.Length; i++)
                {
                    String[] splits = keyValPairs[i].Split('=');
                    switch (splits[0])
                    {
                        case "oauth_token":
                            request_token = splits[1];
                            break;
                        case "oauth_verifier":
                            oauth_verifier = splits[1];
                            break;
                    }
                }

                String TwitterUrl = "https://api.twitter.com/oauth/access_token";

                string timeStamp = GetTimeStamp();
                string nonce = GetNonce();

                String SigBaseStringParams = "oauth_consumer_key=" + "ooWEcrlhooUKVOxSgsVNDJ1RK";
                SigBaseStringParams += "&" + "oauth_nonce=" + nonce;
                SigBaseStringParams += "&" + "oauth_signature_method=HMAC-SHA1";
                SigBaseStringParams += "&" + "oauth_timestamp=" + timeStamp;
                SigBaseStringParams += "&" + "oauth_token=" + request_token;
                SigBaseStringParams += "&" + "oauth_version=1.0";
                String SigBaseString = "POST&";
                SigBaseString += Uri.EscapeDataString(TwitterUrl) + "&" + Uri.EscapeDataString(SigBaseStringParams);

                String Signature = GetSignature(SigBaseString, "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan");

                Windows.Web.Http.HttpStringContent httpContent = new Windows.Web.Http.HttpStringContent("oauth_verifier=" + oauth_verifier, Windows.Storage.Streams.UnicodeEncoding.Utf8);
                httpContent.Headers.ContentType = HttpMediaTypeHeaderValue.Parse("application/x-www-form-urlencoded");
                string authorizationHeaderParams = "oauth_consumer_key=\"" + "ooWEcrlhooUKVOxSgsVNDJ1RK" + "\", oauth_nonce=\"" + nonce + "\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"" + Uri.EscapeDataString(Signature) + "\", oauth_timestamp=\"" + timeStamp + "\", oauth_token=\"" + Uri.EscapeDataString(request_token) + "\", oauth_version=\"1.0\"";

                Windows.Web.Http.HttpClient httpClient = new Windows.Web.Http.HttpClient();

                httpClient.DefaultRequestHeaders.Authorization = new HttpCredentialsHeaderValue("OAuth", authorizationHeaderParams);
                var httpResponseMessage = await httpClient.PostAsync(new Uri(TwitterUrl), httpContent);
                string response = await httpResponseMessage.Content.ReadAsStringAsync();

                String[] Tokens = response.Split('&');
                string oauth_token_secret = null;
                string access_token = null;
                string screen_name = null;
                string user_id = null;

                for (int i = 0; i < Tokens.Length; i++)
                {
                    String[] splits = Tokens[i].Split('=');
                    switch (splits[0])
                    {
                        case "screen_name":
                            screen_name = splits[1];
                            break;
                        case "oauth_token":
                            access_token = splits[1];
                            break;
                        case "oauth_token_secret":
                            oauth_token_secret = splits[1];
                            break;
                        case "user_id":
                            user_id = splits[1];
                            break;
                    }
                }

                // Check if everything is fine AND do_SOCIAL__CNX
                if (user_id != null && access_token != null && oauth_token_secret != null)
                {
                    social_connection(user_id, oauth_token_secret, "twitter");
                }
            }
            catch (Exception Error)
            {
                new MessageDialog("Erreur lors de la recuperation du token Twitter").ShowAsync();
            }
        }

        string GetNonce()
        {
            Random rand = new Random();
            int nonce = rand.Next(1000000000);
            return nonce.ToString();
        }
        string GetTimeStamp()
        {
            TimeSpan SinceEpoch = DateTime.UtcNow - new DateTime(1970, 1, 1);
            return Math.Round(SinceEpoch.TotalSeconds).ToString();
        }
        string GetSignature(string sigBaseString, string consumerSecretKey)
        {
            IBuffer KeyMaterial = CryptographicBuffer.ConvertStringToBinary(consumerSecretKey + "&", BinaryStringEncoding.Utf8);
            MacAlgorithmProvider HmacSha1Provider = MacAlgorithmProvider.OpenAlgorithm("HMAC_SHA1");
            CryptographicKey MacKey = HmacSha1Provider.CreateKey(KeyMaterial);
            IBuffer DataToBeSigned = CryptographicBuffer.ConvertStringToBinary(sigBaseString, BinaryStringEncoding.Utf8);
            IBuffer SignatureBuffer = CryptographicEngine.Sign(MacKey, DataToBeSigned);
            string Signature = CryptographicBuffer.EncodeToBase64String(SignatureBuffer);

            return Signature;
        }


        // GOOGLE CNX
        public async void google_connection()
        {
            //await new MessageDialog("Pas disponible. Soon :)").ShowAsync();
            
            try
            {
                // flo : 793685873206-mtbd8bm2gvskccm5rnnnkod5n6q7dqpv.apps.googleusercontent.com
                // mine : 621183634756-adm22vpl7587nt652ar0o7i8vpersme2.apps.googleusercontent.com

                // mine bis : 621183634756-adm22vpl7587nt652ar0o7i8vpersme2.apps.googleusercontent.com

                //String GoogleURL = "https://accounts.google.com/o/oauth2/auth?client_id=" + Uri.EscapeDataString("621183634756-adm22vpl7587nt652ar0o7i8vpersme2.apps.googleusercontent.com") + "&redirect_uri=" + Uri.EscapeDataString("http://MyCallBackUrlSoonzik.com") + "&response_type=code&scope=" + Uri.EscapeDataString("http://picasaweb.google.com/data");

                //String GoogleURL = "https://accounts.google.com/o/oauth2/auth?client_id=" + Uri.EscapeDataString("793685873206-mtbd8bm2gvskccm5rnnnkod5n6q7dqpv.apps.googleusercontent.com") + "&redirect_uri=" + Uri.EscapeDataString("http://MyCallBackUrlSoonzik.com") + "&response_type=code&scope=" + Uri.EscapeDataString("http://picasaweb.google.com/data");
                String GoogleURL = "https://accounts.google.com/o/oauth2/auth?client_id=" + Uri.EscapeDataString("621183634756-adm22vpl7587nt652ar0o7i8vpersme2.apps.googleusercontent.com") + "&redirect_uri=" + Uri.EscapeDataString("http://MyCallBackUrlSoonzik.com") + "&response_type=code&scope=" + Uri.EscapeDataString("http://picasaweb.google.com/data");

                System.Uri StartUri = new Uri(GoogleURL);
                // When using the desktop flow, the success code is displayed in the html title of this end uri
                System.Uri EndUri = new Uri("https://accounts.google.com/o/oauth2/approval?");



                WebAuthenticationResult WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
                                                        WebAuthenticationOptions.UseTitle,
                                                        StartUri,
                                                        EndUri);
                if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
                {
                    await new MessageDialog("YES").ShowAsync();

                    // GO FOR IT
                    //OutputToken(WebAuthenticationResult.ResponseData.ToString());
                }
                else if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
                {
                    await new MessageDialog("NO OR CANCEL").ShowAsync();

                    //OutputToken("HTTP Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseErrorDetail.ToString());
                }
                else
                {
                    await new MessageDialog("ERROR").ShowAsync();

                    //OutputToken("Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseStatus.ToString());
                }

            }
            catch
            {
                new MessageDialog("ERROR catch").ShowAsync();
            }
            // App id client
            // 621183634756-adm22vpl7587nt652ar0o7i8vpersme2.apps.googleusercontent.com

        }
        // SOCIAL LOGIN
        public async void social_connection(string id, string token, string sn)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string social_token = await Security.getSocialToken(id, sn);
                string encrypted_key = Security.getSocialSecureKey(id, social_token);

                var response = await request.post_request("social-login", "uid=" + id + "&provider=" + sn + "&encrypted_key=" + encrypted_key + "&token=" + token);
                var json = JObject.Parse(response).SelectToken("content");

                if (json.ToString() != null)
                {
                    Get_User(response);
                    ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Home));
                }
                else
                    await new MessageDialog("Erreur lors de la verification de la connexion").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur de connexion via le reseau social").ShowAsync();
        }
    }
}
