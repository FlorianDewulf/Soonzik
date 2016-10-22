using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.Tools
{
    public class Http_post
    {
        static string url = Singleton.Instance.url;
        //public static string url = "http://api.lvh.me:3000/";

        public async Task<string> post_request(string elem, string data)
        {
            Exception exception = null;

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";

            byte[] byteArray = Encoding.UTF8.GetBytes(data);

            try
            {
                Stream dataStream = await request.GetRequestStreamAsync();
                await dataStream.WriteAsync(byteArray, 0, byteArray.Length);

                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                dataStream = response.GetResponseStream();
                StreamReader reader = new StreamReader(dataStream);
                string ret = reader.ReadToEnd();
                return ret;
            }
            catch (WebException ex)
            {
                exception = ex;
                StreamReader reader = new StreamReader(ex.Response.GetResponseStream());
                string ret = reader.ReadToEnd();
                return ret;
            }
        }
    }
}
