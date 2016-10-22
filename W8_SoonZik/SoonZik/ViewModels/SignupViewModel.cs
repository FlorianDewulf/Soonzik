using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.ViewModels.Command;
using System.ComponentModel;
using System.Windows.Input;
using SoonZik.Tools;
using Newtonsoft.Json.Linq;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;


namespace SoonZik.ViewModels
{
    class SignupViewModel : INotifyPropertyChanged
    {
        private User _new_user;
        public User new_user
        {
            get { return _new_user; }
            set
            {
                _new_user = value;
                OnPropertyChanged("new_user");
            }
        }

        private Address _new_user_addr;
        public Address new_user_addr
        {
            get { return _new_user_addr; }
            set
            {
                _new_user_addr = value;
                OnPropertyChanged("new_user_addr");
            }
        }

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

        public int check_addr_nb;
        public DateTimeOffset max_year { get; set; }


        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public ICommand do_signup
        {
            get;
            private set;
        }

        public SignupViewModel()
        {
            new_user = new User();
            new_user_addr = new Address();



            //DEBUG
            //new_user.username = "totolol3";
            //new_user.email = "totolol3@gmail.com";
            //new_user.language = "FR";
            //new_user.birthday = "1989-12-20";
            //passwd = "lolxdlol";
            //passwd_verif = passwd;

            do_signup = new SignupCommand(this);
        }

        // Method called in SignupCommand file
        public async void signup()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                if (passwd != passwd_verif)
                {
                    await new MessageDialog("Les mots de passe insérés sont différents").ShowAsync();
                    return;
                }

                string date = new_user.birthday_dt.ToString("yyyy-MM-dd");

                string user_data =
                    // REQUIRED
                        "&user[username]=" + new_user.username +
                        "&user[email]=" + new_user.email +
                        "&user[password]=" + passwd +
                        "&user[language]=" + "FR" +
                    //"&user[language]=" + new_user.language +
                    //"&user[birthday]=" + new_user.birthday + // OLD DATE
                        "&user[birthday]=" + date +

                        // NOT REQUIRED but are :p
                        "&user[fname]=" + new_user.fname +
                        "&user[lname]=" + new_user.lname +

                        // NOT REQUIRED
                        "&user[phoneNumber]=" + new_user.phoneNumber +
                        "&user[description]=" + new_user.description;

                // Check if address null
                if (await check_addr(new_user_addr))
                    user_data +=
                        "&address[numberStreet]=" + new_user_addr.numberStreet +
                        "&address[street]=" + new_user_addr.street +
                        "&address[zipcode]=" + new_user_addr.zipcode +
                        "&address[city]=" + new_user_addr.city +
                        "&address[country]=" + new_user_addr.country +
                        "&address[complement]=" + new_user_addr.complement;
                else
                    // if the addr is not complete
                    if (check_addr_nb == -1)
                        return;


                var response = await request.post_request("users/save", user_data);

                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Inscription réussie").ShowAsync();
                    ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Connection));
                }
                else
                    await new MessageDialog("Erreur lors de l'inscription").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de l'inscription").ShowAsync();
        }

        async Task<bool> check_addr(Address addr)
        {
            // no addr, let's continue
            if ((addr.city == null || addr.city == "") &&
             (addr.complement == null || addr.complement == "") &&
             (addr.country == null || addr.country == "") &&
             (addr.numberStreet == null || addr.numberStreet == "") &&
             (addr.street == null || addr.street == "") &&
             (addr.zipcode == null || addr.zipcode == ""))
            {
                check_addr_nb = 1;
                return false;
            }

            // full addr
            if ((addr.city != null && addr.city != "") &&
                       (addr.complement != null && addr.complement != "") &&
                       (addr.country != null && addr.country != "") &&
                       (addr.numberStreet != null && addr.numberStreet != "") &&
                       (addr.street != null && addr.street != "") &&
                       (addr.zipcode != null && addr.zipcode != ""))
                return true;

            // INCOMPLETE ADDR
            await new MessageDialog("Merci de remplir tous les champs d'addresse").ShowAsync();
            check_addr_nb = -1;
            return false;
        }
    }
}
