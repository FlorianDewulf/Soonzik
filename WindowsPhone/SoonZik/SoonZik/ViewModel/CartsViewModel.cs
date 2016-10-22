using System;
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
using Newtonsoft.Json.Linq;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class CartsViewModel : ViewModelBase
    {
        #region Ctor

        public CartsViewModel()
        {
            LoadedCommand = new RelayCommand(Charge);

            MusicTappedCommand = new RelayCommand(MusicTappedExecute);
            AlbumTappedCommand = new RelayCommand(AlbumTappedExecute);
            DeleteCommand = new RelayCommand(DeleteCommandExecute);
            BuyCommand = new RelayCommand(BuyCommandExecute);
        }

        #endregion

        #region Attributes

        public double price;
        public ICommand BuyCommand { get; private set; }
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

        private ObservableCollection<Carts> _listCarts;

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

        public ICommand MusicTappedCommand { get; private set; }
        public ICommand AlbumTappedCommand { get; private set; }
        public ICommand DeleteCommand { get; private set; }

        public ICommand LoadedCommand { get; private set; }

        private string _totalPrice;

        public string TotalPrice
        {
            get { return _totalPrice; }
            set
            {
                _totalPrice = value;
                RaisePropertyChanged("TotalPrice");
            }
        }

        #endregion

        #region Methods

        private void Charge()
        {
            var loader = new ResourceLoader();
            price = 0.0;
            ListAlbum = new ObservableCollection<Album>();
            ListMusique = new ObservableCollection<Music>();
            _listCarts = new ObservableCollection<Carts>();

            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();
            var listCarts = request.GetItemFromCarts(new List<Carts>(), Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);

            listCarts.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Carts>;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        foreach (var cart in res)
                        {
                            _listCarts.Add(cart);
                            if (cart.albums != null)
                                foreach (var album in cart.albums)
                                {
                                    ListAlbum.Add(album);
                                    price += Double.Parse(album.price);
                                }
                            if (cart.musics != null)
                                foreach (var music in cart.musics)
                                {
                                    ListMusique.Add(music);
                                    price += Double.Parse(music.price);
                                }
                        }
                        TotalPrice = loader.GetString("Total") + price + loader.GetString("Euros");
                    });
                }
            });
        }

        #region Method Command

        private void AlbumTappedExecute()
        {
        }

        private void MusicTappedExecute()
        {
        }

        private async void BuyCommandExecute()
        {
            //var bn = new BuyNow("enduser_biz@gmail.com");
            //bn.UseSandbox = true;

            //if (ListAlbum.Count > 0)
            //{
            //    foreach (var album in ListAlbum)
            //    {
            //        var item =
            //            new ItemBuilder(album.title).Description(album.descriptions[0].description)
            //                .ID(album.id.ToString())
            //                .Price(album.price);
            //        bn.AddItem(item);
            //    }
            //}
            //if (ListMusique.Count > 0)
            //{
            //    foreach (var music in ListMusique)
            //    {
            //        var item =
            //            new ItemBuilder(music.title).Description(music.descriptions[0].description)
            //                .ID(music.id.ToString())
            //                .Price(music.price);
            //        bn.AddItem(item);
            //    }
            //}

            //// Attach event handlers. The BuyNow class emits 5 events
            //// start, auth, error, cancel and complete
            //bn.Start += new EventHandler<PayPal.Checkout.Event.StartEventArgs>((source, args) =>
            //{

            //});
            //bn.Auth += new EventHandler<PayPal.Checkout.Event.AuthEventArgs>((source, args) =>
            //{

            //});
            //bn.Complete += new EventHandler<PayPal.Checkout.Event.CompleteEventArgs>((source, args) =>
            //{
            //    var request = new HttpRequestGet();
            //    var post = new HttpRequestPost();
            //    _cryptographic = "";
            //    var userKey2 = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            //    userKey2.ContinueWith(delegate(Task<object> task2)
            //    {
            //        var key2 = task2.Result as string;
            //        if (key2 != null)
            //        {
            //            var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key2);
            //            _cryptographic =
            //                EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt + stringEncrypt);
            //        }
            //        var res = post.Purchase(_cryptographic, Singleton.Singleton.Instance().CurrentUser);
            //        res.ContinueWith(delegate(Task<string> tmp2)
            //        {
            //            var res2 = tmp2.Result;
            //            if (res2 != null)
            //            {
            //                var message = (ErrorMessage)JsonConvert.DeserializeObject(res2, typeof(ErrorMessage));
            //                if (message.code != 201)
            //                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
            //                        () => { new MessageDialog("Erreur lors du paiement").ShowAsync(); });
            //                else
            //                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
            //                        () => { new MessageDialog("paiement effectue").ShowAsync(); });

            //            }
            //        });
            //    });

            //});
            //bn.Cancel += new EventHandler<PayPal.Checkout.Event.CancelEventArgs>((source, args) =>
            //{

            //});
            //bn.Error += new EventHandler<PayPal.Checkout.Event.ErrorEventArgs>((source, args) =>
            //{

            //});
        }

        private void DeleteCommandExecute()
        {
            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();
            Carts cart = null;

            foreach (var item in _listCarts)
            {
                if (SelectedAlbum != null && (item.albums.Count > 0 && item.albums[0].id == SelectedAlbum.id))
                    cart = item;
                else if (SelectedMusic != null &&
                         (item.musics.Count > 0 && item.musics[0].id == SelectedMusic.id))
                    cart = item;
            }

            var resDel = request.DeleteFromCart(cart, Singleton.Singleton.Instance().SecureKey,
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
                            new MessageDialog("Article supprime").ShowAsync();
                            Charge();
                        }
                        else
                            new MessageDialog("Delete Fail code: " + stringJson).ShowAsync();
                    });
                }
            });
        }

        #endregion

        #endregion
    }
}