namespace SoonZik.HttpRequest.Poco
{
    public class Comments
    {
        public int id { get; set; }
        public int author_id { get; set; }
        public string content { get; set; }
        public string created_at { get; set; }
        public User user { get; set; }
    }
}