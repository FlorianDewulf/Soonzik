using SonnZik.Streaming.HttpWebRequest.Poco;
using System;

namespace SoonZik.Streaming.Singleton
{
    public class Singleton
    {
        #region Ctor

        protected internal Singleton()
        {
        }

        #endregion

        #region Attribute
        private static Singleton _instance;

        public static Singleton Instance()
        {
            if (_instance == null)
            {
                _instance = new Singleton();
            }
            return _instance;
        }

        public User TheArtiste { get; set; }
        public DateTime compare_date { get; set; }
        public string secureKey { get; set; }

        #endregion
    }
}
