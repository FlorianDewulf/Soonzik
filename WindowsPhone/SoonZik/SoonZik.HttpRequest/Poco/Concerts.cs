namespace SoonZik.HttpRequest.Poco
{
    public class Concerts
    {
        public int id { get; set; }
        public string planification { get; set; }
        public object url { get; set; }
        public string likes { get; set; }
        public bool hasLiked { get; set; }
        public Address address { get; set; }
        public User user { get; set; }
    }
}