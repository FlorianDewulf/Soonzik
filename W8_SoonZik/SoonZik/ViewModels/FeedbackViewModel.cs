using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class FeedbackViewModel : INotifyPropertyChanged
    {
        private string _email;
        public string email
        {
            get { return _email; }
            set
            {
                _email = value;
                OnPropertyChanged("email");
            }
        }

        private string _object_type;
        public string object_type
        {
            get { return _object_type; }
            set
            {
                _object_type = value;
                OnPropertyChanged("object_type");
            }
        }

        private string _objet;
        public string objet
        {
            get { return _objet; }
            set
            {
                _objet = value;
                OnPropertyChanged("objet");
            }
        }

        private string _txt;
        public string txt
        {
            get { return _txt; }
            set
            {
                _txt = value;
                OnPropertyChanged("txt");
            }
        }

        private int _index_cb;
        public int index_cb
        {
            get { return _index_cb; }
            set
            {
                _index_cb = value;
                OnPropertyChanged("index_cb");
            }
        }

        public ICommand do_send_feedback
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

        public FeedbackViewModel()
        {
            do_send_feedback = new RelayCommand(send_feedback);
        }

        async void send_feedback()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                if (!check_value())
                {
                    await new MessageDialog("Remplissez tous les champs").ShowAsync();
                    return;
                }

                //“bug”, “payment”, “account”, “other” --> object type
                if (index_cb == 0)
                    object_type = "bug";
                else if (index_cb == 1)
                    object_type = "payment";
                else if (index_cb == 2)
                    object_type = "account";
                else if (index_cb == 3)
                    object_type = "other";
                else
                    return;


                string feed_data =
                    "feedback[email]=" + WebUtility.UrlEncode(email) +
                    "&feedback[type_object]=" + object_type +
                    "&feedback[object]=" + WebUtility.UrlEncode(objet) +
                    "&feedback[text]=" + WebUtility.UrlEncode(txt);


                // HTTP_POST -> URL + DATA
                var response = await request.post_request("/feedbacks/save/", feed_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("feedback ok").ShowAsync();
                }
                else
                    await new MessageDialog("Erreur lors de l'envoi du feedback").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }
            if (exception != null)
                await new MessageDialog("Erreur lors de l'envoi du feedback").ShowAsync();
        }
        bool check_value()
        {
            if (email == null || index_cb == null || objet == null || txt == null
                || email == "" || objet == "" || txt == "")
                return false;
            return true;
        }

    }
}
