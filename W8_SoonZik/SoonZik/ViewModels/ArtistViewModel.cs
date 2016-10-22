using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Media.Imaging;

namespace SoonZik.ViewModels
{
    class ArtistViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<User> artistlist { get; set; }

        //static string url = "http://api.lvh.me:3000/";
        //static string url = "http://soonzikapi.herokuapp.com/";
        static string url = Singleton.Instance.url;


        private User _artist;
        public User artist
        {
            get { return _artist; }
            set
            {
                _artist = value;
                OnPropertyChanged("artist");
            }
        }

        public ObservableCollection<Album> list_album { get; set; }
        public ObservableCollection<Music> top_five { get; set; }

        private BitmapImage _user_img;
        public BitmapImage user_img
        {
            get { return _user_img; }
            set
            {
                _user_img = value;
                OnPropertyChanged("user_img");
            }
        }

        static public ObservableCollection<User> friends { get; set; }
        static public ObservableCollection<User> follows { get; set; }
        static public ObservableCollection<User> followers { get; set; }
        static public ObservableCollection<Tweet> tweets { get; set; }

        public ICommand do_add_follow
        {
            get;
            private set;
        }

        public ICommand do_remove_follow
        {
            get;
            private set;
        }


        private Visibility _add_follow_btn;
        public Visibility add_follow_btn
        {
            get { return _add_follow_btn; }
            set
            {
                _add_follow_btn = value;
                OnPropertyChanged("add_follow_btn");
            }
        }

        private Visibility _remove_follow_btn;
        public Visibility remove_follow_btn
        {
            get { return _remove_follow_btn; }
            set
            {
                _remove_follow_btn = value;
                OnPropertyChanged("remove_follow_btn");
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

        public ArtistViewModel()
        {
            load_artists();
        }


        public ArtistViewModel(int id)
        {
            add_follow_btn = Visibility.Visible;
            remove_follow_btn = Visibility.Visible;
            do_add_follow = new RelayCommand(add_follow);
            do_remove_follow = new RelayCommand(remove_follow);

            load_artist(id);

            get_friends(id);
            get_follows(id);
            get_follower(id);
            get_tweets(id);

        }

        async void load_artists()
        {
            Exception exception = null;
            artistlist = new ObservableCollection<User>();

            try
            {
                var albums = (List<User>)await Http_get.get_object(new List<User>(), "users");

                foreach (var item in albums)
                    artistlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des artistes").ShowAsync();
        }

        public async void load_artist(int id)
        {
            Exception exception = null;
            list_album = new ObservableCollection<Album>();
            top_five = new ObservableCollection<Music>();

            try
            {
                artist = await Http_get.get_user_by_id(id.ToString());
                user_img = new BitmapImage(new Uri(url + "assets/usersImage/avatars/" + artist.image, UriKind.RelativeOrAbsolute));

                var artist_info = (Artist_info)await Http_get.get_object(new Artist_info(), "users/" + id.ToString() + "/isartist");

                foreach (var item in artist_info.albums)
                    list_album.Add(item);
                foreach (var item in artist_info.topFive)
                    top_five.Add(item);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de l'artiste").ShowAsync();
        }

        public async void get_tweets(int id)
        {
            Exception exception = null;
            tweets = new ObservableCollection<Tweet>();

            try
            {
                var list = (List<Tweet>)await Http_get.get_object(new List<Tweet>(), "tweets/find?attribute[user_id]=" + id.ToString());

                foreach (var item in list)
                    tweets.Add(item);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des sweets de l'utilisateur").ShowAsync();
        }

        public async void get_friends(int id)
        {
            Exception exception = null;
            friends = new ObservableCollection<User>();

            try
            {
                var list = (List<User>)await Http_get.get_object(new List<User>(), "users/" + id.ToString() + "/friends");

                foreach (var item in list)
                    friends.Add(item);

            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des amis de l'utilisateur").ShowAsync();
        }

        async public void get_follows(int id)
        {
            Exception exception = null;
            follows = new ObservableCollection<User>();

            try
            {
                var list = (List<User>)await Http_get.get_object(new List<User>(), "users/" + id.ToString() + "/follows");

                foreach (var item in list)
                    follows.Add(item);

                //if (follows.Any(x => x.username == Singleton.Instance.Current_user.username))
                //    add_follow_btn = Visibility.Collapsed;
                //else
                //    remove_follow_btn = Visibility.Collapsed;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des follows de l'utilisateur").ShowAsync();
        }

        async public void get_follower(int id)
        {
            Exception exception = null;
            followers = new ObservableCollection<User>();

            try
            {
                var list = (List<User>)await Http_get.get_object(new List<User>(), "users/" + id.ToString() + "/followers");

                foreach (var item in list)
                    followers.Add(item);

                if (followers.Any(x => x.username == Singleton.Instance.Current_user.username))
                    add_follow_btn = Visibility.Collapsed;
                else
                    remove_follow_btn = Visibility.Collapsed;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des followers de l'utilisateur").ShowAsync();
        }

        public async void add_follow()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var follow = await Http_get.get_user_by_id(artist.id.ToString());
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&follow_id=" + follow.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/follow", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Created")
                {
                    //await new MessageDialog("Add follow OK").ShowAsync();
                    Singleton.Instance.Current_user.follows.Add(artist);
                    add_follow_btn = Visibility.Collapsed;
                    remove_follow_btn = Visibility.Visible;
                    followers.Add(Singleton.Instance.Current_user);
                }
                else
                    await new MessageDialog("Erreur lors du follow de l'utilisateur").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors du follow de l'utilisateur").ShowAsync();
        }

        public async void remove_follow()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&follow_id=" + artist.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/unfollow", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Success")
                {
                    //await new MessageDialog("Remove follow OK").ShowAsync();
                    Singleton.Instance.Current_user.follows.Remove(artist);
                    add_follow_btn = Visibility.Visible;
                    remove_follow_btn = Visibility.Collapsed;
                    followers.Remove(Singleton.Instance.Current_user);
                }
                else
                    await new MessageDialog("Erreur lors du unfollow de l'utilisateur").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors du unfollow de l'utilisateur").ShowAsync();
        }
    }
}
