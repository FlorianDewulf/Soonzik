using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;

namespace SoonZik.Helpers
{
    public class EncriptSha256
    {
        public static string EncriptStringToSha256(string myString)
        {
            var input = CryptographicBuffer.ConvertStringToBinary(myString, BinaryStringEncoding.Utf8);

            var hasher = HashAlgorithmProvider.OpenAlgorithm("SHA256");
            var hashed = hasher.HashData(input);

            return CryptographicBuffer.EncodeToHexString(hashed);
        }
    }
}