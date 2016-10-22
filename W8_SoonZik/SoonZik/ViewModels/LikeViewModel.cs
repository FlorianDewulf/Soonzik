using Newtonsoft.Json.Linq;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class LikeViewModel
    {

        // type =  “News” | “Albums” | “Concerts”
        public static async Task<bool> like(string type, string id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string url = "/likes/save";
                string data =
                    "like[user_id]=" + Singleton.Instance.Current_user.id +
                    "&like[typeObj]=" + type +
                    "&like[obj_id]=" + id +
                    "&user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey;


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(url, data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    //await new MessageDialog("Like OK").ShowAsync();
                    return true;
                }
                else
                    await new MessageDialog("Erreur lors du like").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors du like").ShowAsync();
            return false;
        }

        public static async Task<bool> unlike(string type, string id)
        {
            Exception exception = null;

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string url = "/likes/destroy";
                string data =
                    "?like[typeObj]=" + type +
                    "&like[obj_id]=" + id +
                    "&user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey;

                var response = Http_get.get_data(url + data);

                //await new MessageDialog("unlike OK").ShowAsync();
                return true;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors du unlike").ShowAsync();
            return false;
        }
    }
}
