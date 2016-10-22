using System.Collections.Generic;
using System.Collections.ObjectModel;
using Windows.UI.Xaml.Media.Imaging;

namespace SoonZik.HttpRequest.Poco
{
    public class Album
    {
        #region Attributes 

        public int id { get; set; }
        public string title { get; set; }
        public string image { get; set; }
        public string price { get; set; }
        public int yearProd { get; set; }
        public string getAverageNote { get; set; }
        public string likes { get; set; }
        public bool hasLiked { get; set; }
        public ObservableCollection<Music> musics { get; set; }
        public User user { get; set; }
        public List<Description> descriptions { get; set; }
        public List<Genre> genres { get; set; }
        public BitmapImage imageAlbum { get; set; }

        #endregion
    }
}