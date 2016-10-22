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
    class UserViewModel : INotifyPropertyChanged
    {
        static string url = Singleton.Instance.url;
        //static string url = "http://api.lvh.me:3000/";
        //static string url = "http://soonzikapi.herokuapp.com/";


        private User _user;
        public User user
        {
            get { return _user; }
            set
            {
                _user = value;
                OnPropertyChanged("user");
            }
        }

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
        static public ObservableCollection<Tweet> tweets { get; set; }

        public ObservableCollection<Message> msg_list { get; set; }

        private string _msg;
        public string msg
        {
            get { return _msg; }
            set
            {
                _msg = value;
                OnPropertyChanged("msg");
            }
        }

        public ICommand do_send_msg
        {
            get;
            private set;
        }
        public ICommand do_add_friend
        {
            get;
            private set;
        }

        public ICommand do_remove_friend
        {
            get;
            private set;
        }


        private Visibility _add_friend_btn;
        public Visibility add_friend_btn
        {
            get { return _add_friend_btn; }
            set
            {
                _add_friend_btn = value;
                OnPropertyChanged("add_friend_btn");
            }
        }

        private Visibility _remove_friend_btn;
        public Visibility remove_friend_btn
        {
            get { return _remove_friend_btn; }
            set
            {
                _remove_friend_btn = value;
                OnPropertyChanged("remove_friend_btn");
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

        public UserViewModel(int id)
        {
            add_friend_btn = Visibility.Visible;
            remove_friend_btn = Visibility.Visible;
            do_add_friend = new RelayCommand(add_friend);
            do_remove_friend = new RelayCommand(remove_friend);
            do_send_msg = new RelayCommand(send_msg);

            load_user(id);

            get_friends(id);
            get_follows(id);
            get_tweets(id);
        }

        public async void load_user(int id)
        {
             Exception exception = null;

            try
            {
                user = await Http_get.get_user_by_id(id.ToString());
                user_img = new BitmapImage(new Uri(url + "assets/usersImage/avatars/" + user.image, UriKind.RelativeOrAbsolute));
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération de l'utilisateur").ShowAsync();
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
            msg_list = new ObservableCollection<Message>();

            try
            {
                var list = (List<User>)await Http_get.get_object(new List<User>(), "users/" + id.ToString() + "/friends");

                foreach (var item in list)
                    friends.Add(item);

                if (friends.Any(x => x.username == Singleton.Instance.Current_user.username))
                {
                    add_friend_btn = Visibility.Collapsed;

                    // LOAD CONVERSATION
                    var messages = (List<Message>)await Http_get.get_object(new List<Message>(), "/messages/conversation/" + id.ToString() + "?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));

                    foreach (var item in messages)
                    {
                        if (item.user_id == Singleton.Instance.Current_user.id)
                            item.name = "Vous";
                        else
                            item.name = user.username;

                        msg_list.Add(item);
                        //msg_list.Insert(0, item);
                    }

                }
                else
                    remove_friend_btn = Visibility.Collapsed;
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
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des follows de l'utilisateur").ShowAsync();
        }

        public async void add_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var friend = await Http_get.get_user_by_id(user.id.ToString());
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&friend_id=" + friend.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/addfriend", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Created")
                {
                    //await new MessageDialog("Add friend OK").ShowAsync();
                    Singleton.Instance.Current_user.friends.Add(user);
                    add_friend_btn = Visibility.Collapsed;
                    remove_friend_btn = Visibility.Visible;
                    friends.Add(Singleton.Instance.Current_user);
                }
                else
                    await new MessageDialog("Erreur lors de l'ajout en ami de cet utilisateur").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de l'ajout en ami de cet utilisateur").ShowAsync();
        }

        public async void remove_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&friend_id=" + user.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/delfriend", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Success")
                {
                    //await new MessageDialog("Remove friend OK").ShowAsync();
                    Singleton.Instance.Current_user.friends.Remove(user);
                    add_friend_btn = Visibility.Visible;
                    remove_friend_btn = Visibility.Collapsed;
                    friends.Remove(Singleton.Instance.Current_user);
                }
                else
                    await new MessageDialog("Erreur lors de la suppression de cet ami de votre liste").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la suppression de cet ami de votre liste").ShowAsync();
        }

        public async void send_msg()
        {
            if (await ChatViewModel.send_msg(user.id, msg))
            {
                // ADD msg to list + reset msg
                var new_msg = new Message();
                new_msg.msg = msg;
                new_msg.name = "Vous";
                msg_list.Add(new_msg);
                msg = null;
            }

        }
    }
}
