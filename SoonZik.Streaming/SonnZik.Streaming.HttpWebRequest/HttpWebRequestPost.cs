using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace SonnZik.Streaming.HttpWebRequest
{
    public class HttpWebRequestPost
    {
        #region Attribute
        //private const string ApiUrl = "http://soonzikapi.herokuapp.com/";
        private const string ApiUrl = "http://api.lvh.me:3000/";
        public String Received { get; set; }
        #endregion

        #region Ctor

        #endregion

        #region Method
        public async Task<String> ConnexionSimple(string username, string password)
        {
            var request = (System.Net.HttpWebRequest)WebRequest.Create(ApiUrl + "login");
            var postData = "email=" + username + "&password=" + password;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> GetHttpPostResponse(System.Net.HttpWebRequest request, string postData)
        {
            Received = null;
            request.Method = "POST";

            request.ContentType = "application/x-www-form-urlencoded";

            var requestBody = Encoding.UTF8.GetBytes(postData);

            // ASYNC: using awaitable wrapper to get request stream
            using (var postStream = await request.GetRequestStreamAsync())
            {
                // Write to the request stream.
                // ASYNC: writing to the POST stream can be slow
                await postStream.WriteAsync(requestBody, 0, requestBody.Length);
            }

            try
            {
                // ASYNC: using awaitable wrapper to get response
                var response = (HttpWebResponse)await request.GetResponseAsync();
                if (response != null)
                {
                    var reader = new StreamReader(response.GetResponseStream());
                    // ASYNC: using StreamReader's async method to read to end, in case
                    // the stream i slarge.
                    Received = await reader.ReadToEndAsync();
                }
            }
            catch (WebException we)
            {
                var reader = new StreamReader(we.Response.GetResponseStream());
                var responseString = reader.ReadToEnd();
                Debug.WriteLine(responseString);
                return responseString;
            }
            return Received;
        }
        #endregion

    }
}
