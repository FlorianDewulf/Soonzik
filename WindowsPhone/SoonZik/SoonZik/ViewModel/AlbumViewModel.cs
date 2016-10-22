using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Imaging;
using Coding4Fun.Toolkit.Controls;
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
    public class AlbumViewModel : ViewModelBase
    {
        #region ctor

        public AlbumViewModel()
        {
            SelectionCommand = new RelayCommand(SelectionExecute);
            SendComment = new RelayCommand(SendCommentExecute);
            AddToCart = new RelayCommand(AddToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            RateMusic = new RelayCommand(RateMusicExecute);
            LikeCommand = new RelayCommand(LikeCommandExecute);
        }

        private void RateMusicExecute()
        {
            NotationMusic.SelectMusic = SelectedMusic;
            RatePopup = new Popup();
            var content = new NotationMusic();
            width = content.Width;
            height = content.Height;
            RatePopup.Child = content;
            RatePopup.VerticalOffset = (Window.Current.Bounds.Height - height)/2;
            RatePopup.HorizontalOffset = (Window.Current.Bounds.Width - width)/2;
            RatePopup.IsOpen = true;
            RatePopup.Closed += RatePopupOnClosed;
        }

        private void RatePopupOnClosed(object sender, object o)
        {
            SelectionExecute();
        }

        #endregion

        #region Attribute

        private BitmapImage _like;

        private readonly BitmapImage bmLike =
            new BitmapImage(new Uri("ms-appx:///Resources/Icones/like_icon.png", UriKind.RelativeOrAbsolute));

        private readonly BitmapImage bmDislike =
            new BitmapImage(new Uri("ms-appx:///Resources/Icones/notlike_icon.png", UriKind.RelativeOrAbsolute));

        public BitmapImage Like
        {
            get { return _like; }
            set
            {
                _like = value;
                RaisePropertyChanged("Like");
            }
        }

        public static Popup RatePopup { get; set; }

        public double width;
        public double height;

        private readonly INavigationService _navigationService;

        private string _likes;

        public string Likes
        {
            get { return _likes; }
            set
            {
                _likes = value;
                RaisePropertyChanged("Likes");
            }
        }

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

        public static Album MyAlbum { get; set; }
        private Music _selectedMusic;

        public Music SelectedMusic
        {
            get { return _selectedMusic; }
            set
            {
                _selectedMusic = value;
                RaisePropertyChanged("SelectedMusic");
            }
        }

        public static MessagePrompt MessagePrompt { get; set; }
        private RelayCommand _itemClickCommand;

        public RelayCommand ItemClickCommand
        {
            get { return _itemClickCommand; }
            set
            {
                _itemClickCommand = value;
                RaisePropertyChanged("ItemClickCommand");
            }
        }

        public ICommand LikeCommand { get; private set; }
        public ICommand SelectionCommand { get; private set; }
        public ICommand SendComment { get; private set; }
        public ICommand AddToCart { get; set; }
        public ICommand RatingValueChange { get; private set; }
        public ICommand PlayCommand { get; private set; }
        public ICommand AddToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        public ICommand RateMusic { get; private set; }

        private string _crypto;
        private string _textComment;

        public string TextComment
        {
            get { return _textComment; }
            set
            {
                _textComment = value;
                RaisePropertyChanged("TextComment");
            }
        }

        private ObservableCollection<Comments> _listCommAlbum;

        public ObservableCollection<Comments> ListCommAlbum
        {
            get { return _listCommAlbum; }
            set
            {
                _listCommAlbum = value;
                RaisePropertyChanged("ListCommAlbum");
            }
        }

        private ObservableCollection<Music> _listMusics;

        public ObservableCollection<Music> ListMusics
        {
            get { return _listMusics; }
            set
            {
                _listMusics = value;
                RaisePropertyChanged("ListMusics");
            }
        }

        #endregion

        #region Method

        private void LikeCommandExecute()
        {
            if (!TheAlbum.hasLiked)
            {
                Like = bmLike;
                ValidateKey.GetValideKey();
                var post = new HttpRequestPost();
                var res = post.SetLike("Albums", Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString(), TheAlbum.id.ToString());
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2.Result;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            UpdateAlbum);
                    }
                });
            }
            else
            {
                Like = bmDislike;
                ValidateKey.GetValideKey();
                var get = new HttpRequestGet();
                var res = get.DestroyLike("Albums", TheAlbum.id.ToString(), Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString());
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            UpdateAlbum);
                    }
                });
            }
        }

        private void UpdateAlbum()
        {
            var request = new HttpRequestGet();
            var album = request.GetSecureObject(new Album(), "albums", TheAlbum.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            album.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as Album;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            TheAlbum.hasLiked = test.hasLiked;
                            TheAlbum.likes = test.likes;
                            Likes = TheAlbum.likes;
                        });
                }
            });

            TheAlbum.image = Constant.UrlImageAlbum + TheAlbum.image;
        }

        private void SendCommentExecute()
        {
            var post = new HttpRequestPost();
            try
            {
                ValidateKey.GetValideKey();
                var test = post.SendComment(TextComment, TheAlbum, null, Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser);
                test.ContinueWith(delegate(Task<string> tmp)
                {
                    var res = tmp.Result;
                    if (res != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            LoadComment);
                    }
                });
            }
            catch (Exception)
            {
                new MessageDialog("Erreur lors du post").ShowAsync();
            }
        }

        private void SelectionExecute()
        {
            ListMusics = new ObservableCollection<Music>();
            TheAlbum = MyAlbum;
            var req = new HttpRequestGet();
            ValidateKey.CheckValidateKey();
            var al = req.GetSecureObject(new Album(), "albums", TheAlbum.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            al.ContinueWith(delegate(Task<object> task)
            {
                var res = al.Result as Album;
                if (res != null)
   {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            ListMusics = res.musics;
                            Likes = res.likes;
                            Like = res.hasLiked ? bmLike : bmDislike;
                        });
                }
            });
            //TheAlbum.imageAlbum = new BitmapImage(new System.Uri(Constant.UrlImageAlbum + TheAlbum.image, UriKind.RelativeOrAbsolute));
            LoadComment();
        }

        private void AddToCartExecute()
        {
            var loader = new ResourceLoader();
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            var res = post.SaveCart(null, TheAlbum, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);
            res.ContinueWith(delegate(Task<string> tmp2)
            {
                var res2 = tmp2.Result;
                if (res2 != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { new MessageDialog(loader.GetString("ProductAddToCart")).ShowAsync(); });
                }
            });
        }

        private void LoadComment()
        {
            TextComment = "";
            var request = new HttpRequestGet();
            ListCommAlbum = new ObservableCollection<Comments>();
            var elem = "albums/" + TheAlbum.id + "/comments";
            var listCom = request.GetListObject(new List<Comments>(), elem);
            listCom.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Comments>;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        foreach (var item in res)
                        {
                            ListCommAlbum.Add(item);
                        }
                    });
                }
            });
        }

        private void PlayCommandExecute()
        {
            var request = new HttpRequestGet();
            var res = request.GetObject(new Music(), "musics", SelectedMusic.id.ToString());
            res.ContinueWith(delegate(Task<object> task)
            {
                var music = task.Result as Music;
                if (music != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            SelectedMusic = music;
                            SelectedMusic.file = "http://soonzikapi.herokuapp.com/musics/get/" + SelectedMusic.id;
                            Singleton.Singleton.Instance().SelectedMusicSingleton.Clear();
                            Singleton.Singleton.Instance().SelectedMusicSingleton.Add(SelectedMusic);
                            //GlobalMenuControl.SetChildren(new BackgroundAudioPlayer());
                            GlobalMenuControl.MyPlayerToggleButton.IsChecked = true;
                            GlobalMenuControl.SetPlayerAudio();
                            GlobalMenuControl.PlayerButton.Content =
                                Singleton.Singleton.Instance().SelectedMusicSingleton[0].title;
                        });
                }
            });
        }

        private void AddMusicToCartExecute()
        {
            var loader = new ResourceLoader();
            _selectedMusic = SelectedMusic;
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            var res = post.SaveCart(_selectedMusic, null, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);
            res.ContinueWith(delegate(Task<string> tmp2)
            {
                var res2 = tmp2.Result;
                if (res2 != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { new MessageDialog(loader.GetString("ProductAddToCart")).ShowAsync(); });
                }
            });
        }

        private void AddToPlaylistExecute()
        {
            MyMusicViewModel.MusicForPlaylist = SelectedMusic;
            MyMusicViewModel.IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
        }

        #endregion
    }
}