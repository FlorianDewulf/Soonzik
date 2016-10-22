using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Music
    {
        public string file { get; set; }
        public int id { get; set; }
        public string title { get; set; }
        public string duration { get; set; }
        public string price { get; set; }
        public bool limited { get; set; }
        public string getAverageNote { get; set; }
        public Album album { get; set; }
        public List<Genre> genres { get; set; }
        public User user { get; set; }
    }
}