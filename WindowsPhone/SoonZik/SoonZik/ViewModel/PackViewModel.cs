using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.UI.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class PackViewModel : ViewModelBase
    {
        #region ctor

        public PackViewModel()
        {
            ListArtistes = new ObservableCollection<User>();

            PackTappedCommand = new RelayCommand(ExecutePackTapped);
            AlbumTappedCommand = new RelayCommand(ExecuteAlbumTapped);
            ArtistTappedCommand = new RelayCommand(ExecuteArtistTapped);
            BuyCommand = new RelayCommand(ExecuteBuyCommand);
            Charge();

            if (ThePack != null)
            {
                SelectionCommand = new RelayCommand(SelectionExecute);
            }
        }

        #endregion

        #region attributes

        private User _friend;

        public User Friend
        {
            get { return _friend;}
            set
            {
                _friend = value;
                RaisePropertyChanged("Friend");
            }
        }

        private ObservableCollection<User> _listFriend;

        public ObservableCollection<User> ListFriend
        {
            get { return _listFriend;}
            set
            {
                _listFriend = value;
                RaisePropertyChanged("ListFriend");
            }
        }

        private List<Album> _listAlbums;
        private Album _selectedAlbum;

        public ObservableCollection<Pack> CompleteListPack { get; set; }
        public static Pack ThePack { get; set; }

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

        public Album SelectedAlbum
        {
            get { return _selectedAlbum; }
            set
            {
                _selectedAlbum = value;
                RaisePropertyChanged("SelectedAlbum");
            }
        }

        public List<Album> ListAlbums
        {
            get { return _listAlbums; }
            set
            {
                _listAlbums = value;
                RaisePropertyChanged("ListAlbums");
            }
        }

        public ICommand SelectionCommand { get; private set; }

        public RelayCommand PackTappedCommand { get; private set; }
        public RelayCommand AlbumTappedCommand { get; private set; }
        public RelayCommand ArtistTappedCommand { get; private set; }
        public RelayCommand BuyCommand { get; private set; }

        private ObservableCollection<User> _listArtistes;

        public ObservableCollection<User> ListArtistes
        {
            get { return _listArtistes; }
            set
            {
                _listArtistes = value;
                RaisePropertyChanged("ListArtistes");
            }
        }

        private Pack _myPack;

        public Pack MyPack
        {
            get { return _myPack; }
            set
            {
                _myPack = value;
                RaisePropertyChanged("MyPack");
            }
        }

        #endregion

        #region Method

        private void ExecuteBuyCommand()
        {
            if (ThePack != null)
            {
                PriceControlViewModel.SelecetdPack = ThePack;
                PriceControlViewModel.Friend = Friend;
                GlobalMenuControl.MyGrid.Children.Clear();
                GlobalMenuControl.MyGrid.Children.Add(new PriceControl());
            }
            else
            {
                var loader = new ResourceLoader();
                new MessageDialog(loader.GetString("PackError")).ShowAsync();
            }
        }

        private void SelectionExecute()
        {
            Charge();
        }

        private void ExecutePackTapped()
        {
            MyPack = ThePack;
            ListAlbums = ThePack.albums;
            foreach (var album in ListAlbums)
            {
                ListArtistes.Add(album.user);
            }
        }

        private void ExecuteAlbumTapped()
        {
            AlbumViewModel.MyAlbum = SelectedAlbum;
            GlobalMenuControl.MyGrid.Children.Clear();
            GlobalMenuControl.MyGrid.Children.Add(new AlbumView());
        }

        private void ExecuteArtistTapped()
        {
            ProfilArtisteViewModel.TheUser = TheArtiste;
            GlobalMenuControl.MyGrid.Children.Clear();
            GlobalMenuControl.MyGrid.Children.Add(new ProfilArtiste());
        }

        public void Charge()
        {
            ListFriend = new ObservableCollection<User>();
            ListFriend = Singleton.Singleton.Instance().CurrentUser.friends;
            var request = new HttpRequestGet();
            var ListPack = request.GetListObject(new List<Pack>(), "packs");
            CompleteListPack = new ObservableCollection<Pack>();
            ListPack.ContinueWith(delegate(Task<object> obj)
            {
                var res = obj.Result as List<Pack>;
                if (res != null)
                {
                    foreach (var pack in res)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { CompleteListPack.Add(pack); });
                    }
                }
            });
        }

        #endregion
    }
}