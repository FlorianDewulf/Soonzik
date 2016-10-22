using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.UI.Core;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class ProfilArtisteViewModel : ViewModelBase
    {
        #region ctor

        public ProfilArtisteViewModel()
        {
            if (TheUser != null)
            {
                SelectionCommand = new RelayCommand(SelectionExecute);
                FollowCommand = new RelayCommand(FollowCommandExecute);
                ItemClickCommand = new RelayCommand(ItemClickCommandExecute);
                ListAlbums = new ObservableCollection<Album>();
                AddCommand = new RelayCommand(AddFriendExecute);
            }
        }

        #endregion

        #region Attribute

        public ICommand AddCommand { get; private set; }
        public ICommand FollowCommand { get; private set; }
        public ICommand SelectionCommand { get; private set; }
        private ICommand _itemClickCommand;

        public ICommand ItemClickCommand
        {
            get { return _itemClickCommand; }
            set
            {
                _itemClickCommand = value;
                RaisePropertyChanged("ItemClickCommand");
            }
        }

        private const string UrlImage = "http://soonzikapi.herokuapp.com/assets/usersImage/avatars/";

        private string _buttonFriendText;

        public string ButtonFriendText
        {
            get { return _buttonFriendText; }
            set
            {
                _buttonFriendText = value;
                RaisePropertyChanged("ButtonFriendText");
            }
        }

        private bool _friend;
        private bool _follow;
        private User _theArtiste;

        public User TheArtiste
        {
            get { return _theArtiste; }
            set
            {
                _theArtiste = value;
                RaisePropertyChanged("TheArtiste");
            }
        }

        private string _followText;

        public string FollowText
        {
            get { return _followText; }
            set
            {
                _followText = value;
                RaisePropertyChanged("FollowText");
            }
        }

        private ObservableCollection<Album> _listAlbums;

        public ObservableCollection<Album> ListAlbums
        {
            get { return _listAlbums; }
            set
            {
                _listAlbums = value;
                RaisePropertyChanged("ListAlbums");
            }
        }

        public static User TheUser { get; set; }

        private Album _theAlbum;

        public Album TheAlbum
        {
            get { return _theAlbum; }
            set
            {
                _theAlbum = value;
                RaisePropertyChanged("TheAlbum");
            }
        }

        private string _nbrFollowers;

        public string NbrFollowers
        {
            get { return _nbrFollowers; }
            set
            {
                _nbrFollowers = value;
                RaisePropertyChanged("NbrFollowers");
            }
        }

        private string _nbrTitres;

        public string NbrTitres
        {
            get { return _nbrTitres; }
            set
            {
                _nbrTitres = value;
                RaisePropertyChanged("NbrTitres");
            }
        }

        #endregion

        #region Method

        public void Charge()
        {
            var request = new HttpRequestGet();

            var res = request.GetArtist(new Artist(), "users", TheUser.id.ToString());
            res.ContinueWith(delegate(Task<object> obj)
            {
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                {
                    if (ListAlbums.Count != 0)
                        ListAlbums.Clear();
                    var art = obj.Result as Artist;
                    if (art != null && art.artist)
                    {
                        foreach (var album in art.albums)
                        {
                            album.imageAlbum =
                                new BitmapImage(new Uri(Constant.UrlImageAlbum + album.image, UriKind.RelativeOrAbsolute));
                            NbrTitres = album.musics.Count + " titres";
                            ListAlbums.Add(album);
                        }
                    }
                    if (TheArtiste.follows != null)
                        NbrFollowers = TheArtiste.follows.Count.ToString();
                });
            });
        }

        private void SetFollowText()
        {
            foreach (var follow in Singleton.Singleton.Instance().CurrentUser.follows)
            {
                if (follow.id == TheArtiste.id)
                    _follow = true;
            }
            FollowText = _follow ? "Unfollow" : "Follow";
        }

        private void Follow(HttpRequestPost post, string cryptographic, HttpRequestGet get)
        {
            var resPost = post.Follow(cryptographic, TheArtiste.id.ToString(),
                Singleton.Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var followers = get.GetFollows(new List<User>(), "users",
                            Singleton.Singleton.Instance().CurrentUser.id.ToString());
                        followers.ContinueWith(delegate(Task<object> task1)
                        {
                            var res = task1.Result as List<User>;
                            if (res != null)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        Singleton.Singleton.Instance().CurrentUser.follows = res;
                                        var a = TheArtiste;
                                        SetFollowText();
                                    });
                            }
                        });
                    });
                }
            });
        }

        private void Unfollow(HttpRequestPost post, string cryptographic, HttpRequestGet get)
        {
            var resPost = post.Unfollow(cryptographic, TheArtiste.id.ToString(),
                Singleton.Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var followers = get.GetFollows(new List<User>(), "users",
                            Singleton.Singleton.Instance().CurrentUser.id.ToString());
                        followers.ContinueWith(delegate(Task<object> task1)
                        {
                            var res = task1.Result as List<User>;
                            if (res != null)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        Singleton.Singleton.Instance().CurrentUser.follows = res;
                                        var a = TheArtiste;
                                        _follow = false;
                                        SetFollowText();
                                    });
                            }
                        });
                    });
                }
            });
        }

        #endregion

        #region Method Command

        private void ItemClickCommandExecute()
        {
            var request = new HttpRequestGet();
            var album = request.GetSecureObject(new Album(), "albums", TheAlbum.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            album.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as Album;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        TheAlbum = test;
                        TheAlbum.imageAlbum =
                            new BitmapImage(new Uri(Constant.UrlImageAlbum + TheAlbum.image, UriKind.RelativeOrAbsolute));
                        AlbumViewModel.MyAlbum = TheAlbum;
                        GlobalMenuControl.SetChildren(new AlbumView());
                    });
                }
            });
        }

        private void SelectionExecute()
        {
            if (TheUser != null)
            {
                TheArtiste = TheUser;
                TheArtiste.image = new Uri(UrlImage + TheUser.image, UriKind.RelativeOrAbsolute).ToString();
                SetFollowText();
                Charge();
                CheckIfFriend();
            }
        }

        private void FollowCommandExecute()
        {
            var post = new HttpRequestPost();
            var get = new HttpRequestGet();

            if (_follow)
                Unfollow(post, Singleton.Singleton.Instance().SecureKey, get);
            else if (!_follow)
                Follow(post, Singleton.Singleton.Instance().SecureKey, get);
        }

        private void CheckIfFriend()
        {
            var loader = new ResourceLoader();
            foreach (var friend in Singleton.Singleton.Instance().CurrentUser.friends)
            {
                if (friend.username == TheArtiste.username)
                {
                    ButtonFriendText = loader.GetString("DelFriend");
                    _friend = true;
                }
                else
                {
                    ButtonFriendText = loader.GetString("AddFriend");
                    _friend = false;
                }
            }
        }

        private void AddFriendExecute()
        {
            var loader = new ResourceLoader();
            AddDelFriendHelpers.GetUserKeyForFriend(TheArtiste.id.ToString(), _friend);
            _friend = !_friend;
            ButtonFriendText = loader.GetString(_friend ? "DelFriend" : "AddFriend");
        }

        #endregion
    }
}