using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.UI.Core;
using Windows.UI.Popups;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class PlaylistViewModel : ViewModelBase
    {
        #region Ctor

        public PlaylistViewModel()
        {
            loader = new ResourceLoader();
            LoadedCommand = new RelayCommand(OnLoadedPageExecute);
            RenameCommand = new RelayCommand(RenameCommandExecute);
            UpdatePlaylist = new RelayCommand(UpdatePlaylistExecute);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            DelToPlaylist = new RelayCommand(DelToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
            PlayAllCommand = new RelayCommand(PlayAllCommandExecute);
        }

        #endregion

        #region Attribute

        public ResourceLoader loader;
        private string _cryptographic;
        public ICommand RenameCommand { get; private set; }
        public ICommand PlayCommand { get; private set; }
        public ICommand PlayAllCommand { get; private set; }
        public ICommand AddToPlaylist { get; private set; }
        public ICommand DelToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        public ICommand LoadedCommand { get; private set; }
        public static ICommand UpdatePlaylist { get; private set; }

        public static Playlist PlaylistTmp { get; set; }

        public static MessagePrompt MessagePrompt { get; set; }
        private bool _moreOption;

        private Playlist _thePlaylist;

        public Playlist ThePlaylist
        {
            get { return _thePlaylist; }
            set
            {
                _thePlaylist = value;
                RaisePropertyChanged("ThePlaylist");
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

        private bool _boolRename;

        public bool BoolRename
        {
            get { return _boolRename; }
            set
            {
                _boolRename = value;
                RaisePropertyChanged("BoolRename");
            }
        }

        private string _renameButton;

        public string RenameButton
        {
            get { return _renameButton; }
            set
            {
                _renameButton = value;
                RaisePropertyChanged("RenameButton");
            }
        }

        private string _key { get; set; }
        private string _cryptocraphic { get; set; }

        #endregion

        #region Method

        private void RenameCommandExecute()
        {
            if (!BoolRename)
            {
                BoolRename = true;
                RenameButton = "Validate";
                return;
            }
            if (BoolRename)
            {
                RenameButton = "Rename";
                var request2 = new HttpRequestPost();

                ValidateKey.GetValideKey();

                var res = request2.UpdateNamePlaylist(ThePlaylist, Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser);
                res.ContinueWith(delegate(Task<string> tmp)
                {
                    if (tmp.Result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                var stringJson = JObject.Parse(tmp.Result).SelectToken("content").ToString();
                                ThePlaylist = (Playlist)JsonConvert.DeserializeObject(stringJson, typeof(Playlist));
                                var i = ThePlaylist.musics.Count;
                            });
                    }
                });
                BoolRename = false;
            }
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
                            GlobalMenuControl.MyPlayerToggleButton.IsChecked = true;
                            GlobalMenuControl.SetPlayerAudio();
                        });
                }
            });
        }

        private void PlayAllCommandExecute()
        {
            var request = new HttpRequestGet();
            Singleton.Singleton.Instance().SelectedMusicSingleton.Clear();
            foreach (var music in ThePlaylist.musics)
            {
                var res = request.GetObject(new Music(), "musics", music.id.ToString());
                res.ContinueWith(delegate(Task<object> task)
                {
                    var musics = task.Result as Music;
                    if (musics != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                SelectedMusic = musics;
                                SelectedMusic.file = "http://soonzikapi.herokuapp.com/musics/get/" + SelectedMusic.id;
                                Singleton.Singleton.Instance().SelectedMusicSingleton.Add(SelectedMusic);
                                if (ThePlaylist.musics.Count ==
                                    Singleton.Singleton.Instance().SelectedMusicSingleton.Count)
                                {
                                    //GlobalMenuControl.SetChildren(new BackgroundAudioPlayer());
                                    GlobalMenuControl.MyPlayerToggleButton.IsChecked = true;
                                    GlobalMenuControl.SetPlayerAudio();
                                }
                            });
                    }
                });
            }
        }

        private void UpdatePlaylistExecute()
        {
            var request = new HttpRequestGet();

            var res = request.GetObject(new Playlist(), "playlists", ThePlaylist.id.ToString());
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var pl = tmp.Result as Playlist;
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                    () =>
                    {
                        if (pl != null)
                            ThePlaylist = pl;
                    });
            });
        }

        public void OnLoadedPageExecute()
        {
            ThePlaylist = PlaylistTmp;
            ListMusics = new ObservableCollection<Music>();
            RenameButton = "Rename";
            UpdatePlaylistExecute();
        }

        private void AddMusicToCartExecute()
        {
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

        private void DelToPlaylistExecute()
        {
            if (ThePlaylist != null)
            {
                _selectedMusic = SelectedMusic;
                var request = new HttpRequestGet();

                ValidateKey.GetValideKey();
                var resDel = request.DeleteMusicFromPlaylist(ThePlaylist, _selectedMusic,
                    Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser);

                resDel.ContinueWith(delegate(Task<string> tmp)
                {
                    var test = tmp.Result;
                    if (test != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                var stringJson = JObject.Parse(test).SelectToken("code").ToString();
                                if (stringJson == "200")
                                {
                                    new MessageDialog(loader.GetString("MusicDelete")).ShowAsync();
                                    UpdatePlaylist.Execute(null);
                                }
                                else
                                {
                                    new MessageDialog(loader.GetString("ErrorDeleteMusic") + stringJson).ShowAsync();
                                }
                            });
                    }
                });
            }
            else
            {
                new MessageDialog(loader.GetString("ErrorAddPlaylist")).ShowAsync();
            }
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