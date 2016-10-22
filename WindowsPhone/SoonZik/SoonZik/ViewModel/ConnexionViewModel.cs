using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Activation;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.Security.Authentication.Web;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;
using Windows.Storage;
using Windows.Storage.Streams;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Imaging;
using Windows.Web.Http;
using Windows.Web.Http.Headers;
using Facebook;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Microsoft.Practices.ServiceLocation;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using Tweetinvi.Core.Credentials;

namespace SoonZik.ViewModel
{
    public class ConnexionViewModel : ViewModelBase, IWebAuthenticationBrokerContinuable
    {
        #region Attribute

        public ResourceLoader loader; 
        private readonly string _consumerKey = "ooWEcrlhooUKVOxSgsVNDJ1RK";
        private const string ConsumerSecret = "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan";
        private readonly string _accessToken = "1951971955-TJuWAfR6awbG9ds1lEh9quuHzqtnx1xlRtORZD2";
        private readonly string _accessTokenSecret = "mrRO5x2p4z0tOGeIwvnw5D6iDplGIFhONL0bGbZpmhYLF";
        public static Popup TwitterPopup;
        private readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;
        private readonly FaceBookHelper ObjFBHelper = new FaceBookHelper();
        private FacebookClient fbclient = new FacebookClient();
        private bool _progressOn;

        public bool ProgressOn
        {
            get { return _progressOn; }
            set
            {
                _progressOn = value;
                RaisePropertyChanged("ProgressOn");
            }
        }

        private string _username;

        public string Username
        {
            get { return _username; }
            set
            {
                _username = value;
                RaisePropertyChanged("Username");
            }
        }

        private string _password;

        public string Password
        {
            get { return _password; }
            set
            {
                _password = value;
                RaisePropertyChanged("Password");
            }
        }

        public ICommand SelectionCommand { get; private set; }
        public ICommand ConnexionCommand { get; private set; }
        public ICommand InscritpiomCommand { get; private set; }
        public ICommand FacebookTapped { get; private set; }
        public ICommand TwitterTapped { get; private set; }
        public ICommand GoogleTapped { get; private set; }
        public INavigationService Navigation;

        #endregion

        #region Ctor

        public ConnexionViewModel()
        {
            loader = new ResourceLoader();
            ProgressOn = false;
            Singleton.Singleton.Instance().SelectedMusicSingleton = new ObservableCollection<Music>();
            Navigation = new NavigationService();
            ConnexionCommand = new RelayCommand(MakeConnexion);
            FacebookTapped = new RelayCommand(MakeFacebookConnection);
            SelectionCommand = new RelayCommand(SelectionExecute);
            InscritpiomCommand = new RelayCommand(ExecuteInscription);
            TwitterTapped = new RelayCommand(TwitterCommandExecute);
            GoogleTapped = new RelayCommand(GoogleTappedExecute);
            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                _password = _localSettings.Values["SoonZikPassWord"].ToString();
                _username = _localSettings.Values["SoonZikUserName"].ToString();
            }
            Network.InternetConnectionChanged += NetworkOnInternetConnectionChanged;
        }

        private void ExecuteInscription()
        {
            Navigation.Navigate(new InscriptionView().GetType());
        }

        #endregion

        #region Method

        private void SelectionExecute()
        {
        }

        private void NetworkOnInternetConnectionChanged(object sender,
            InternetConnectionChangedEventArgs internetConnectionChangedEventArgs)
        {
            if (!Network.IsConnected)
            {
            }
        }

        private async void MakeConnexion()
        {
            var dispatcher = CoreApplication.MainView.CoreWindow.Dispatcher;

            await dispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                if (_username != null && _password != null)
                {
                    ProgressOn = true;
                    var connec = new HttpRequestPost();
                    await connec.ConnexionSimple(_username, _password);
                    var res = connec.Received;
                    GetUser(res);
                }
                else
                {
                    new MessageDialog(loader.GetString("InfosConec")).ShowAsync();
                }
            });
        }

        private void GetUser(string res)
        {
            if (res != null)
            {
                try
                {
                    var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                    Singleton.Singleton.Instance().CurrentUser =
                        JsonConvert.DeserializeObject(stringJson, typeof (User)) as User;
                    Singleton.Singleton.Instance().CurrentUser.profilImage =
                        new BitmapImage(new Uri(
                            Constant.UrlImageUser + Singleton.Singleton.Instance().CurrentUser.image,
                            UriKind.RelativeOrAbsolute));
                    foreach (var friend in Singleton.Singleton.Instance().CurrentUser.friends)
                    {
                        friend.profilImage =
                            new BitmapImage(new Uri(Constant.UrlImageUser + friend.image, UriKind.RelativeOrAbsolute));
                    }
                    ValidateKey.GetValideKey();
                    ServiceLocator.Current.GetInstance<MyNetworkViewModel>().UpdateFriend();
                }
                catch (Exception e)
                {
                    new MessageDialog(loader.GetString("ErrorConnec") + e).ShowAsync();
                    ProgressOn = false;
                }
                ValidateKey.GetValideKey();
                WriteInformation();
                Navigation.Navigate(typeof (MainView));
                ProgressOn = false;
            }
            else
            {
                new MessageDialog(loader.GetString("ErrorSignal")).ShowAsync();
                ProgressOn = false;
            }
        }

        private void WriteInformation()
        {
            _localSettings.Values["SoonZikUserName"] = _username;
            _localSettings.Values["SoonZikPassWord"] = _password;
            _localSettings.Values["SoonZikAlreadyConnect"] = "yes";
        }

        private async void MakeFacebookConnection()
        {
            ObjFBHelper.LoginAndContinue();
        }

        private void TwitterCommandExecute()
        {
            twitter_connection();
        }

        private void GoogleTappedExecute()
        {
        }

        public async void ContinueWithWebAuthenticationBroker(WebAuthenticationBrokerContinuationEventArgs args)
        {
            ProgressOn = true;
            ObjFBHelper.ContinueAuthentication(args);
            if (ObjFBHelper.AccessToken != null)
            {
                fbclient = new FacebookClient(ObjFBHelper.AccessToken);
                Singleton.Singleton.Instance().MyFacebookClient = new FacebookClient(ObjFBHelper.AccessToken);

                dynamic result = await fbclient.GetTaskAsync("me");
                string id = result.id;

                var connecionSocial = new HttpRequestPost();
                var getKey = new HttpRequestGet();

                var key = await getKey.GetSocialToken(id, "facebook") as string;
                char[] delimiter = {' ', '"', '{', '}'};
                var word = key.Split(delimiter);
                var stringEncrypt = (id + word[4] + "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E");
                var sha256 = EncriptSha256.EncriptStringToSha256(stringEncrypt);

                await connecionSocial.ConnexionSocial("facebook", sha256, ObjFBHelper.AccessToken, id);
                var res = connecionSocial.Received;
                GetUser(res);
            }
        }

        #endregion

        #region Twitter Connect

        public async void twitter_connection()
        {
            try
            {
                var oauth_token = await GetTwitterRequestTokenAsync();
                var TwitterUrl = "https://api.twitter.com/oauth/authorize?oauth_token=" + oauth_token;

                var StartUri = new Uri(TwitterUrl);
                var EndUri = new Uri("http://MyW8appTwitterCallback.net");

                var WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
                    WebAuthenticationOptions.None,
                    StartUri,
                    EndUri);
                if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
                {
                    // await new MessageDialog(WebAuthenticationResult.ResponseData.ToString()).ShowAsync();
                    await GetTwitterUserNameAsync(WebAuthenticationResult.ResponseData);

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
                new MessageDialog(loader.GetString("ErrorTwitter")).ShowAsync();
            }
        }

        private async Task<string> GetTwitterRequestTokenAsync()
        {
            //
            // Acquiring a request token
            //
            var TwitterUrl = "https://api.twitter.com/oauth/request_token";

            var nonce = GetNonce();
            var timeStamp = GetTimeStamp();
            var SigBaseStringParams = "oauth_callback=" + Uri.EscapeDataString("http://MyW8appTwitterCallback.net");
            SigBaseStringParams += "&" + "oauth_consumer_key=" + "ooWEcrlhooUKVOxSgsVNDJ1RK"; // CONSUMER KEY
            SigBaseStringParams += "&" + "oauth_nonce=" + nonce;
            SigBaseStringParams += "&" + "oauth_signature_method=HMAC-SHA1";
            SigBaseStringParams += "&" + "oauth_timestamp=" + timeStamp;
            SigBaseStringParams += "&" + "oauth_version=1.0";
            var SigBaseString = "GET&";
            SigBaseString += Uri.EscapeDataString(TwitterUrl) + "&" + Uri.EscapeDataString(SigBaseStringParams);
            var Signature = GetSignature(SigBaseString, "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan");
            // TWITTER SECRET CONSUMER KEY

            TwitterUrl += "?" + SigBaseStringParams + "&oauth_signature=" + Uri.EscapeDataString(Signature);

            var httpClient = new HttpClient();
            var GetResponse = await httpClient.GetStringAsync(new Uri(TwitterUrl));


            string request_token = null;
            string oauth_token_secret = null;
            var keyValPairs = GetResponse.Split('&');

            for (var i = 0; i < keyValPairs.Length; i++)
            {
                var splits = keyValPairs[i].Split('=');
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

        private async Task GetTwitterUserNameAsync(string webAuthResultResponseData)
        {
            TwitterCredentials _appCredentials;
            //
            // Acquiring a access_token first
            //
            _appCredentials = new TwitterCredentials(_consumerKey, ConsumerSecret);
            _appCredentials.AccessToken = _accessToken;
            _appCredentials.AccessTokenSecret = _accessTokenSecret;
            var responseData = webAuthResultResponseData.Substring(webAuthResultResponseData.IndexOf("oauth_token"));
            string request_token = null;
            string oauth_verifier = null;
            var keyValPairs = responseData.Split('&');

            for (var i = 0; i < keyValPairs.Length; i++)
            {
                var splits = keyValPairs[i].Split('=');
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

            var TwitterUrl = "https://api.twitter.com/oauth/access_token";

            var timeStamp = GetTimeStamp();
            var nonce = GetNonce();

            var SigBaseStringParams = "oauth_consumer_key=" + "ooWEcrlhooUKVOxSgsVNDJ1RK";
            SigBaseStringParams += "&" + "oauth_nonce=" + nonce;
            SigBaseStringParams += "&" + "oauth_signature_method=HMAC-SHA1";
            SigBaseStringParams += "&" + "oauth_timestamp=" + timeStamp;
            SigBaseStringParams += "&" + "oauth_token=" + request_token;
            SigBaseStringParams += "&" + "oauth_version=1.0";
            var SigBaseString = "POST&";
            SigBaseString += Uri.EscapeDataString(TwitterUrl) + "&" + Uri.EscapeDataString(SigBaseStringParams);

            var Signature = GetSignature(SigBaseString, "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan");

            var httpContent = new HttpStringContent("oauth_verifier=" + oauth_verifier, UnicodeEncoding.Utf8);
            httpContent.Headers.ContentType = HttpMediaTypeHeaderValue.Parse("application/x-www-form-urlencoded");
            var authorizationHeaderParams = "oauth_consumer_key=\"" + "ooWEcrlhooUKVOxSgsVNDJ1RK" + "\", oauth_nonce=\"" +
                                            nonce + "\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"" +
                                            Uri.EscapeDataString(Signature) + "\", oauth_timestamp=\"" + timeStamp +
                                            "\", oauth_token=\"" + Uri.EscapeDataString(request_token) +
                                            "\", oauth_version=\"1.0\"";

            var httpClient = new HttpClient();

            httpClient.DefaultRequestHeaders.Authorization = new HttpCredentialsHeaderValue("OAuth",
                authorizationHeaderParams);
            var httpResponseMessage = await httpClient.PostAsync(new Uri(TwitterUrl), httpContent);
            var response = await httpResponseMessage.Content.ReadAsStringAsync();

            var Tokens = response.Split('&');
            string oauth_token_secret = null;
            string access_token = null;
            string screen_name = null;
            string user_id = null;

            for (var i = 0; i < Tokens.Length; i++)
            {
                var splits = Tokens[i].Split('=');
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
                var connec = new HttpRequestPost();
                var getKey = new HttpRequestGet();

                var key = await getKey.GetSocialToken(user_id, "twitter") as string;
                char[] delimiter = {' ', '"', '{', '}'};
                var word = key.Split(delimiter);
                var stringEncrypt = (user_id + word[4] + "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E");
                var sha256 = EncriptSha256.EncriptStringToSha256(stringEncrypt);
                await connec.ConnexionSocial("twitter", sha256, oauth_token_secret, user_id);
                var res = connec.Received;
                GetUser(res);
            }
        }

        private string GetNonce()
        {
            var rand = new Random();
            var nonce = rand.Next(1000000000);
            return nonce.ToString();
        }

        private string GetTimeStamp()
        {
            var SinceEpoch = DateTime.UtcNow - new DateTime(1970, 1, 1);
            return Math.Round(SinceEpoch.TotalSeconds).ToString();
        }

        private string GetSignature(string sigBaseString, string consumerSecretKey)
        {
            var KeyMaterial = CryptographicBuffer.ConvertStringToBinary(consumerSecretKey + "&",
                BinaryStringEncoding.Utf8);
            var HmacSha1Provider = MacAlgorithmProvider.OpenAlgorithm("HMAC_SHA1");
            var MacKey = HmacSha1Provider.CreateKey(KeyMaterial);
            var DataToBeSigned = CryptographicBuffer.ConvertStringToBinary(sigBaseString, BinaryStringEncoding.Utf8);
            var SignatureBuffer = CryptographicEngine.Sign(MacKey, DataToBeSigned);
            var Signature = CryptographicBuffer.EncodeToBase64String(SignatureBuffer);

            return Signature;
        }

        #endregion
    }
}