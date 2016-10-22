using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using System.Windows.Input;
using Newtonsoft.Json.Linq;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.ViewModels.Command;
using System.Collections.ObjectModel;

namespace SoonZik.ViewModels
{
    class UserEditViewModel : INotifyPropertyChanged
    {
        private User _edit_user;
        public User edit_user
        {
            get { return _edit_user; }
            set
            {
                _edit_user = value;
                OnPropertyChanged("edit_user");
            }
        }

        public ObservableCollection<User> friends { get; set; }
        public ObservableCollection<User> follows { get; set; }

        //private User _selected_user;
        public User selected_user { get; set; }
        //{
        //    get { return _selected_user; }
        //    set
        //    {
        //        _SelectedUser = value;
        //        OnPropertyChanged("selected_user");
        //    }
        //}

        private string _passwd;
        public string passwd
        {
            get { return _passwd; }
            set
            {
                _passwd = value;
                OnPropertyChanged("passwd");
            }
        }

        private string _passwd_verif;
        public string passwd_verif
        {
            get { return _passwd_verif; }
            set
            {
                _passwd_verif = value;
                OnPropertyChanged("passwd_verif");
            }
        }

        // new friend's username
        private string _new_friend;
        public string new_friend
        {
            get { return _new_friend; }
            set
            {
                _new_friend = value;
                OnPropertyChanged("new_friend");
            }
        }

        // new follow username
        private string _new_follow;
        public string new_follow
        {
            get { return _new_follow; }
            set
            {
                _new_follow = value;
                OnPropertyChanged("new_follow");
            }
        }
        public ICommand do_update_user
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
        public ICommand do_follow
        {
            get;
            private set;
        }
        public ICommand do_unfollow
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

        public UserEditViewModel()
        {
            edit_user = Singleton.Instance.Current_user;
            if (edit_user.address == null)
                edit_user.address = new Address();
            friends = new ObservableCollection<User>(edit_user.friends);
            follows = new ObservableCollection<User>(edit_user.follows);

            do_add_friend = new AddFriendCommand(this);
            do_remove_friend = new RemoveFriendCommand(this);
            do_follow = new FollowCommand(this);
            do_unfollow = new UnfollowCommand(this);
            do_update_user = new EditUserCommand(this);
        }

        public async void update_user()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string user_data =
                        "&user_id=" + Singleton.Instance.Current_user.id.ToString() +
                        "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()) +
                        "&user[username]=" + edit_user.username +
                        "&user[email]=" + edit_user.email +
                        "&user[password]=" + passwd +
                        "&user[language]=" + edit_user.language +
                        "&user[birthday]=" + edit_user.birthday +
                        "&user[fname]=" + edit_user.fname +
                        "&user[lname]=" + edit_user.lname +
                        "&user[phoneNumber]=" + edit_user.phoneNumber +
                        "&user[description]=" + edit_user.description;


                if (check_addr(edit_user.address))
                    user_data +=
                        "&address[numberStreet]=" + edit_user.address.numberStreet +
                        "&address[street]=" + edit_user.address.street +
                        "&address[zipcode]=" + edit_user.address.zipcode +
                        "&address[city]=" + edit_user.address.city +
                        "&address[country]=" + edit_user.address.country +
                        "&address[complement]=" + edit_user.address.complement;

                var response = await request.post_request("users/update", user_data);

                var json = JObject.Parse(response).SelectToken("message");
                var json1 = JObject.Parse(response).SelectToken("content");

                // Debug
                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Mise à jour du profil réussie").ShowAsync();
                    Singleton.Instance.Current_user = edit_user;
                }
                else
                    await new MessageDialog("Erreur lors de la mise à jour du profil").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la mise à jour du profil").ShowAsync();
        }

        public async void add_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var friend = await Http_get.get_user_by_username(new_friend);
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
                    // To save current user state
                    Singleton.Instance.Current_user.friends.Add(friend);
                    // To update UI (observableCollection)
                    friends.Add(friend);
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

        public async void follow()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var follow = await Http_get.get_user_by_username(new_follow);
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&follow_id=" + follow.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/follow", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Created")
                {
                    //await new MessageDialog("Follow OK").ShowAsync();
                    Singleton.Instance.Current_user.follows.Add(follow);
                    follows.Add(follow);

                }
                else
                    await new MessageDialog("Erreur lors du follow de cet utilisateur").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors du follow de cet utilisateur").ShowAsync();
        }

        public async void remove_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&friend_id=" + selected_user.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/delfriend", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Success")
                {
                    //await new MessageDialog("Remove friend OK").ShowAsync();
                    Singleton.Instance.Current_user.friends.Remove(selected_user);
                    friends.Remove(selected_user);
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

        public async void unfollow()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&follow_id=" + selected_user.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/unfollow", post_data);
                var json = JObject.Parse(response).SelectToken("message");
                // Debug
                if (json.ToString() == "Success")
                {
                    //await new MessageDialog("Unfollow OK").ShowAsync();
                    Singleton.Instance.Current_user.follows.Remove(selected_user);
                    follows.Remove(selected_user);
                }
                else
                    await new MessageDialog("Erreur lors du unfollow de l'utilisateur").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors du unfollow de l'utilisateur").ShowAsync();
        }

        bool check_addr(Address addr)
        {
            if (addr == null)
                return false;
            if (addr.city == null || addr.complement == null || addr.country == null ||
                addr.numberStreet == null || addr.street == null || addr.zipcode == null)
            {
                // To reset addr (delete / new)
                edit_user.address = null;
                edit_user.address = new Address();
                return false;
            }
            return true;
        }
    }
}
