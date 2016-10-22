using Newtonsoft.Json.Linq;
using System;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;

namespace SoonZik.Tools
{
    class Post_comment
    {
        // Comment_txt = content, type = music | album | news, id = id of the news | album | music ...
        public Post_comment(string comment_txt, string type, string id)
        {
            send_comment(comment_txt, type, id);
        }

        public async void send_comment(string comment_txt, string type, string id)
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
                    await new MessageDialog("Comment SEND").ShowAsync();
                }
                else
                    await new MessageDialog("Comment KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Comment POST Error").ShowAsync();
        }
    }
}
