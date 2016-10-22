using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class TweetViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<Tweet> tweetlist { get; set; }
        public ObservableCollection<User> userlist { get; set; }

        private string _message;
        public string message
        {
            get { return _message; }
            set
            {
                _message = value;
                OnPropertyChanged("message");
            }
        }

        public ICommand do_send_tweet
        {
            get;
            private set;
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

        public TweetViewModel()
        {
            do_send_tweet = new RelayCommand(send_tweets);
            load_all_tweets();
            load_users();
        }

        async static public Task<List<Tweet>> load_flux_tweets()
        {
            Exception exception = null;
            //ObservableCollection<Tweet> tweetlist = new ObservableCollection<Tweet>();

            try
            {
                var tweets = (List<Tweet>)await Http_get.get_object(new List<Tweet>(), "tweets/flux?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));

                //foreach (var item in tweets)
                //    tweetlist.Insert(0, item); // LAST ON TOP
                //return tweetlist;
                return tweets;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération du flux de sweets").ShowAsync();
            return null;
        }

        //async static public Task<ObservableCollection<Tweet>> load_all_tweets() ---> OLD
        async public void load_all_tweets()
        {
            Exception exception = null;
            tweetlist = new ObservableCollection<Tweet>();

            try
            {
                var tweets = (List<Tweet>)await Http_get.get_object(new List<Tweet>(), "tweets");

                foreach (var item in tweets)
                    tweetlist.Insert(0, item); // To have the last tweet on top
                    //tweetlist.Add(item);
                //return tweetlist;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des sweets").ShowAsync();
            //return null;
        }

        // public async Task<bool> send_tweets()
        public async void send_tweets()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string tweet_data = "tweet[user_id]=" + Singleton.Instance.Current_user.id.ToString() +
                                    "&tweet[msg]=" + WebUtility.UrlEncode(message) +
                                    "&user_id=" + Singleton.Instance.Current_user.id.ToString() +
                                    "&secureKey=" + secureKey;

                // HTTP_POST -> URL + DATA
                var response = await request.post_request("tweets/save", tweet_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    Tweet new_tweet = new Tweet();
                    new_tweet.user = Singleton.Instance.Current_user;
                    new_tweet.msg = message;

                    tweetlist.Insert(0, new_tweet); // new tewwt on top

                    //tweetlist.Add(new_tweet);
                    message = "";
                    //await new MessageDialog("Tweet SEND").ShowAsync();
                    //return true;
                }
                else
                    await new MessageDialog("Erreur lors de l'envoi du sweet").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de l'envoi du sweet").ShowAsync();
            //return false;
        }

        async public void load_users()
        {
            Exception exception = null;
            userlist = new ObservableCollection<User>();

            try
            {
                var users = (List<User>)await Http_get.get_object(new List<User>(), "users");

                foreach (var item in users)
                {
                    item.image = Singleton.Instance.url + "/assets/usersImage/avatars/" + item.image;
                    userlist.Add(item);
                }
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération des utilisateurs").ShowAsync();
        }
    }
}
