using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Battle
    {
        #region Attribute

        public int id { get; set; }
        public string date_begin { get; set; }
        public string date_end { get; set; }
        public ArtistOne artist_one { get; set; }
        public ArtistTwo artist_two { get; set; }
        public List<Vote> votes { get; set; }

        #endregion
    }
}