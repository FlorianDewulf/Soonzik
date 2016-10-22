using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;

namespace SoonZik.ViewModels
{
    class PackViewModel : INotifyPropertyChanged
    {
        private Pack _pack;
        public Pack pack
        {
            get { return _pack; }
            set
            {
                _pack = value;
                OnPropertyChanged("pack");
            }
        }

        public ObservableCollection<Album> album_list { get; set; }

        private int _amount;
        public int amount
        {
            get { return _amount; }
            set
            {
                _amount = value;
                OnPropertyChanged("amount");
            }
        }

        private string _offer_username;
        public string offer_username
        {
            get { return _offer_username; }
            set
            {
                _offer_username = value;
                OnPropertyChanged("offer_username");
            }
        }

        private int _artist;
        public int artist
        {
            get { return _artist; }
            set
            {
                _artist = value;
                OnPropertyChanged("artist");
            }
        }

        private int _association;
        public int association
        {
            get { return _association; }
            set
            {
                _association = value;
                OnPropertyChanged("association");

            }
        }

        private int _website;
        public int website
        {
            get { return _website; }
            set
            {
                _website = value;
                OnPropertyChanged("website");
            }
        }

        private string _txt_pp;
        public string txt_pp
        {
            get { return _txt_pp; }
            set
            {
                _txt_pp = value;
                OnPropertyChanged("txt_pp");
            }
        }

        public string pp_transac_id { get; set; }

        private double _cart_price;
        public double cart_price
        {
            get { return _cart_price; }
            set
            {
                _cart_price = value;
                OnPropertyChanged("cart_price");
            }
        }

        private Visibility _desc_fr_visibility;
        public Visibility desc_fr_visibility
        {
            get { return _desc_fr_visibility; }
            set
            {
                _desc_fr_visibility = value;
                OnPropertyChanged("desc_fr_visibility");
            }
        }

        private Visibility _desc_en_visibility;
        public Visibility desc_en_visibility
        {
            get { return _desc_en_visibility; }
            set
            {
                _desc_en_visibility = value;
                OnPropertyChanged("desc_en_visibility");
            }
        }

        public ICommand do_buy_pack
        {
            get;
            private set;
        }
        public ICommand do_offer_pack
        {
            get;
            private set;
        }


        //public Visibility visible;

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public PackViewModel(int id)
        {
            load_pack(id);
            desc_fr_visibility = Visibility.Visible;
            desc_en_visibility = Visibility.Visible;
            do_buy_pack = new RelayCommand(buy_pack);
            do_offer_pack = new RelayCommand(offer_pack);

            // SET DEFAULT VALUE FOR BUYING A PACK
            artist = 65;
            association = 20;
            website = 15;
        }

        async public void load_pack(int id)
        {
            Exception exception = null;

            try
            {
                album_list = new ObservableCollection<Album>();

                pack = await Http_get.get_pack_by_id(id);

                foreach (var item in pack.albums)
                {
                    item.image = Singleton.Instance.url + "/assets/albums/" + item.image;
                    album_list.Add(item);
                }

                // Detect current language and set visibility
                if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                    desc_en_visibility = Visibility.Collapsed;
                else
                    desc_fr_visibility = Visibility.Collapsed;

                // SET DESC if null to avoid crash ...
                if (pack.descriptions.Any())
                {
                    if (pack.descriptions[0].description == null)
                        pack.descriptions[0].description = "PAS DE DESCRIPTION DISPONIBLE";
                    if (pack.descriptions.Count == 2)
                        if (pack.descriptions[1].description == null)
                            pack.descriptions[1].description = "NO DESCRIPTION AVAILABLE";
                }

                //pack.begin_date = DateTime.ParseExact(pack.begin_date, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture).Date.ToString();
                //pack.end_date = DateTime.ParseExact(pack.end_date, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture).Date.ToString();
                //pack.end_date = "lol";
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération du pack").ShowAsync();
        }

        //async public void buy_pack() OLD
        //{
        //    Exception exception = null;
        //    var request = new Http_post();

        //    try
        //    {
        //        string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

        //        // NOT DONE -> FIND WHAT FUCK IT UP
        //        string pack_data =
        //            "user_id=" + Singleton.Instance.Current_user.id +
        //            "&secureKey=" + secureKey +
        //            "&pack_id=" + pack.id.ToString() +
        //            "&amount=" + amount.ToString() + 
        //            "&artist=" + artist.ToString() + 
        //            "&association=" + association.ToString() + 
        //            "&website=" + website.ToString();


        //        // HTTP_POST -> URL + DATA
        //        var response = await request.post_request("purchases/buypack", pack_data);

        //        var json = JObject.Parse(response).SelectToken("message");

        //        // NO CONTENT RETURNED WHEN OK
        //        if (json.ToString() == "Created")
        //            await new MessageDialog("Purchase PACK OK").ShowAsync();
        //        else
        //            await new MessageDialog(json.ToString(), "Purchase PACK KO").ShowAsync();
        //    }
        //    catch (Exception e)
        //    {
        //        exception = e;
        //    }

        //    if (exception != null)
        //        await new MessageDialog(exception.Message, "Purchase PACK error").ShowAsync();
        //}

        async public void buy_pack()
        {
            try
            {
                //PayPal.Checkout.BuyNow purchase = new PayPal.Checkout.BuyNow("test_sz_merchant@gmail.com");
                //PayPal.Checkout.BuyNow purchase = new PayPal.Checkout.BuyNow("test_sz_merchand_bis@gmail.com");
                PayPal.Checkout.BuyNow purchase = new PayPal.Checkout.BuyNow("florian.dewulf-facilitator@gmail.com");

                purchase.UseSandbox = true;

                purchase.Currency = "EUR";

                // Use the ItemBuilder to create a new example item
                PayPal.Checkout.ItemBuilder itemBuilder = new PayPal.Checkout.ItemBuilder("W8_PP")
                    .ID("W8_PP")
                    .Price(amount.ToString())
                    .Description(pack.title)
                    .Quantity(1);

                // Add the item to the purchase,
                purchase.AddItem(itemBuilder.Build());

                // Attach event handlers so you will be notified of important events
                // The BuyNow interface provides 5 events - Start, Auth, Cancel, Complete and Error
                // See http://paypal.github.io/Windows8SDK/csharp.html#Events for more
                purchase.Error += new EventHandler<PayPal.Checkout.Event.ErrorEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Une erreur est survenue lors du paiement." + eventArg.Message;
                });
                purchase.Auth += new EventHandler<PayPal.Checkout.Event.AuthEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Authentification: " + eventArg.Token;
                });
                purchase.Start += new EventHandler<PayPal.Checkout.Event.StartEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Chargement de PayPal...";
                });
                purchase.Complete += new EventHandler<PayPal.Checkout.Event.CompleteEventArgs>((source, eventArg) =>
                {
                    //buy_cart_after_pp_validation();
                    this.txt_pp = "Le paiement à été validé." + eventArg.TransactionID;
                    this.pp_transac_id = eventArg.TransactionID;
                    this.buy_cart_after_pp_validation();
                });
                purchase.Cancel += new EventHandler<PayPal.Checkout.Event.CancelEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Le paiement à été annulé par l'utilisateur.";
                });

                // Launch the secure PayPal interface. This is an asynchronous method
                await purchase.Execute();
            }
            catch (Exception Error)
            {
                new MessageDialog("Erreur lors de la connexion avec PayPal").ShowAsync();
            }
        } //buy_cart_after_pp_validation
        // buy pack debug
        async public void buy_cart_after_pp_validation()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string pack_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&pack_id=" + pack.id.ToString() +
                    "&amount=" + amount.ToString() +
                    "&artist=" + "65" + //artist.ToString() +
                    "&association=" + "20" + // association.ToString() +
                    "&website=" + "15" + //website.ToString() +
                    "&paypal[payment_id]=" + pp_transac_id;



                // HTTP_POST -> URL + DATA
                var response = await request.post_request("purchases/buypack", pack_data);
                //var json = JObject.Parse(response).SelectToken("message");

                //if (json.ToString() == "Created")
                //{
                await new MessageDialog("Achat du pack validé").ShowAsync();
                //}
                //else
                //    await new MessageDialog("Erreur lors de l'achat du pack").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de l'achat du pack").ShowAsync();
        }


        async public void offer_pack()
        {
            try
            {
                if (offer_username == "" || offer_username == null)
                {
                    await new MessageDialog("Entrez un pseudo").ShowAsync();
                    return;
                }

                var user_id = await Http_get.get_user_by_username(offer_username);

                if (user_id == null)
                {
                    await new MessageDialog("Entrez un pseudo existant.").ShowAsync();
                    return;
                }



                PayPal.Checkout.BuyNow purchase = new PayPal.Checkout.BuyNow("florian.dewulf-facilitator@gmail.com");
                purchase.UseSandbox = true;
                purchase.Currency = "EUR";

                PayPal.Checkout.ItemBuilder itemBuilder = new PayPal.Checkout.ItemBuilder("W8_PP")
                    .ID("W8_PP")
                    .Price(amount.ToString())
                    .Description(pack.title)
                    .Quantity(1);

                purchase.AddItem(itemBuilder.Build());

                purchase.Error += new EventHandler<PayPal.Checkout.Event.ErrorEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Une erreur est survenue lors du paiement." + eventArg.Message;
                });
                purchase.Auth += new EventHandler<PayPal.Checkout.Event.AuthEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Authentification: " + eventArg.Token;
                });
                purchase.Start += new EventHandler<PayPal.Checkout.Event.StartEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Chargement de PayPal...";
                });
                purchase.Complete += new EventHandler<PayPal.Checkout.Event.CompleteEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Le paiement à été validé." + eventArg.TransactionID;
                    this.pp_transac_id = eventArg.TransactionID;
                    this.offer_cart_after_pp_validation(user_id.id);
                });
                purchase.Cancel += new EventHandler<PayPal.Checkout.Event.CancelEventArgs>((source, eventArg) =>
                {
                    this.txt_pp = "Le paiement à été annulé par l'utilisateur.";
                });

                // Launch the secure PayPal interface. This is an asynchronous method
                await purchase.Execute();
            }
            catch (Exception Error)
            {
                new MessageDialog("Erreur lors de la connexion avec PayPal").ShowAsync();
            }
        }

        async public void offer_cart_after_pp_validation(int id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string pack_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&pack_id=" + pack.id.ToString() +
                    "&amount=" + amount.ToString() +
                    "&artist=" + "65" + //artist.ToString() +
                    "&association=" + "20" + // association.ToString() +
                    "&website=" + "15" + //website.ToString() +
                    "&paypal[payment_id]=" + pp_transac_id +
                    "&gift_user_id=" + id;

                // HTTP_POST -> URL + DATA
                var response = await request.post_request("purchases/buypack", pack_data);
                //var json = JObject.Parse(response).SelectToken("message");

                //if (json.ToString() == "Created")
                //{
                await new MessageDialog("Offre du pack validé").ShowAsync();
                //}
                //else
                //    await new MessageDialog("Erreur lors de l'achat du pack").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de l'offre du pack").ShowAsync();
        }

    }

}

