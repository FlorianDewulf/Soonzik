using System;
using System.Net;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;
using SoonZik.Helpers;
using SoonZik.ViewModel;
using Tweetinvi;
using Tweetinvi.Core.Credentials;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class TwitterConnect : UserControl
    {
        #region Method

        private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
        }

        #endregion

        #region Attribute

        public static string TwitterKey;
        private readonly string _consumerKey = "ooWEcrlhooUKVOxSgsVNDJ1RK";
        private readonly string _consumerSecret = "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan";
        private readonly string _accessToken = "1951971955-TJuWAfR6awbG9ds1lEh9quuHzqtnx1xlRtORZD2";
        private readonly string _accessTokenSecret = "mrRO5x2p4z0tOGeIwvnw5D6iDplGIFhONL0bGbZpmhYLF";
        private TwitterCredentials _appCredentials;

        #endregion

        #region Ctor

        public TwitterConnect()
        {
            InitializeComponent();
            Loaded += TwitterConnect_Loaded;
        }

        private void TwitterConnect_Loaded(object sender, RoutedEventArgs e)
        {
            _appCredentials = new TwitterCredentials(_consumerKey, _consumerSecret);
            _appCredentials.AccessToken = _accessToken;
            _appCredentials.AccessTokenSecret = _accessTokenSecret;

            var url = CredentialsCreator.GetAuthorizationURL(_appCredentials);
            TwitterWebView.Source = new Uri(url);
            TwitterWebView.LoadCompleted += TwitterWebViewOnLoadCompleted;
        }

        private async void TwitterWebViewOnLoadCompleted(object sender, NavigationEventArgs navigationEventArgs)
        {
            var html = await TwitterWebView.InvokeScriptAsync("eval", new[] {"document.documentElement.outerHTML;"});
            var res = WebUtility.HtmlDecode(html);
            TwitterKey = KeyHelpers.GetTwitterKey(res);
            if (TwitterKey != null)
            {
                Singleton.Singleton.Instance().UserTwitterCredentials =
                    CredentialsCreator.GetCredentialsFromVerifierCode(TwitterKey, _appCredentials);
                ConnexionViewModel.TwitterPopup.IsOpen = false;
            }
        }

        #endregion
    }
}