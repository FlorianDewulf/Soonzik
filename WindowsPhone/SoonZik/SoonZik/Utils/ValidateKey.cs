using System;
using System.Threading.Tasks;
using Newtonsoft.Json;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.Utils
{
    public static class ValidateKey
    {
        public static bool CheckValidateKey()
        {
            if (Singleton.Singleton.Instance().Key == null)
                return false;
            var myDate = DateTime.Parse(Singleton.Singleton.Instance().Key.last_update);

            if (myDate < DateTime.Now)
                return false;
            return true;
        }

        public static void GetValideKey()
        {
            if (CheckValidateKey()) return;
            var get = new HttpRequestGet();
            var userKey = get.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var key = task.Result as String;
                if (key != null)
                {
                    var obj = JsonConvert.DeserializeObject(key, typeof (Key)) as Key;
                    var stringEncrypt = obj.key;
                    Singleton.Singleton.Instance().Key = obj;
                    Singleton.Singleton.Instance().SecureKey =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                            stringEncrypt);
                }
            });
        }
    }
}