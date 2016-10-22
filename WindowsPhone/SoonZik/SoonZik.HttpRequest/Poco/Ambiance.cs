using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Ambiance
    {
        public int id { get; set; }
        public string name { get; set; }
        public List<Music> musics { get; set; }
    }
}