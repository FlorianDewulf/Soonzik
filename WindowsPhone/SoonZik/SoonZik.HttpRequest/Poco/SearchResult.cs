using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class SearchResult
    {
        public List<User> artist { get; set; }
        public List<User> user { get; set; }
        public List<Music> music { get; set; }
        public List<Album> album { get; set; }
        public List<Pack> pack { get; set; }
    }
}