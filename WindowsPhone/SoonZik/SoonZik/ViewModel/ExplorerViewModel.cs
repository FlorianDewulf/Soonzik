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
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using Genre = SoonZik.HttpRequest.Poco.Genre;

namespace SoonZik.ViewModel
{
    public class ExplorerViewModel : ViewModelBase
    {
        #region Ctor

        public ExplorerViewModel()
        {
            loader = new ResourceLoader();
            Navigation = new NavigationService();

            InfluenceTapped = new RelayCommand(InfluenceTappedExecute);
            // AmbianceTapped = new RelayCommand(AmbianceTappedExecute);
            AlbumCommand = new RelayCommand(AlbumCommandExecute);
            TappedCommand = new RelayCommand(ArtisteTappedCommand);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
            DowloadMusic = new RelayCommand(DownloadMusicExecute);
            LoadCommand = new RelayCommand(LoadContent);
            MusiCommand = new RelayCommand(MusiCommandExecute);
        }

        #endregion

        #region Attribute

        public ResourceLoader loader;
        public ICommand LoadCommand { get; private set; }
        public ICommand AddToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        public ICommand DowloadMusic { get; private set; }
        public ICommand InfluenceTapped { get; private set; }

        public ICommand AmbianceTapped { get; private set; }
        public ICommand TappedCommand { get; private set; }
        public ICommand AlbumCommand { get; private set; }
        public ICommand PlayCommand { get; set; }
        public INavigationService Navigation;

        private string _crypto;
        public static Music SelecMusic { get; set; }
        private Influence _selectedInfluence;

        public Influence SelectedInfluence
        {
            get { return _selectedInfluence; }
            set
            {
                _selectedInfluence = value;
                RaisePropertyChanged("SelectedInfluence");
            }
        }

        private Ambiance _selectedAmbiance;

        public Ambiance SelectedAmbiance
        {
            get { return _selectedAmbiance; }
            set
            {
                _selectedAmbiance = value;
                RaisePropertyChanged("SelectedAmbiance");
            }
        }

        private ObservableCollection<Ambiance> _listAmbiance;

        public ObservableCollection<Ambiance> ListAmbiance
        {
            get { return _listAmbiance; }
            set
            {
                _listAmbiance = value;
                RaisePropertyChanged("ListAmbiance");
            }
        }

        private ObservableCollection<Influence> _listInfluences;

        public ObservableCollection<Influence> ListInfluences
        {
            get { return _listInfluences; }
            set
            {
                _listInfluences = value;
                RaisePropertyChanged("ListInfluences");
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

        private ObservableCollection<User> _listArtiste;

        public ObservableCollection<User> ListArtiste
        {
            get { return _listArtiste; }
            set
            {
                _listArtiste = value;
                RaisePropertyChanged("ListArtiste");
            }
        }

        public Music SelectedMusic { get; set; }
        public static Music PlayerSelectedMusic { get; set; }
        public RelayCommand MusiCommand { get; set; }
        private string _cryptographic;
        private User _selectedArtiste;

        public User SelectedArtiste
        {
            get { return _selectedArtiste; }
            set
            {
                _selectedArtiste = value;
                RaisePropertyChanged("SelectedArtiste");
            }
        }

        #endregion

        #region Method

        private void InfluenceTappedExecute()
        {
            var id = SelectedInfluence.id;
            GenreViewModel.TheListGenres = new ObservableCollection<Genre>();
            GenreViewModel.TheListGenres = SelectedInfluence.genres;
            GlobalMenuControl.SetChildren(new GenreView());
        }

        private void DownloadMusicExecute()
        {
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
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
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
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


        private void AlbumCommandExecute()
        {
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
            AlbumViewModel.MyAlbum = SelectedMusic.album;
            GlobalMenuControl.SetChildren(new AlbumView());
        }

        private void PlayCommandExecute()
        {
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
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

        public void LoadContent()
        {
            ListArtiste = new ObservableCollection<User>();
            ListMusique = new ObservableCollection<Music>();
            ListInfluences = new ObservableCollection<Influence>();
            ListAmbiance = new ObservableCollection<Ambiance>();
            var request = new HttpRequestGet();
            try
            {
                var listIdentities = request.GetIdentities(new List<Identities>(), Singleton.Singleton.Instance().CurrentUser.id.ToString(), Singleton.Singleton.Instance().SecureKey);
                listIdentities.ContinueWith(delegate(Task<object> tmp)
                {
                    var test = tmp.Result as List<Identities>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            if (item.provider == "soundcloud")
                            {
                                var post = new HttpRequestPost();
                                var result = post.GetMusicalPast(item.uid, Singleton.Singleton.Instance().SecureKey,
                                    Singleton.Singleton.Instance().CurrentUser.id.ToString());
                                result.ContinueWith(delegate(Task<string> t) { var res = t.Result; });
                            }
                        }
                    }
                });
                var listGenre = request.GetListObject(new List<Influence>(), "influences");
                listGenre.ContinueWith(delegate(Task<object> tmp)
                {
                    var test = tmp.Result as List<Influence>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () => { ListInfluences.Add(item); });
                        }
                    }
                });
                var listUser = request.GetListObject(new List<User>(), "users");
                listUser.ContinueWith(delegate(Task<object> tmp)
                {
                    var test = tmp.Result as List<User>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            var res = request.GetArtist(new Artist(), "users", item.id.ToString());
                            res.ContinueWith(delegate(Task<object> obj)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        var art = obj.Result as Artist;
                                        item.profilImage =
                                            new BitmapImage(new Uri(Constant.UrlImageUser + item.image,
                                                UriKind.RelativeOrAbsolute));
                                        if (art != null && art.artist)
                                            ListArtiste.Add(item);
                                    });
                            });
                        }
                    }
                });
                ValidateKey.GetValideKey();
                var listZik = request.GetSuggest(new List<Music>(), "music");
                listZik.ContinueWith(delegate(Task<object> tmp)
                {
                    var test = tmp.Result as List<Music>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(
                                CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    item.album.imageAlbum =
                                        new BitmapImage(new Uri(Constant.UrlImageAlbum + item.album.image,
                                            UriKind.RelativeOrAbsolute));
                                    ListMusique.Add(item);
                                });
                        }
                    }
                });
                var listAmb = request.GetListObject(new List<Ambiance>(), "ambiances");
                listAmb.ContinueWith(delegate(Task<object> task)
                {
                    var test = listAmb.Result as List<Ambiance>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(
                                CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    var ambiance = request.GetObject(new Ambiance(), "ambiances", item.id.ToString());
                                    ambiance.ContinueWith(delegate(Task<object> task1)
                                    {
                                        var am = task1.Result as Ambiance;
                                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(
                                            CoreDispatcherPriority.Normal,
                                            () =>
                                            {
                                                foreach (var music in am.musics)
                                                {
                                                    music.album.imageAlbum =
                                                        new BitmapImage(
                                                            new Uri(Constant.UrlImageAlbum + music.album.image,
                                                                UriKind.RelativeOrAbsolute));
                                                }
                                                ListAmbiance.Add(am);
                                            });
                                    });
                                });
                        }
                    }
                });
            }
            catch (Exception e)
            {
                //new MessageDialog("probleme reseau : " + e.Message).ShowAsync();
            }
        }

        private void AddMusicToCartExecute()
        {
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            var res = post.SaveCart(SelectedMusic, null, Singleton.Singleton.Instance().SecureKey,
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
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
            MyMusicViewModel.MusicForPlaylist = SelectedMusic;
            MyMusicViewModel.IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
        }

        private void MusiCommandExecute()
        {
            if (SelecMusic != null)
                SelectedMusic = SelecMusic;
            Singleton.Singleton.Instance().SelectedMusicSingleton.Clear();
            Singleton.Singleton.Instance().SelectedMusicSingleton.Add(SelectedMusic);
            GlobalMenuControl.MyPlayerToggleButton.IsChecked = true;
            GlobalMenuControl.SetPlayerAudio();
            //Navigation.Navigate(new PlayerControl().GetType());
        }

        private void ArtisteTappedCommand()
        {
            ProfilArtisteViewModel.TheUser = SelectedArtiste;
            GlobalMenuControl.SetChildren(new ProfilArtiste());
        }

        #endregion
    }
}