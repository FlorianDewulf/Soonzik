using System.Net;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.HttpExtensions
{
    public static class HttpExtensions
    {
        public static Task<HttpWebResponse> GetResponseAsync(HttpWebRequest request)
        {
            var taskComplete = new TaskCompletionSource<HttpWebResponse>();
            request.BeginGetResponse(asyncResponse =>
            {
                try
                {
                    var responseRequest = (HttpWebRequest) asyncResponse.AsyncState;
                    var theResponse = (HttpWebResponse) responseRequest.EndGetResponse(asyncResponse);
                    taskComplete.TrySetResult(theResponse);
                }
                catch (WebException e)
                {
                    var failedResponse = (HttpWebResponse) e.Response;
                    taskComplete.TrySetResult(failedResponse);
                }
            }, request);
            return taskComplete.Task;
        }
    }
}