using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.Devices.Geolocation;
using Windows.Foundation;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Controls.Maps;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class GeolocalisationViewModel : ViewModelBase
    {
        #region Ctor

        public GeolocalisationViewModel()
        {
            loader = new ResourceLoader();
            LoadedCommand = new RelayCommand(LoadedCommandExecute);
        }

        #endregion

        #region Method

        private void LoadedCommandExecute()
        {
            TwoChecked = new RelayCommand(TwoCheckedExecute);
            FiveChecked = new RelayCommand(FiveCheckedExecute);
            TenChecked = new RelayCommand(TenCheckedExecute);
            TwentyChecked = new RelayCommand(TwentyCheckedExecute);
            UserTappedCommand = new RelayCommand(UserTappedExecute);
            ConcertTappedCommand = new RelayCommand(ConcertTappedExecute);
            InitVariable().ContinueWith(delegate
            {
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                    () =>
                    {
                        ListMapIcons = new List<MapIcon>();
                        CreateListElement();
                    });
            });
        }


        private void CreateListElement()
        {
            try
            {
                var mapIcon = new MapIcon
                {
                    Location = new Geopoint(new BasicGeoposition
                    {
                        Latitude = UserLocation.Latitude,
                        Longitude = UserLocation.Longitude
                    }),
                    NormalizedAnchorPoint = new Point(0.5, 1.0),
                    Title = Singleton.Singleton.Instance().CurrentUser.username
                };

                ListMapIcons.Add(mapIcon);
                MapElements = new ObservableCollection<MapElement>();
                foreach (var icon in ListMapIcons)
                {
                    MapElements.Add(icon);
                }
            }
            catch (Exception)
            {
                new MessageDialog(loader.GetString("ErrorGeo")).ShowAsync();
            }

        }

        private void GetListeners(string range)
        {
            try
            {
                var reqGet = new HttpRequestGet();
                ListListeners = new ObservableCollection<Listenings>();
                ListUser = new ObservableCollection<User>();
                var listListeners = reqGet.GetListenerAroundMe(new List<Listenings>(), UserLocation.Latitude.ToString(),
                    UserLocation.Longitude.ToString(), range);
                listListeners.ContinueWith(delegate(Task<object> tmp)
                {
                    var res = tmp.Result as List<Listenings>;
                    if (res != null)
                    {
                        foreach (var item in res)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    ListListeners.Add(item);
                                    ListUser.Add(item.user);
                                });
                        }
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            AddMappElements);
                    }
                });
            }
            catch (Exception)
            {
                new MessageDialog(loader.GetString("WaitGeo")).ShowAsync();
            }

        }

        private void GetConcert()
        {
            var reqGet = new HttpRequestGet();
            ValidateKey.CheckValidateKey();
            ListConcerts = new ObservableCollection<Concerts>();
            var listConcerts = reqGet.GetListObjectSecure(new List<Concerts>(), "concerts", Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            listConcerts.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<Concerts>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { ListConcerts.Add(item); });
                    }
                }
            });
        }

        private async Task InitVariable()
        {
            GetConcert();
            _myGeolocator = new Geolocator();
            var myGeoposition = await _myGeolocator.GetGeopositionAsync();
            UserLocation = myGeoposition.Coordinate;
        }

        private void ConcertTappedExecute()
        {
            ConcertDetailViewModel.Concert = ConcertSelected;
            GlobalMenuControl.SetChildren(new ConcertDetail());
        }

        #region Command

        private void UserTappedExecute()
        {
            var request = new HttpRequestGet();
            var res = request.GetObject(new Music(), "musics", ListenningSelected.music.id.ToString());
            res.ContinueWith(delegate(Task<object> task)
            {
                var music = task.Result as Music;
                if (music != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            music.file = "http://soonzikapi.herokuapp.com/musics/get/" + music.id;
                            Singleton.Singleton.Instance().SelectedMusicSingleton.Clear();
                            Singleton.Singleton.Instance().SelectedMusicSingleton.Add(music);
                            GlobalMenuControl.MyPlayerToggleButton.IsChecked = true;
                            GlobalMenuControl.SetPlayerAudio();
                        });
                }
            });
        }

        private void TwentyCheckedExecute()
        {
            GetListeners("500");
            TwoKmActivated = false;
            FiveKmActivated = false;
            TenKmActivated = false;
        }

        private void TenCheckedExecute()
        {
            GetListeners("10");
            TwoKmActivated = false;
            FiveKmActivated = false;
            TwentyKmActivated = false;
        }

        private void FiveCheckedExecute()
        {
            GetListeners("5");
            TwoKmActivated = false;
            TenKmActivated = false;
            TwentyKmActivated = false;
        }

        private void TwoCheckedExecute()
        {
            GetListeners("2");

            FiveKmActivated = false;
            TenKmActivated = false;
            TwentyKmActivated = false;
        }

        private void AddMappElements()
        {
            CreateListElement();
            if (ListListeners != null)
            {
                foreach (var listener in ListListeners)
                {
                    var t = new MapIcon
                    {
                        Location = new Geopoint(new BasicGeoposition
                        {
                            Latitude = listener.latitude,
                            Longitude = listener.longitude
                        }),
                        NormalizedAnchorPoint = new Point(0.5, 1.0),
                        Title = listener.user.username
                    };
                    MapElements.Add(t);
                }
            }
        }

        #endregion

        #endregion

        #region Attribute

        public ResourceLoader loader;
        public List<MapIcon> ListMapIcons { get; set; }

        private ObservableCollection<MapElement> _mapElements;

        public ObservableCollection<MapElement> MapElements
        {
            get { return _mapElements; }
            set
            {
                _mapElements = value;
                RaisePropertyChanged("MapElements");
            }
        }

        private ObservableCollection<Concerts> _listConcerts;

        public ObservableCollection<Concerts> ListConcerts
        {
            get { return _listConcerts; }
            set
            {
                _listConcerts = value;
                RaisePropertyChanged("ListConcerts");
            }
        }

        private ObservableCollection<Listenings> _listListeners;

        public ObservableCollection<Listenings> ListListeners
        {
            get { return _listListeners; }
            set
            {
                _listListeners = value;
                RaisePropertyChanged("ListListeners");
            }
        }

        private ObservableCollection<User> _listUser;

        public ObservableCollection<User> ListUser
        {
            get { return _listUser; }
            set
            {
                _listUser = value;
                RaisePropertyChanged("ListUser");
            }
        }

        public Listenings ListenningSelected { get; set; }
        public User UserSelected { get; set; }
        public Concerts ConcertSelected { get; set; }

        public ICommand TwoChecked { get; private set; }
        public ICommand FiveChecked { get; private set; }
        public ICommand TenChecked { get; private set; }
        public ICommand TwentyChecked { get; private set; }
        public ICommand UserTappedCommand { get; private set; }
        public ICommand ConcertTappedCommand { get; private set; }
        public ICommand GetMap { get; private set; }
        public ICommand LoadedCommand { get; private set; }

        private Geolocator _myGeolocator;
        private Geocoordinate _userLocation;

        public Geocoordinate UserLocation
        {
            get { return _userLocation; }
            set
            {
                _userLocation = value;
                RaisePropertyChanged("UserLocation");
            }
        }

        private bool _twoKmActivated;

        public bool TwoKmActivated
        {
            get { return _twoKmActivated; }
            set
            {
                _twoKmActivated = value;
                RaisePropertyChanged("TwoKmActivated");
            }
        }

        private bool _fiveKmActivated;

        public bool FiveKmActivated
        {
            get { return _fiveKmActivated; }
            set
            {
                _fiveKmActivated = value;
                RaisePropertyChanged("FiveKmActivated");
            }
        }

        private bool _tenKmActivated;

        public bool TenKmActivated
        {
            get { return _tenKmActivated; }
            set
            {
                _tenKmActivated = value;
                RaisePropertyChanged("TenKmActivated");
            }
        }

        private bool _twentyKmActivated;

        public bool TwentyKmActivated
        {
            get { return _twentyKmActivated; }
            set
            {
                _twentyKmActivated = value;
                RaisePropertyChanged("TwentyKmActivated");
            }
        }

        #endregion
    }
}