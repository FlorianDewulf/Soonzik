using System.Collections.ObjectModel;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Facebook;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using Tweetinvi.Core.Credentials;

namespace SoonZik.Singleton
{
    public sealed class Singleton
    {
        #region Ctor

        protected internal Singleton()
        {
        }

        #endregion

        #region Method

        public void Charge()
        {
            var request = new HttpRequestGet();

            var test = request.GetObject(new User(), "users", Instance().NewProfilUser.ToString());
            test.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as User;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { SelectedUser = res; });
                }
            });
        }

        #endregion

        #region Attribute

        private static Singleton _instance;

        public static Singleton Instance()
        {
            if (_instance == null)
            {
                _instance = new Singleton();
            }
            return _instance;
        }

        public User CurrentUser { get; set; }

        public User SelectedUser { get; set; }

        public bool ItsMe { get; set; }

        public int NewProfilUser { get; set; }

        public UIElement LastElement { get; set; }

        public ObservableCollection<Music> SelectedMusicSingleton { get; set; }

        public FacebookClient MyFacebookClient { get; set; }

        public ITwitterCredentials UserTwitterCredentials { get; set; }

        public Key Key { get; set; }

        public string SecureKey { get; set; }

        #endregion
    }
}