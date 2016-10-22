using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;
using Windows.UI.Popups;

namespace SoonZik.Tools
{
    class Security
    {
        static string url = Singleton.Instance.url;
        //public static string url = "http://api.lvh.me:3000/";

        static async Task<string> getKey(string id)
        {
            Exception exception = null;
            HttpClient client = new HttpClient();

            try
            {
                var data = await client.GetStringAsync(url + "getKey/" + id);
                var result = JObject.Parse(data);

                string key = result["key"].ToString();
                return key;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de la clé de sécurité").ShowAsync();
            return null;
        }

        public static async Task<string> getSocialToken(string id, string sn)
        {
            Exception exception = null;
            HttpClient client = new HttpClient();

            try
            {
                var data = await client.GetStringAsync(url + "getSocialToken/" + id + "/" + sn);
                var result = JObject.Parse(data);

                string key = result["key"].ToString();
                return key;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération du SocialToken").ShowAsync();
            return null;
        }

        public static string getSocialSecureKey(string id, string token)
        {
            string key_to_encode = id + token + "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E"; // SALT
            return CryptographicBuffer.EncodeToHexString(HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha256).HashData(CryptographicBuffer.ConvertStringToBinary(key_to_encode, BinaryStringEncoding.Utf8)));
        }

        public static async Task<string> getSecureKey(string id)
        {
            if (Singleton.Instance.compare_date.AddMinutes(5) < DateTime.Now || Singleton.Instance.compare_date.GetHashCode() == 0)
            {
                //await new MessageDialog("GETKEY").ShowAsync();
                string key = await getKey(id);
                string key_to_encode = Singleton.Instance.Current_user.salt + key;

                Singleton.Instance.compare_date = DateTime.Now;
                Singleton.Instance.secureKey = CryptographicBuffer.EncodeToHexString(HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha256).HashData(CryptographicBuffer.ConvertStringToBinary(key_to_encode, BinaryStringEncoding.Utf8)));

                return Singleton.Instance.secureKey;
            }
            //await new MessageDialog("PAS DE GETKEY").ShowAsync();
            return Singleton.Instance.secureKey;
        }
    }
}
