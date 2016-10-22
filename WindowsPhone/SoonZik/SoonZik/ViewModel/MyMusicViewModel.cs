using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.Networking.BackgroundTransfer;
using Windows.Storage;
using Windows.UI.Core;
using Windows.UI.Popups;
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
    public class MyMusicViewModel : ViewModelBase
    {
        #region Ctor

        public MyMusicViewModel()
        {
            DowloadMusic = new RelayCommand(DownloadMusicExecute);
            loader = new ResourceLoader();
            ListAlbum = new ObservableCollection<Album>();
            ListMusique = new ObservableCollection<Music>();
            ListPack = new ObservableCollection<Pack>();
            ListPlaylist = new ObservableCollection<Playlist>();

            MusicTappedCommand = new RelayCommand(MusicTappedExecute);
            AlbumTappedCommand = new RelayCommand(AlbumTappedExecute);
            PackTappedCommand = new RelayCommand(PackTappedExecute);
            PlaylistTappedCommand = new RelayCommand(PlaylistTappedExecute);
            CreatePlaylist = new RelayCommand(CreatePlaylistExecute);
            DeletePlaylist = new RelayCommand(DeletePlaylistExecute);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);

            PlayCommand = new RelayCommand(PlayCommandExecute);
            SelectedIndex = IndexForPlaylist;

            LoadContent();
        }

        #endregion

        #region Method        
        private void DownloadMusicExecute()
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

                            DownloadFile();
                        });
                }
            });
        }

        private async void DownloadFile()
        {
            try
            {
                var source = new Uri(SelectedMusic.file, UriKind.Absolute);
                var destinationFile =
                    await
                        KnownFolders.MusicLibrary.CreateFileAsync(SelectedMusic.title + ".mp3",
                            CreationCollisionOption.ReplaceExisting);
                var downloader = new BackgroundDownloader();
                var download = downloader.CreateDownload(source, destinationFile);
                await download.StartAsync().AsTask(new CancellationToken(), new Progress<DownloadOperation>());
            }
            catch (Exception e)
            {
                new MessageDialog(loader.GetString("ErrorDowload")).ShowAsync();
            }
            new MessageDialog(loader.GetString("DownloadOk")).ShowAsync();
        }

        private void PlayCommandExecute()
        {
            var test = 0;
        }

        private void AddMusicToCartExecute()
        {
            _selectedMusic = SelectedMusic;
            var request = new HttpRequestGet();
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
            MusicForPlaylist = SelectedMusic;
            IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
        }

        public void LoadContent()
        {
            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();
            var listAlbumTmp = request.GetAllMusicForUser(new UserMusic(), Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser.id.ToString());

            listAlbumTmp.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as UserMusic;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        if (test.ListAlbums != null)
                            foreach (var album in test.ListAlbums)
                                ListAlbum.Add(album);
                        if (test.ListMusiques != null)
                            foreach (var music in test.ListMusiques)
                                ListMusique.Add(music);
                        if (test.ListPack != null)
                            foreach (var playlist in test.ListPack)
                                ListPack.Add(playlist);
                    });
                }
            });

            var listPlaylist = request.Find(new List<Playlist>(), "playlists",
                Singleton.Singleton.Instance().CurrentUser.id.ToString());
            listPlaylist.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Playlist>;

                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                {
                    if (res != null)
                        foreach (var playlist in res)
                        {
                            ListPlaylist.Add(playlist);
                        }
                });
            });
        }

        private void AlbumTappedExecute()
        {
            AlbumViewModel.MyAlbum = SelectedAlbum;
            GlobalMenuControl.SetChildren(new AlbumView());
        }

        private void PackTappedExecute()
        {
            PackViewModel.ThePack = SelectedPack;
            GlobalMenuControl.SetChildren(new Packs());
        }

        private void MusicTappedExecute()
        {
            AlbumViewModel.MyAlbum = SelectedMusic.album;
            GlobalMenuControl.SetChildren(new AlbumView());
        }

        private void PlaylistTappedExecute()
        {
            if (MusicForPlaylist == null && !_delete)
            {
                PlaylistViewModel.PlaylistTmp = SelectedPlaylist;
                GlobalMenuControl.SetChildren(new PlaylistView());
            }
            else if (!_delete)
            {
                new MessageDialog(loader.GetString("AddPlaylist")).ShowAsync();

                SelectedPlaylist.musics.Add(MusicForPlaylist);

                var request = new HttpRequestGet();
                var post = new HttpRequestPost();
                try
                {
                    ValidateKey.GetValideKey();
                    var test = post.UpdatePlaylist(SelectedPlaylist, MusicForPlaylist,
                        Singleton.Singleton.Instance().SecureKey,
                        Singleton.Singleton.Instance().CurrentUser);
                    test.ContinueWith(delegate(Task<string> tmp)
                    {
                        var res = tmp.Result;
                        if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                RefreshPlaylist);
                        }
                    });
                }
                catch (Exception)
                {
                    new MessageDialog(loader.GetString("ErrorUpdatePlaylist")).ShowAsync();
                }
            }
            else
            {
                _delete = false;
            }
        }

        private void RefreshPlaylist()
        {
            ListPlaylist = new ObservableCollection<Playlist>();
            MusicForPlaylist = null;
            var request = new HttpRequestGet();
            var listPlaylist = request.Find(new List<Playlist>(), "playlists",
                Singleton.Singleton.Instance().CurrentUser.id.ToString());
            listPlaylist.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Playlist>;

                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                {
                    if (res != null)
                        foreach (var playlist in res)
                        {
                            ListPlaylist.Add(playlist);
                        }
                });
            });
        }

        private void CreatePlaylistExecute()
        {
            var playlist = new Playlist
            {
                name = "MyPlaylist",
                user = Singleton.Singleton.Instance().CurrentUser,
                musics = new List<Music> {MusicForPlaylist}
            };
            if (MusicForPlaylist != null)
            {
                var post = new HttpRequestPost();
                try
                {
                    ValidateKey.GetValideKey();
                    var test = post.SavePlaylist(playlist, Singleton.Singleton.Instance().SecureKey,
                        Singleton.Singleton.Instance().CurrentUser);
                    test.ContinueWith(delegate(Task<string> tmp)
                    {
                        var res = tmp.Result;
                        if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                                    var playList =
                                        (Playlist)
                                            JsonConvert.DeserializeObject(stringJson, new Playlist().GetType());
                                    try
                                    {
                                        ValidateKey.GetValideKey();
                                        var up = post.UpdatePlaylist(playList, MusicForPlaylist,
                                            Singleton.Singleton.Instance().SecureKey,
                                            Singleton.Singleton.Instance().CurrentUser);
                                        up.ContinueWith(delegate(Task<string> tmp2)
                                        {
                                            var res2 = tmp2.Result;
                                            if (res2 != null)
                                            {
                                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(
                                                    CoreDispatcherPriority.Normal, RefreshPlaylist);
                                            }
                                        });
                                    }
                                    catch (Exception)
                                    {
                                        new MessageDialog(loader.GetString("ErrorUpdatePlaylist")).ShowAsync();
                                    }
                                });
                        }
                    });
                }
                catch (Exception)
                {
                    new MessageDialog(loader.GetString("ErrorUpdatePlaylist")).ShowAsync();
                }
            }
            else
            {
                new MessageDialog(loader.GetString("ErrorNoMusic")).ShowAsync();
            }
        }

        private void DeletePlaylistExecute()
        {
            _delete = true;
            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();
            var resDel = request.DeletePlaylist(SelectedPlaylist, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);

            resDel.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var stringJson = JObject.Parse(test).SelectToken("code").ToString();
                        if (stringJson == "202")
                        {
                            new MessageDialog(loader.GetString("ErrorDeletePlaylist")).ShowAsync();
                            RefreshPlaylist();
                        }
                        else
                            new MessageDialog("Delete Fail code: " + stringJson).ShowAsync();
                    });
                }
            });
        }

        #endregion

        #region Attribute

        public ResourceLoader loader;
        public ICommand DowloadMusic { get; private set; }
        public ICommand PlayCommand { get; private set; }
        public ICommand AddToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        private static int _id;
        private bool _delete;
        public static int IndexForPlaylist { get; set; }
        private int _selectedIndex;

        public int SelectedIndex
        {
            get { return _selectedIndex; }
            set
            {
                _selectedIndex = value;
                RaisePropertyChanged("SelectedIndex");
            }
        }

        private string _key { get; set; }
        private string _cryptographic { get; set; }
        private ObservableCollection<Album> _listAlbum;

        public ObservableCollection<Album> ListAlbum
        {
            get { return _listAlbum; }
            set
            {
                _listAlbum = value;
                RaisePropertyChanged("ListAlbum");
            }
        }

        private ObservableCollection<Music> _listMusique;

        public ObservableCollection<Music> ListMusique
        {
            get { return _listMusique; }
            set
            {
                _listMusique = value;
                RaisePropertyChanged("ListMusique");
            }
        }

        private ObservableCollection<Pack> _listPack;

        public ObservableCollection<Pack> ListPack
        {
            get { return _listPack; }
            set
            {
                _listPack = value;
                RaisePropertyChanged("ListPack");
            }
        }

        private ObservableCollection<Playlist> _listPlaylist;

        public ObservableCollection<Playlist> ListPlaylist
        {
            get { return _listPlaylist; }
            set
            {
                _listPlaylist = value;
                RaisePropertyChanged("ListPlaylist");
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

        private Album _selectedAlbum;

        public Album SelectedAlbum
        {
            get { return _selectedAlbum; }
            set
            {
                _selectedAlbum = value;
                RaisePropertyChanged("SelectedAlbum");
            }
        }

        private Pack _selectedPack;

        public Pack SelectedPack
        {
            get { return _selectedPack; }
            set
            {
                _selectedPack = value;
                RaisePropertyChanged("SelectedPack");
            }
        }

        private Playlist _selectedPlaylist;

        public Playlist SelectedPlaylist
        {
            get { return _selectedPlaylist; }
            set
            {
                _selectedPlaylist = value;
                RaisePropertyChanged("SelectedPlaylist");
            }
        }

        public ICommand MusicTappedCommand { get; private set; }
        public ICommand PackTappedCommand { get; private set; }
        public ICommand AlbumTappedCommand { get; private set; }
        public ICommand PlaylistTappedCommand { get; private set; }
        public ICommand CreatePlaylist { get; private set; }
        public ICommand DeletePlaylist { get; private set; }

        public static Music MusicForPlaylist;

        #endregion
    }
}