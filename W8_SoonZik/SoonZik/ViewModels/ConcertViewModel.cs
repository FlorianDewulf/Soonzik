using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using Windows.UI.Popups;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using System.Net;
using Windows.UI.Xaml;
using System.ComponentModel;
using System.Windows.Input;
using SoonZik.Common;

namespace SoonZik.ViewModels
{
    class ConcertViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<Concert> concertlist { get; set; }
        public Concert selected_concert { get; set; }
        //public ICommand do_like
        //{
        //    get;
        //    private set;
        //}
        //public ICommand do_unlike
        //{
        //    get;
        //    private set;
        //}

        //private Visibility _like_btn;
        //public Visibility like_btn
        //{
        //    get { return _like_btn; }
        //    set
        //    {
        //        _like_btn = value;
        //        OnPropertyChanged("like_btn");
        //    }
        //}

        //private Visibility _unlike_btn;
        //public Visibility unlike_btn
        //{
        //    get { return _unlike_btn; }
        //    set
        //    {
        //        _unlike_btn = value;
        //        OnPropertyChanged("unlike_btn");
        //    }
        //}

        private int _likes;
        public int likes
        {
            get { return _likes; }
            set
            {
                _likes = value;
                OnPropertyChanged("likes");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public ConcertViewModel()
        {
            load_concert();
        }

        async void load_concert()
        {
            Exception exception = null;
            concertlist = new ObservableCollection<Concert>();

            try
            {
                var concert = (List<Concert>)await Http_get.get_object(new List<Concert>(), "concerts?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));

                foreach (var item in concert)
                {
                    item.do_like = new RelayCommand(like);
                    item.do_unlike = new RelayCommand(unlike);
                    if (item.hasLiked)
                    {
                        item.like_btn = Visibility.Collapsed;
                        item.unlike_btn = Visibility.Visible;
                    }
                    else
                    {
                        item.like_btn = Visibility.Visible;
                        item.unlike_btn = Visibility.Collapsed;
                    }
                    item.address = await geocode(item.address);
                    concertlist.Add(item);
                }
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des concerts").ShowAsync();
        }

        async public void like()
        {
            if (await LikeViewModel.like("Concerts", selected_concert.id.ToString()))
            {
                //selected_concert.li = Visibility.Collapsed;
                //selected_concert.unlike_btn = Visibility.Visible;
                //likes += 1;
            }
        }

        async public void unlike()
        {
            if (await LikeViewModel.unlike("Concerts", selected_concert.id.ToString()))
            {
                //like_btn = Visibility.Visible;
                //unlike_btn = Visibility.Collapsed;
                //likes -= 1;
            }
        }

        async Task<Address> geocode(Address addr)
        {
            HttpClient client = new HttpClient();
            Exception exception = null;

            string address = addr.numberStreet.ToString() + " " + addr.street + " " + addr.zipcode + " " + addr.city;
            string url = "http://maps.google.com/maps/api/geocode/json?address=" + WebUtility.UrlEncode(address);

            try
            {
                var data = await client.GetStringAsync(url);
                var result = JObject.Parse(data);

                var lat = result["results"][0]["geometry"]["location"]["lat"];
                var lng = result["results"][0]["geometry"]["location"]["lng"];

                addr.lat = lat.ToString().Replace(",", ".");
                addr.lng = lng.ToString().Replace(",", ".");
                addr.latt = Double.Parse(lat.ToString());
                addr.lngg = Double.Parse(lng.ToString());

                return addr;
            }
            catch (Exception e)
            {
                exception = e;
            }
            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des coordonnées des concerts").ShowAsync();
            return addr;
        }
    }
}
