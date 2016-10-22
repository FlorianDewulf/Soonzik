using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
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
    public class GenreViewModel : ViewModelBase
    {
        #region Attribute

        public ResourceLoader loader;
        public static Music SelecMusic { get; set; }

        public Music SelectedMusic
        {
            get { return _selectedMusic; }
            set
            {
                _selectedMusic = value;
                RaisePropertyChanged("SelectedMusic");
            }
        }

        private Music _selectedMusic;
        public ICommand AddToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        public ICommand AlbumCommand { get; private set; }
        public ICommand PlayCommand { get; set; }
        public ICommand SelectionCommand { get; set; }

        public static ObservableCollection<Genre> TheListGenres;
        private ObservableCollection<Genre> _listGenreSelected;

        public ObservableCollection<Genre> ListGenreSelected
        {
            get { return _listGenreSelected; }
            set
            {
                _listGenreSelected = value;
                RaisePropertyChanged("ListGenreSelected");
            }
        }

        #endregion

        #region Ctor

        public GenreViewModel()
        {
            loader = new ResourceLoader();
            AlbumCommand = new RelayCommand(AlbumCommandExecute);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
            SelectionCommand = new RelayCommand(SelectionCommandExecute);
        }

        #endregion

        #region Method
        private void SelectionCommandExecute()
        {
            ListGenreSelected = new ObservableCollection<Genre>();
            var get = new HttpRequestGet();
            foreach (var genre in TheListGenres)
            {
                var res = get.GetObject(new Genre(), "genres", genre.id.ToString());
                res.ContinueWith(delegate(Task<object> task)
                {
                    var r = task.Result as Genre;
                    if (r != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                        {
                            foreach (var mus in r.musics)
                            {
                                mus.album.imageAlbum =
                                    new BitmapImage(new Uri(Constant.UrlImageAlbum + mus.album.image,
                                        UriKind.RelativeOrAbsolute));
                            }
                            ListGenreSelected.Add(r);
                        });
                    }
                });
            }
        }

        private void AlbumCommandExecute()
        {
            SelectedMusic = SelecMusic;
            AlbumViewModel.MyAlbum = SelectedMusic.album;
            GlobalMenuControl.SetChildren(new AlbumView());
        }

        private void PlayCommandExecute()
        {
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

        private void AddMusicToCartExecute()
        {
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
                        () => { new MessageDialog(loader.GetString("PrdouctAddToCart")).ShowAsync(); });
                }
            });
        }


        private void AddToPlaylistExecute()
        {
            SelectedMusic = SelecMusic;
            MyMusicViewModel.MusicForPlaylist = SelectedMusic;
            MyMusicViewModel.IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
        }

        #endregion
    }
}