using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Pack
    {
        public int id { get; set; }
        public string title { get; set; }
        public string begin_date { get; set; }
        public string end_date { get; set; }
        public string minimal_price { get; set; }
        public string averagePrice { get; set; }
        public List<Album> albums { get; set; }
        public List<Description> descriptions { get; set; }
    }
}