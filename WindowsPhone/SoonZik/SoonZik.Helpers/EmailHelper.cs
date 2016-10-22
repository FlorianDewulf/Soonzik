using System.Text.RegularExpressions;

namespace SoonZik.Helpers
{
    public class EmailHelper
    {
        public static bool IsValidEmail(string emailStr)
        {
            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(emailStr,
                @"^(?("")(""[^""]+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))" +
                @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
        }
    }
}