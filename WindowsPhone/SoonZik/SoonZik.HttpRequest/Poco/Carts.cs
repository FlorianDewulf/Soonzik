using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Carts
    {
        public int id { get; set; }
        public string created_at { get; set; }
        public List<Music> musics { get; set; }
        public List<Album> albums { get; set; }
    }
}