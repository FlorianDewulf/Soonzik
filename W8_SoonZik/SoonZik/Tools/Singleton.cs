using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;

namespace SoonZik.Tools
{
    class Singleton
    {
        private static Singleton instance = null;

        public string url = "http://api.lvh.me:3000/";
        //public string url = "http://soonzikapi.herokuapp.com/";

        public User Current_user;

        // For secureKey
        public string secureKey { get; set; }
        public DateTime compare_date { get; set; }
        public Music selected_music { get; set; }

        //// For Facebook Connection ::: NOPE, USELESS
        //public string fb_id { get; set; }
        //public string fb_token { get; set; }

        // Private ctor
        private Singleton(){}

        public static Singleton Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new Singleton();
                }
                return instance;
            }
        }
    }
}

