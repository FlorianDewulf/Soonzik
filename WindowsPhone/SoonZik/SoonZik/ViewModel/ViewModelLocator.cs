/*
  In App.xaml:
  <Application.Resources>
      <vm:ViewModelLocator xmlns:vm="clr-namespace:SoonZik"
                           x:Key="Locator" />
  </Application.Resources>
  
  In the View:
  DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"

  You can also use Blend to do all this with the tool's support.
  See http://www.galasoft.ch/mvvm
*/

using GalaSoft.MvvmLight.Ioc;
using GalaSoft.MvvmLight.Views;
using Microsoft.Practices.ServiceLocation;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    /// <summary>
    ///     This class contains static references to all the view models in the
    ///     application and provides an entry point for the bindings.
    /// </summary>
    public class ViewModelLocator
    {
        /// <summary>
        ///     Initializes a new instance of the ViewModelLocator class.
        /// </summary>
        public ViewModelLocator()
        {
            ServiceLocator.SetLocatorProvider(() => SimpleIoc.Default);
            SimpleIoc.Default.Register<INavigationService>(() => new NavigationService());

            SimpleIoc.Default.Register<MainViewModel>();
            SimpleIoc.Default.Register<ConnexionViewModel>();
            SimpleIoc.Default.Register<NewsViewModel>();
            SimpleIoc.Default.Register<PackViewModel>();
            SimpleIoc.Default.Register<ProfilUserViewModel>();
            SimpleIoc.Default.Register<ProfilArtisteViewModel>();
            SimpleIoc.Default.Register<BattleViewModel>();
            SimpleIoc.Default.Register<MyNetworkViewModel>();
            SimpleIoc.Default.Register<ConversationViewModel>();
            SimpleIoc.Default.Register<MainPageViewModel>();
            SimpleIoc.Default.Register<ExplorerViewModel>();
            SimpleIoc.Default.Register<NewsDetailViewModel>();
            SimpleIoc.Default.Register<ProfilFriendViewModel>();
            SimpleIoc.Default.Register<AlbumViewModel>();
            SimpleIoc.Default.Register<GeolocalisationView>();
            SimpleIoc.Default.Register<MyMusicViewModel>();
            SimpleIoc.Default.Register<InscriptionViewModel>();
            SimpleIoc.Default.Register<BattleDetailViewModel>();
            SimpleIoc.Default.Register<CartsViewModel>();
            SimpleIoc.Default.Register<PlaylistViewModel>();
            SimpleIoc.Default.Register<AboutViewModel>();
            SimpleIoc.Default.Register<PlayerControlViewModel>();
            SimpleIoc.Default.Register<PriceControlViewModel>();
            SimpleIoc.Default.Register<GenreViewModel>();
            SimpleIoc.Default.Register<ConcertDetailViewModel>();
        }

        public ConcertDetailViewModel ConcertDetail
        {
            get { return ServiceLocator.Current.GetInstance<ConcertDetailViewModel>(); }
        }

        public GenreViewModel GenreView
        {
            get { return ServiceLocator.Current.GetInstance<GenreViewModel>(); }
        }

        public PriceControlViewModel PriceControl
        {
            get { return ServiceLocator.Current.GetInstance<PriceControlViewModel>(); }
        }

        public PlayerControlViewModel PlayerControl
        {
            get { return ServiceLocator.Current.GetInstance<PlayerControlViewModel>(); }
        }

        public MainViewModel Main
        {
            get { return ServiceLocator.Current.GetInstance<MainViewModel>(); }
        }

        public ConnexionViewModel Connexion
        {
            get { return ServiceLocator.Current.GetInstance<ConnexionViewModel>(); }
        }

        public NewsViewModel News
        {
            get { return ServiceLocator.Current.GetInstance<NewsViewModel>(); }
        }

        public PackViewModel Pack
        {
            get { return ServiceLocator.Current.GetInstance<PackViewModel>(); }
        }

        public ProfilUserViewModel ProfilUser
        {
            get { return ServiceLocator.Current.GetInstance<ProfilUserViewModel>(); }
        }

        public ProfilArtisteViewModel ProfilArtiste
        {
            get { return ServiceLocator.Current.GetInstance<ProfilArtisteViewModel>(); }
        }

        public BattleViewModel Battle
        {
            get { return ServiceLocator.Current.GetInstance<BattleViewModel>(); }
        }

        public MyNetworkViewModel Friend
        {
            get { return ServiceLocator.Current.GetInstance<MyNetworkViewModel>(); }
        }

        public ConversationViewModel Conversation
        {
            get { return ServiceLocator.Current.GetInstance<ConversationViewModel>(); }
        }

        public MainPageViewModel MainPage
        {
            get { return ServiceLocator.Current.GetInstance<MainPageViewModel>(); }
        }

        public ExplorerViewModel Explorer
        {
            get { return ServiceLocator.Current.GetInstance<ExplorerViewModel>(); }
        }

        public NewsDetailViewModel NewsDetail
        {
            get { return ServiceLocator.Current.GetInstance<NewsDetailViewModel>(); }
        }

        public ProfilFriendViewModel ProfilFriend
        {
            get { return ServiceLocator.Current.GetInstance<ProfilFriendViewModel>(); }
        }

        public AlbumViewModel AlbumView
        {
            get { return ServiceLocator.Current.GetInstance<AlbumViewModel>(); }
        }

        public GeolocalisationView GeolocView
        {
            get { return ServiceLocator.Current.GetInstance<GeolocalisationView>(); }
        }

        public MyMusicViewModel PlaylistView
        {
            get { return ServiceLocator.Current.GetInstance<MyMusicViewModel>(); }
        }

        public InscriptionViewModel InscriptionView
        {
            get { return ServiceLocator.Current.GetInstance<InscriptionViewModel>(); }
        }

        public BattleDetailViewModel BattleDetail
        {
            get { return ServiceLocator.Current.GetInstance<BattleDetailViewModel>(); }
        }

        public CartsViewModel Carts
        {
            get { return ServiceLocator.Current.GetInstance<CartsViewModel>(); }
        }

        public PlaylistViewModel Playlist
        {
            get { return ServiceLocator.Current.GetInstance<PlaylistViewModel>(); }
        }

        public AboutViewModel About
        {
            get { return ServiceLocator.Current.GetInstance<AboutViewModel>(); }
        }

        public static void Cleanup()
        {
            // TODO Clear the ViewModels
        }
    }
}