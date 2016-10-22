namespace SoonZik.HttpRequest.Poco
{
    public class Tweets
    {
        public int id { get; set; }
        public string msg { get; set; }
        public string created_at { get; set; }
        public User user { get; set; }
    }
}