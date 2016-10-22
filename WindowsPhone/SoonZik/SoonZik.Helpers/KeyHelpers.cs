using System;

namespace SoonZik.Helpers
{
    public class KeyHelpers
    {
        public static string GetUserKeyFromResponse(string key)
        {
            char[] delimiter = {' ', '"', '{', '}'};
            var word = key.Split(delimiter);
            var stringEncrypt = (word[4]);
            return stringEncrypt;
        }

        public static string GetTwitterKey(string key)
        {
            string[] separator = {"<code>", "</code>"};
            var theKey = key.Split(separator, StringSplitOptions.None);
            if (theKey.Length > 1)
                return theKey[1];
            return null;
            ;
        }
    }
}