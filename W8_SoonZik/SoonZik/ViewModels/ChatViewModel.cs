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
    class ChatViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<Message> messages_list { get; set; }

        //public ICommand do_send_msg
        //{
        //    get;
        //    private set;
        //}

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }


        public ChatViewModel(int id)
        {
            //do_send_msg = new RelayCommand(send_msg);
            load_messages(id);
        }

        async void load_messages(int id)
        {
            Exception exception = null;
            messages_list = new ObservableCollection<Message>();


            // /messages/conversation/2?user_id=1&secureKey=2479e4eb4e23f7a2d807ac01a6858d584a17d10a14d9cffb1ef055a66f804e0d
            try
            {
                var messages = (List<Message>)await Http_get.get_object(new List<Message>(), "messages/conversation/" + id.ToString() + "?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));

                foreach (var item in messages)
                {
                    messages_list.Add(item);
                }

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de la conversation").ShowAsync();
        }

        static public async Task<bool> send_msg(int dest, string msg)
        {
            //messages/save?message[user_id]=4&message[dest_id]=1&message[msg]=salut_comment_va_looooooool&user_id=4&secureKey=694229ac41695d8a8f00c9a6a04206911180a1f11f0543b3112734abdce47071

            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string msg_data =
                    "message[user_id]=" + Singleton.Instance.Current_user.id +
                    "&message[dest_id]=" + dest.ToString() + 
                    "&message[msg]=" + WebUtility.UrlEncode(msg) +
                    "&user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey;


                // HTTP_POST -> URL + DATA
                var response = await request.post_request("/messages/save?", msg_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    //await new MessageDialog("msg SEND").ShowAsync();
                    return true;
                }
                else
                    await new MessageDialog("Erreur lors de l'envoi du message").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }
            return false;
        }
    }
}
