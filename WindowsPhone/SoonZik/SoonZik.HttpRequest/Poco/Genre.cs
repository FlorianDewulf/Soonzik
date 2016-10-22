using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Genre
    {
        public int id { get; set; }
        public string style_name { get; set; }
        public string color_name { get; set; }
        public string color_hexa { get; set; }
        public string created_at { get; set; }
        public string updated_at { get; set; }
        public List<Influence> influences { get; set; }
        public List<Music> musics { get; set; }
    }
}