using System.Collections.Generic;
using Windows.UI.Xaml.Media.Imaging;

namespace SoonZik.HttpRequest.Poco
{
    public class News
    {
        #region Attributes

        public int id { get; set; }
        public string created_at { get; set; }
        public string title { get; set; }
        public string content { get; set; }
        public string likes { get; set; }
        public bool hasLiked { get; set; }
        public User user { get; set; }
        public List<Newstext> newstexts { get; set; }
        public List<Attachment> attachments { get; set; }
        public BitmapImage imageNews { get; set; }

        #endregion
    }
}