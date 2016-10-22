using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Artist
    {
        public bool artist { get; set; }
        public List<Album> albums { get; set; }
    }
}