using Newtonsoft.Json.Linq;
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
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class CommentViewModel
    {
        //public ObservableCollection<Comment> commentlist { get; set; }
        public static ObservableCollection<Comment> _commentlist { get; set; }


        public CommentViewModel()
        {

        }

        async static public Task<ObservableCollection<Comment>> load_comments(string elem)
        {
            Exception exception = null;
            _commentlist = new ObservableCollection<Comment>();
            elem += "/comments";

            try
            {
                var comments = (List<Comment>)await Http_get.get_object(new List<Comment>(), elem);

                foreach (var item in comments)
                    _commentlist.Insert(0, item); // To have the last comment on top
                //_commentlist.Add(item);
                return _commentlist;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des commentaires").ShowAsync();
            return null;
           
        }

        public static async Task<bool> send_comment(string comment_txt, string type, string id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string url = type + "/addcomment/" + id;
                string comment_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&content=" + WebUtility.UrlEncode(comment_txt) +
                    "&secureKey=" + secureKey;


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(type + "/addcomment/" + id, comment_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    //await new MessageDialog("Comment SEND").ShowAsync();
                    return true;
                }
                else
                    await new MessageDialog("Erreur lors de l'envoi du commentaire").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de l'envoi du commentaire").ShowAsync();
            return false;
        }
    }
}
