using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.Devices.Geolocation;
using Windows.Phone.UI.Input;
using Windows.Storage;
using Windows.Storage.Streams;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media.Animation;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Properties;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;
using Battle = SoonZik.Views.BattleView;
using News = SoonZik.Views.News;
using Playlist = SoonZik.Views.MyMusic;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class GlobalMenuControl : UserControl, INotifyPropertyChanged
    {
        #region NotifyPropertyCahnge

        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChange(string propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }

        #endregion

        #region Attribute

        public static ToggleButton PlayerButton { get; set; }
        public static Grid MyPlayerGrid { get; set; }
        public static Grid MyGrid { get; set; }
        public ObservableCollection<SearchResult> ListObject;
        public event PropertyChangedEventHandler PropertyChanged;
        public string SearchText { get; set; }
        private readonly INavigationService _navigationService;
        private static UIElement _lastElement;

        #endregion

        #region Attributes StoryBoard Menu

        public static ToggleButton MyPlayerToggleButton;
        private static Storyboard story { get; set; }
        private static Storyboard playerStoryboard { get; set; }
        private static Storyboard playerStoryboardBack { get; set; }
        private static ToggleButton toggle { get; set; }
        public static ToggleButton MenuToggleButton { get; set; }

        #endregion

        #region Attributes Recherche

        private SearchResult _myResult;

        public SearchResult MyResult
        {
            get { return _myResult; }
            set
            {
                _myResult = value;
                RaisePropertyChange("MyResult");
            }
        }

        private User _selectedUser;

        private User _selectedArtist;

        public User SelectedArtist
        {
            get { return _selectedArtist; }
            set
            {
                _selectedArtist = value;
                RaisePropertyChange("SelectedArtist");
            }
        }

        public User SelectedUser
        {
            get { return _selectedUser; }
            set
            {
                _selectedUser = value;
                RaisePropertyChange("SelectedUser");
            }
        }

        private Music _selectedMusic;

        public Music SelectedMusic
        {
            get { return _selectedMusic; }
            set
            {
                _selectedMusic = value;
                RaisePropertyChange("SelectedMusic");
            }
        }

        private Album _selectedAlbum;

        public Album SelectedAlbum
        {
            get { return _selectedAlbum; }
            set
            {
                _selectedAlbum = value;
                RaisePropertyChange("SelectedAlbum");
            }
        }

        private Pack _selectedPack;

        public Pack SelectedPack
        {
            get { return _selectedPack; }
            set
            {
                _selectedPack = value;
                RaisePropertyChange("SelectedPack");
            }
        }

        private BouttonMenu _selectedBouttonMenu;

        public BouttonMenu SelectedBouttonMenu
        {
            get { return _selectedBouttonMenu; }
            set
            {
                _selectedBouttonMenu = value;
                RaisePropertyChange("SelectedBouttonMenu");
            }
        }

        #endregion

        #region Attribute Headers

        private string _headerArtiste;

        public string HeaderArtiste
        {
            get { return _headerArtiste; }
            set
            {
                _headerArtiste = value;
                RaisePropertyChange("HeaderArtiste");
            }
        }

        private string _headerMusique;

        public string HeaderMusique
        {
            get { return _headerMusique; }
            set
            {
                _headerMusique = value;
                RaisePropertyChange("HeaderMusique");
            }
        }

        private string _headerUser;

        public string HeaderUser
        {
            get { return _headerUser; }
            set
            {
                _headerUser = value;
                RaisePropertyChange("Header");
            }
        }

        private string _headerPack;

        public string HeaderPack
        {
            get { return _headerPack; }
            set
            {
                _headerPack = value;
                RaisePropertyChange("HeaderPack");
            }
        }

        private string _headerAlbum;

        public string HeaderAlbum
        {
            get { return _headerAlbum; }
            set
            {
                _headerAlbum = value;
                RaisePropertyChange("HeaderAlbum");
            }
        }

        #endregion

        #region Ctor

        private readonly DispatcherTimer dispatcherTimer;
        public int i;

        public GlobalMenuControl()
        {
            InitializeComponent();
            DataContext = this;
            MyGrid = GlobalGrid;
            MyPlayerGrid = PlayerGrid;
            PlayerButton = MyPlayerToggleButton;
            GlobalGrid.Children.Add(new News());

            _navigationService = new NavigationService();
            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            MyPlayerToggleButton = PlayerToggleButton;
            story = MenuStoryBoardBack;
            playerStoryboard = PlayerStoryBoard;
            playerStoryboard.Completed += PlayerStoryboardOnCompleted;
            playerStoryboardBack = PlayerStoryBoardBack;
            playerStoryboardBack.Completed += PlayerStoryboardBackOnCompleted;
            toggle = ToggleButtonSearch;
            MenuToggleButton = ToggleButtonMenu;
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;

            ProfilButton.Command = new RelayCommand(GoToProfil);
            NewsButton.Command = new RelayCommand(GoToNews);
            ExplorerButton.Command = new RelayCommand(GoToExplorer);
            PacksButton.Command = new RelayCommand(GoToPacks);
            MondeMusicalButton.Command = new RelayCommand(GoToMondeMusical);
            BattleButton.Command = new RelayCommand(GoToBattle);
            PlaylistButton.Command = new RelayCommand(GoToPlaylist);
            AmisButton.Command = new RelayCommand(GoToAmis);
            AchatButton.Command = new RelayCommand(GoToAchat);
            ConnexionButton.Command = new RelayCommand(GoToConnexionPage);
            APropos.Command = new RelayCommand(GoToAbout);

            CreateFile();

            dispatcherTimer = new DispatcherTimer();
            dispatcherTimer.Tick += DispatcherTimerOnTick;
            dispatcherTimer.Interval = new TimeSpan(0, 0, 10);
            dispatcherTimer.Start();
            i = 0;
        }

        private void PlayerStoryboardOnCompleted(object sender, object o)
        {
            MyPlayerToggleButton.Content = "Close";
        }

        private void PlayerStoryboardBackOnCompleted(object sender, object o)
        {
            if (PlayerControlViewModel.StaticCurrentMusic != null)
                MyPlayerToggleButton.Content = PlayerControlViewModel.StaticCurrentMusic.title;
        }

        private async void CreateFile()
        {
            // Serialize our Product class into a string             
            var jsonContents = JsonConvert.SerializeObject(new ObservableCollection<Message>());
            // Get the app data folder and create or replace the file we are storing the JSON in.            
            try
            {
                var localFolder = ApplicationData.Current.LocalFolder;
                var textFile = await localFolder.CreateFileAsync("conversations",
                    CreationCollisionOption.FailIfExists);
                // Open the file...      
                using (var textStream = await textFile.OpenAsync(FileAccessMode.ReadWrite))
                {
                    // write the JSON string!
                    using (var textWriter = new DataWriter(textStream))
                    {
                        textWriter.WriteString(jsonContents);
                        await textWriter.StoreAsync();
                    }
                }
            }
            catch (Exception q)
            {
                var test = q.Message;
            }
        }

        private void DispatcherTimerOnTick(object sender, object o)
        {
            MyNetworkViewModel.LoadConversation();
        }

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs e)
        {
            e.Handled = true;
            SetChildren(_lastElement);
        }

        #endregion

        #region Method Menu

        private void MenuAloneClose_OnCompleted(object sender, object e)
        {
            ToggleButtonMenu.IsChecked = false;
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
            MenuStoryBoardBack.Pause();
        }

        private void SearchAloneBack_OnCompleted(object sender, object e)
        {
            ToggleButtonSearch.IsChecked = false;
            SearchStoryBoardBack.Pause();
        }

        public static void CloseMenu()
        {
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
            story.Begin();
            toggle.IsChecked = false;
        }

        #endregion

        #region Method Bouttons

        private void GoToProfil()
        {
            Singleton.Singleton.Instance().ItsMe = true;
            SetChildren(new ProfilUser());
        }

        private void GoToNews()
        {
            SetChildren(new News());
        }

        private void GoToExplorer()
        {
            SetChildren(new Explorer());
        }

        private void GoToPacks()
        {
            SetChildren(new Packs());
        }

        private void GoToMondeMusical()
        {
            var locator = new Geolocator();
            if (locator.LocationStatus == PositionStatus.Disabled)
            {
                new MessageDialog("Veuillez activer votre Location").ShowAsync();
            }
            else
            {
                SetChildren(new GeolocalisationView());
            }
        }

        private void GoToBattle()
        {
            SetChildren(new BattleView());
        }

        private void GoToPlaylist()
        {
            //PlaylistAdd.Visibility = Visibility.Visible;
            SetChildren(new Playlist());
        }

        private void GoToAmis()
        {
            SetChildren(new MyNetwork());
        }

        private void GoToAbout()
        {
            SetChildren(new AboutView());
        }

        private void GoToAchat()
        {
            SetChildren(new CartsView());
        }

        private void GoToConnexionPage()
        {
            _navigationService.Navigate(typeof (Connexion));
        }

        public static void SetChildren(UIElement myObj)
        {
            //if (myObj.GetType() != typeof(Playlist))
            // PlaylistAdd.Visibility = Visibility.Collapsed;
            try
            {
                Singleton.Singleton.Instance().LastElement = MyGrid.Children.First();
                _lastElement = MyGrid.Children.LastOrDefault();
                MyGrid.Children.Clear();
                MyGrid.Children.Add(myObj);
                CloseMenu();
            }
            catch (Exception e)
            {
                new MessageDialog("Fail back").ShowAsync();
            }
        }

        public static void SetPlayerAudio()
        {
            PlayerButton = MyPlayerToggleButton;
            MyPlayerGrid.Children.Clear();
            MyPlayerGrid.Children.Add(new PlayerControl());
        }

        #endregion

        #region Methods Search

        private void SearchTextBlock_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            SearchText = SearchTextBlock.Text;
            if (SearchText != string.Empty)
                MakeTheSearch();
            else
                CleanResultList();
        }

        private async void MakeTheSearch()
        {
            var request = new HttpRequestGet();
            try
            {
                var list = (SearchResult) await request.Search(new SearchResult(), SearchText);
                if (list != null)
                {
                    MyResult = list;
                    DisplayResult();
                }
            }

            catch (Exception e)
            {
                Debug.WriteLine(e.Message);
            }
        }

        private void DisplayResult()
        {
            if (MyResult.artist != null)
            {
                ResultArtisteListView.Visibility = Visibility.Visible;
                ResultArtisteListView.ItemsSource = MyResult.artist;
            }
            if (MyResult.user != null)
            {
                ResultUserListView.Visibility = Visibility.Visible;
                ResultUserListView.ItemsSource = MyResult.user;
            }
            if (MyResult.album != null)
            {
                ResultAlbumListView.Visibility = Visibility.Visible;
                ResultAlbumListView.ItemsSource = MyResult.album;
            }
            if (MyResult.pack != null)
            {
                ResultPackListView.Visibility = Visibility.Visible;
                ResultPackListView.ItemsSource = MyResult.pack;
            }
            if (MyResult.music != null)
            {
                ResultMusicListView.Visibility = Visibility.Visible;
                ResultMusicListView.ItemsSource = MyResult.music;
            }
        }

        private void CleanResultList()
        {
            //ResultArtisteListView.ItemsSource = null;
            //ResultUserListView.ItemsSource = null;
            //ResultAlbumListView.ItemsSource = null;
            //ResultMusicListView.ItemsSource = null;
            //ResultPackListView.ItemsSource = null;
        }

        private void GlobalGrid_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            CloseMenu();
            ToggleButtonMenu.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
        }

        private void UsersStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            ProfilFriendViewModel.UserFromButton = SelectedUser;
            SetChildren(new ProfilFriendView());
        }

        private void MusicStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var get = new HttpRequestGet();
            ValidateKey.GetValideKey();
            var res = get.GetSecureObject(new Album(), "albums", SelectedMusic.album.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var album = tmp.Result as Album;
                if (album != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            album.imageAlbum =
                                new BitmapImage(new Uri(Constant.UrlImageAlbum + album.image, UriKind.RelativeOrAbsolute));
                            AlbumViewModel.MyAlbum = album;
                            SetChildren(new AlbumView());
                        });
                }
            });
        }

        private void AlbumStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            AlbumViewModel.MyAlbum = SelectedAlbum;
            var get = new HttpRequestGet();
            ValidateKey.GetValideKey();
            var res = get.GetSecureObject(new Album(), "albums", SelectedAlbum.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var album = tmp.Result as Album;
                if (album != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            album.imageAlbum =
                                new BitmapImage(new Uri(Constant.UrlImageAlbum + album.image, UriKind.RelativeOrAbsolute));
                            AlbumViewModel.MyAlbum = album;
                            SetChildren(new AlbumView());
                        });
                }
            });
        }

        private void ArtistStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var get = new HttpRequestGet();
            var res = get.GetObject(new User(), "users", SelectedArtist.id.ToString());
            res.ContinueWith(delegate(Task<object>tmp)
            {
                var user = tmp.Result as User;
                if (user != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            user.profilImage =
                                new BitmapImage(new Uri(Constant.UrlImageUser + user.image, UriKind.RelativeOrAbsolute));
                            ProfilArtisteViewModel.TheUser = user;
                            SetChildren(new ProfilArtiste());
                        });
                }
            });
        }

        private void PackStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            PackViewModel.ThePack = SelectedPack;
            SetChildren(new Packs());
        }

        #endregion

        #region Method Toggle

        private void ToggleButtonMenu_OnChecked(object sender, RoutedEventArgs e)
        {
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleCloseStyle"] as Style;
        }

        private void ToggleButtonMenu_OnUnchecked(object sender, RoutedEventArgs e)
        {
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
        }

        #endregion
    }
}