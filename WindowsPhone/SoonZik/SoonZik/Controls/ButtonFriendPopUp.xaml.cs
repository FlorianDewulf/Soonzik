using System.Collections.Generic;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Microsoft.Practices.ServiceLocation;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class ButtonFriendPopUp : UserControl
    {
        #region ctor

        public ButtonFriendPopUp(int Id)
        {
            InitializeComponent();
            Navigation = new NavigationService();
            Friend = Id;

            GetUser();
        }

        #endregion

        #region Attribute

        public int Friend;
        private User TheUser { get; set; }
        public INavigationService Navigation;

        #endregion

        #region Method

        private void GetUser()
        {
            var request = new HttpRequestGet();
            var res = request.GetObject(new User(), "users", Friend.ToString());
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var user = tmp.Result as User;
                if (user != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            TheUser = user;
                            if (user.groups.Count > 0)
                            {
                                if (user.groups[0].name == "User")
                                    ProfilFriendViewModel.UserFromButton = user;
                                else if (user.groups[0].name == "Artist")
                                    ProfilArtisteViewModel.TheUser = user;
                            }
                            else
                            {
                                ProfilFriendViewModel.UserFromButton = user;
                            }
                        });
                }
            });
        }

        private void SendMessage(object sender, RoutedEventArgs e)
        {
            ConversationViewModel.NewUser = TheUser;
            GlobalMenuControl.SetChildren(new Conversation());
        }

        private void GoToProfil(object sender, RoutedEventArgs e)
        {
            //    Singleton.Singleton.Instance().NewProfilUser = Friend;
            //    Singleton.Singleton.Instance().ItsMe = false;
            //    Singleton.Singleton.Instance().Charge();
            if (ProfilFriendViewModel.UserFromButton != null)
                GlobalMenuControl.SetChildren(new ProfilFriendView());
            else if (ProfilArtisteViewModel.TheUser != null)
                GlobalMenuControl.SetChildren(new ProfilArtiste());
            MyNetworkViewModel.MeaagePrompt.Hide();
        }

        private void DeleteContact(object sender, RoutedEventArgs e)
        {
            AddDelFriendHelpers.GetUserKeyForFriend(Friend.ToString(), true);
        }

        private void DelFriend(HttpRequestPost post, string cryptographic, HttpRequestGet get)
        {
            var resPost = post.DelFriend(cryptographic, Friend.ToString(),
                Singleton.Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var followers = get.GetFriends(new List<User>(), "users",
                            Singleton.Singleton.Instance().CurrentUser.id.ToString());
                        followers.ContinueWith(delegate(Task<object> task1)
                        {
                            var res = task1.Result as List<User>;
                            if (res != null)
                            {
                                Singleton.Singleton.Instance().CurrentUser.friends.Clear();
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        foreach (var user in res)
                                        {
                                            Singleton.Singleton.Instance().CurrentUser.friends.Add(user);
                                        }
                                        ServiceLocator.Current.GetInstance<MyNetworkViewModel>().UpdateFriend();
                                        new MessageDialog("Suppression OK").ShowAsync();
                                    });
                            }
                        });
                    });
                }
            });
        }

        #endregion
    }
}