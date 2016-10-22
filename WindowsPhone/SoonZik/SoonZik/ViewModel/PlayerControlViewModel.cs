using System;
using System.Windows.Input;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class PlayerControlViewModel : ViewModelBase
    {
        #region Ctor

        public PlayerControlViewModel()
        {
            PlayerLoaded = new RelayCommand(PlayerLoadedExecute);
            RewindCommand = new RelayCommand(RewindExecute);
            ForwardCommand = new RelayCommand(ForwardExecute);
            PlayCommand = new RelayCommand(PlayExecute); 
            TimerCommand = new RelayCommand(TimerCommandExecute);
            MediaElementObject = new MediaElement();
            MediaElementObject.MediaOpened += MediaElementObjectOnMediaOpened;
            MediaElementObject.MediaEnded += MediaElementObjectOnMediaEnded;
        }

        #endregion

        #region Attribute

        private double _time;

        public double Time
        {
            get { return _time;}
            set
            {
                _time = value;
                RaisePropertyChanged("Time");
            }
            
        }
        private DispatcherTimer dispatcherTimer;
        private static PlayerControlViewModel _instance;

        public static PlayerControlViewModel Instance()
        {
            if (_instance == null)
            {
                _instance = new PlayerControlViewModel();
            }
            return _instance;
        }

        private bool IsPlaylist;

        public ICommand TimerCommand { get; private set; }
        public ICommand PlayCommand { get; private set; }
        public ICommand ForwardCommand { get; private set; }
        public ICommand RewindCommand { get; private set; }
        public ICommand PlayerLoaded { get; private set; }

        public static Music StaticCurrentMusic { get; set; }

        private Music _currentMusic;
        private int _indexCurentMusic;

        public Music CurrentMusic
        {
            get { return _currentMusic; }
            set
            {
                _currentMusic = value;
                RaisePropertyChanged("CurrentMusic");
            }
        }

        private MediaElement _mediaElementObject;

        public MediaElement MediaElementObject
        {
            get { return _mediaElementObject; }
            set
            {
                _mediaElementObject = value;
                RaisePropertyChanged("MediaElementObject");
            }
        }

        private string _titleTrack;

        public string TitleTrack
        {
            get { return _titleTrack; }
            set
            {
                _titleTrack = value;
                RaisePropertyChanged("TitleTrack");
            }
        }

        private string _artistName;

        public string ArtisteName
        {
            get { return _artistName; }
            set
            {
                _artistName = value;
                RaisePropertyChanged("ArtisteName");
            }
        }

        private BitmapImage _musicImage;

        public BitmapImage MusiqueImage
        {
            get { return _musicImage; }
            set
            {
                _musicImage = value;
                RaisePropertyChanged("MusiqueImage");
            }
        }

        private BitmapImage _playImage;

        public BitmapImage PlayImage
        {
            get { return _playImage; }
            set
            {
                _playImage = value;
                RaisePropertyChanged("PlayImage");
            }
        }

        #endregion

        #region Method

        private void ForwardExecute()
        {
            if (IsPlaylist)
            {
                if (_indexCurentMusic == Singleton.Singleton.Instance().SelectedMusicSingleton.Count - 1)
                    _indexCurentMusic = 0;
                else
                    _indexCurentMusic += 1;
                CurrentMusic = Singleton.Singleton.Instance().SelectedMusicSingleton[_indexCurentMusic];
                StaticCurrentMusic = CurrentMusic;
                SetMediaInfo();
                MediaElementObject.Source = new Uri(CurrentMusic.file, UriKind.RelativeOrAbsolute);
            }
            else
            {
                PlayImage =
                    new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                MediaElementObject.Stop();
            }
        }

        private void RewindExecute()
        {
            if (IsPlaylist)
            {
                if (_indexCurentMusic == 0)
                    _indexCurentMusic = Singleton.Singleton.Instance().SelectedMusicSingleton.Count - 1;
                else
                    _indexCurentMusic -= 1;
                CurrentMusic = Singleton.Singleton.Instance().SelectedMusicSingleton[_indexCurentMusic];
                StaticCurrentMusic = CurrentMusic;
                SetMediaInfo();
                MediaElementObject.Source = new Uri(CurrentMusic.file, UriKind.RelativeOrAbsolute);
            }
            else
            {
                MediaElementObject.Source = new Uri(CurrentMusic.file, UriKind.RelativeOrAbsolute);
                MediaElementObject.Play();
            }
        }

        private void PlayExecute()
        {
            if (MediaElementObject.CurrentState == MediaElementState.Playing)
            {
                MediaElementObject.Pause();
                PlayImage =
                    new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
            }
            else
            {
                if (dispatcherTimer == null)
                {
                    dispatcherTimer = new DispatcherTimer();
                    dispatcherTimer.Tick += DispatcherTimerOnTick;
                    dispatcherTimer.Interval = new TimeSpan(0, 0, 1);
                    dispatcherTimer.Start();
                }
                else 
                {
                    dispatcherTimer.Start();
                }
                PlayImage =
                    new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/pause.png", UriKind.RelativeOrAbsolute));
                MediaElementObject.Play();
            }
        }
        
        private void TimerCommandExecute()
        {
            var test = Time;
            TimeSpan now = new TimeSpan(0,0,0,(int)Time);
            MediaElementObject.Position = now;
        }

        private void PlayerLoadedExecute()
        {
            try
            {

                //MediaElementObject = new MediaElement();
                MediaInfo();
            }
            catch (Exception e)
            {
            }
        }

        private void DispatcherTimerOnTick(object sender, object e)
        {
            Time = MediaElementObject.Position.Seconds;
        }

        private void MediaInfo()
        {
            _indexCurentMusic = 0;
            CurrentMusic = Singleton.Singleton.Instance().SelectedMusicSingleton[_indexCurentMusic];
            StaticCurrentMusic = CurrentMusic;
            SetMediaInfo();
            IsPlaylist = Singleton.Singleton.Instance().SelectedMusicSingleton.Count > 1;
            MediaElementObject.Stop();
            if (MediaElementObject.Source != null)
            {
                MediaElementObject.Source = new Uri(CurrentMusic.file, UriKind.Absolute);
            }
            else
            {
                MediaElementObject.Source = new Uri(CurrentMusic.file, UriKind.Absolute);
            }
            PlayImage =
                new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/pause.png", UriKind.RelativeOrAbsolute));
        }

        private void MediaElementObjectOnMediaEnded(object sender, RoutedEventArgs routedEventArgs)
        {
            if (IsPlaylist)
            {
                if (_indexCurentMusic == Singleton.Singleton.Instance().SelectedMusicSingleton.Count - 1)
                    _indexCurentMusic = 0;
                else
                    _indexCurentMusic += 1;
                CurrentMusic = Singleton.Singleton.Instance().SelectedMusicSingleton[_indexCurentMusic];
                StaticCurrentMusic = CurrentMusic;
                SetMediaInfo();
                MediaElementObject.Source = new Uri(CurrentMusic.file, UriKind.Absolute);
                GlobalMenuControl.MyPlayerToggleButton.Content = CurrentMusic.title;
            }
            else
            {
                PlayImage =
                    new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                MediaElementObject.Stop();
            }
        }

        private void MediaElementObjectOnMediaOpened(object sender, RoutedEventArgs routedEventArgs)
        {
            MediaElementObject.Play(); 
            dispatcherTimer = new DispatcherTimer();
            dispatcherTimer.Tick += DispatcherTimerOnTick;
            dispatcherTimer.Interval = new TimeSpan(0, 0, 1);
            dispatcherTimer.Start();
        }

        private void SetMediaInfo()
        {
            TitleTrack = CurrentMusic.title;
            ArtisteName = CurrentMusic.user.username;
            MusiqueImage =
                new BitmapImage(new Uri(Constant.UrlImageAlbum + CurrentMusic.album.image, UriKind.RelativeOrAbsolute));
        }

        #endregion
    }
}